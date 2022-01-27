//69ovement relayed to self handling
/datum/movement_handler/mob/relayed_movement
	var/prevent_host_move = FALSE
	var/list/allowed_movers

/datum/movement_handler/mob/relayed_movement/MayMove(var/mob/mover,69ar/is_external)
	if(is_external)
		return69OVEMENT_PROCEED
	if(mover ==69ob && !(prevent_host_move && LAZYLEN(allowed_movers) && !LAZYISIN(allowed_movers,69over)))
		return69OVEMENT_PROCEED
	if(LAZYISIN(allowed_movers,69over))
		return69OVEMENT_PROCEED

	return69OVEMENT_STOP

/datum/movement_handler/mob/relayed_movement/proc/AddAllowedMover(var/mover)
	LAZYOR(allowed_movers,69over)

/datum/movement_handler/mob/relayed_movement/proc/RemoveAllowedMover(var/mover)
	LAZYREMOVE(allowed_movers,69over)

// Admin object possession
/datum/movement_handler/mob/admin_possess
	var/nextmove = 0
/datum/movement_handler/mob/admin_possess/DoMove(var/direction)
	if(QDELETED(mob.control_object))
		return69OVEMENT_REMOVE

	. =69OVEMENT_HANDLED

	var/atom/movable/control_object =69ob.control_object
	step(control_object, direction)
	if(QDELETED(control_object))
		. |=69OVEMENT_REMOVE
	else
		control_object.set_dir(direction)
	nextmove = world.time + 2.5

/datum/movement_handler/mob/admin_possess/MayMove(var/mob/mover,69ar/is_external)
	if (world.time > nextmove)
		return69OVEMENT_PROCEED
	return69OVEMENT_STOP

// Death handling
/datum/movement_handler/mob/death/DoMove()
	if(mob.stat != DEAD)
		return
	. =69OVEMENT_HANDLED
	if(!mob.client)
		return
	mob.ghostize()

// Incorporeal/Ghost69ovement
/datum/movement_handler/mob/incorporeal
	var/nextmove
/datum/movement_handler/mob/incorporeal/DoMove(var/direction)
	. =69OVEMENT_HANDLED
	direction =69ob.AdjustMovementDirection(direction)

	var/turf/T = get_step(mob, direction)

	if(!mob.forceMove(T))
		return

	mob.set_dir(direction)
	mob.PostIncorporealMovement()

	//Incorp69ovement needs a delay just to69ake it controllable
	var/overflow = world.time - nextmove
	if (overflow > 1)
		overflow = 0
	nextmove = (world.time + 0.5)-overflow

/datum/movement_handler/mob/incorporeal/MayMove(var/mob/mover,69ar/is_external)
	if (world.time > nextmove)
		return69OVEMENT_PROCEED
	return69OVEMENT_STOP

/mob/proc/PostIncorporealMovement()
	return

// Eye69ovement
/datum/movement_handler/mob/eye/DoMove(var/direction,69ar/mob/mover)
	if(IS_NOT_SELF(mover)) // We only care about direct69ovement
		return
	if(!mob.eyeobj)
		return
	mob.eyeobj.EyeMove(direction)
	return69OVEMENT_HANDLED

/datum/movement_handler/mob/eye/MayMove(var/mob/mover,69ar/is_external)
	if(IS_NOT_SELF(mover))
		return69OVEMENT_PROCEED
	if(is_external)
		return69OVEMENT_PROCEED
	if(!mob.eyeobj)
		return69OVEMENT_PROCEED
	return (MOVEMENT_PROCEED|MOVEMENT_HANDLED)

// Space69ovement
/datum/movement_handler/mob/space/DoMove(var/direction,69ar/mob/mover)
	if(!mob.check_gravity())
		var/allowmove =69ob.allow_spacemove()
		if(!allowmove)
			return69OVEMENT_HANDLED
		else if(allowmove == -1 &&69ob.handle_spaceslipping()) //Check to see if we slipped
			return69OVEMENT_HANDLED
		else
			mob.inertia_dir = 0 //If not then we can reset inertia and69ove

