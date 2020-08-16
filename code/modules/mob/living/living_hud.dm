/mob/proc/create_HUD()
/mob/proc/dead_HUD()
/mob/proc/minimalize_HUD()

/mob/living/proc/destroy_HUD()
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

/mob/living/proc/show_HUD()
	if(src.client)
		for(var/i=1,i<=HUDneed.len,i++)
			var/p = HUDneed[i]
			src.client.screen += HUDneed[p]
		for(var/obj/screen/HUDinv in src.HUDinventory)
			src.client.screen += HUDinv
		for(var/i=1,i<=HUDtech.len,i++)
			var/p = HUDtech[i]
			src.client.screen += HUDtech[p]

/mob/living/proc/hide_HUD()
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


/mob/living/proc/recolor_HUD(var/_color, var/_alpha)
	for(var/i=1,i<=HUDneed.len,i++)
		var/p = HUDneed[i]
		var/obj/screen/HUDelm = HUDneed[p]
		HUDelm.color = _color
		HUDelm.alpha = _alpha
	for(var/obj/screen/HUDinv in src.HUDinventory)
		HUDinv.color = _color
		HUDinv.alpha = _alpha

/mob/living/proc/check_HUD()//Main HUD check process
	check_HUDdatum() //Elar was here :angrycanvas:
	check_HUDinventory()
	check_HUDneed()
	check_HUDfrippery()
	check_HUDprocess()
	check_HUDtech()
	check_HUD_style()

/mob/living/proc/check_HUDdatum()//correct a datum?
/mob/living/proc/check_HUDinventory()//correct a HUDinventory?
/mob/living/proc/check_HUDneed()
/mob/living/proc/check_HUDfrippery()
/mob/living/proc/check_HUDprocess()
/mob/living/proc/check_HUDtech()
/mob/living/proc/check_HUD_style()

/mob/living/create_HUD()
	. = ..()
	create_HUDinventory()
	create_HUDneed()
	create_HUDfrippery()
	create_HUDtech()
	show_HUD()

/mob/living/proc/create_HUDinventory()//correct a HUDinventory?
/mob/living/proc/create_HUDneed()
/mob/living/proc/create_HUDfrippery()
///mob/living/proc/create_HUDprocess()
/mob/living/proc/create_HUDtech()

/mob/living/proc/reset_HUD()
	destroy_HUD()
	create_HUD()
	update_hud()