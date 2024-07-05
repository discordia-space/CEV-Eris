// Helper for can_safely_remove_from_zone(). Stolen from Aurora(i think)
#define GET_ZONE_NEIGHBOURS(T, ret) \
	ret = 0; \
	if (T.zone) { \
		for (var/_gzn_dir in GLOB.gzn_check) { \
			var/turf/other = get_step(T, _gzn_dir); \
			if (istype(other) && other.zone == T.zone) { \
				var/block; \
				ATMOS_CANPASS_TURF(block, other, T); \
				if (!(block & AIR_BLOCKED)) { \
					ret |= _gzn_dir; \
				} \
			} \
		} \
	}


/turf/proc/update_graphic(list/graphic_add = null, list/graphic_remove = null)
	if(graphic_add && graphic_add.len)
		vis_contents += graphic_add
	if(graphic_remove && graphic_remove.len)
		vis_contents -= graphic_remove


/turf/proc/update_air_properties()
	#ifdef ZASDBG
	if(air)
		maptext_height = 16
		maptext_width = 32
		maptext = "[round(air.total_moles)]"
	else
		maptext = null
	#endif

	if(is_simulated)
		if(zone && zone.invalid)
			c_copy_air()
			zone = null //Easier than iterating through the list at the zone.

		var/s_block
		ATMOS_CANPASS_TURF(s_block, src, src)
		if(s_block & AIR_BLOCKED)
			#ifdef ZASDBG
			add_ZAS_debug_overlay(ZAS_DEBUG_OVERLAY_AIR_FULLY_BLOCKED)
			#endif
			if(zone)
				var/zone/z = zone
				if(can_safely_remove_from_zone()) //Helps normal airlocks avoid rebuilding zones all the time
					c_copy_air()
					z.remove(src)
				else
					z.rebuild()
			return TRUE

		var/previously_open = open_directions
		open_directions = 0
		var/list/postponed
		#ifdef ZLEVELS
		for(var/d = 1, d < 64, d *= 2)
		#else
		for(var/d = 1, d < 16, d *= 2)
		#endif

			var/turf/neighbour_turf = get_step(src, d)
			if(!neighbour_turf) // Edge of map
				continue

			var/block = neighbour_turf.c_airblock(src)
			if(block & AIR_BLOCKED)
				#ifdef ZASDBG
				neighbour_turf.add_ZAS_debug_overlay(ZAS_DEBUG_OVERLAY_AIR_DIRECTION_BLOCKED, turn(180, d))
				#endif
				continue

			var/r_block = c_airblock(neighbour_turf)
			if(r_block & AIR_BLOCKED)
				#ifdef ZASDBG
				add_ZAS_debug_overlay(ZAS_DEBUG_OVERLAY_AIR_DIRECTION_BLOCKED, d)
				#endif
				//Check that our zone hasn't been cut off recently.
				//This happens when windows move or are constructed. We need to rebuild.
				if((previously_open & d) && neighbour_turf.is_simulated)
					if(zone && neighbour_turf.zone == zone)
						zone.rebuild()
						return
				continue
			open_directions |= d

			if(neighbour_turf.is_simulated)
				neighbour_turf.open_directions |= reverse_dir[d]
				if(TURF_HAS_VALID_ZONE(neighbour_turf))
					//Might have assigned a zone, since this happens for each direction.
					if(!zone)
						//We do not merge if
						//    they are blocking us and we are not blocking them, or if
						//    we are blocking them and not blocking ourselves - this prevents tiny zones from forming on doorways.
						if(((block & ZONE_BLOCKED) && !(r_block & ZONE_BLOCKED)) || ((r_block & ZONE_BLOCKED) && !(s_block & ZONE_BLOCKED)))
							//Postpone this tile rather than exit, since a connection can still be made.
							if(!postponed)
								postponed = list()
							postponed.Add(neighbour_turf)
						else
							neighbour_turf.zone.add(src)
							#ifdef ZASDBG
							add_ZAS_debug_overlay(ZAS_DEBUG_OVERLAY_ZONE_ASSIGNED)
							#endif
					else if(neighbour_turf.zone != zone)
						SSair.connect(src, neighbour_turf)

		if(!TURF_HAS_VALID_ZONE(src)) //Still no zone, make a new one.
			var/zone/newzone = new/zone()
			newzone.add(src)

		#ifdef ZASDBG
			add_ZAS_debug_overlay(ZAS_DEBUG_OVERLAY_ZONE_CREATED)
		ASSERT(zone)
		#endif

		//At this point, a zone should have happened. If it hasn't, don't add more checks, fix the bug.
		for(var/turf/postproned_turf as anything in postponed)
			SSair.connect(src, postproned_turf)

	else // Not simulated. Curious why it got any simulation at all // TODO: Try disabling it? --KIROV
		var/block = c_airblock(src)
		if(block & AIR_BLOCKED)
			#ifdef ZASDBG
			add_ZAS_debug_overlay(ZAS_DEBUG_OVERLAY_AIR_FULLY_BLOCKED)
			#endif
			return 1

		#ifdef ZLEVELS
		for(var/d = 1, d < 64, d *= 2)
		#else
		for(var/d = 1, d < 16, d *= 2)
		#endif

			var/turf/neighbour_turf = get_step(src, d)
			if(!neighbour_turf) // Map border
				continue

			block = neighbour_turf.c_airblock(src)
			if(block & AIR_BLOCKED)
				#ifdef ZASDBG
				neighbour_turf.add_ZAS_debug_overlay(ZAS_DEBUG_OVERLAY_AIR_DIRECTION_BLOCKED, d)
				#endif
				continue

			var/r_block = c_airblock(neighbour_turf)
			if(r_block & AIR_BLOCKED)
				continue

			if(neighbour_turf.is_simulated && TURF_HAS_VALID_ZONE(neighbour_turf))
				SSair.connect(neighbour_turf, src)

