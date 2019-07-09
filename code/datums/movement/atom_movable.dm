// Static movement denial
/datum/movement_handler/no_move/MayMove()
	return MOVEMENT_STOP

// Anchor check
/datum/movement_handler/anchored/MayMove()
	return host.anchored ? MOVEMENT_STOP : MOVEMENT_PROCEED

// Movement relay
/datum/movement_handler/move_relay/DoMove(var/direction, var/mover)
	var/atom/movable/AM = host.loc
	if(!istype(AM))
		return
	. = AM.DoMove(direction, mover, FALSE)
	if(!(. & MOVEMENT_HANDLED))
		. = (MOVEMENT_HANDLED|MOVEMENT_STOP)
		AM.relaymove(mover, direction)

// Movement delay
/datum/movement_handler/delay
	var/calculatedDelay
	var/list/delayData = list()
	var/next_move

/datum/movement_handler/delay/DoMove(var/direction, var/atom/movable/mover)
	/*
	Overflow is used to prevent rounding errors, caused by the world time overshooting the next time we're allowed to move. This is inevitable
	because the server fires events 10x per second when the user is holding down a movement key, meaning that your movement is anywhere up to 0.1
	seconds later than it should have been.
	This doesn't sound like much, but it causes a lot of lost total time when moving across the whole ship.

	Here, we store the overflow time and apply it as a discount to the next step's delay. This ensures that journey times are accurate over a distance
	Any individual step can still be slightly slower than it should be, but the next one will compensate and errors won't compound
	*/
	// we will set delay after actual movement, so we can change movespeed during movement_handler that handle actual movement
	spawn()
		/*var/overflow = next_move - world.time
		if (overflow > 1 || overflow < 0)
			overflow = 0
		*/
		var/delay
		if(host.buckle_drivable && host.buckled_mob == mover)
			host.update_movement_delays()
			delay = host.get_movement_delay()// - overflow
		else
			mover.update_movement_delays()
			delay = mover.get_movement_delay()// - overflow
		setNextMove(delay)
		host.set_glide_size(DELAY2GLIDESIZE(delay), 0)

/datum/movement_handler/delay/MayMove(var/mover, var/is_external)
	if(IS_NOT_SELF(mover) && !host.buckle_drivable)
		return MOVEMENT_PROCEED
	return world.time >= next_move ? MOVEMENT_PROCEED : MOVEMENT_STOP

/datum/movement_handler/delay/proc/setNextMove(var/delay)
	next_move = max(next_move, world.time + delay)

/datum/movement_handler/delay/proc/adjustDelay(var/tag, var/delay, var/noUpdate = FALSE)
	if(!tag)
		log_debug("error: Adjusting delay without tag, returned.")
	if(delay == 0)
		if(delayData[tag])
			delayData.Remove(tag)
			if(!noUpdate)
				updateDelay()
		return
	if(delayData[tag] == delay)
		return
	delayData[tag] = delay
	if(!noUpdate)
		updateDelay()

/datum/movement_handler/delay/proc/getDelay(var/tag)
	if(!tag)
		return calculatedDelay
	else 
		return delayData[tag]

/datum/movement_handler/delay/proc/updateDelay()
	calculatedDelay = 0
	for(var/tag in delayData)
		calculatedDelay += delayData[tag]
	calculatedDelay = max(1, calculatedDelay)

/datum/movement_handler/movement/DoMove(var/direction, var/mover)
	. = MOVEMENT_PROCEED
	var/moved = 0
	// To prevent issues, diagonal movements are broken up into two cardinal movements.
	// Is this a diagonal movement?
	if (direction & (direction - 1))
		if (direction & NORTH)
			if (direction & EAST)
				// Pretty simple really, try to move north -> east, else try east -> north
				// Pretty much exactly the same for all the other cases here.
				if (step(host, NORTH))
					moved++
					moved += step(host, EAST)
				else
					if (step(host, EAST))
						moved++
						moved += step(host, NORTH)
			else
				if (direction & WEST)
					if (step(host, NORTH))
						moved++
						moved += step(host, WEST)
					else
						if (step(host, WEST))
							moved++
							moved += step(host, NORTH)
		else
			if (direction & SOUTH)
				if (direction & EAST)
					if (step(host, SOUTH))
						moved++
						moved += step(host, EAST)
					else
						if (step(host, EAST))
							moved++
							moved += step(host, SOUTH)
				else
					if (direction & WEST)
						if (step(host, SOUTH))
							moved++
							moved += step(host, WEST)
						else
							if (step(host, WEST))
								moved++
								moved += step(host, SOUTH)
	
	else
		moved += step(host, direction)
	if(moved)
		. |= MOVEMENT_HANDLED

