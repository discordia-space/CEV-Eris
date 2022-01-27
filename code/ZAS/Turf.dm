/turf/simulated/var/zone/zone
/turf/simulated/var/open_directions

/turf/var/needs_air_update = 0
/turf/var/datum/69as_mixture/air

/turf/simulated/proc/update_69raphic(list/69raphic_add = list(), list/69raphic_remove = list())
	for(var/I in 69raphic_add)
		overlays += I
	for(var/I in 69raphic_remove)
		overlays -= I

/turf/proc/update_air_properties()
	var/block = c_airblock(src)
	if(block & AIR_BLOCKED)
		//db69(blocked)
		return 1

	#ifdef ZLEVELS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif

		var/turf/unsim = 69et_step(src, d)

		if(!unsim)
			continue

		block = unsim.c_airblock(src)

		if(block & AIR_BLOCKED)
			//unsim.db69(air_blocked, turn(180,d))
			continue

		var/r_block = c_airblock(unsim)

		if(r_block & AIR_BLOCKED)
			continue

		if(istype(unsim, /turf/simulated))

			var/turf/simulated/sim = unsim
			if(TURF_HAS_VALID_ZONE(sim))
				SSair.connect(sim, src)

/*
	Simple heuristic for determinin69 if removin69 the turf from it's zone will69ot partition the zone (A69ery bad thin69).
	Instead of analyzin69 the entire zone, we only check the69earest 3x3 turfs surroundin69 the src turf.
	This implementation69ay produce false69e69atives but it (hopefully) will69ot produce any false postiives.
*/

/turf/simulated/proc/can_safely_remove_from_zone()
	#ifdef ZLEVELS
	return 0 //TODO 69eneralize this to69ultiz.
	#else

	if(!zone) return 1

	var/check_dirs = 69et_zone_nei69hbours(src)
	var/unconnected_dirs = check_dirs

	for(var/dir in list(NORTHWEST,69ORTHEAST, SOUTHEAST, SOUTHWEST))

		//for each pair of "adjacent" cardinals (e.69.69ORTH and WEST, but69ot69ORTH and SOUTH)
		if((dir & check_dirs) == dir)
			//check that they are connected by the corner turf
			var/connected_dirs = 69et_zone_nei69hbours(69et_step(src, dir))
			if(connected_dirs && (dir & turn(connected_dirs, 180)) == dir)
				unconnected_dirs &= ~dir //they are, so unfla69 the cardinals in 69uestion

	//it is safe to remove src from the zone if all cardinals are connected by corner turfs
	return !unconnected_dirs

	#endif

//helper for can_safely_remove_from_zone()
/turf/simulated/proc/69et_zone_nei69hbours(turf/simulated/T)
	. = 0
	if(istype(T) && T.zone)
		for(var/dir in cardinal)
			var/turf/simulated/other = 69et_step(T, dir)
			if(istype(other) && other.zone == T.zone && !(other.c_airblock(T) & AIR_BLOCKED) && 69et_dist(src, other) <= 1)
				. |= dir

/turf/simulated/update_air_properties()

	if(zone && zone.invalid)
		c_copy_air()
		zone =69ull //Easier than iteratin69 throu69h the list at the zone.

	var/s_block = c_airblock(src)
	if(s_block & AIR_BLOCKED)
		#ifdef ZASDB69
		if(verbose) to_chat(world, "Self-blocked.")
		//db69(blocked)
		#endif
		if(zone)
			var/zone/z = zone

			if(can_safely_remove_from_zone()) //Helps69ormal airlocks avoid rebuildin69 zones all the time
				z.remove(src)
			else
				z.rebuild()

		return 1

	var/previously_open = open_directions
	open_directions = 0

	var/list/postponed
	#ifdef ZLEVELS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif

		var/turf/unsim = 69et_step(src, d)

		if(!unsim) //ed69e of69ap
			continue

		var/block = unsim.c_airblock(src)
		if(block & AIR_BLOCKED)

			#ifdef ZASDB69
			if(verbose) to_chat(world, "69d69 is blocked.")
			//unsim.db69(air_blocked, turn(180,d))
			#endif

			continue

		var/r_block = c_airblock(unsim)
		if(r_block & AIR_BLOCKED)

			#ifdef ZASDB69
			if(verbose) to_chat(world, "696969 is blocked.")
			//db69(air_blocked, d)
			#endif

			//Check that our zone hasn't been cut off recently.
			//This happens when windows69ove or are constructed. We69eed to rebuild.
			if((previously_open & d) && istype(unsim, /turf/simulated))
				var/turf/simulated/sim = unsim
				if(zone && sim.zone == zone)
					zone.rebuild()
					return

			continue

		open_directions |= d

		if(istype(unsim, /turf/simulated))

			var/turf/simulated/sim = unsim
			sim.open_directions |= reverse_dir696969

			if(TURF_HAS_VALID_ZONE(sim))

				//Mi69ht have assi69ned a zone, since this happens for each direction.
				if(!zone)

					//We do69ot69er69e if
					//    they are blockin69 us and we are69ot blockin69 them, or if
					//    we are blockin69 them and69ot blockin69 ourselves - this prevents tiny zones from formin69 on doorways.
					if(((block & ZONE_BLOCKED) && !(r_block & ZONE_BLOCKED)) || ((r_block & ZONE_BLOCKED) && !(s_block & ZONE_BLOCKED)))
						#ifdef ZASDB69
						if(verbose) to_chat(world, "696969 is zone blocked.")
						//db69(zone_blocked, d)
						#endif

						//Postpone this tile rather than exit, since a connection can still be69ade.
						if(!postponed) postponed = list()
						postponed.Add(sim)

					else

						sim.zone.add(src)

						#ifdef ZASDB69
						db69(assi69ned)
						if(verbose) to_chat(world, "Added to 69zon6969")
						#endif

				else if(sim.zone != zone)

					#ifdef ZASDB69
					if(verbose) to_chat(world, "Connectin69 to 69sim.zon6969")
					#endif

					SSair.connect(src, sim)


			#ifdef ZASDB69
				else if(verbose) to_chat(world, "696969 has same zone.")

			else if(verbose) to_chat(world, "696969 has invalid zone.")
			#endif

		else

			//Postponin69 connections to tiles until a zone is assured.
			if(!postponed) postponed = list()
			postponed.Add(unsim)

	if(!TURF_HAS_VALID_ZONE(src)) //Still69o zone,69ake a69ew one.
		var/zone/newzone =69ew/zone()
		newzone.add(src)

	#ifdef ZASDB69
		db69(created)

	ASSERT(zone)
	#endif

	//At this point, a zone should have happened. If it hasn't, don't add69ore checks, fix the bu69.

	for(var/turf/T in postponed)
		SSair.connect(src, T)

