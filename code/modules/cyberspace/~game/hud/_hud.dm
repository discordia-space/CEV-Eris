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

/mob/observer/cyberspace_eye/create_HUDneed()
	. = ..()
	var/datum/hud/HUDdatum = GLOB.HUDdatums[defaultHUD]

	for(var/HUDname in HUDdatum.HUDneed)
		if(HUDdatum.HUDneed)
			var/obj/screen/movable/cyberspace_eye/HUDtype = HUDdatum.HUDneed[HUDname]["type"]
			var/obj/screen/movable/cyberspace_eye/SO = new HUDtype(src)
			NEWorNOACTION(SO.name, HUDname)
			NEWorNOACTION(SO.icon, HUDdatum.HUDneed[HUDname]["icon"])
			NEWorNOACTION(SO.icon_state, HUDdatum.HUDneed[HUDname]["icon_state"])
			NEWorNOACTION(SO.screen_loc, HUDdatum.HUDneed[HUDname]["loc"])
			NEWorNOACTION(SO.hideflag, HUDdatum.HUDneed[HUDname]["hideflag"])

			HUDneed[HUDname] = SO
			if(SO.process_flag)
				HUDprocess += SO
	
	if(istype(owner))
		var/i = 0
		while(i <= owner.chip_slots)
			var/obj/screen/movable/cyberspace_eye/chips/H = new(_name = "Chip [i]", _parentmob = src)
			H.screen_loc = "WEST+[i]:4,SOUTH:11"
			HUDneed[H.name] = H
			i++