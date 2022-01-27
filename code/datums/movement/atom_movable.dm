// Static69ovement denial
/datum/movement_handler/no_move/MayMove()
	return69OVEMENT_STOP

// Anchor check
/datum/movement_handler/anchored/MayMove()
	return host.anchored ?69OVEMENT_STOP :69OVEMENT_PROCEED

//69ovement relay
/datum/movement_handler/move_relay/DoMove(var/direction,69ar/mover)
	var/atom/movable/AM = host.loc
	if(!istype(AM))
		return
	. = AM.DoMove(direction,69over, FALSE)
	if(!(. &69OVEMENT_HANDLED))
		. =69OVEMENT_HANDLED
		AM.relaymove(mover, direction)

//69ovement delay
/datum/movement_handler/delay
	var/delay = 1
	var/next_move

/datum/movement_handler/delay/New(var/host,69ar/delay)
	..()
	src.delay =69ax(1, delay)

/datum/movement_handler/delay/DoMove()
	next_move = world.time + delay

/datum/movement_handler/delay/MayMove()
	return world.time >= next_move ?69OVEMENT_PROCEED :69OVEMENT_STOP

// Relay self
/datum/movement_handler/move_relay_self/DoMove(var/direction,69ar/mover)
	host.relaymove(mover, direction)
	return69OVEMENT_HANDLED
