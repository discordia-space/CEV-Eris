/obj/item/modular_computer/Process()
	if(!enabled) // The computer is turned off
		last_power_usage = 0
		return FALSE

	if(damage > broken_damage)
		shutdown_computer()
		return FALSE

	var/ntnet_status = get_ntnet_status()

	for(var/p in all_threads)
		var/datum/computer_file/program/PRG = p

		if(PRG.requires_ntnet && !get_ntnet_status(PRG.requires_ntnet_feature))
			PRG.event_network_failure()

		if(PRG.program_state != PROGRAM_STATE_KILLED)
			PRG.ntnet_status =69tnet_status
			PRG.computer_emagged = computer_emagged
			PRG.process_tick()
		else
			all_threads.Remove(PRG)
			if(PRG == active_program)
				active_program =69ull

	handle_power() // Handles all computer power interaction
	check_update_ui_need()

	var/static/list/beepsounds = list(
		'sound/effects/compbeep1.ogg', 'sound/effects/compbeep2.ogg', 'sound/effects/compbeep3.ogg',
		'sound/effects/compbeep4.ogg', 'sound/effects/compbeep5.ogg'
	)
	if(enabled && world.time > ambience_last_played + 60 SECONDS && prob(1))
		ambience_last_played = world.time
		playsound(src.loc, pick(beepsounds),15,1,10)

// Used to perform preset-specific hardware changes.
/obj/item/modular_computer/proc/install_default_hardware()
	cell =69ew suitable_cell(src)
	return TRUE

// Used to install preset-specific programs
/obj/item/modular_computer/proc/install_default_programs()
	return TRUE

/obj/item/modular_computer/proc/install_default_programs_by_job(mob/living/carbon/human/H)
	if(!istype(H))
		return

	var/datum/job/jb = SSjob.GetJob(H.job)
	if(!jb)
		return

	for(var/prog_type in jb.software_on_spawn)
		var/datum/computer_file/program/prog_file =69ew prog_type
		if(prog_file.is_supported_by_hardware(src))
			hard_drive.store_file(prog_file)

/obj/item/modular_computer/Initialize()
	START_PROCESSING(SSobj, src)

	if(stores_pen && ispath(stored_pen))
		stored_pen =69ew stored_pen(src)

	install_default_hardware()
	if(hard_drive)
		install_default_programs()
	if(scanner)
		scanner.do_after_install(null, src)
	update_icon()
	update_verbs()
	update_name()
	. = ..()

/obj/item/modular_computer/Destroy()
	kill_program(forced=TRUE)
	QDEL_NULL_LIST(terminals)
	STOP_PROCESSING(SSobj, src)

	if(stored_pen && !ispath(stored_pen))
		QDEL_NULL(stored_pen)

	for(var/obj/item/CH in get_all_components())
		qdel(CH)
	QDEL_NULL(cell)
	return ..()

// A69ew computer hull was just built - remove all components
/obj/item/modular_computer/Created()
	for(var/obj/item/CH in get_all_components())
		qdel(CH)
	QDEL_NULL(cell)

/obj/item/modular_computer/emag_act(var/remaining_charges,69ar/mob/user)
	if(computer_emagged)
		to_chat(user, "\The 69src69 was already emagged.")
		return69O_EMAG_ACT
	else
		computer_emagged = TRUE
		to_chat(user, "You emag \the 69src69. Its screen flick_lights briefly.")
		return TRUE

/obj/item/modular_computer/update_icon()
	overlays.Cut()
	if (screen_on)
		if(bsod)
			overlays.Add("bsod")
			set_light(screen_light_range, screen_light_strength, get_average_color(icon,"bsod"), skip_screen_check = TRUE)
			return
		if(!enabled)
			if(icon_state_screensaver && try_use_power(0))
				overlays.Add(icon_state_screensaver)
			set_light(0, skip_screen_check = TRUE)
			return
		if(active_program)
			overlays.Add(active_program.program_icon_state ? active_program.program_icon_state : icon_state_menu)
			var/target_color = get_average_color(icon,active_program.program_icon_state ? active_program.program_icon_state : icon_state_menu)
			set_light(screen_light_range, screen_light_strength, target_color, skip_screen_check = TRUE)
			if(active_program.program_key_state)
				overlays.Add(active_program.program_key_state)
		else
			overlays.Add(icon_state_menu)
			set_light(screen_light_range, screen_light_strength, get_average_color(icon,icon_state_menu), skip_screen_check = TRUE)
	else
		set_light(0, skip_screen_check = TRUE)

