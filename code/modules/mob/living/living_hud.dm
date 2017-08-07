/mob/proc/create_HUD()
	return

/mob/proc/minimalize_HUD()
	return

/mob/living/proc/destroy_HUD()
	var/mob/living/H = src
	H.HUDprocess.Cut()
	for (var/p in H.HUDneed)
		qdel(H.HUDneed[p])
	for (var/HUDelement in H.HUDinventory)
		qdel(HUDelement)
	for (var/HUDelement in H.HUDfrippery)
		qdel(HUDelement)
	for (var/p in H.HUDtech)
		qdel(H.HUDtech[p])
	H.HUDtech.Cut()
	H.HUDneed.Cut()
	H.HUDinventory.Cut()
	H.HUDfrippery.Cut()
	return

/mob/living/proc/show_HUD()
	if(src.client)
		for (var/i=1,i<=HUDneed.len,i++)
			var/p = HUDneed[i]
			src.client.screen += HUDneed[p]
		for (var/obj/screen/HUDinv in src.HUDinventory)
			src.client.screen += HUDinv
		for (var/i=1,i<=HUDtech.len,i++)
			var/p = HUDtech[i]
			src.client.screen += HUDtech[p]
//For HUD checking needs
	return

/mob/living/proc/recolor_HUD(var/_color, var/_alpha)
	for (var/i=1,i<=HUDneed.len,i++)
		var/p = HUDneed[i]
		var/obj/screen/HUDelm = HUDneed[p]
		HUDelm.color = _color
		HUDelm.alpha = _alpha
	for (var/obj/screen/HUDinv in src.HUDinventory)
		HUDinv.color = _color
		HUDinv.alpha = _alpha
	return

/mob/living/proc/check_HUD()//Main HUD check process
	return

/mob/living/proc/check_HUDdatum()//correct a datum?
	return
/mob/living/proc/check_HUDinventory()//correct a HUDinventory?
	return
/mob/living/proc/check_HUDneed()
	return
/mob/living/proc/check_HUDfrippery()
	return
/mob/living/proc/check_HUDprocess()
	return
/mob/living/proc/check_HUDtech()
	return
/mob/living/proc/check_HUD_style()
	return


/mob/living/proc/create_HUDinventory()//correct a HUDinventory?
	return
/mob/living/proc/create_HUDneed()
	return
/mob/living/proc/create_HUDfrippery()
	return
///mob/living/proc/create_HUDprocess()
//	return
/mob/living/proc/create_HUDtech()
	return