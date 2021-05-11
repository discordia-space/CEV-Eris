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
			NEWorNOACTION(SO.icon, HUDdatum.icon)
			NEWorNOACTION(SO.screen_loc, HUDdatum.HUDneed[HUDname]["loc"])
			NEWorNOACTION(SO.hideflag, HUDdatum.HUDneed[HUDname]["hideflag"])

			HUDneed[HUDname] = SO
			if(SO.process_flag)
				HUDprocess += SO
	
	if(istype(owner))
		var/hardwareI = 0
		var/chipI = 0
		for(var/obj/item/weapon/deck_hardware/H in owner.hardware)
			var/number = 0
			var/screen_position = ""
			if(istype(H, /obj/item/weapon/deck_hardware/chip))
				number = chipI
				screen_position = "CENTER+[chipI - owner.chip_slots + 2]:4,SOUTH:11"
				chipI++
			else
				number = hardwareI
				screen_position = "WEST:4,CENTER+[hardwareI - owner.hardware_slots + 4]:11"
				hardwareI++
			
			var/obj/screen/movable/cyberspace_eye/hardware/screenObject = new(_name = "[number + 1]> [H]", _parentmob = src)
			screenObject.screen_loc = screen_position

			screenObject.SetObject(H)
			HUDneed[screenObject.name] = screenObject
