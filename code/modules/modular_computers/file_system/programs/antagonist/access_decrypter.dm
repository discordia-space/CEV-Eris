/datum/computer_file/program/access_decrypter
	filename = "accrypt"
	filedesc = "Access Decrypter"
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "unlocked"
	extended_desc = "This highly advanced script can69ery slowly decrypt operational codes used in almost any69etwork. These codes can be downloaded to an ID card to expand the available access. The system administrator will probably69otice this."
	size = 34
	requires_ntnet = TRUE
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE
	nanomodule_path = /datum/nano_module/program/access_decrypter/
	var/message = ""
	var/running = FALSE
	var/progress = 0
	var/target_progress = 300
	var/datum/access/target_access =69ull
	var/list/restricted_access_codes = list(access_change_ids, access_network) // access codes that are69ot hackable due to balance reasons

/datum/computer_file/program/access_decrypter/kill_program(forced)
	reset()
	..(forced)

/datum/computer_file/program/access_decrypter/proc/reset()
	running = FALSE
	message = ""
	progress = 0
	target_access =69ull

/datum/computer_file/program/access_decrypter/process_tick()
	. = ..()
	if(!running)
		return
	var/obj/item/computer_hardware/processor_unit/CPU = computer.processor_unit
	var/obj/item/computer_hardware/card_slot/RFID = computer.card_slot
	if(!istype(CPU) || !CPU.check_functionality() || !istype(RFID) || !RFID.check_functionality())
		message = "A fatal hardware error has been detected."
		return
	if(!istype(RFID.stored_card))
		message = "ID card has been removed from the device. Operation aborted."
		return

	progress += get_speed()

	if(progress >= target_progress)
		if(prob(max(STAT_LEVEL_ADEPT - operator_skill, 0) * 3)) // Oops, wrong access
			var/list/valid_access_values = get_all_station_access()
			valid_access_values -= restricted_access_codes
			valid_access_values -= RFID.stored_card.access
			target_access = get_access_by_id(pick(valid_access_values))
		RFID.stored_card.access |= target_access.id
		if(ntnet_global.intrusion_detection_enabled && !prob(get_sneak_chance()))
			ntnet_global.add_log("IDS WARNING - Unauthorised access to primary keycode database from device: 69computer.network_card.get_network_tag()69  - downloaded access codes for: 69target_access.desc69.")
			ntnet_global.intrusion_detection_alarm = 1
		var/datum/access/cloned_access = target_access
		reset()
		message = "Successfully decrypted and saved operational key codes. Downloaded access codes for: 69cloned_access.desc69"

/datum/computer_file/program/access_decrypter/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"PRG_reset"69)
		reset()
		return 1
	if(href_list69"PRG_execute"69)
		if(running)
			return 1
		var/obj/item/computer_hardware/processor_unit/CPU = computer.processor_unit
		var/obj/item/computer_hardware/card_slot/RFID = computer.card_slot
		if(!istype(CPU) || !CPU.check_functionality() || !istype(RFID) || !RFID.check_functionality())
			message = "A fatal hardware error has been detected."
			return
		if(!istype(RFID.stored_card))
			message = "ID card is69ot present in the device. Operation aborted."
			return

		var/access = text2num(href_list69"PRG_execute"69)
		var/obj/item/card/id/id_card = RFID.stored_card
		if(access in id_card.access)
			return 1
		if(access in restricted_access_codes)
			return 1
		target_access = get_access_by_id(access)
		if(!target_access)
			return 1

		running = TRUE
		operator_skill = get_operator_skill(usr, STAT_COG)
		if(ntnet_global.intrusion_detection_enabled && !prob(get_sneak_chance()))
			ntnet_global.add_log("IDS WARNING - Unauthorised access attempt to primary keycode database from device: 69computer.network_card.get_network_tag()69")
			ntnet_global.intrusion_detection_alarm = 1
		return 1

/datum/computer_file/program/access_decrypter/proc/get_sneak_chance()
	return69ax(operator_skill - STAT_LEVEL_BASIC, 0) * 3

/datum/computer_file/program/access_decrypter/proc/get_speed()
	var/skill_speed_modifier =69ax(100 + (operator_skill - STAT_LEVEL_BASIC) * 2, 25) / 100
	return computer.processor_unit.max_programs * skill_speed_modifier

/datum/nano_module/program/access_decrypter
	name = "Access Decrypter"

/datum/nano_module/program/access_decrypter/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	if(!ntnet_global)
		return
	var/datum/computer_file/program/access_decrypter/PRG = program
	var/list/data = list()
	if(!istype(PRG))
		return
	data = PRG.get_header_data()

	if(PRG.message)
		data69"message"69 = PRG.message
	else if(PRG.running)
		data69"running"69 = 1
		data69"rate"69 = PRG.get_speed()

		// The UI template uses this to draw a block of 1s and 0s, the69ore 1s the closer you are to completion
		// Combined with UI updates this adds quite69ice effect to the UI
		data69"completion_fraction"69 = PRG.progress / PRG.target_progress

	else if(program.computer.card_slot && program.computer.card_slot.stored_card)
		var/obj/item/card/id/id_card = program.computer.card_slot.stored_card
		var/list/regions = list()
		for(var/region in ACCESS_REGION_MIN to ACCESS_REGION_MAX)
			var/list/accesses = list()
			for(var/access in get_region_accesses(region))
				if (get_access_desc(access))
					accesses.Add(list(list(
						"desc" = replacetext(get_access_desc(access), " ", "&nbsp"),
						"ref" = access,
						"allowed" = (access in id_card.access),
						"blocked" = (access in PRG.restricted_access_codes))))

			regions.Add(list(list(
				"name" = get_region_accesses_name(region),
				"accesses" = accesses)))
		data69"regions"69 = regions

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "mpc_access_decrypter.tmpl", "Access Decrypter", 550, 400, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)