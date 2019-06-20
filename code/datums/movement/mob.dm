// Movement relayed to self handling
/datum/movement_handler/mob/relayed_movement
	var/prevent_host_move = FALSE
	var/list/allowed_movers

/datum/movement_handler/mob/relayed_movement/MayMove(var/mob/mover, var/is_external)
	if(is_external)
		return MOVEMENT_PROCEED
	if(mover == mob && !(prevent_host_move && LAZYLEN(allowed_movers) && !LAZYISIN(allowed_movers, mover)))
		return MOVEMENT_PROCEED
	if(LAZYISIN(allowed_movers, mover))
		return MOVEMENT_PROCEED

	return MOVEMENT_STOP

/datum/movement_handler/mob/relayed_movement/proc/AddAllowedMover(var/mover)
	LAZYDISTINCTADD(allowed_movers, mover)

/datum/movement_handler/mob/relayed_movement/proc/RemoveAllowedMover(var/mover)
	LAZYREMOVE(allowed_movers, mover)

// Admin object possession
/datum/movement_handler/mob/admin_possess
	var/nextmove = 0
/datum/movement_handler/mob/admin_possess/DoMove(var/direction)
	if(QDELETED(mob.control_object))
		return MOVEMENT_REMOVE

	. = (MOVEMENT_HANDLED|MOVEMENT_STOP)

	var/atom/movable/control_object = mob.control_object
	step(control_object, direction)
	if(QDELETED(control_object))
		. |= MOVEMENT_REMOVE
	else
		control_object.set_dir(direction)
	nextmove = world.time + 2.5

/datum/movement_handler/mob/admin_possess/MayMove(var/mob/mover, var/is_external)
	if (world.time > nextmove)
		return MOVEMENT_PROCEED
	return MOVEMENT_STOP

// Death handling
/datum/movement_handler/mob/death/DoMove()
	if(mob.stat != DEAD)
		return
	. = (MOVEMENT_HANDLED|MOVEMENT_STOP)
	if(!mob.client)
		return
	mob.ghostize()

// Incorporeal/Ghost movement
/datum/movement_handler/mob/incorporeal
	var/nextmove
/datum/movement_handler/mob/incorporeal/DoMove(var/direction)
	. = (MOVEMENT_HANDLED|MOVEMENT_STOP)
	direction = mob.AdjustMovementDirection(direction)

	var/turf/T = get_step(mob, direction)

	if(!mob.forceMove(T))
		return

	mob.set_dir(direction)
	mob.PostIncorporealMovement()

	//Incorp movement needs a delay just to make it controllable
	var/overflow = world.time - nextmove
	if (overflow > 1)
		overflow = 0
	nextmove = (world.time + 0.5)-overflow

/datum/movement_handler/mob/incorporeal/MayMove(var/mob/mover, var/is_external)
	if (world.time > nextmove)
		return MOVEMENT_PROCEED
	return MOVEMENT_STOP

/mob/proc/PostIncorporealMovement()
	return

// Eye movement
/datum/movement_handler/mob/eye/DoMove(var/direction, var/mob/mover)
	if(IS_NOT_SELF(mover)) // We only care about direct movement
		return
	if(!mob.eyeobj)
		return
	mob.eyeobj.EyeMove(direction)
	return (MOVEMENT_HANDLED|MOVEMENT_STOP)

/datum/movement_handler/mob/eye/MayMove(var/mob/mover, var/is_external)
	if(IS_NOT_SELF(mover))
		return MOVEMENT_PROCEED
	if(is_external)
		return MOVEMENT_PROCEED
	if(!mob.eyeobj)
		return MOVEMENT_PROCEED
	return MOVEMENT_STOP

// Space movement
/datum/movement_handler/mob/space/DoMove(var/direction, var/mob/mover)
	if(!mob.check_gravity())
		var/allowmove = mob.allow_spacemove()
		if(!allowmove)
			return MOVEMENT_STOP
		else if(allowmove == -1 && mob.handle_spaceslipping()) //Check to see if we slipped
			return MOVEMENT_STOP
		else
			mob.inertia_dir = 0 //If not then we can reset inertia and move
	return MOVEMENT_PROCEED