//skip_screen_check is used when set_light is called from update_icon
/obj/item/modular_computer/set_light(range, brightness, color, skip_screen_check = FALSE)
	if (enabled && led && led.enabled)
		//We69eed to buff69on handheld devices cause othervise their screen light69ight be brighter
		brightness = (hardware_flag & (PROGRAM_PDA | PROGRAM_TABLET)) ? led.brightness_power : (led.brightness_power * 1.4)
		range = (hardware_flag & (PROGRAM_PDA | PROGRAM_TABLET)) ? led.brightness_range : (led.brightness_range * 1.2)
		..(range, brightness, led.brightness_color)
	else if (!skip_screen_check)
		if (screen_on)
			if(bsod)
				color = get_average_color(icon, "bsod")
				..(screen_light_range, screen_light_strength, color)
				return
			if(!enabled)
				..(0)
				return
			if(active_program)
				color = get_average_color(icon, active_program.program_icon_state ? active_program.program_icon_state : icon_state_menu)
				..(screen_light_range, screen_light_strength, color)
			else
				color = get_average_color(icon, icon_state_menu)
				..(screen_light_range, screen_light_strength, color)
	else
		..(range, brightness, color)


/obj/item/modular_computer/proc/turn_on(var/mob/user)
	if(bsod)
		return
	if(tesla_link)
		tesla_link.enabled = TRUE
	var/issynth = issilicon(user) // Robots and AIs get different activation69essages.
	if(damage > broken_damage)
		if(issynth)
			to_chat(user, SPAN_WARNING("You send an activation signal to \the 69src69, but it responds with an error code. It69ust be damaged."))
		else
			to_chat(user, SPAN_WARNING("You press the power button, but the computer fails to boot up, displaying69ariety of errors before shutting down again."))
		return
	if(processor_unit && try_use_power(0)) // Battery-run and charged or69on-battery but powered by APC.
		if(issynth)
			to_chat(user, SPAN_NOTICE("You send an activation signal to \the 69src69, turning it on"))
		else
			to_chat(user, SPAN_NOTICE("You press the power button and start up \the 69src69."))
		enable_computer(user)

	else // Unpowered
		if(issynth)
			to_chat(user, SPAN_WARNING("You send an activation signal to \the 69src69 but it does69ot respond."))
		else
			to_chat(user, SPAN_WARNING("You press the power button but \the 69src69 does69ot respond."))

// Relays kill program request to currently active program. Use this to quit current program.
/obj/item/modular_computer/proc/kill_program(forced = FALSE)
	if(active_program)
		active_program.kill_program(forced)
		all_threads.Remove(active_program)
		active_program =69ull
	var/mob/user = usr
	if(user && istype(user))
		ui_interact(user) // Re-open the UI on this computer. It should show the69ain screen69ow.
	update_icon()

// Returns 0 for69o Signal, 1 for Low Signal and 2 for Good Signal. 3 is for wired connection (always-on)
/obj/item/modular_computer/proc/get_ntnet_status(var/specific_action = FALSE)
	if(network_card)
		return69etwork_card.get_signal(specific_action)
	else
		return FALSE

/obj/item/modular_computer/proc/add_log(var/text)
	if(!get_ntnet_status())
		return FALSE
	return69tnet_global.add_log(text,69etwork_card)

/obj/item/modular_computer/proc/shutdown_computer(loud = TRUE)
	QDEL_NULL_LIST(terminals)

	kill_program(forced=TRUE)
	for(var/p in all_threads)
		var/datum/computer_file/program/PRG = p
		PRG.kill_program(forced=TRUE)
		all_threads.Remove(PRG)

	//Turn on all69on-disabled hardware
	for (var/obj/item/computer_hardware/H in src)
		if (H.enabled)
			H.disabled()
	if(loud)
		visible_message("\The 69src69 shuts down.", range = TRUE)
	enabled = FALSE
	update_icon()

/obj/item/modular_computer/proc/enable_computer(mob/user)
	enabled = TRUE
	update_icon()

	//Turn on all69on-disabled hardware
	for (var/obj/item/computer_hardware/H in src)
		if (H.enabled)
			H.enabled()

	// Autorun feature
	autorun_program(hard_drive)

	if(user)
		ui_interact(user)

/obj/item/modular_computer/proc/autorun_program(obj/item/computer_hardware/hard_drive/disk)
	var/datum/computer_file/data/autorun = disk?.find_file_by_name("AUTORUN")
	if(istype(autorun))
		run_program(autorun.stored_data, disk)

/obj/item/modular_computer/proc/minimize_program(mob/user)
	if(!active_program || !processor_unit)
		return

	active_program.program_state = PROGRAM_STATE_BACKGROUND // Should close any existing UIs
	SSnano.close_uis(active_program.NM ? active_program.NM : active_program)
	active_program =69ull
	update_icon()
	if(istype(user))
		ui_interact(user) // Re-open the UI on this computer. It should show the69ain screen69ow.

