#define BAR_CAP 12

/mob/living/exosuit/check_HUD()
	. = ..()
	if(LAZYLEN(pilots)) for(var/mob/living/pilot in pilots) if(pilot.client) update_mech_hud_4(pilot)
	if(client) show_HUD()

/mob/living/exosuit/create_HUD()
	. = ..()
	for(var/mob/living/p in pilots) update_mech_hud_4(p)

/mob/living/exosuit/create_HUDneed()
	. = ..()
	var/datum/hud/HUDdatum = global.HUDdatums[defaultHUD]

	for(var/HUDname in HUDdatum.HUDneed)
		if (!(HUDdatum.HUDneed.Find(HUDname)))
			log_debug("[usr] try create a [HUDname], but it no have in HUDdatum [HUDdatum.name]")
		else
			var/HUDtype = HUDdatum.HUDneed[HUDname]["type"]
			var/obj/screen/HUD = new HUDtype(HUDname, src,\
			HUDdatum.HUDneed[HUDname]["icon"] ? HUDdatum.HUDneed[HUDname]["icon"] : HUDdatum.icon,\
			HUDdatum.HUDneed[HUDname]["icon_state"] ? HUDdatum.HUDneed[HUDname]["icon_state"] : null)
			if(HUDdatum.HUDneed[HUDname]["hideflag"])
				HUD.hideflag = HUDdatum.HUDneed[HUDname]["hideflag"]
			HUDneed[HUD.name] += HUD
			if(HUD.process_flag)
				HUDprocess += HUD
/*
	var/i = 1
	var/list/additional_hud_elements = list(
		/obj/screen/movable/exosuit/toggle/maint,
		/obj/screen/movable/exosuit/eject,
		/obj/screen/movable/exosuit/toggle/hardpoint,
		/obj/screen/movable/exosuit/toggle/hatch,
		/obj/screen/movable/exosuit/toggle/hatch_open,
		/obj/screen/movable/exosuit/radio,
		/obj/screen/movable/exosuit/rename,
		/obj/screen/movable/exosuit/toggle/camera
		)
	if(body && body.pilot_coverage >= 100)
		additional_hud_elements += /obj/screen/movable/exosuit/toggle/air
	i = 0
	var/pos = 7
	for(var/additional_hud in additional_hud_elements)
		var/obj/screen/movable/exosuit/M = new additional_hud(src)
		M.screen_loc = "1:6,[pos]:[i * -12]"
		hud_elements |= M
		i++
		if(i == 3)
			pos--
			i = 0
*/

/mob/living/exosuit/show_HUD()
	. = ..()
	for(var/mob/living/P in pilots)
		update_mech_hud_4(P)

/mob/living/exosuit/handle_regular_hud_updates()
	. = ..()
	for(var/mob/living/L in pilots) update_mech_hud_4(L)
	for(var/obj/screen/movable/exosuit/E in HUDneed)
		E.on_handle_hud(src)

/mob/living/exosuit/proc/get_hardpoints_HUD()
	return HUDneed["mech_hard_point_selector"]

/mob/living/exosuit/proc/reset_hardpoint_HUD()
	var/obj/screen/movable/exosuit/hardpoints_show/H = get_hardpoints_HUD()
	H.myhardpoint = null
	H.update_icon()

/mob/living/exosuit/proc/update_mech_hud_4(var/mob/living/M)
	if(M in pilots)		for(var/i in HUDneed) if(!HUDneed[i] in M.HUDneed) M.HUDneed[i] = HUDneed[i]
	else if(M != src)	for(var/i in HUDneed) LAZYREMOVE(M.HUDneed, i)
	M.check_HUD()

#include "screen_objects.dm"
#include "datum_HUD.dm"