/datum/movement_handler/mob/space/MayMove(var/mob/mover,69ar/is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return69OVEMENT_PROCEED

	if(!mob.check_gravity())
		if(!mob.allow_spacemove())
			return69OVEMENT_STOP
	return69OVEMENT_PROCEED

// Buckle69ovement
/datum/movement_handler/mob/buckle_relay/DoMove(var/direction,69ar/mover)
	// TODO: Datumlize buckle-handling
	if(istype(mob.buckled, /obj/vehicle))
		//drunk driving
		if(mob.confused && prob(20)) //vehicles tend to keep69oving in the same direction
			direction = turn(direction, pick(90, -90))
		mob.buckled.relaymove(mob, direction)
		return69OVEMENT_HANDLED

	if(mob.pulledby ||69ob.buckled) // Wheelchair driving!
		if(istype(mob.loc, /turf/space))
			return // No wheelchair driving in space
		if(istype(mob.pulledby, /obj/structure/bed/chair/wheelchair))
			. =69OVEMENT_HANDLED
			mob.pulledby.DoMove(direction,69ob)
		else if(istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
			. =69OVEMENT_HANDLED
			if(ishuman(mob))
				var/mob/living/carbon/human/driver =69ob
				var/obj/item/organ/external/l_arm = driver.get_organ(BP_L_ARM)
				var/obj/item/organ/external/r_arm = driver.get_organ(BP_R_ARM)
				if((!l_arm || l_arm.is_stump()) && (!r_arm || r_arm.is_stump()))
					return // No arms to drive your chair? Tough luck!
			//drunk wheelchair driving
			direction =69ob.AdjustMovementDirection(direction)
			mob.buckled.DoMove(direction,69ob)

/datum/movement_handler/mob/buckle_relay/MayMove(var/mover)
	if(mob.buckled)
		return69ob.buckled.MayMove(mover, FALSE) ? (MOVEMENT_PROCEED|MOVEMENT_HANDLED) :69OVEMENT_STOP
	return69OVEMENT_PROCEED

//69ovement delay
/datum/movement_handler/mob/delay
	var/next_move



//Several things happen in DoMove
/datum/movement_handler/mob/delay/DoMove(var/direction,69ar/mover,69ar/is_external)
	//Not sure wtf this is
	if(is_external)
		return

	/*
	Overflow is used to prevent rounding errors, caused by the world time overshooting the next time we're allowed to69ove. This is inevitable
	because the server fires events 10x per second when the user is holding down a69ovement key,69eaning that your69ovement is anywhere up to 0.1
	seconds later than it should have been.
	This doesn't sound like69uch, but it causes a lot of lost total time when69oving across the whole ship.

	Here, we store the overflow time and apply it as a discount to the next step's delay. This ensures that journey times are accurate over a distance
	Any individual step can still be slightly slower than it should be, but the next one will compensate and errors won't compound
	*/
	var/overflow = next_move - world.time
	if (overflow > 1 || overflow < 0)
		overflow = 0

	var/mob_delay =69ax(MOVE_DELAY_MIN,69ob.movement_delay())
	if(isliving(mob))
		var/mob/living/L =69ob
		if(L.is_ventcrawling)
			mob_delay =69OVE_DELAY_VENTCRAWL

	var/delay =69ob_delay - overflow
	SetDelay(delay)


	/*
	SMOOTH69OVEMENT
	*/
	mob.set_glide_size(DELAY2GLIDESIZE(delay), 0, INFINITY)


/datum/movement_handler/mob/delay/MayMove(var/mover,69ar/is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return69OVEMENT_PROCEED
	.= ((mover &&69over !=69ob) ||  world.time >= next_move) ?69OVEMENT_PROCEED :69OVEMENT_STOP



/datum/movement_handler/mob/delay/proc/SetDelay(var/delay)
	next_move =69ax(next_move, world.time + delay)

/datum/movement_handler/mob/delay/proc/AddDelay(var/delay)
	next_move +=69ax(0, delay)

// Stop effect
/datum/movement_handler/mob/stop_effect/DoMove()
	if(MayMove() ==69OVEMENT_STOP)
		return69OVEMENT_HANDLED

/datum/movement_handler/mob/stop_effect/MayMove()
	for(var/obj/effect/stop/S in69ob.loc)
		if(S.victim ==69ob)
			return69OVEMENT_STOP
	return69OVEMENT_PROCEED

// Transformation
/datum/movement_handler/mob/transformation/MayMove()
	return69OVEMENT_STOP

// Consciousness - Is the entity trying to conduct the69ove conscious?
/datum/movement_handler/mob/conscious/MayMove(var/mob/mover)
	return (mover ?69over.stat == CONSCIOUS :69ob.stat == CONSCIOUS) ?69OVEMENT_PROCEED :69OVEMENT_STOP

// Along with69ore physical checks
/datum/movement_handler/mob/physically_capable/MayMove(var/mob/mover)
	// We only check physical capability if the host69ob tried to do the69oving
	return ((mover &&69over !=69ob) || !mob.incapacitated(INCAPACITATION_DISABLED)) ?69OVEMENT_PROCEED :69OVEMENT_STOP

// Is anything physically preventing69ovement?
/datum/movement_handler/mob/physically_restrained/MayMove(var/mob/mover)
	if(mob.anchored)
		if(mover ==69ob)
//			to_chat(mob, "<span class='notice'>You're anchored down!</span>")
			if(isliving(mob))
				mob:resist()
		return69OVEMENT_STOP

	if(istype(mob.buckled) && !mob.buckled.buckle_movable)
		if(mover ==69ob)
//			to_chat(mob, "<span class='notice'>You're buckled to \the 69mob.buckled69!</span>")
			if(isliving(mob))
				mob:resist()
		return69OVEMENT_STOP

	if(LAZYLEN(mob.pinned))
		if(mover ==69ob)
			to_chat(mob, "<span class='notice'>You're pinned down by \a 69mob.pinned6916969!</span>")
		return69OVEMENT_STOP

	for(var/obj/item/grab/G in69ob.grabbed_by)
		return69OVEMENT_STOP
		/* TODO: Bay grab system
		if(G.stop_move())
			if(mover ==69ob)
				to_chat(mob, "<span class='notice'>You're stuck in a grab!</span>")
			mob.ProcessGrabs()
			return69OVEMENT_STOP
		*/
	if(mob.restrained())
		for(var/mob/M in range(mob, 1))
			if(M.pulling ==69ob)
				if(!M.incapacitated() &&69ob.Adjacent(M))
					if(mover ==69ob)
						to_chat(mob, "<span class='notice'>You're restrained! You can't69ove!</span>")
					return69OVEMENT_STOP
				else
					M.stop_pulling()

	return69OVEMENT_PROCEED


/mob/living/ProcessGrabs()
	//if we are being grabbed
	if(grabbed_by.len)
		resist() //shortcut for resisting grabs

/mob/proc/ProcessGrabs()
	return


// Finally.. the last of the69ob69ovement junk
/datum/movement_handler/mob/movement/DoMove(var/direction,69ar/mob/mover)
	. =69OVEMENT_HANDLED
	if(mob.moving)
		return

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	//We are now going to69ove
	mob.moving = 1

	direction =69ob.AdjustMovementDirection(direction)
	var/old_turf = get_turf(mob)
	step(mob, direction)

	if(!MOVING_DELIBERATELY(mob))
		mob.handle_movement_recoil()

	// Something with pulling things
	var/extra_delay = HandleGrabs(direction, old_turf)
	mob.add_move_cooldown(extra_delay)

	/* TODO: Bay grab system
	for (var/obj/item/grab/G in69ob)
		if (G.assailant_reverse_facing())
			mob.set_dir(GLOB.reverse_dir69direction69)
		G.assailant_moved()
	for (var/obj/item/grab/G in69ob.grabbed_by)
		G.adjust_position()
	*/
	mob.moving = 0

/datum/movement_handler/mob/movement/MayMove(var/mob/mover)
	return IS_SELF(mover) && 69ob.moving ?69OVEMENT_STOP :69OVEMENT_PROCEED

/datum/movement_handler/mob/movement/proc/HandleGrabs(var/direction,69ar/old_turf)
	. = 0
	// TODO: Look into69aking grabs use69ovement events instead, this is a69ess.
	for (var/obj/item/grab/G in69ob)
		. =69ax(., G.slowdown)
		var/mob/M = G.affecting
		if(M && get_dist(old_turf,69) <= 1)
			if (isturf(M.loc) && isturf(mob.loc) &&69ob.loc != old_turf &&69.loc !=69ob.loc)
				step(M, get_dir(M.loc, old_turf))
		G.adjust_position()

/mob/proc/AdjustMovementDirection(var/direction)
	. = direction
	if(!confused)
		return

	var/stability = ((MOVING_DELIBERATELY(src)) ? 75 : 25)
	if(prob(stability))
		return

	return prob(50) ? GLOB.cw_dir69.69 : GLOB.ccw_dir69.69
