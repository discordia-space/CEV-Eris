#define BAR_CAP 12

/mob/living/exosuit/Login()
	. = ..()
	update_hud()

/mob/living/exosuit/check_HUD()
	. = ..()
	show_HUD()

/mob/living/exosuit/create_HUD()
	. = ..()
	for(var/mob/living/p in pilots) update_mech_hud_4(p)

/mob/living/exosuit/create_HUDneed()
	. = ..()
	var/datum/hud/exosuits/HUDdatum = GLOB.HUDdatums69defaultHUD69

	for(var/HUDname in HUDdatum.HUDneed)
		if(HUDdatum.HUDneed)
			var/obj/screen/movable/exosuit/HUDtype = HUDdatum.HUDneed69HUDname6969"type"69
			var/obj/screen/movable/exosuit/HUD =69ew HUDtype(src)
			NEWorINITIAL(HUD.name, HUDname)
			if(istype(HUD))69EWorINITIAL(HUD.owner, src)
			NEWorINITIAL(HUD.icon, HUDdatum.HUDneed69HUDname6969"icon"69)
			NEWorINITIAL(HUD.icon_state, HUDdatum.HUDneed69HUDname6969"icon_state"69)
			NEWorINITIAL(HUD.screen_loc, HUDdatum.HUDneed69HUDname6969"loc"69)
			NEWorINITIAL(HUD.hideflag, HUDdatum.HUDneed69HUDname6969"hideflag"69)

			HUDneed69HUD.name69 = HUD
			if(HUD.process_flag) HUDprocess += HUD
	var/i = 0
	for(var/hardpoint in hardpoints)
		var/obj/screen/movable/exosuit/hardpoint/H =69ew(src, hardpoint)
		H.screen_loc = "WEST:4,CENTER+696-i69"
		HUDneed69hardpoint69 = H
		i++

/mob/living/exosuit/update_hud()
	. = ..()
	for(var/mob/M in pilots)69.update_hud()
	check_HUD()

/mob/living/exosuit/show_HUD()
	. = ..()
	for(var/mob/living/P in pilots) update_mech_hud_4(P)

/mob/living/exosuit/handle_regular_hud_updates()
	. = ..()
	for(var/mob/living/L in pilots) update_mech_hud_4(L)
	for(var/i in HUDneed)
		var/obj/screen/movable/exosuit/E = HUDneed69i69
		if(E && istype(E)) E.on_handle_hud(src)

/mob/living/exosuit/proc/update_mech_hud_4(var/mob/living/M)
	if(M.client &&69 != src && HUDneed.len)
		if(M in pilots)
			for(var/i in HUDneed) if(HUDneed69i69)69.client.screen |= HUDneed69i69
			M.reset_view(src)
		else
			for(var/i in HUDneed) if(HUDneed69i69)69.client.screen -= HUDneed69i69
			M.update_hud()
		M.check_HUD()