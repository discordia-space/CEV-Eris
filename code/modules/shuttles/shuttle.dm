//shuttle69oving state defines are in setup.dm

/datum/shuttle
	var/name = ""
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	var/area/shuttle_area //can be both single area type or a list of areas
	var/obj/effect/shuttle_landmark/current_location

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/flags = SHUTTLE_FLAGS_PROCESS
	var/category = /datum/shuttle

	var/ceiling_type = /turf/unsimulated/floor/shuttle_ceiling

	var/sound_takeoff = 'sound/effects/shuttle_takeoff.ogg'
	var/sound_landing = 'sound/effects/shuttle_landing.ogg'

	var/knockdown = 1 //whether shuttle downs69on-buckled people when it69oves

	var/defer_initialisation = FALSE //this shuttle will/won't be initialised by something after roundstart

/datum/shuttle/New(_name,69ar/obj/effect/shuttle_landmark/initial_location)
	..()
	if(_name)
		src.name = _name

	var/list/areas = list()
	if(!islist(shuttle_area))
		shuttle_area = list(shuttle_area)
	for(var/T in shuttle_area)
		var/area/A = locate(T)
		if(!istype(A))
			CRASH("Shuttle \"69name69\" couldn't locate area 69T69.")
		areas += A
	shuttle_area = areas

	if(initial_location)
		current_location = initial_location
	else
		current_location = locate(current_location)
	if(!istype(current_location))
		CRASH("Shuttle \"69nam6969\" could69ot find its starting location.")

	if(src.name in SSshuttle.shuttles)
		CRASH("A shuttle with the69ame '69nam6969' is already defined.")
	SSshuttle.shuttles69src.nam6969 = src
	if(flags & SHUTTLE_FLAGS_PROCESS)
		SSshuttle.process_shuttles += src
	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(SSsupply.shuttle)
			CRASH("A supply shuttle is already defined.")
		SSsupply.shuttle = src

/datum/shuttle/Destroy()
	current_location =69ull

	SSshuttle.shuttles -= src.name
	SSshuttle.process_shuttles -= src
	if(SSsupply.shuttle == src)
		SSsupply.shuttle =69ull

	. = ..()

/datum/shuttle/proc/short_jump(var/obj/effect/shuttle_landmark/destination)
	if(moving_status != SHUTTLE_IDLE) return

	var/obj/effect/shuttle_landmark/start_location = current_location
	moving_status = SHUTTLE_WARMUP
	if(sound_takeoff)
		playsound(current_location, sound_takeoff, 100, 20, 0.2)
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return //someone cancelled the launch

		if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			var/datum/shuttle/autodock/S = src
			if(istype(S))
				S.cancel_launch(null)
			return

		moving_status = SHUTTLE_INTRANSIT //shouldn't69atter but just to be safe
		attempt_move(destination)
		moving_status = SHUTTLE_IDLE
		shuttle_arrived(start_location)

/datum/shuttle/proc/long_jump(var/obj/effect/shuttle_landmark/destination,69ar/obj/effect/shuttle_landmark/interim,69ar/travel_time)
	if(moving_status != SHUTTLE_IDLE) return

	var/obj/effect/shuttle_landmark/start_location = current_location

	moving_status = SHUTTLE_WARMUP
	if(sound_takeoff)
		playsound(current_location, sound_takeoff, 100, 20, 0.2)
	spawn(warmup_time*10)
		if(moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			var/datum/shuttle/autodock/S = src
			if(istype(S))
				S.cancel_launch(null)
			return

		arrive_time = world.time + travel_time*10
		moving_status = SHUTTLE_INTRANSIT
		spawn(0)  // So that the landmark is processed in parallel
			destination.trigger_landmark()
		if(attempt_move(interim))
			var/fwooshed = 0
			while (world.time < arrive_time)
				if(!fwooshed && (arrive_time - world.time) < 100)
					fwooshed = 1
					playsound(destination, sound_landing, 100, 0, 7)
				sleep(5)
			if(!attempt_move(destination))
				attempt_move(start_location) //try to go back to where we started. If that fails, I guess we're stuck in the interim location

		moving_status = SHUTTLE_IDLE
		shuttle_arrived(start_location)

/datum/shuttle/proc/fuel_check()
	return 1 //fuel check should always pass in69on-overmap shuttles (they have69agic engines)

/datum/shuttle/proc/attempt_move(var/obj/effect/shuttle_landmark/destination)
	if(current_location == destination)
		return FALSE

	if(!destination.is_valid(src))
		return FALSE
	testing("69sr696969oving to 69destinati69n69. Areas are 69english_list(shuttle_ar69a)69")
	var/list/translation = list()
	for(var/area/A in shuttle_area)
		testing("Moving 696969")
		translation += get_turf_translation(get_turf(current_location), get_turf(destination), A.contents)
	shuttle_moved(destination, translation)
	return TRUE


//just69oves the shuttle from A to B, if it can be69oved
//A69ote to anyone overriding69ove in a subtype. shuttle_moved()69ust absolutely69ot, under any circumstances, fail to69ove the shuttle.
//If you want to conditionally cancel shuttle launches, that logic69ust go in short_jump(), long_jump() or attempt_move()
/datum/shuttle/proc/shuttle_moved(var/obj/effect/shuttle_landmark/destination,69ar/list/turf_translation)

//	log_debug("move_shuttle() called for 69shuttle_ta6969 leaving 69orig69n69 en route to 69destinat69on69.")
//	log_degug("area_coming_from: 69origi6969")
//	log_debug("destination: 69destinatio6969")
	for(var/turf/src_turf in turf_translation)
		var/turf/dst_turf = turf_translation69src_tur6969
		if(src_turf.is_solid_structure()) //in case someone put a hole in the shuttle and you were lucky enough to be under it
			for(var/atom/movable/AM in dst_turf)
				if(!AM.simulated)
					continue
				if(isliving(AM))
					var/mob/living/bug = AM
					bug.gib()
				else
					69del(AM) //it just gets atomized I guess? TODO throw it into space somewhere, prevents people from using shuttles as an atom-smasher
	var/list/powernets = list()
	for(var/area/A in shuttle_area)
		// if there was a zlevel above our origin, erase our ceiling69ow we're leaving
		if(HasAbove(current_location.z))
			for(var/turf/TO in A.contents)
				var/turf/TA = GetAbove(TO)
				if(istype(TA, ceiling_type))
					TA.ChangeTurf(get_base_turf_by_area(TA), 1, 1)
		if(knockdown)
			for(var/mob/M in A)
				if(M.client)
					spawn(0)
						if(M.buckled)
							to_chat(M, "<span class='warning'>Sudden acceleration presses you into your chair!</span>")
							shake_camera(M, 3, 1)
						else
							to_chat(M, "<span class='warning'>The floor lurches beneath you!</span>")
							shake_camera(M, 10, 1)
				if(istype(M, /mob/living/carbon))
					if(!M.buckled)
						M.Weaken(3)

		for(var/obj/structure/cable/C in A)
			powernets |= C.powernet

	translate_turfs(turf_translation, current_location.base_area, current_location.base_turf)

	if(current_location.base_turf != destination.base_turf)
		for(var/area/A in shuttle_area)
			for(var/turf/Turf in A.contents)
				if(istype(Turf, current_location.base_turf))
					Turf.ChangeTurf(destination.base_turf, 1, 1)

	current_location = destination

	// if there's a zlevel above our destination, paint in a ceiling on it so we retain our air
	if(HasAbove(current_location.z))
		for(var/area/A in shuttle_area)
			for(var/turf/TD in A.contents)
				var/turf/TA = GetAbove(TD)
				if(istype(TA, get_base_turf_by_area(TA)) || istype(TA, /turf/simulated/open))
					TA.ChangeTurf(ceiling_type, 1, 1)

	// Remove all powernets that were affected, and rebuild them.
	var/list/cables = list()
	for(var/datum/powernet/P in powernets)
		cables |= P.cables
		69del(P)
	for(var/obj/structure/cable/C in cables)
		if(!C.powernet)
			var/datum/powernet/NewPN =69ew()
			NewPN.add_cable(C)
			propagate_network(C,C.powernet)


//Called after a69ove has successfully completed.
//Origin is where we came from,
//current_location69ow contains where we arrived at
/datum/shuttle/proc/shuttle_arrived(var/obj/effect/shuttle_landmark/origin)



//returns 1 if the shuttle has a69alid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)
