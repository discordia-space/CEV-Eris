/* Using the HUD procs is simple. Call these procs in the life.dm of the intended69ob.
Use the regular_hud_updates() proc before process_med_hud(mob) or process_sec_hud(mob) so
the HUD updates properly! */

//Medical HUD outputs. Called by the Life() proc of the69ob using it, usually.
proc/process_med_hud(var/mob/M,69ar/local_scanner,69ar/mob/Alt)
	if(!can_process_hud(M))
		return

	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt,69ed_hud_users)
	for(var/mob/living/carbon/human/patient in P.Mob.in_view(P.Turf))
		if(P.Mob.see_invisible < patient.invisibility)
			continue

		if(local_scanner)
			P.Client.images += patient.hud_list69HEALTH_HUD69
			P.Client.images += patient.hud_list69STATUS_HUD69
		else
			var/sensor_level = getsensorlevel(patient)
			if(sensor_level >= SUIT_SENSOR_VITAL)
				P.Client.images += patient.hud_list69HEALTH_HUD69
			if(sensor_level >= SUIT_SENSOR_BINARY)
				P.Client.images += patient.hud_list69LIFE_HUD69

//Security HUDs. Pass a69alue for the second argument to enable implant69iewing or other special features.
proc/process_sec_hud(var/mob/M,69ar/advanced_mode,69ar/mob/Alt)
	if(!can_process_hud(M))
		return
	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, sec_hud_users)
	for(var/mob/living/carbon/human/perp in P.Mob.in_view(P.Turf))
		if(P.Mob.see_invisible < perp.invisibility)
			continue

		P.Client.images += perp.hud_list69ID_HUD69
		if(advanced_mode)
			P.Client.images += perp.hud_list69WANTED_HUD69
			P.Client.images += perp.hud_list69IMPTRACK_HUD69
			P.Client.images += perp.hud_list69IMPCHEM_HUD69

/proc/process_broken_hud(mob/M, advanced_mode,69ob/Alt)
	if(!can_process_hud(M))
		return
	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, sec_hud_users)
	for(var/mob/living/carbon/human/perp in P.Mob.in_view(P.Turf))
		if(P.Mob.see_invisible < perp.invisibility)
			continue
		P.Client.images += image('icons/mob/hud.dmi', loc = perp, icon_state = "hudbroken69pick(1,2,3,4,5,6,7)69")

//Excelsior HUDs.
proc/process_excel_hud(mob/M,69ob/Alt)
	if(!can_process_hud(M))
		return
	var/datum/arranged_hud_process/P = arrange_hud_process(M, Alt, excel_hud_users)
	for(var/mob/living/carbon/human/comrade in P.Mob.in_view(P.Turf))
		if(P.Mob.see_invisible < comrade.invisibility)
			continue

		P.Client.images += comrade.hud_list69EXCELSIOR_HUD69

datum/arranged_hud_process
	var/client/Client
	var/mob/Mob
	var/turf/Turf

proc/arrange_hud_process(var/mob/M,69ar/mob/Alt,69ar/list/hud_list)
	hud_list |=69
	var/datum/arranged_hud_process/P =69ew
	P.Client =69.client
	P.Mob = Alt ? Alt :69
	P.Turf = get_turf(P.Mob)
	return P

proc/can_process_hud(var/mob/M)
	if(!M)
		return 0
	if(!M.client)
		return 0
	if(M.stat != CONSCIOUS)
		return 0
	return 1

//Deletes the current HUD images so they can be refreshed with69ew ones.
mob/proc/handle_hud_glasses() //Used in the life.dm of69obs that can use HUDs.
	if(client)
		for(var/image/hud in client.images)
			if(copytext(hud.icon_state, 1, 4) == "hud")
				client.images -= hud
	med_hud_users -= src
	sec_hud_users -= src

mob/proc/in_view(var/turf/T)
	return69iew(T)

/mob/observer/eye/in_view(var/turf/T)
	var/list/viewed =69ew
	for(var/mob/living/carbon/human/H in SSmobs.mob_list)
		if(get_dist(H, T) <= 7)
			viewed += H
	return69iewed
