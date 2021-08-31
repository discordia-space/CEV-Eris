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
	var/datum/hud/exosuits/HUDdatum = GLOB.HUDdatums[defaultHUD]

	for(var/HUDname in HUDdatum.HUDneed)
		if(HUDdatum.HUDneed)
			var/obj/screen/movable/exosuit/HUDtype = HUDdatum.HUDneed[HUDname]["type"]
			var/obj/screen/movable/exosuit/HUD = new HUDtype(src)
			NEWorINITIAL(HUD.name, HUDname)
			if(istype(HUD)) NEWorINITIAL(HUD.owner, src)
			NEWorINITIAL(HUD.icon, HUDdatum.HUDneed[HUDname]["icon"])
			NEWorINITIAL(HUD.icon_state, HUDdatum.HUDneed[HUDname]["icon_state"])
			NEWorINITIAL(HUD.screen_loc, HUDdatum.HUDneed[HUDname]["loc"])
			NEWorINITIAL(HUD.hideflag, HUDdatum.HUDneed[HUDname]["hideflag"])

			HUDneed[HUD.name] = HUD
			if(HUD.process_flag) HUDprocess += HUD
	var/i = 0
	for(var/hardpoint in hardpoints)
		var/obj/screen/movable/exosuit/hardpoint/H = new(src, hardpoint)
		H.screen_loc = "WEST:4,CENTER+[6-i]"
		HUDneed[hardpoint] = H
		i++

/mob/living/exosuit/update_hud()
	. = ..()
	for(var/mob/M in pilots) M.update_hud()
	check_HUD()

/mob/living/exosuit/show_HUD()
	. = ..()
	for(var/mob/living/P in pilots) update_mech_hud_4(P)

/mob/living/exosuit/handle_regular_hud_updates()
	. = ..()
	for(var/mob/living/L in pilots) update_mech_hud_4(L)
	for(var/i in HUDneed)
		var/obj/screen/movable/exosuit/E = HUDneed[i]
		if(E && istype(E)) E.on_handle_hud(src)

/mob/living/exosuit/proc/update_mech_hud_4(var/mob/living/M)
	if(M.client && M != src && HUDneed.len)
		if(M in pilots)
			for(var/i in HUDneed) if(HUDneed[i]) M.client.screen |= HUDneed[i]
			M.reset_view(src)
		else
			for(var/i in HUDneed) if(HUDneed[i]) M.client.screen -= HUDneed[i]
			M.update_hud()
		M.check_HUD()