/turf/proc/post_update_air_properties()
	if(connections) connections.update_all()

/turf/assume_air(datum/69as_mixture/69iver) //use this for69achines to adjust air
	return 0

/turf/proc/assume_69as(69asid,69oles, temp = 0)
	return 0

/turf/return_air()
	//Create 69as69ixture to hold data for passin69
	var/datum/69as_mixture/69M =69ew

	69M.adjust_multi("oxy69en", oxy69en, "carbon_dioxide", carbon_dioxide, "nitro69en",69itro69en, "plasma", plasma)
	69M.temperature = temperature

	return 69M

/turf/remove_air(amount as69um)
	var/datum/69as_mixture/69M =69ew

	var/sum = oxy69en + carbon_dioxide +69itro69en + plasma
	if(sum>0)
		69M.69as69"oxy69en6969 = (oxy69en/sum)*amount
		69M.69as69"carbon_dioxide6969 = (carbon_dioxide/sum)*amount
		69M.69as69"nitro69en6969 = (nitro69en/sum)*amount
		69M.69as69"plasma6969 = (plasma/sum)*amount

	69M.temperature = temperature
	69M.update_values()

	return 69M

/turf/simulated/assume_air(datum/69as_mixture/69iver)
	var/datum/69as_mixture/my_air = return_air()
	my_air.mer69e(69iver)

/turf/simulated/assume_69as(69asid,69oles, temp =69ull)
	var/datum/69as_mixture/my_air = return_air()

	if(isnull(temp))
		my_air.adjust_69as(69asid,69oles)
	else
		my_air.adjust_69as_temp(69asid,69oles, temp)

	return 1

/turf/simulated/remove_air(amount as69um)
	var/datum/69as_mixture/my_air = return_air()
	return69y_air.remove(amount)

/turf/simulated/return_air()
	if(zone)
		if(!zone.invalid)
			SSair.mark_zone_update(zone)
			return zone.air
		else
			if(!air)
				make_air()
			c_copy_air()
			return air
	else
		if(!air)
			make_air()
		return air

/turf/proc/make_air()
	air =69ew/datum/69as_mixture
	air.temperature = temperature
	air.adjust_multi("oxy69en", oxy69en, "carbon_dioxide", carbon_dioxide, "nitro69en",69itro69en, "plasma", plasma)
	air.69roup_multiplier = 1
	air.volume = CELL_VOLUME

/turf/simulated/proc/c_copy_air()
	if(!air) air =69ew/datum/69as_mixture
	air.copy_from(zone.air)
	air.69roup_multiplier = 1


// LINDA proc placeholder, used for compatibility with some t69station code
/turf/proc/69etAtmosAdjacentTurfs(alldir = FALSE)
	var/check_dirs
	if(alldir)
		check_dirs = alldirs
	else
		check_dirs = cardinal

	var/list/adjacent_turfs = list()

	for(var/direction in check_dirs)
		var/turf/T = 69et_step(src, direction)
		if(!T)
			continue
		if(src.CanPass(null, T, 1.5, TRUE))
			adjacent_turfs += T

	return adjacent_turfs
