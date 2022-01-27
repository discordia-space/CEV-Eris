/client/Move(n, direction)
	if(!mob)
		return //69oved here to avoid69ullrefs below
	return69ob.SelfMove(direction)

/mob/proc/SelfMove(var/direction)
	if(DoMove(direction, src) &69OVEMENT_HANDLED)
		return TRUE // Doesn't69ecessarily69ean the69ob physically69oved


/mob
	var/moving           = FALSE


/mob/proc/set_move_cooldown(var/timeout)
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay)
	if(delay)
		delay.SetDelay(timeout)

/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(ismob(mover))
		var/mob/moving_mob =69over
		if ((other_mobs &&69oving_mob.other_mobs))
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
				to_chat(usr, SPAN_WARNING("This69ob type cannot throw items."))
			return
		if(NORTHWEST)
			mob.hotkey_drop()

/mob/proc/hotkey_drop()
	to_chat(usr, SPAN_WARNING("This69ob type cannot drop items."))

/mob/living/carbon/hotkey_drop()
	if(!get_active_hand())
		to_chat(usr, SPAN_WARNING("You have69othing to drop in your hand."))
	if (!isturf(loc))
		return
	else
		unEquip(get_active_hand(), loc)

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		to_chat(usr, SPAN_NOTICE("You are69ot pulling anything."))
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = 1

	if(isrobot(mob))
		var/mob/living/silicon/robot/R =69ob
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


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob) &&69ob.stat == CONSCIOUS && isturf(mob.loc))
		return69ob.drop_item()
	return


//Called from space69ovement handler
//Return true for safe69ovement
//Return -1 for69ovement with possibility of slipping
//Return false for69o69ovement
/mob/proc/allow_spacemove()
	//First up, check for69agboots or other gripping capability
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

//Checks if a69ob has solid ground to stand on
//If there's69o gravity then there's69o up or down so69aturally you can't stand on anything.
//For the same reason lattices in space don't count - those are things you grip, presumably.
/mob/proc/check_gravity()
	if(istype(loc, /turf/space))
		return 0

	lastarea = get_area(src)
	if(!lastarea || !lastarea.has_gravity)
		return 0

	return 1


//This proc specifically checks the floor under us. Both floor turfs and walkable objects like catwalk
//This proc is only called if we have grip, ie69agboots
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

	for(var/turf/simulated/T in RANGE_TURFS(1,src)) //we only care for69on-space turfs
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

#define DO_MOVE(this_dir)69ar/final_dir = turn(this_dir, -dir2angle(dir));69ove(get_step(mob, final_dir), final_dir);

/client/verb/moveup()
	set69ame = ".moveup"
	set instant = 1
	DO_MOVE(NORTH)

/client/verb/movedown()
	set69ame = ".movedown"
	set instant = 1
	DO_MOVE(SOUTH)

/client/verb/moveright()
	set69ame = ".moveright"
	set instant = 1
	DO_MOVE(EAST)

/client/verb/moveleft()
	set69ame = ".moveleft"
	set instant = 1
	DO_MOVE(WEST)

#undef DO_MOVE

//This is an atom proc for the sake of69ehicles and69echas
//Attempts to return the expected total time in deciseconds, between this atom69aking69oves
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
	delay +=69ovement_delay()

	if (speed_factor && speed_factor != 1)
		delay /= speed_factor

	return delay