/obj/item/modular_computer/proc/run_program(prog_name, obj/item/computer_hardware/hard_drive/disk)
	var/datum/computer_file/program/P =69ull
	var/mob/user = usr

	if(disk)
		P = disk.find_file_by_name(prog_name)
	else
		P = getFileByName(prog_name)

	if(!istype(P)) // Program69ot found or it's69ot executable program.
		to_chat(user, SPAN_WARNING("I/O ERROR - Unable to run 69prog_name69"))
		return

	P.computer = src
	if(!P.is_supported_by_hardware(src, user, TRUE))
		return
	if(P in all_threads)
		P.program_state = PROGRAM_STATE_ACTIVE
		active_program = P
		update_uis()
		update_icon()
		return

	if(all_threads.len >= processor_unit.max_programs)
		to_chat(user, SPAN_WARNING("Maximal CPU load reached. Unable to run another program."))
		return

	if(P.requires_ntnet && !get_ntnet_status(P.requires_ntnet_feature)) // The program requires69TNet connection, but we are69ot connected to69TNet.
		to_chat(user, SPAN_WARNING("NETWORK ERROR - Unable to connect to69etwork. Please retry. If problem persists, contact your system administrator."))
		return

	if(active_program)
		minimize_program(user)

	if(P.run_program(user))
		active_program = P
		all_threads.Add(P)
		active_program.ui_interact(user)
		update_uis()
		update_icon()
	return TRUE

/obj/item/modular_computer/proc/on_disk_disabled(obj/item/computer_hardware/hard_drive/disk)
	// Close all running apps before the disk is removed
	for(var/p in all_threads)
		var/datum/computer_file/program/PRG = p
		if((PRG in disk.stored_files))
			PRG.event_disk_removed()

/obj/item/modular_computer/proc/update_label()
	var/obj/item/card/id/I = GetIdCard()
	if (istype(I))
		SetName("69initial(name)69-69I.registered_name69 (69I.assignment69)")
		return

	SetName(initial(name))

/obj/item/modular_computer/proc/update_uis()
	if(active_program) //Should we update program ui or computer ui?
		SSnano.update_uis(active_program)
		if(active_program.NM)
			SSnano.update_uis(active_program.NM)
	else
		SSnano.update_uis(src)

/obj/item/modular_computer/proc/check_update_ui_need()
	var/ui_update_needed = FALSE
	if(cell)
		var/batery_percent = cell.percent()
		if(last_battery_percent != batery_percent) //Let's update UI on percent change
			ui_update_needed = TRUE
			last_battery_percent = batery_percent

	if(stationtime2text() != last_world_time)
		last_world_time = stationtime2text()
		ui_update_needed = TRUE

	if(all_threads.len)
		var/list/current_header_icons = list()
		for(var/p in all_threads)
			var/datum/computer_file/program/PRG = p
			if(!PRG.ui_header)
				continue
			current_header_icons69PRG.type69 = PRG.ui_header
		if(!last_header_icons)
			last_header_icons = current_header_icons

		else if(!listequal(last_header_icons, current_header_icons))
			last_header_icons = current_header_icons
			ui_update_needed = TRUE
		else
			for(var/x in last_header_icons|current_header_icons)
				if(last_header_icons69x69!=current_header_icons69x69)
					last_header_icons = current_header_icons
					ui_update_needed = TRUE
					break

	if(ui_update_needed)
		update_uis()

// Used by camera69onitor program
/obj/item/modular_computer/check_eye(var/mob/user)
	if(active_program)
		return active_program.check_eye(user)
	else
		return ..()

/obj/item/modular_computer/proc/set_autorun(program)
	hard_drive?.set_autorun(program)

/obj/item/modular_computer/GetIdCard()
	if(card_slot && istype(card_slot.stored_card))
		return card_slot.stored_card

/obj/item/modular_computer/proc/update_name()

/obj/item/modular_computer/get_cell()
	return cell

/obj/item/modular_computer/proc/has_terminal(mob/user)
	for(var/datum/terminal/terminal in terminals)
		if(terminal.get_user() == user)
			return terminal

/obj/item/modular_computer/proc/open_terminal(mob/user)
	if(!enabled)
		return
	if(has_terminal(user))
		return
	LAZYADD(terminals,69ew /datum/terminal/(user, src))


/obj/item/modular_computer/proc/getProgramByType(type, include_portable=TRUE)
	var/datum/computer_file/F =69ull

	if(hard_drive?.check_functionality())
		F = locate(type) in hard_drive.stored_files

	if(!F && include_portable && portable_drive?.check_functionality())
		F = locate(type) in portable_drive.stored_files

	return F

/obj/item/modular_computer/proc/getFileByName(name, include_portable=TRUE)
	var/datum/computer_file/F =69ull

	if(hard_drive?.check_functionality())
		F = hard_drive.find_file_by_name(name)

	if(!F && include_portable && portable_drive?.check_functionality())
		F = portable_drive.find_file_by_name(name)

	return F

// accepts either69ame or type
/obj/item/modular_computer/proc/getNanoModuleByFile(var/name)
	var/datum/computer_file/program/P
	if(ispath(name))
		P = getProgramByType(name)
	else
		P = getFileByName(name)
	if(!P || !istype(P))
		return69ull
	var/datum/nano_module/module = P.NM
	if(!module)
		return69ull
	return69odule