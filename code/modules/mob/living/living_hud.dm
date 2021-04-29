/mob/proc/create_HUD()
/mob/proc/dead_HUD()
/mob/proc/minimalize_HUD()

/mob/proc/destroy_HUD()
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
		for(var/p in HUDneed)
			client.screen |= HUDneed[p]
		for(var/obj/screen/HUDinv in HUDinventory)
			client.screen |= HUDinv
		for(var/p in HUDtech)
			client.screen |= HUDtech[p]

/mob/proc/hide_HUD()
	if(client)
		for(var/i = 1 to HUDneed.len)
			client.screen.Remove(HUDneed[HUDneed[i]])

		for(var/obj/screen/HUDinv in HUDinventory)
			client.screen.Remove(HUDinv)

		for(var/obj/screen/HUDinv in HUDfrippery)
			client.screen.Remove(HUDinv)

		for(var/obj/screen/HUDinv in HUDprocess)
			client.screen.Remove(HUDinv)

		for(var/i = 1 to HUDtech.len)
			client.screen.Remove(HUDtech[HUDtech[i]])

//For HUD checking needs


/mob/proc/recolor_HUD(var/_color, var/_alpha)
	for(var/i=1,i<=HUDneed.len,i++)
		var/p = HUDneed[i]
		var/obj/screen/HUDelm = HUDneed[p]
		HUDelm.color = _color
		HUDelm.alpha = _alpha
	for(var/obj/screen/HUDinv in src.HUDinventory)
		HUDinv.color = _color
		HUDinv.alpha = _alpha

/mob/proc/check_HUD()//Main HUD check process
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