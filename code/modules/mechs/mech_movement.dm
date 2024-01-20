/mob/living/exosuit
	movement_handlers = list(
		/datum/movement_handler/mob/space/exosuit,
		/datum/movement_handler/mob/exosuit
	)

/mob/living/exosuit/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0, initiator = src)
	. = ..()
	if(.)
		// Check for ore auto insertion
		var/obj/structure/ore_box/box = getOreCarrier()
		if(box)
			for(var/obj/item/ore/i in get_turf(src))
				i.Move(box)
		// Check for walking sound
		if(!isinspace())
			if(legs && legs.mech_step_sound)
				playsound(src.loc,legs.mech_step_sound,40,1)
		// Check for stomping people
		if(legs)
			var/blocked = FALSE
			var/turf/theDepths = GetBelow(src)
			if(isinspace())
				if(theDepths)
					for(var/obj/thing in theDepths.contents)
						if(thing.density)
							blocked = TRUE
							break
				else
					blocked = TRUE
			else
				blocked = TRUE
			for(var/mob/living/victim in get_turf(src))
				if(victim.lying || victim.resting || victim.mob_size <= MOB_MEDIUM)
					if(blocked || victim.anchored)
						victim.apply_damage(legs.stomp_damage, BRUTE, BP_CHEST, 1, 1.5, FALSE, FALSE, src.legs )
						visible_message("The [src] stomps on [victim], crushing their chest!")
						occupant_message("You can feel \the [src] stomp something.")
					else
						victim.forceMove(theDepths)
						visible_message("The [src] pushes [victim] downwards.")
						occupant_message("You can feel \the [src] step onto something.")
		for(var/hardpoint in hardpoints)
			if(!hardpoints[hardpoint])
				continue
			var/obj/item/mech_equipment/thing = hardpoints[hardpoint]
			if(!(thing.equipment_flags & EQUIPFLAG_UPDTMOVE))
				continue
			thing.update_icon()

/mob/living/exosuit/set_dir()
	. = ..()
	if(.)
		update_pilots()
		for(var/hardpoint in hardpoints)
			if(!hardpoints[hardpoint])
				continue
			var/obj/item/mech_equipment/thing = hardpoints[hardpoint]
			if(!(thing.equipment_flags & EQUIPFLAG_UPDTMOVE))
				continue
			thing.update_icon()

/mob/living/exosuit/get_jetpack()
	for(var/hardpoint_thing in hardpoints)
		if(istype(hardpoints[hardpoint_thing], /obj/item/mech_equipment/thrusters))
			var/obj/item/mech_equipment/thrusters/jetpack = hardpoints[hardpoint_thing]
			if(jetpack.on)
				return jetpack.jetpack_fluff
	return null

/mob/living/exosuit/allow_spacemove()
	. = ..()
	for(var/hardpoint_thing in hardpoints)
		if(istype(hardpoints[hardpoint_thing], /obj/item/mech_equipment/thrusters))
			var/obj/item/mech_equipment/thrusters/jetpack = hardpoints[hardpoint_thing]
			if(jetpack.on)
				return TRUE
	return .

/mob/living/exosuit/update_plane()
	. = ..()
	for(var/mob/M in pilots)
		M.update_plane()

//Override this and space move once a way to travel vertically is in
///mob/living/exosuit/can_ztravel()
//	if(allow_spacemove()) //Handle here
	// 	return 1

	// for(var/turf/simulated/T in RANGE_TURFS(1,src))
	// 	if(T.density)
	// 		return 1



/*/mob/living/exosuit/can_fall()
	//mechs are always anchored, so falling should always ignore it
	if(..(TRUE, location_override))
		return !(CanAvoidGravity())*/


/datum/movement_handler/mob/exosuit
	expected_host_type = /mob/living/exosuit
	var/next_move

