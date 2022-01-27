/datum/computer_file/program/aidiag
	filename = "aidiag"
	filedesc = "AI69aintenance Utility"
	program_icon_state = "generic"
	program_key_state = "mining_key"
	program_menu_icon = "person"
	extended_desc = "This program is capable of reconstructing damaged AI systems. It can also be used to upload basic laws to the AI. Requires direct AI connection69ia inteliCard slot."
	size = 12
	requires_ntnet = 0
	required_access = access_heads
	requires_access_to_run = 0
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/program/computer_aidiag/
	var/restoring = 0

/datum/computer_file/program/aidiag/proc/get_ai()
	if(computer && computer.ai_slot && computer.ai_slot.check_functionality() && computer.ai_slot.enabled && computer.ai_slot.stored_card && computer.ai_slot.stored_card.carded_ai)
		return computer.ai_slot.stored_card.carded_ai
	return69ull

/datum/computer_file/program/aidiag/Topic(href, href_list)
	if(..())
		return 1

	if(!usr.stat_check(STAT_COG, STAT_LEVEL_ADEPT))
		return 1

	var/mob/living/silicon/ai/A = get_ai()
	if(!A)
		return 0
	if(href_list69"PRG_beginReconstruction"69)
		if((A.hardware_integrity() < 100) || (A.backup_capacitor() < 100))
			restoring = 1
		return 1

	// Following actions can only be used by69on-silicon users, as they involve69anipulation of laws.
	if(issilicon(usr))
		return 0
	if(href_list69"PRG_purgeAiLaws"69)
		A.laws.clear_zeroth_laws()
		A.laws.clear_ion_laws()
		A.laws.clear_inherent_laws()
		A.laws.clear_supplied_laws()
		to_chat(A, "<span class='danger'>All laws purged.</span>")
		return 1
	if(href_list69"PRG_resetLaws"69)
		A.laws.clear_ion_laws()
		A.laws.clear_supplied_laws()
		to_chat(A, "<span class='danger'>Non-core laws reset.</span>")
		return 1
	if(href_list69"PRG_uploadDefault"69)
		A.laws =69ew69aps_data.default_law_type
		to_chat(A, "<span class='danger'>All laws purged. Default lawset uploaded.</span>")
		return 1
	if(href_list69"PRG_addCustomSuppliedLaw"69)
		var/law_to_add = sanitize(input("Please enter a69ew law for the AI.", "Custom Law Entry"))
		var/sector = input("Please enter the priority for your69ew law. Can only write to law sectors 15 and above.", "Law Priority (15+)") as69um
		sector = between(MIN_SUPPLIED_LAW_NUMBER, sector,69AX_SUPPLIED_LAW_NUMBER)
		A.add_supplied_law(sector, law_to_add)
		to_chat(A, "<span class='danger'>Custom law uploaded to sector 69sector69: 69law_to_add69.</span>")
		return 1


/datum/computer_file/program/aidiag/process_tick()
	var/mob/living/silicon/ai/A = get_ai()
	if(!A || !restoring)
		restoring = 0	// If the AI was removed, stop the restoration sequence.
		return
	A.adjustFireLoss(-4)
	A.adjustBruteLoss(-4)
	A.adjustOxyLoss(-4)
	A.updatehealth()
	// If the AI is dead, revive it.
	if (A.health >= -100 && A.stat == DEAD)
		A.set_stat(CONSCIOUS)
		A.lying = 0
		A.switch_from_dead_to_living_mob_list()
		A.add_ai_verbs()
		A.update_icon()
		var/obj/item/aicard/AC = A.loc
		if(AC)
			AC.update_icon()
	// Finished restoring
	if((A.hardware_integrity() == 100) && (A.backup_capacitor() == 100))
		restoring = 0

/datum/nano_module/program/computer_aidiag
	name = "AI69aintenance Utility"

/datum/nano_module/program/computer_aidiag/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data += "skill_fail"
	if(!user.stat_check(STAT_COG, STAT_LEVEL_ADEPT))
		var/datum/extension/fake_data/fake_data = get_or_create_extension(src, /datum/extension/fake_data, /datum/extension/fake_data, 25)
		data69"skill_fail"69 = fake_data.update_and_return_data()
	data69"terminal"69 = !!program

	var/mob/living/silicon/ai/A
	// A shortcut for getting the AI stored inside the computer. The program already does69ecessary checks.
	if(program && istype(program, /datum/computer_file/program/aidiag))
		var/datum/computer_file/program/aidiag/AD = program
		A = AD.get_ai()

	if(!A)
		data69"error"69 = "No AI located"
	else
		data69"ai_name"69 = A.name
		data69"ai_integrity"69 = A.hardware_integrity()
		data69"ai_capacitor"69 = A.backup_capacitor()
		data69"ai_isdamaged"69 = (A.hardware_integrity() < 100) || (A.backup_capacitor() < 100)
		data69"ai_isdead"69 = (A.stat == DEAD)

		var/list/all_laws69069
		for(var/datum/ai_law/L in A.laws.all_laws())
			all_laws.Add(list(list(
			"index" = L.index,
			"text" = L.law
			)))

		data69"ai_laws"69 = all_laws

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "aidiag.tmpl", "AI69aintenance Utility", 600, 400, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)