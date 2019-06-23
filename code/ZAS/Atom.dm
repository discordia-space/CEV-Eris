
/atom/proc/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	//Purpose: Determines if the object (or airflow) can pass this atom.
	//Called by: Movement, airflow.
	//Inputs: The moving atom (optional), target turf, "height" and air group
	//Outputs: Boolean if can pass.

	return (!density || !height || air_group)

// if mover can pass turf coming from target turf
/turf/CanPass(atom/movable/mover, turf/target, height=1.5,air_group=0)
	if(!target)
		return 0

	if(target.blocks_air||blocks_air)
		return 0
	
	if(istype(mover))
		//First, check objects to block exit that are not on the border
		for(var/obj/obstacle in target)
			if(!(obstacle.flags & ON_BORDER) && (mover != obstacle) && (mover != obstacle))
				if(!obstacle.CheckExit(mover, src))
					if(mover.debug)
						world << "first : obstacle is [obstacle]"
					mover.Bump(obstacle, 1)
					if(!mover.canPush(obstacle, get_dir(target, src)))
						return 0

		//Now, check objects to block exit that are on the border
		for(var/obj/border_obstacle in target)
			if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (mover != border_obstacle))
				if(!border_obstacle.CheckExit(mover, src))
					if(mover.debug)
						world << "second : obstacle is [border_obstacle]"
					mover.Bump(border_obstacle, 1)
					if(!mover.canPush(border_obstacle, get_dir(target, src)))
						return 0

		//Next, check objects to block entry that are on the border
		for(var/obj/border_obstacle in src)
			if(border_obstacle.flags & ON_BORDER)
				if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (mover != border_obstacle))
					if(mover.debug)
						world << "third : obstacle is [border_obstacle]"
					mover.Bump(border_obstacle, 1)
					if(!mover.canPush(border_obstacle, get_dir(target, src)))
						return 0

		//Finally, check objects/mobs to block entry that are not on the border
		for(var/atom/movable/obstacle in src)
			if(!(obstacle.flags & ON_BORDER))
				if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (mover != obstacle))
					if(mover.debug)
						world << "forth : obstacle is [obstacle]"
					mover.Bump(obstacle, 1)
					if(!mover.canPush(obstacle, get_dir(target, src)))
						return 0

	return 1

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