/datum/movement_handler/mob/exosuit/MayMove(var/mob/mover, var/is_external)
	var/mob/living/exosuit/exosuit = host
	if(world.time < next_move)
		return MOVEMENT_STOP
	/// Added to handle with the case of ballistic shields (and probably other ones in the future.)
	var/text = exosuit.moveBlocked()
	if(length(text))
		to_chat(mover, SPAN_NOTICE(text))
		return MOVEMENT_STOP
	if((!(mover in exosuit.pilots) && mover != exosuit) || exosuit.incapacitated() || mover.incapacitated())
		return MOVEMENT_STOP
	if(!exosuit.legs)
		to_chat(mover, SPAN_WARNING("\The [exosuit] has no means of propulsion!"))
		next_move = world.time + 3 // Just to stop them from getting spammed with messages.
		return MOVEMENT_STOP
	if(!exosuit.legs.motivator || !exosuit.legs.motivator.is_functional())
		to_chat(mover, SPAN_WARNING("Your motivators are damaged! You can't move!"))
		next_move = world.time + 15
		return MOVEMENT_STOP
	if(exosuit.maintenance_protocols)
		to_chat(mover, SPAN_WARNING("Maintenance protocols are in effect."))
		next_move = world.time + 3 // Just to stop them from getting spammed with messages.
		return MOVEMENT_STOP
	var/obj/item/cell/C = exosuit.get_cell()
	if(!C || !C.check_charge(exosuit.legs.power_use * CELLRATE))
		to_chat(mover, SPAN_WARNING("The power indicator flashes briefly."))
		next_move = world.time + 3 //On fast exosuits this got annoying fast
		return MOVEMENT_STOP

	next_move = world.time + (exosuit.legs ? exosuit.legs.move_delay : 3)
	return MOVEMENT_PROCEED

/datum/movement_handler/mob/exosuit/DoMove(var/direction, var/mob/mover, var/is_external)
	var/mob/living/exosuit/exosuit = host
	var/moving_dir = direction

	if(exosuit.emp_damage >= EMP_STRAFE_DISABLE && exosuit.strafing == TRUE) //Stops a heavily EMP'd exosuit from strafing
		exosuit.strafing = FALSE

	var/failed = FALSE
	if(exosuit.emp_damage >= EMP_MOVE_DISRUPT && prob(30))
		failed = TRUE
	if(failed)
		moving_dir = pick(GLOB.cardinal - exosuit.dir)

	var/obj/item/cell/C = exosuit.get_cell()
	C.use(exosuit.legs.power_use * CELLRATE)
	if(exosuit.dir != moving_dir && !exosuit.strafing)
		playsound(exosuit.loc, exosuit.legs.mech_turn_sound, 40,1)
		exosuit.set_dir(moving_dir)
		next_move = world.time + exosuit.legs.turn_delay
	else
		var/turf/target_loc = get_step(exosuit, direction)
		if(target_loc && exosuit.legs && exosuit.legs.can_move_on(exosuit.loc, target_loc))
			exosuit.Move(target_loc)
	return MOVEMENT_HANDLED


/datum/movement_handler/mob/space/exosuit/expected_host_type = /mob/living/exosuit

// Space movement
/datum/movement_handler/mob/space/exosuit/DoMove(var/direction, var/mob/mover)

	if(!mob.check_gravity())
		var/allowmove = mob.allow_spacemove()
		if(!allowmove)
			return MOVEMENT_HANDLED
		else if(allowmove == -1 && mob.handle_spaceslipping()) //Check to see if we slipped
			return MOVEMENT_HANDLED
		else
			mob.inertia_dir = 0 //If not then we can reset inertia and move
	else

/datum/movement_handler/mob/space/exosuit/MayMove(var/mob/mover, var/is_external)
	if((mover != host) && is_external)
		return MOVEMENT_PROCEED

	if(!mob.check_gravity())
		if(!mob.allow_spacemove())
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

/mob/living/exosuit/lost_in_space()
	for(var/atom/movable/AM in contents)
		if(!AM.lost_in_space())
			return FALSE
	return !pilots.len

/mob/living/exosuit/get_fall_damage(var/turf/from, var/turf/dest)
	//Exosuits are big and heavy, but one z level can't damage them
	. = (from && dest) ? ((from.z - dest.z > 1) ? (50 * from.z - dest.z) : 0) : min(15, maxHealth * 0.4)

/mob/living/exosuit/proc/moveBlocked()
	for(var/hardpoint in hardpoints)
		var/obj/item/mech_equipment/equip = hardpoints[hardpoint]
		if(equip)
			switch(equip.type)
				if(/obj/item/mech_equipment/shield_generator/ballistic)
					var/obj/item/mech_equipment/shield_generator/ballistic/blocker = equip
					if(blocker.on)
						return "\The [blocker] is deployed! Immobilizing you. "
				if(/obj/item/mech_equipment/forklifting_system)
					var/obj/item/mech_equipment/forklifting_system/fork = equip
					if(fork.lifted)
						return "\The [fork] is lifted, locking you in place!"
	return ""


/*
/mob/living/exosuit/handle_fall_effect(var/turf/landing)
	// Return here if for any reason you shouldn´t take damage
	..()
	var/damage = 30 //Enough to cause a malfunction if unlucky
	apply_damage(rand(0, damage), BRUTE, BP_R_LEG) //Any leg is good, will damage both
*/
