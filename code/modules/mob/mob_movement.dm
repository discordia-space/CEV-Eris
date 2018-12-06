/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return 1
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)
	return

/mob/proc/setMoveCooldown(var/timeout)
	if(client)
		client.setMoveCooldown(timeout)

/client/proc/setMoveCooldown(var/timeout)
	return move_delayer.setDelayMin(timeout)

/client/proc/isMovementBlocked()
	return move_delayer.isBlocked()


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
				usr << "\red This mob type cannot throw items."
			return
		if(NORTHWEST)
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(!C.get_active_hand())
					usr << "\red You have nothing to drop in your hand."
					return
				drop_item()
			else
				usr << "\red This mob type cannot drop items."
			return

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		usr << "\blue You are not pulling anything."
		return
	usr.stop_pulling()

/client/verb/swap_hand()
	set hidden = 1
	if(iscarbon(mob))
		mob:swap_hand()
	if(isrobot(mob))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return



/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/toggle_throw_mode()
	set hidden = 1
	if(!iscarbon(mob))
		return
	if (!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob:toggle_throw_mode()
	else
		return


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob) && mob.stat == CONSCIOUS && isturf(mob.loc))
		return mob.drop_item()
	return


/client/Center()
	/* No 3D movement in 2D spessman game. dir 16 is Z Up
	if (isobj(mob.loc))
		var/obj/O = mob.loc
		if (mob.canmove)
			return O.relaymove(mob, 16)
	*/
	return

/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))
	return


