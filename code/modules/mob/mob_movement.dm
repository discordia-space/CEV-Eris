/client/Move(n, direction)
	if(!mob)
		return // Moved here to avoid nullrefs below
	return mob.SelfMove(direction)

/mob/proc/SelfMove(var/direction)

	if(SEND_SIGNAL(src, COMSIG_MOB_TRY_MOVE, direction) & COMSIG_CANCEL_MOVE)
		return TRUE
	if(DoMove(direction, src) & MOVEMENT_HANDLED)
		return TRUE // Doesn't necessarily mean the mob physically moved


/mob
	var/moving           = FALSE


/mob/proc/set_move_cooldown(var/timeout)
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay)
	if(delay)
		delay.SetDelay(timeout)

/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return 1
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)

/mob/proc/add_move_cooldown(var/timeout)
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay)
	if(delay)
		delay.AddDelay(timeout)

/client/proc/client_dir(input, direction=-1)
	return turn(input, direction*dir2angle(dir))

/client/Northeast()
	diagonal_action(NORTHEAST)
/client/Northwest()
	diagonal_action(NORTHWEST)
/client/Southeast()
	diagonal_action(SOUTHEAST)
/client/Southwest()
	diagonal_action(SOUTHWEST)

/client/proc/diagonal_action(direction)
	switch(client_dir(direction, 1))
		if(NORTHEAST)
			swap_hand()
			return
		if(SOUTHEAST)
			attack_self()
			return
		if(SOUTHWEST)
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.toggle_throw_mode()
			else
				to_chat(usr, SPAN_WARNING("This mob type cannot throw items."))
			return
		if(NORTHWEST)
			mob.hotkey_drop()

/mob/proc/hotkey_drop()
	to_chat(usr, SPAN_WARNING("This mob type cannot drop items."))

/mob/living/carbon/hotkey_drop()
	if(!get_active_hand())
		to_chat(usr, SPAN_WARNING("You have nothing to drop in your hand."))
	if (!isturf(loc))
		return
	else
		unEquip(get_active_hand(), loc)

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!locate(/obj/item/grab) in usr)
		to_chat(usr, SPAN_NOTICE("You are not pulling anything."))
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = 1

	if(isrobot(mob))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	else
		mob.swap_hand()
	return



/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/toggle_throw_mode()
	set hidden = 1
	if(!istype(mob, /mob/living/carbon))
		return
	if (!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob:toggle_throw_mode()
	else
		return

/client/verb/blocking()
	set hidden = 1
	if(!istype(mob, /mob/living/carbon/human))
		return
	if(!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob:blocking()
	else
		return

/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob) && mob.stat == CONSCIOUS && isturf(mob.loc))
		return mob.drop_item()
	return


//Called from space movement handler
//Return true for safe movement
//Return -1 for movement with possibility of slipping
//Return false for no movement
/mob/proc/allow_spacemove()
	//First up, check for magboots or other gripping capability
	//If we have some, then check the ground under us
	if (incorporeal_move)
		return TRUE
	if (check_shoegrip() && check_solid_ground())
		return TRUE
	if (check_dense_object())
		return -1
	return FALSE

//return 1 if slipped, 0 otherwise
/mob/proc/handle_spaceslipping()
	if(prob(1)) //Todo: Factor in future agility stat here
		to_chat(src, SPAN_WARNING("You slipped!"))
		src.inertia_dir = src.last_move
		step(src, src.inertia_dir)
		return 1
	return 0

//Checks if a mob has solid ground to stand on
//If there's no gravity then there's no up or down so naturally you can't stand on anything.
//For the same reason lattices in space don't count - those are things you grip, presumably.
/mob/proc/check_gravity()
	if(istype(loc, /turf/space))
		return FALSE

	lastarea = get_area(src)
	if(!lastarea || !lastarea.has_gravity)
		return FALSE

	return TRUE


//This proc specifically checks the floor under us. Both floor turfs and walkable objects like catwalk
//This proc is only called if we have grip, ie magboots
/mob/proc/check_solid_ground()
	if (istype(loc, /turf/simulated))
		if(istype(loc, /turf/simulated/open))
			return FALSE //open spess was fogotten
		return TRUE //We're standing on a simulated floor
	else
		//We're probably in space
		for(var/obj/O in loc)
			if(istype(O, /obj/structure/lattice))
				return TRUE
			if(istype(O, /obj/structure/catwalk))
				return TRUE
	return FALSE

//This proc checks for dense, anchored atoms, or walls.
//It checks all the adjacent tiles
/mob/proc/check_dense_object()

	for(var/turf/simulated/T in RANGE_TURFS(1,src)) //we only care for non-space turfs
		if(T.density)	//walls work when you're adjacent
			return TRUE


	for(var/obj/O in orange(1, src))
		if(O.density && O.anchored)
			return TRUE

	return FALSE

/mob/proc/check_shoegrip()
	return 0

/mob/proc/slip_chance(var/prob_slip = 5)
	if(stat)
		return 0
	if(check_shoegrip())
		return 0
	return prob_slip

#define DO_MOVE(this_dir) var/final_dir = turn(this_dir, -dir2angle(dir)); Move(get_step(mob, final_dir), final_dir);

/client/verb/moveup()
	set name = ".moveup"
	set instant = 1
	DO_MOVE(NORTH)

/client/verb/movedown()
	set name = ".movedown"
	set instant = 1
	DO_MOVE(SOUTH)

/client/verb/moveright()
	set name = ".moveright"
	set instant = 1
	DO_MOVE(EAST)

/client/verb/moveleft()
	set name = ".moveleft"
	set instant = 1
	DO_MOVE(WEST)

#undef DO_MOVE

//This is an atom proc for the sake of vehicles and mechas
//Attempts to return the expected total time in deciseconds, between this atom making moves
//TODO: Fix this shit
/atom/movable/proc/total_movement_delay()
	return 0

/mob/total_movement_delay()
	var/delay = 0

	if (MOVING_QUICKLY(src))
		if(drowsyness > 0)
			delay += 6
		delay += 1
	else
		delay += 7
	delay += movement_delay()

	if (speed_factor && speed_factor != 1)
		delay /= speed_factor

	return delay

/mob/proc/add_momentum()
	return FALSE