/*
	Simple heuristic for determining if removing the turf from it's zone will not partition the zone (A very bad thing).
	Instead of analyzing the entire zone, we only check the nearest 3x3 turfs surrounding the src turf.
	This implementation may produce false negatives but it (hopefully) will not produce any false postiives.
*/

// Ported from Bay , Optimized in part by Kappu and some other guys

/turf/proc/can_safely_remove_from_zone()
	if(!zone)
		return TRUE

	var/check_dirs
	GET_ZONE_NEIGHBOURS(src, check_dirs)
	. = check_dirs

	//src is only connected to the zone by a single direction, this is a safe removal.
	if (!(. & (. - 1)))
		return TRUE

	for(var/dir in GLOB.csrfz_check)
		//for each pair of "adjacent" cardinals (e.g. NORTH and WEST, but not NORTH and SOUTH)
		if((dir & check_dirs) == dir)
			//check that they are connected by the corner turf
			var/turf/T = get_step(src, dir)
			if (!istype(T))
				. &= ~dir
				continue

			var/connected_dirs
			GET_ZONE_NEIGHBOURS(T, connected_dirs)
			if(connected_dirs && (dir & GLOB.reverse_dir[connected_dirs]) == dir)
				. &= ~dir //they are, so unflag the cardinals in question

	//it is safe to remove src from the zone if all cardinals are connected by corner turfs
	. = !.

//helper for can_safely_remove_from_zone()
/turf/proc/get_zone_neighbours(turf/T)
	. = 0
	if(istype(T) && T.zone)
		for(var/dir in cardinal)
			var/turf/other = get_step(T, dir)
			if(istype(other) && other.zone == T.zone && !(other.c_airblock(T) & AIR_BLOCKED) && get_dist(src, other) <= 1)
				. |= dir

/turf/assume_air(datum/gas_mixture/giver) //use this for machines to adjust air
	return 0

/turf/proc/assume_gas(gasid, moles, temp = 0)
	return 0

/turf/return_air()
	//Create gas mixture to hold data for passing
	var/datum/gas_mixture/GM = new

	GM.adjust_multi("oxygen", oxygen, "carbon_dioxide", carbon_dioxide, "nitrogen", nitrogen, "plasma", plasma)
	GM.temperature = temperature

	return GM

/turf/remove_air(amount as num)
	var/datum/gas_mixture/GM = new

	var/sum = oxygen + carbon_dioxide + nitrogen + plasma
	if(sum>0)
		GM.gas["oxygen"] = (oxygen/sum)*amount
		GM.gas["carbon_dioxide"] = (carbon_dioxide/sum)*amount
		GM.gas["nitrogen"] = (nitrogen/sum)*amount
		GM.gas["plasma"] = (plasma/sum)*amount

	GM.temperature = temperature
	GM.update_values()

	return GM

/turf/assume_air(datum/gas_mixture/giver)
	var/datum/gas_mixture/my_air = return_air()
	my_air.merge(giver)

/turf/assume_gas(gasid, moles, temp = null)
	var/datum/gas_mixture/my_air = return_air()

	if(isnull(temp))
		my_air.adjust_gas(gasid, moles)
	else
		my_air.adjust_gas_temp(gasid, moles, temp)

	return 1

/turf/remove_air(amount as num)
	var/datum/gas_mixture/my_air = return_air()
	return my_air.remove(amount)

/turf/return_air()
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
	air = new/datum/gas_mixture
	air.temperature = temperature
	air.adjust_multi("oxygen", oxygen, "carbon_dioxide", carbon_dioxide, "nitrogen", nitrogen, "plasma", plasma)
	air.group_multiplier = 1
	air.volume = CELL_VOLUME

/turf/proc/c_copy_air()
	if(!air) air = new/datum/gas_mixture
	air.copy_from(zone.air)
	air.group_multiplier = 1

/turf/proc/reset_air()
	QDEL_NULL(fire)
	var/list/initial_gas = new

	var/initial_oxygen = initial(oxygen)
	if(initial_oxygen)
		initial_gas["oxygen"] = initial_oxygen

	var/initial_carbon_dioxide = initial(carbon_dioxide)
	if(initial_carbon_dioxide )
		initial_gas["carbon_dioxide"] = initial_carbon_dioxide

	var/initial_nitrogen = initial(nitrogen)
	if(initial_nitrogen)
		initial_gas["nitrogen"] = initial_nitrogen

	var/initial_plasma = initial(plasma)
	if(initial_plasma )
		initial_gas["plasma"] = initial_plasma

	air.gas = initial_gas
	air.temperature = initial(temperature)
	air.update_values()


// LINDA proc placeholder, used for compatibility with some tgstation code
/turf/proc/GetAtmosAdjacentTurfs(alldir = FALSE)
	var/check_dirs
	if(alldir)
		check_dirs = alldirs
	else
		check_dirs = cardinal

	var/list/adjacent_turfs = list()

	for(var/direction in check_dirs)
		var/turf/T = get_step(src, direction)
		if(!T)
			continue
		if(src.CanPass(null, T, 1.5, TRUE))
			adjacent_turfs += T

	return adjacent_turfs
