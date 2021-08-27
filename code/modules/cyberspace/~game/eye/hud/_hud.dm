/mob/observer/cyberspace_eye
	defaultHUD = "cyberspace_eye"

/mob/observer/cyberspace_eye/Initialize()
	. = ..()
	create_HUD()

/mob/observer/cyberspace_eye/Login()
	. = ..()
	show_HUD()

/mob/observer/cyberspace_eye/update_hud()
	. = ..()
	for(var/i in HUDneed)
		var/obj/screen/movable/cyberspace_eye/E = HUDneed[i]
		if(istype(E))
			E.update_icon()
	show_HUD()

/mob/observer/cyberspace_eye/create_HUDfrippery()
	. = ..()
	if(istype(owner))
		var/datum/hud/cybereye/HUDdatum = GLOB.HUDdatums[defaultHUD]
		if(HUDdatum.use_borders)
			init_HUDpanel(
				1,
				owner.chip_slots,
				HUDdatum.ChipPanel.template,
				HUDdatum.ChipPanel.states,
				HUDdatum.ChipPanel.dirs_of_edges,
				HUDdatum.ChipPanel.direction,
				icon_file = HUDdatum.icon,
			)
			init_HUDpanel(
				1,
				owner.hardware_slots,
				HUDdatum.HardwarePanel.template,
				HUDdatum.HardwarePanel.states,
				HUDdatum.HardwarePanel.dirs_of_edges,
				HUDdatum.HardwarePanel.direction,
				icon_file = HUDdatum.icon,
			)
			init_HUDpanel(
				1,
				owner.memory_buffer.Memory / 16,
				HUDdatum.GripPanel.template,
				HUDdatum.GripPanel.states,
				HUDdatum.GripPanel.dirs_of_edges,
				HUDdatum.GripPanel.direction,
				icon_file = HUDdatum.icon,
			)
			init_HUDpanel(
				1,
				owner.MemoryForInstalledPrograms / 16,
				HUDdatum.ProgramPanel.template,
				HUDdatum.ProgramPanel.states,
				HUDdatum.ProgramPanel.dirs_of_edges,
				HUDdatum.ProgramPanel.direction,
				icon_file = HUDdatum.icon,
			)

/mob/observer/cyberspace_eye/proc/init_HUDpanel(
		start = 1,
		limiter = 4,
		screen_loc_template, // "WEST+%X:11,CENTER+%Y:4"
		list/borders_states, // bottom, upper
		list/borders_dir, // bottom, upper, center
		list/location_dirs, //X, Y, negative and positive numba to invert or double
		icon_file
	)
	limiter += 2
	for(var/i in start to limiter)
		var/obj/screen/border = new(_name = "border", _parentmob = src)
		border.icon_state = "border"
		border.icon = icon_file

		if(i == 1)
			border.dir = length(borders_dir) >= 1 ? borders_dir[1] : borders_dir
			border.icon_state = borders_states[1]
		else if(i == limiter)
			border.dir = length(borders_dir) >= 2 ? borders_dir[2] : borders_dir
			border.icon_state = borders_states[2]
		else
			border.dir = length(borders_dir) >= 3 ? borders_dir[3] : borders_dir

		var/position = screen_loc_template
		position = replacetextEx(position, "%X", i - (limiter*location_dirs[1])/2)
		position = replacetextEx(position, "%Y", i - (limiter*location_dirs[2])/2)//"WEST:11,CENTER+[i - owner.chip_slots + 2]:4"
		border.screen_loc = position
		HUDfrippery += border

/mob/observer/cyberspace_eye/create_HUDneed()
	. = ..()
	var/datum/hud/cybereye/HUDdatum = GLOB.HUDdatums[defaultHUD]
	for(var/HUDname in HUDdatum.HUDneed)
		var/HUDtype = HUDdatum.HUDneed[HUDname]["type"]
		var/obj/screen/movable/cyberspace_eye/SO = new HUDtype(_parentmob = src)
		NEWorNOACTION(SO.name, HUDname)
		NEWorNOACTION(SO.icon, HUDdatum.icon)
		NEWorNOACTION(SO.screen_loc, HUDdatum.HUDneed[HUDname]["loc"])
		NEWorNOACTION(SO.hideflag, HUDdatum.HUDneed[HUDname]["hideflag"])

		HUDneed[HUDname] = SO
		if(SO.process_flag)
			HUDprocess += SO

	if(istype(owner))
		var/hardwareI = 0
		var/chipI = 0
		for(var/obj/item/deck_hardware/H in owner.hardware)
			var/number = 0
			var/screen_position = ""
			var/slots = 1
			if(istype(H, /obj/item/deck_hardware/chip))
				number = chipI
				slots += number - owner.chip_slots / 2

				screen_position = HUDdatum.ChipPanel.template

				chipI++
			else
				number = hardwareI
				slots += number - owner.hardware_slots / 2

				screen_position = HUDdatum.HardwarePanel.template

				hardwareI++

			screen_position = replacetextEx(screen_position, "%X", slots)
			screen_position = replacetextEx(screen_position, "%Y", slots)//"WEST:11,CENTER+[i - owner.chip_slots + 2]:4"

			var/obj/screen/movable/cyberspace_eye/hardware/screenObject = new(_name = "[number + 1]> [H]", _parentmob = src)
			screenObject.screen_loc = screen_position

			screenObject.SetObject(H)
			HUDneed[screenObject.name] = screenObject
