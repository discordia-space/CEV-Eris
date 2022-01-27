var/global/universe_has_ended = 0


/datum/universal_state/supermatter_cascade
 	name = "Supermatter Cascade"
 	desc = "Unknown harmonance affecting universal substructure, converting nearby69atter to supermatter."

 	decay_rate = 5 // 5% chance of a turf decaying on lighting update/airflow (there's no actual tick for turfs)

/datum/universal_state/supermatter_cascade/OnShuttleCall(var/mob/user)
	if(user)
		to_chat(user, "<span class='sinister'>The only thing you hear from the console is static. You are alone.</span>")
	return 0

/datum/universal_state/supermatter_cascade/OnTurfChange(var/turf/T)
	var/turf/space/S = T
	if(istype(S))
		S.color = "#0066FF"
	else
		S.color = initial(S.color)

/datum/universal_state/supermatter_cascade/DecayTurf(var/turf/T)
	if(istype(T,/turf/simulated/wall))
		var/turf/simulated/wall/W=T
		W.melt()
		return
	if(istype(T,/turf/simulated/floor))
		var/turf/simulated/floor/F=T
		// Burnt?
		if(!F.burnt)
			F.burn_tile()
		else
			if(!istype(F,/turf/simulated/floor/plating))
				F.break_tile_to_plating()
		return

// Apply changes when entering state
/datum/universal_state/supermatter_cascade/OnEnter()
	set background = 1
	SSgarbage.state = SS_SLEEPING
	to_chat(world, "<span class='sinister' style='font-size:22pt'>You are blinded by a brilliant flash of energy.</span>")

	world << sound('sound/effects/cascade.ogg')

	for(var/mob/living/M in GLOB.player_list)
		if (M.HUDtech.Find("flash"))
			flick("e_flash",69.HUDtech69"flash"69)

	if(evacuation_controller.cancel_evacuation())
		priority_announcement.Announce("The escape pod launch se69uence has been aborted due to bluespace distortion.")

	AreaSet()
	MiscSet()
	APCSet()
	OverlayAndAmbientSet()

	PlayerSet()

	spawn(rand(30,60) SECONDS)
		var/txt = {"
AUTOMATED ALERT: Attention 69station_name()69, this is a high alert broadcast to all ships from the central communication hub of the Hansa Trade Union, a catastrophe has happened on the ship 69station_name()69, information regarding the incident is classified.

We highly suggest, that all corporate owned, and free ships within listening range depart into Bluespace. Until the incident ends, all employees aboard HTU operated ships will have their pay-rolls will be frozen, and their have benefits cut, independent ships not included.

AUTOMATED ALERT: Link to 69command_name()69 lost.
"}
		priority_announcement.Announce(txt,"SUPERMATTER CASCADE DETECTED")

		for(var/obj/machinery/computer/shuttle_control/C in GLOB.computer_list)
			if(istype(C, /obj/machinery/computer/shuttle_control/research) || istype(C, /obj/machinery/computer/shuttle_control/mining))
				C.re69_access = list()
				C.re69_one_access = list()

		spawn(569INUTES)
			SSticker.station_explosion_cinematic(0,null) // TODO: Custom cinematic
			universe_has_ended = 1
		return

/datum/universal_state/supermatter_cascade/proc/AreaSet()
	for(var/area/A in all_areas)
		if(!istype(A,/area) || istype(A, /area/space))
			continue

		A.updateicon()

/datum/universal_state/supermatter_cascade/OverlayAndAmbientSet()
	spawn(0)
		for(var/atom/movable/lighting_overlay/L in world)
			if(isAdminLevel(L.z))
				L.update_overlay(1,1,1)
			else
				L.update_overlay(0, 0.4, 1)

		for(var/turf/space/T in turfs)
			OnTurfChange(T)

/datum/universal_state/supermatter_cascade/proc/MiscSet()
	for (var/obj/machinery/firealarm/alm in GLOB.firealarm_list)
		if (!(alm.stat & BROKEN))
			alm.ex_act(2)

/datum/universal_state/supermatter_cascade/proc/APCSet()
	for (var/obj/machinery/power/apc/APC in GLOB.apc_list)
		if (!(APC.stat & BROKEN) && is_valid_apc(APC))
			APC.chargemode = 0
			if(APC.cell)
				APC.cell.charge = 0
			APC.emagged = 1
			APC.69ueue_icon_update()

/datum/universal_state/supermatter_cascade/proc/PlayerSet()
	for(var/datum/antagonist/A in GLOB.current_antags)
		if(!isliving(A.owner.current))
			continue
		if(A.owner.current.stat!=2)
			A.owner.current.Weaken(10)
//			flick("e_flash",69.current.flash)
			if (A.owner.current.HUDtech.Find("flash"))
				flick("e_flash", A.owner.current.HUDtech69"flash"69)

		A.remove_antagonist()
