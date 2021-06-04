/mob/proc/create_HUD()
/mob/proc/dead_HUD()
/mob/proc/minimalize_HUD()

/mob/proc/destroy_HUD()
	hide_HUD()
	HUDprocess.Cut()
	for(var/p in HUDneed)
		qdel(HUDneed[p])
	HUDneed.Cut()
	for(var/HUDelement in HUDinventory)
		qdel(HUDelement)
	HUDinventory.Cut()
	for(var/HUDelement in HUDfrippery)
		qdel(HUDelement)
	HUDfrippery.Cut()
	for(var/p in HUDtech)
		qdel(HUDtech[p])
	HUDtech.Cut()

/mob/proc/show_HUD()
	if(client)
		for(var/HUDname in HUDneed)
			client.screen |= HUDneed[HUDname]
		for(var/HUDname in HUDtech)
			client.screen |= HUDtech[HUDname]
		for(var/obj/screen/HUD in HUDinventory + HUDfrippery + HUDprocess)
			client.screen |= HUD

/mob/proc/hide_HUD()
	if(client)
		for(var/HUDname in HUDneed)
			client.screen.Remove(HUDneed[HUDname])
		for(var/HUDname in HUDtech)
			client.screen.Remove(HUDtech[HUDname])
		for(var/obj/screen/HUD in HUDinventory + HUDfrippery + HUDprocess) // Removing of unnamed SOs
			client.screen.Remove(HUD)


//For HUD checking needs
/mob/proc/recolor_HUD(var/_color, var/_alpha)
	for(var/HUDName in HUDneed)
		var/obj/screen/HUD = HUDneed[HUDName] // DO NOT NAME VARIABLES AS SHORTNAMES example of bad naming ["HUDelem", "HUDinv"], example of good naming ["HUDElement", "HUD"]
		HUD.color = _color
		HUD.alpha = _alpha
	for(var/obj/screen/HUD in HUDinventory)
		HUD.color = _color
		HUD.alpha = _alpha

/mob/proc/check_HUD()
	check_HUDdatum() //Elar was here :angrycanvas:
	check_HUDinventory()
	check_HUDneed()
	check_HUDfrippery()
	check_HUDtech()
	check_HUD_style()

/mob/proc/check_HUDdatum() 		// Why the fuck we need so many unused procs of same thing?
/mob/proc/check_HUDinventory() 	// Why the fuck we need so many unused procs of same thing?
/mob/proc/check_HUDneed() 		// Why the fuck we need so many unused procs of same thing?
/mob/proc/check_HUDfrippery() 	// Why the fuck we need so many unused procs of same thing?
/mob/proc/check_HUDtech() 		// Why the fuck we need so many unused procs of same thing?
/mob/proc/check_HUD_style() 	// Why the fuck we need so many unused procs of same thing?

/mob/create_HUD()
	. = ..()
	create_HUDinventory()
	create_HUDneed()
	create_HUDfrippery()
	create_HUDtech()
	show_HUD()

/mob/proc/create_HUDinventory()
/mob/proc/create_HUDneed()
/mob/proc/create_HUDfrippery()
/mob/proc/create_HUDtech()

/mob/proc/reset_HUD()
	destroy_HUD()
	create_HUD()
	update_hud()