/client/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	if(!mob)
		return // Moved here to avoid nullrefs below

	if(mob.control_object)	Move_object(Dir)

	if(moving)	return 0

	if (isMovementBlocked())
		return

	if(mob.incorporeal_move && isobserver(mob))
		Process_Incorpmove(Dir)
		return

	if(locate(/obj/effect/stop/, mob.loc))
		for(var/obj/effect/stop/S in mob.loc)
			if(S.victim == mob)
				return

	if(mob.stat==DEAD && isliving(mob))
		mob.ghostize()
		return

	if(isAI(mob))
		var/mob/living/silicon/ai/AI = mob
		if(AI.controlled_mech)
			return AI.controlled_mech.relaymove(mob, Dir)

	// handle possible Eye movement
	if(mob.eyeobj)
		return mob.EyeMove(NewLoc, Dir)

	if(mob.transforming)	return//This is sota the goto stop mobs from moving var

	if(isliving(mob))
		var/mob/living/L = mob
		if(L.incorporeal_move)//Move though walls
			Process_Incorpmove(Dir)
			return
		if(mob.client)
			if(mob.client.view != world.view) // If mob moves while zoomed in with device, unzoom them.
				for(var/obj/item/item in mob.contents)
					if(item.zoom)
						item.zoom()
						break
				/*
				if(locate(/obj/item/weapon/gun/energy/sniperrifle, mob.contents))		// If mob moves while zoomed in with sniper rifle, unzoom them.
					var/obj/item/weapon/gun/energy/sniperrifle/s = locate() in mob
					if(s.zoom)
						s.zoom()
				if(locate(/obj/item/device/binoculars, mob.contents))		// If mob moves while zoomed in with binoculars, unzoom them.
					var/obj/item/device/binoculars/b = locate() in mob
					if(b.zoom)
						b.zoom()
				*/

	if(Process_Grab())	return

	if(!mob.canmove)
		return


	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)



	if(isobj(mob.loc) || ismob(mob.loc))//Inside an object, tell it we moved
		var/atom/O = mob.loc
		return O.relaymove(mob, Dir)


	if(isturf(mob.loc))

		if((istype(mob.loc, /turf/space)) || (mob.lastarea.has_gravity == 0))
			if(!mob.Allow_Spacemove(0))
				return 0


		if(mob.restrained())//Why being pulled while cuffed prevents you from moving
			for(var/mob/M in range(mob, 1))
				if(M.pulling == mob)
					if(!M.restrained() && M.stat == 0 && M.canmove && mob.Adjacent(M))
						src << "\blue You're restrained! You can't move!"
						return 0
					else
						M.stop_pulling()

		if(mob.pinned.len)
			src << "\blue You're pinned to a wall by [mob.pinned[1]]!"
			return 0



		if(istype(mob.buckled, /obj/vehicle))
			//manually set move_delay for vehicles so we don't inherit any mob movement penalties
			//specific vehicle move delays are set in code\modules\vehicles\vehicle.dm
			//drunk driving
			if(mob.confused)
				Dir = pick(cardinal)

			return mob.buckled.relaymove(mob,Dir)

		var/delay = 0

		switch(mob.m_intent)
			if("run")
				if(mob.drowsyness > 0)
					delay += 6
				delay += 1
			if("walk")
				delay += 7
		delay += mob.movement_delay()

		if(istype(mob.machine, /obj/machinery))
			if(mob.machine.relaymove(mob,Dir))
				move_delayer.setDelay(delay)
				return

		if(mob.pulledby || mob.buckled) // Wheelchair driving!
			if(istype(mob.loc, /turf/space))
				move_delayer.setDelay(delay)
				return // No wheelchair driving in space
			if(istype(mob.pulledby, /obj/structure/bed/chair/wheelchair))
				move_delayer.setDelay(delay)
				return mob.pulledby.relaymove(mob, Dir)
			else if(istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
				if(ishuman(mob))
					var/mob/living/carbon/human/driver = mob
					var/obj/item/organ/external/l_hand = driver.get_organ(BP_L_ARM)
					var/obj/item/organ/external/r_hand = driver.get_organ(BP_R_ARM)
					if((!l_hand || l_hand.is_stump()) && (!r_hand || r_hand.is_stump()))
						move_delayer.setDelay(delay)
						return // No hands to drive your chair? Tough luck!
				//drunk wheelchair driving
				if(mob.confused)
					Dir = pick(cardinal)
				delay += 2
				move_delayer.setDelay(delay)
				return mob.buckled.relaymove(mob,Dir)


		//Here we apply speed factor only if the mob is moving under its own power
		if (mob.speed_factor && mob.speed_factor != 1.0)
			delay /= mob.speed_factor

		if (locate(/obj/item/weapon/grab, mob))
			delay = max(7, delay)

		move_delayer.setDelay(delay)
		// Since we're moving OUT OF OUR OWN VOLITION AND BY OURSELVES we can update our glide_size here!
		var/glide_size = DELAY2GLIDESIZE(delay)
		mob.set_glide_size(DELAY2GLIDESIZE(delay))

		//We are now going to move
		moving = 1
		//Something with pulling things
		if(locate(/obj/item/weapon/grab, mob))
			var/list/L = mob.ret_grab()
			if(istype(L, /list))
				if(L.len == 2)
					L -= mob
					var/mob/M = L[1]
					if(M)
						if ((get_dist(mob, M) <= 1 || M.loc == mob.loc))
							var/turf/T = mob.loc
							. = ..()
							if (isturf(M.loc))
								var/diag = get_dir(mob, M)
								if ((diag - 1) & diag)
								else
									diag = null
								if ((get_dist(mob, M) > 1 || diag))
									step_glide(M, get_dir(M.loc, T), glide_size)
				else
					for(var/mob/M in L)
						M.other_mobs = 1
						if(mob != M)
							M.animate_movement = 3
					for(var/mob/M in L)
						spawn( 0 )
							step_glide(M, Dir, glide_size)
							return
						spawn( 1 )
							M.other_mobs = null
							M.animate_movement = 2
							return

		else
			if(mob.confused)
				step(mob, pick(cardinal))
			else
				. = mob.SelfMove(NewLoc, Dir)

		for (var/obj/item/weapon/grab/G in mob)
			if (G.state == GRAB_NECK)
				mob.set_dir(reverse_dir[Dir])
			G.adjust_position()
		for (var/obj/item/weapon/grab/G in mob.grabbed_by)
			G.adjust_position()

		moving = 0

/mob/proc/SelfMove(turf/n, direct)
	return Move(n, direct)


///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct)
	var/turf/mobloc = get_turf(mob)

	switch(mob.incorporeal_move)
		if(1)
			var/turf/T = get_step(mob, direct)
			if(mob.check_holy(T))
				mob << SPAN_WARNING("You cannot get past holy grounds while you are in this plane of existence!")
				return
			else
				var/delay = 0.5;
				// NOTE HERE: even when we're moving diagonally we pass glide size as if it's a cardinal movement.
				// This is because LONG_GLIDE is set. It'll handle adjustment for diagonals itself.
				var/new_glide_size = DELAY2GLIDESIZE(delay)
				if (direct in cornerdirs)
					delay *= sqrt(2)
				move_delayer.setDelayMin(delay)
				mob.forceMove(get_step(mob, direct), glide_size_override=new_glide_size)
				mob.dir = direct
		if(2)
			var/delay = MOVE_DELAY_BASE+1
			if(prob(50))
				var/locx
				var/locy
				switch(direct)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y+2)
						if(locy>world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y-2)
						if(locy<1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x+2)
						if(locx>world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x-2)
						if(locx<1)
							return
					else
						return

				move_delayer.setDelayMin(delay)
				mob.forceMove(locate(locx,locy,mobloc.z), glide_size_override=DELAY2GLIDESIZE(delay))
				spawn(0)
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, mob.loc))
						spawn(0)
							anim(T,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
						limit--
						if(limit<=0)	break
			else
				spawn(0)
					anim(mobloc,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
				move_delayer.setDelayMin(delay)
				mob.forceMove(get_step(mob, direct), glide_size_override=DELAY2GLIDESIZE(delay))
			mob.dir = direct
	// Crossed is always a bit iffy
	for(var/obj/S in mob.loc)
		if(istype(S,/obj/effect/step_trigger) || istype(S,/obj/effect/beam))
			S.Crossed(mob)

	var/area/A = get_area_master(mob)
	if(A)
		A.Entered(mob)
	if(isturf(mob.loc))
		var/turf/T = mob.loc
		T.Entered(mob)
	mob.Post_Incorpmove()
	return 1

/mob/proc/Post_Incorpmove()
	return

///Allow_Spacemove
///Called by /client/Move()
///For moving in space
///Return 1 for movement 0 for none
/mob/proc/Allow_Spacemove(var/check_drift = 0)

	if(!Check_Dense_Object()) //Nothing to push off of so end here
		update_floating(0)
		return 0

	update_floating(1)

	if(restrained()) //Check to see if we can do things
		return 0

	//Check to see if we slipped
	if(prob(slip_chance(5)) && !buckled)
		src << SPAN_WARNING("You slipped!")
		src.inertia_dir = src.last_move
		step(src, src.inertia_dir)
		return 0
	//If not then we can reset inertia and move
	inertia_dir = 0
	return 1

/mob/proc/Check_Dense_Object() //checks for anything to push off in the vicinity. also handles magboots on gravity-less floors tiles

	var/shoegrip = Check_Shoegrip()

	for(var/turf/simulated/T in trange(1,src)) //we only care for non-space turfs
		if(T.density)	//walls work
			return 1
		else
			var/area/A = T.loc
			if(A.has_gravity || shoegrip)
				return 1

	for(var/obj/O in range(1, src))
		if(istype(O, /obj/structure/lattice))
			return 1
		if(istype(O, /obj/structure/catwalk))
			return 1
		if(O && O.density && O.anchored)
			return 1

	return 0

/mob/proc/Check_Shoegrip()
	return 0

/mob/proc/slip_chance(var/prob_slip = 5)
	if(stat)
		return 0
	if(Check_Shoegrip())
		return 0
	return prob_slip

/client/verb/moveup()
	set name = ".moveup"
	set instant = 1
	Move(get_step(mob, NORTH), NORTH)

/client/verb/movedown()
	set name = ".movedown"
	set instant = 1
	Move(get_step(mob, SOUTH), SOUTH)

/client/verb/moveright()
	set name = ".moveright"
	set instant = 1
	Move(get_step(mob, EAST), EAST)

/client/verb/moveleft()
	set name = ".moveleft"
	set instant = 1
	Move(get_step(mob, WEST), WEST)


/mob/proc/total_movement_delay()
	var/delay = 0

	switch(m_intent)
		if("run")
			if(drowsyness > 0)
				delay += 6
			delay += 1
		if("walk")
			delay += 7
	delay += movement_delay()

	if (speed_factor && speed_factor != 1.0)
		delay /= speed_factor

	return delay