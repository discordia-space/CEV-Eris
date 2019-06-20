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
	var/overflow = next_move - world.time
	if (overflow > 1 || overflow < 0)
		overflow = 0

	var/delay
	if(IS_SELF(mover))
		delay = host.movement_delay() - overflow
	else
		delay = min(mover.movement_delay(), host.movement_delay()) - overflow
	SetDelay(delay)
	host.set_glide_size(DELAY2GLIDESIZE(delay), 0)
	
	host.reset_movement_delay()

/datum/movement_handler/delay/MayMove(var/mover, var/is_external)
	if(IS_NOT_SELF(mover) && !host.buckle_drivable)
		return MOVEMENT_PROCEED
	return world.time >= next_move ? MOVEMENT_PROCEED : MOVEMENT_STOP

/datum/movement_handler/delay/proc/SetDelay(var/delay)
	next_move = max(next_move, world.time + delay)

/datum/movement_handler/delay/proc/AddDelay(var/delay)
	next_move += max(0, delay)

/datum/movement_handler/basic/DoMove(var/direction, var/mover)
	. = MOVEMENT_HANDLED
	// To prevent issues, diagonal movements are broken up into two cardinal movements.
	// Is this a diagonal movement?
	if (direction & (direction - 1))
		if (direction & NORTH)
			if (direction & EAST)
				// Pretty simple really, try to move north -> east, else try east -> north
				// Pretty much exactly the same for all the other cases here.
				if (step(host, NORTH))
					step(host, EAST)
				else
					if (step(host, EAST))
						step(host, NORTH)
			else
				if (direction & WEST)
					if (step(host, NORTH))
						step(host, WEST)
					else
						if (step(host, WEST))
							step(host, NORTH)
		else
			if (direction & SOUTH)
				if (direction & EAST)
					if (step(host, SOUTH))
						step(host, EAST)
					else
						if (step(host, EAST))
							step(host, SOUTH)
				else
					if (direction & WEST)
						if (step(host, SOUTH))
							step(host, WEST)
						else
							if (step(host, WEST))
								step(host, SOUTH)
	
	else
		step(host, direction)

/datum/movement_handler/basic/MayMove(var/mover, var/is_external)
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
/datum/movement_handler/obstacle/DoMove(var/direction, var/mover)
	return MOVEMENT_PROCEED

/datum/movement_handler/obstacle/MayMove(var/mover, var/is_external, var/direction)
	var/turf/T = get_step(get_turf(host),direction)
	if(istype(T) && T.density)
		return MOVEMENT_STOP
	return MOVEMENT_PROCEED