/datum/movement_handler/mob/space/MayMove(var/mob/mover, var/is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED

	if(!mob.check_gravity())
		if(!mob.allow_spacemove())
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED
/datum/movement_handler/mob/buckle_relay
	var/lastBuckledMessage = 0

// Buckle movement (when you are trying to move when buckled to something)
/datum/movement_handler/mob/buckle_relay/DoMove(var/direction, var/mover)
	if(mob.buckled) // Wheelchair driving!
		direction = mob.AdjustMovementDirection(direction)
		if(IS_SELF(mover))
			mob.buckled.DoMove(direction, mob)
			return (MOVEMENT_HANDLED|MOVEMENT_STOP)
	return MOVEMENT_PROCEED

/datum/movement_handler/mob/buckle_relay/MayMove(var/mob/mover, var/is_external, var/direction)
	if(mob.buckled)
		if(!mob.buckled.buckle_movable)
			if(lastBuckledMessage > world.time + 2 SECONDS)
				lastBuckledMessage = world.time
				to_chat(mob, SPAN_NOTICE("You're buckled to \the [mob.buckled]!</span>"))
			else if(IS_SELF(mover))
				if(isliving(mob))
					mob:resist()
			return MOVEMENT_STOP
		if(mob.buckled.buckle_drivable)
			return mob.buckled.MayMove(mob, TRUE, direction) ? MOVEMENT_PROCEED : MOVEMENT_STOP
		else
			return mob.buckled.MayMove(mover, FALSE, direction) ? MOVEMENT_PROCEED : MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Stop effect
/datum/movement_handler/mob/stop_effect/DoMove()
	if(MayMove() == MOVEMENT_STOP)
		return (MOVEMENT_HANDLED|MOVEMENT_STOP)

/datum/movement_handler/mob/stop_effect/MayMove()
	for(var/obj/effect/stop/S in mob.loc)
		if(S.victim == mob)
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Transformation
/datum/movement_handler/mob/transformation/MayMove()
	return MOVEMENT_STOP

// Consciousness - Is the entity trying to conduct the move conscious?
/datum/movement_handler/mob/conscious/MayMove(var/mob/mover)
	return (mover ? mover.stat == CONSCIOUS : mob.stat == CONSCIOUS) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Along with more physical checks
/datum/movement_handler/mob/physically_capable/MayMove(var/mob/mover)
	// We only check physical capability if the host mob tried to do the moving
	return ((mover && mover != mob) || !mob.incapacitated(INCAPACITATION_DISABLED & ~INCAPACITATION_FORCELYING)) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Is anything physically preventing movement?
/datum/movement_handler/mob/physically_restrained/MayMove(var/mob/mover)
	if(mob.anchored)
		if(mover == mob)
			if(isliving(mob))
				mob:resist()
		return MOVEMENT_STOP

	if(LAZYLEN(mob.pinned))
		if(mover == mob)
			to_chat(mob, "<span class='notice'>You're pinned down by \a [mob.pinned[1]]!</span>")
		return MOVEMENT_STOP

	if(mob.restrained())
		for(var/mob/M in range(mob, 1))
			if(M.pulling == mob)
				if(!M.incapacitated() && mob.Adjacent(M))
					if(mover == mob)
						to_chat(mob, "<span class='notice'>You're restrained! You can't move!</span>")
					return MOVEMENT_STOP
				else
					M.stop_pulling()

	return MOVEMENT_PROCEED

// Finally.. the last of the mob movement junk
/datum/movement_handler/mob/movement/DoMove(var/direction, var/mob/mover)
	. = MOVEMENT_HANDLED
	if(mob.moving)
		return

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	var/old_turf = get_turf(mob)

	if(mob.pulling)
		if(!mob.Adjacent(mob.pulling))
			to_chat(mob, "<span class='notice'>You have lost your grip on [mob.pulling]!</span>")
			mob.stop_pulling()

	var/obj/item/grab/heldGrab = locate() in mob
	if(heldGrab)
		if(!QDELETED(heldGrab))
			heldGrab.validate()

	//We are now going to move
	mob.moving = 1

	direction = mob.AdjustMovementDirection(direction)
	
	// To prevent issues, diagonal movements are broken up into two cardinal movements.
	// Is this a diagonal movement?
	if (direction & (direction - 1))
		if (direction & NORTH)
			if (direction & EAST)
				// Pretty simple really, try to move north -> east, else try east -> north
				// Pretty much exactly the same for all the other cases here.
				if (step(mob, NORTH))
					step(mob, EAST)
				else
					if (step(mob, EAST))
						step(mob, NORTH)
			else
				if (direction & WEST)
					if (step(mob, NORTH))
						step(mob, WEST)
					else
						if (step(mob, WEST))
							step(mob, NORTH)
		else
			if (direction & SOUTH)
				if (direction & EAST)
					if (step(mob, SOUTH))
						step(mob, EAST)
					else
						if (step(mob, EAST))
							step(mob, SOUTH)
				else
					if (direction & WEST)
						if (step(mob, SOUTH))
							step(mob, WEST)
						else
							if (step(mob, WEST))
								step(mob, SOUTH)
	
	else
		step(mob, direction)

	for(var/obj/item/grab/G in mob)
		G.affecting.DoMove(old_turf, mob, TRUE)

	if(mob.pulling)
		mob.pulling.DoMove(old_turf, mob, TRUE)
	mob.moving = 0

/datum/movement_handler/mob/movement/MayMove(var/mob/mover)
	return IS_SELF(mover) && mob.moving ? MOVEMENT_STOP : MOVEMENT_PROCEED

/datum/movement_handler/mob/grabbed/DoMove(var/direction, var/mob/mover)
	if(LAZYLEN(mob.grabbed_by))
		for(var/obj/item/grab/G in mob.grabbed_by)
			if(!QDELETED(G))
				G.validate()
		if(IS_SELF(mover))
			mob:resist()
			return MOVEMENT_STOP
		else
			for (var/obj/item/grab/G in mob.grabbed_by)
				if(!QDELETED(G))
					if(G.assailant == mover)
						G.assailant_moved()
						if (G.assailant_reverse_facing())
							mob.set_dir(GLOB.reverse_dir[direction])
					else
						G.adjust_position()
			return MOVEMENT_PROCEED
	return MOVEMENT_PROCEED

/datum/movement_handler/mob/grabbed/MayMove(var/mover, var/is_external)
	for(var/obj/item/grab/G in mob.grabbed_by)
		if(G.stop_move())
			if(mover == mob)
				var/mob/living/L = mob
				if(L.last_resist + 6 SECONDS <= world.time)
					to_chat(mob, "<span class='notice'>You're stuck in a grab!</span>")
				L.resist()
				return MOVEMENT_STOP
			else if(G.assailant != mover)
				to_chat(mover, "<span class='notice'>[mob] is being held by [G.assailant]!</span>")
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

/mob/proc/AdjustMovementDirection(var/direction)
	. = direction
	if(!confused)
		return

	var/stability = ((MOVING_DELIBERATELY(src)) ? 75 : 25)
	if(prob(stability))
		return

	return prob(50) ? GLOB.cw_dir[.] : GLOB.ccw_dir[.]
