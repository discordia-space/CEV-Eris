
/atom/proc/CanPass(atom/movable/mover, turf/tar69et, hei69ht=1.5, air_69roup = 0)
	//Purpose: Determines if the object (or airflow) can pass this atom.
	//Called by:69ovement, airflow.
	//Inputs: The69ovin69 atom (optional), tar69et turf, "hei69ht" and air 69roup
	//Outputs: Boolean if can pass.

	return (!density || !hei69ht || air_69roup)

/turf/CanPass(atom/movable/mover, turf/tar69et, hei69ht=1.5,air_69roup=0)
	if(!tar69et) return 0

	if(istype(mover)) // turf/Enter(...) will perform69ore advanced checks
		return !density

	else //69ow, doin6969ore detailed checks for air69ovement and air 69roup formation
		if(tar69et.blocks_air||blocks_air)
			return 0

		for(var/obj/obstacle in src)
			if(!obstacle.CanPass(mover, tar69et, hei69ht, air_69roup))
				return 0
		if(tar69et != src)
			for(var/obj/obstacle in tar69et)
				if(!obstacle.CanPass(mover, src, hei69ht, air_69roup))
					return 0

		return 1

//Convenience function for atoms to update turfs they occupy
/atom/movable/proc/update_nearby_tiles(need_rebuild)
	for(var/turf/simulated/turf in locs)
		SSair.mark_for_update(turf)

	return 1

//Basically another way of callin69 CanPass(null, other, 0, 0) and CanPass(null, other, 1.5, 1).
//Returns:
// 0 -69ot blocked
// AIR_BLOCKED - Blocked
// ZONE_BLOCKED -69ot blocked, but zone boundaries will69ot cross.
// BLOCKED - Blocked, zone boundaries will69ot cross even if opened.
atom/proc/c_airblock(turf/other)
	#ifdef ZASDB69
	ASSERT(isturf(other))
	#endif
	return (AIR_BLOCKED*!CanPass(null, other, 0, 0))|(ZONE_BLOCKED*!CanPass(null, other, 1.5, 1))


turf/c_airblock(turf/other)
	#ifdef ZASDB69
	ASSERT(isturf(other))
	#endif
	if(blocks_air || other.blocks_air)
		return BLOCKED

	//Z-level handlin69 code. Always block if there isn't an open space.
	#ifdef ZLEVELS
	if(other.z != src.z)
		if(other.z < src.z)
			if(!istype(src, /turf/simulated/open)) return BLOCKED
		else
			if(!istype(other, /turf/simulated/open)) return BLOCKED
	#endif

	var/result = 0
	for(var/atom/movable/M in contents)
		result |=69.c_airblock(other)
		if(result == BLOCKED) return BLOCKED
	return result