/datum/movement_handler/movement/MayMove(var/mover, var/is_external)
	var/datum/movement_handler/obstacle/obstacleHandler = host.GetMovementHandler(/datum/movement_handler/obstacle)
	if(obstacleHandler && obstacleHandler.obstaclesFound.len)
		//if (!(world.time % 5))
		//	to_chat(host, SPAN_WARNING("You can't go past [pick(obstacleHandler.obstaclesFound)]."))
		return MOVEMENT_STOP
	return MOVEMENT_PROCEED

/datum/movement_handler/pulled/DoMove(var/direction, var/mover)
	if(host.pulledby)
		if(!host.Adjacent(host.pulledby))
			to_chat(host.pulledby, "<span class='notice'>You have lost your grip on [host]!</span>")
			host.pulledby.stop_pulling()
	return MOVEMENT_PROCEED

/datum/movement_handler/pulled/MayMove(var/mover, var/is_external)
	return MOVEMENT_PROCEED

// obstacle check
/datum/movement_handler/obstacle
	var/list/obstaclesFound = list()

/datum/movement_handler/obstacle/DoMove(var/direction, var/mover)
	return MOVEMENT_PROCEED

/datum/movement_handler/obstacle/MayMove(var/mover, var/is_external, var/direction)
	var/turf/T = get_step(get_turf(host),direction)

	if(!istype(T))
		to_chat(host, "<span class='danger'>You are trying to move to null turf, contact coders.!</span>")
		return MOVEMENT_STOP

	if(!T.CanPass(host, get_turf(host)))
		obstaclesFound = host.getObstacles(T)
		for(var/atom/A in obstaclesFound)
			host.Bump(A, 1)
		if(IS_SELF(mover))
			if(direction != host.dir)
				host.set_dir(direction)
	else
		obstaclesFound = list()

	return MOVEMENT_PROCEED

// swapping handler
/datum/movement_handler/swapper
	var/list/obstaclesToSwap = list()

/datum/movement_handler/swapper/DoMove(var/direction, var/mover)
	if(IS_SELF(mover))
		for(var/atom/movable/A in obstaclesToSwap)
			A.DoMove(reverse_direction(direction), host, TRUE)

/datum/movement_handler/swapper/MayMove(var/mover, var/is_external, var/direction)
	obstaclesToSwap = list()

	if(IS_SELF(mover))
		var/datum/movement_handler/obstacle/obstacleHandler = host.GetMovementHandler(/datum/movement_handler/obstacle)
		if(obstacleHandler && obstacleHandler.obstaclesFound.len)
			for(var/atom/movable/A in obstacleHandler.obstaclesFound)
				if(A.can_swap_with(host))
					obstaclesToSwap += A
					obstacleHandler.obstaclesFound.Remove(A)
	return MOVEMENT_PROCEED

// pushing handler
/datum/movement_handler/pusher
	var/list/obstaclesToPush = list()

/datum/movement_handler/pusher/DoMove(var/direction, var/mover)
	if(IS_SELF(mover))
		for(var/atom/movable/A in obstaclesToPush)
			A.DoMove(direction, host, TRUE)
	
	return MOVEMENT_PROCEED

/datum/movement_handler/pusher/MayMove(var/mover, var/is_external, var/direction)
	obstaclesToPush = list()

	if(IS_SELF(mover))
		var/datum/movement_handler/obstacle/obstacleHandler = host.GetMovementHandler(/datum/movement_handler/obstacle)
		if(obstacleHandler && obstacleHandler.obstaclesFound.len)
			for(var/atom/A in obstacleHandler.obstaclesFound)
				if(host.canPush(A, direction))
					obstaclesToPush += A
					obstacleHandler.obstaclesFound.Remove(A)
	
	return MOVEMENT_PROCEED
