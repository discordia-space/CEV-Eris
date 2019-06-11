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
		. = MOVEMENT_HANDLED
		AM.relaymove(mover, direction)

// Movement delay
/datum/movement_handler/delay
	var/delay = 1
	var/next_move

/datum/movement_handler/delay/New(var/host, var/delay)
	..()
	src.delay = max(1, delay)

/datum/movement_handler/delay/DoMove()
	next_move = world.time + delay

/datum/movement_handler/delay/MayMove()
	return world.time >= next_move ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Relay self
/datum/movement_handler/move_relay_self/DoMove(var/direction, var/mover)
	host.relaymove(mover, direction)
	return MOVEMENT_HANDLED

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
	if(isliving(mover))
		var/mob/living/L = mover
		if(!host.Adjacent(L))
			L.stop_pulling()
			return MOVEMENT_STOP
		else
			host.set_glide_size(DELAY2GLIDESIZE(L.movement_delay()), 0)
	return MOVEMENT_PROCEED

/datum/movement_handler/pulled/MayMove(var/mover, var/is_external)
	if(isliving(mover))
		var/mob/living/L = mover
		if(!host.Adjacent(L))
			L.stop_pulling()
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED