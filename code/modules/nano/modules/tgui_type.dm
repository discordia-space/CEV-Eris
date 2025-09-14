/datum/nano_module/tgui
	var/datum/tgui/currentui // gotta save it, we can't get it any other way
	var/show_map ; var/map_z_level // the sins of our predecessors, brought to the present by the sins of our own

/datum/nano_module/tgui/ui_host(mob/user)
	return nano_host()

/datum/nano_module/tgui/ui_close(mob/user)
	. = ..()
	currentui = null // must clear reference to ui

/datum/nano_module/tgui/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/legacyicons)
	)


/datum/nano_module/tgui/ui_act(action, params)
	. = ..()

	if(istype(host, /datum/computer_file/program))
		var/datum/computer_file/program/program = host 
		switch(action)
			if("PC_exit")
				program.computer.kill_program()
				return TRUE
			if("PC_enable_component")
				var/obj/item/computer_hardware/H = program.computer.find_hardware_by_name(params["component"])
				if(istype(H) && !H.enabled)
					H.enabled = TRUE
					H.enabled()
				. = TRUE
			if("PC_disable_component")
				var/obj/item/computer_hardware/H = program.computer.find_hardware_by_name(params["component"])
				if(istype(H) && H.enabled)
					H.enabled = FALSE
					H.disabled()
				. = TRUE
			if("PC_toggle_component")
				var/obj/item/computer_hardware/H = program.computer.find_hardware_by_name(params["component"])
				if(istype(H))
					H.enabled = !H.enabled
					if(H.enabled)
						H.enabled()
					else
						H.disabled()
				. = TRUE
			if("PC_shutdown")
				program.computer.shutdown_computer()
				return TRUE
			if("PC_minimize")
				var/mob/user = usr
				program.computer.minimize_program(user)

			if("PC_killprogram")
				var/prog_name = params["PC_killprogram"]
				var/obj/item/computer_hardware/hard_drive/prog_disk = locate(params["disk"]) in program.computer
				if(!prog_disk)
					return TRUE

				for(var/p in program.computer.all_threads)
					var/datum/computer_file/program/PRG = p
					if(PRG.program_state == PROGRAM_STATE_KILLED)
						continue

					if(PRG.filename == prog_name && (PRG in prog_disk.stored_files))
						PRG.kill_program(forced=TRUE)
						to_chat(usr, SPAN_NOTICE("Program [PRG.filename].[PRG.filetype] has been killed."))
						. = TRUE

			if("PC_runprogram")
				var/obj/item/computer_hardware/hard_drive/prog_disk = locate(params["disk"]) in program.computer
				return program.computer.run_program(params["PC_runprogram"], prog_disk)

			if("PC_setautorun")
				if(!program.computer.hard_drive)
					return
				program.computer.set_autorun(params["PC_setautorun"])
			if("PC_terminal")
				program.computer.open_terminal(usr)
				return TRUE

/datum/nano_module/tgui/ui_status(mob/user, datum/ui_state/state)
	. = ..(user, state ? state : GLOB.default_state)
	if(. > UI_DISABLED && istype(host, /datum/computer_file/program))
		var/datum/computer_file/program/relevant = host
		if(relevant.program_state == PROGRAM_STATE_KILLED)
			. = UI_CLOSE
		else if(relevant.program_state == PROGRAM_STATE_BACKGROUND)
			. = min(., UI_UPDATE) // theoretically might be necessary with a new system, if redundant just collapse this with the killing check.


