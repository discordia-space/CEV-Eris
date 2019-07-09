
/atom/proc/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	//Purpose: Determines if the object (or airflow) can pass this atom.
	//Called by: Movement, airflow.
	//Inputs: The moving atom (optional), target turf, "height" and air group
	//Outputs: Boolean if can pass.
	if(debug)
		world << "CanPass return result (([!density] || [!height] || [air_group] || [CheckExit(mover, target)]))"
	return (!density || !height || air_group || CheckExit(mover, target))

// if mover can pass turf coming from target turf
// if you modifying this you should also check canPushTurfAtoms()
/turf/CanPass(atom/movable/mover, turf/target, height=1.5,air_group=0)
	if(!target)
		return FALSE

	if(target.blocks_air||blocks_air)
		return FALSE
	
	if(istype(mover))
		//First, check atoms on target turf
		for(var/atom/obstacle in target)
			if(!obstacle.CanPass(mover, get_turf(mover), 1, 0))
				return FALSE

		//Second, check atoms on src turf
		for(var/atom/obstacle in src)
			if((mover != obstacle) && !obstacle.CanPass(mover, get_turf(mover), 1, 0))
				return FALSE
	return ..()

//Convenience function for atoms to update turfs they occupy
/atom/movable/proc/update_nearby_tiles(need_rebuild)
	for(var/turf/simulated/turf in locs)
		SSair.mark_for_update(turf)

	return 1

//Basically another way of calling CanPass(null, other, 0, 0) and CanPass(null, other, 1.5, 1).
//Returns:
// 0 - Not blocked
// AIR_BLOCKED - Blocked
// ZONE_BLOCKED - Not blocked, but zone boundaries will not cross.
// BLOCKED - Blocked, zone boundaries will not cross even if opened.
atom/proc/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	return (AIR_BLOCKED*!CanPass(null, other, 0, 0))|(ZONE_BLOCKED*!CanPass(null, other, 1.5, 1))


turf/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	if(blocks_air || other.blocks_air)
		return BLOCKED

	//Z-level handling code. Always block if there isn't an open space.
	#ifdef ZLEVELS
	if(other.z != src.z)
		if(other.z < src.z)
			if(!istype(src, /turf/simulated/open)) return BLOCKED
		else
			if(!istype(other, /turf/simulated/open)) return BLOCKED
	#endif

	var/result = 0
	for(var/atom/movable/M in contents)
		result |= M.c_airblock(other)
		if(result == BLOCKED) return BLOCKED
	return result
