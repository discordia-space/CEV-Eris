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
	var/datum/hud/exosuits/HUDdatum = global.HUDdatums[defaultHUD]

	for(var/HUDname in HUDdatum.HUDneed)
		if (!(HUDdatum.HUDneed.Find(HUDname)))
			log_debug("[usr] try create a [HUDname], but it no have in HUDdatum [HUDdatum.name]")
		else
			var/obj/screen/movable/exosuit/HUDtype = HUDdatum.HUDneed[HUDname]["type"]
			var/obj/screen/movable/exosuit/HUD = new HUDtype(src)
			NEWorINITIAL(HUD.name, HUDname)
			if(istype(HUD)) NEWorINITIAL(HUD.owner, src)
			NEWorINITIAL(HUD.icon, HUDdatum.HUDneed[HUDname]["icon"])
			NEWorINITIAL(HUD.icon_state, HUDdatum.HUDneed[HUDname]["icon_state"])
			NEWorINITIAL(HUD.screen_loc, HUDdatum.HUDneed[HUDname]["loc"])
			NEWorINITIAL(HUD.hideflag, HUDdatum.HUDneed[HUDname]["hideflag"])

			HUDneed[HUD.name] += HUD
			if(HUD.process_flag) HUDprocess += HUD

/mob/living/exosuit/update_hud()
	. = ..()
	for(var/mob/M in pilots)
		M.update_hud()
	check_HUD()

/mob/living/exosuit/show_HUD()
	. = ..()
	for(var/mob/living/P in pilots)
		update_mech_hud_4(P)

/mob/living/exosuit/handle_regular_hud_updates()
	. = ..()
	for(var/mob/living/L in pilots) update_mech_hud_4(L)
	for(var/obj/screen/movable/exosuit/E in HUDneed) E.on_handle_hud(src)

/mob/living/exosuit/proc/get_hardpoints_HUD()
	return HUDneed["mech_hard_point_selector"]

/mob/living/exosuit/proc/reset_hardpoint_HUD()
	var/obj/screen/movable/exosuit/hardpoints_show/H = get_hardpoints_HUD()
	H.myhardpoint = null
	H.update_icon()

/mob/living/exosuit/proc/update_mech_hud_4(var/mob/living/M)
	if(M.client)
		if(M in pilots)
			M.hud_override = TRUE
			M.hide_HUD()
			for(var/i in HUDneed) M.client.screen |= HUDneed[i]
		else if(M != src)
			M.hud_override = FALSE
			for(var/i in HUDneed) M.client.screen -= HUDneed[i]
			M.reset_HUD()
		if(M != src) M.check_HUD()
		M.reset_view()