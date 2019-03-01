/datum/vertical_travel_method/jump
	start_verb_visible = "%m pushes off the %s and leaps %dward"
	start_verb_personal = "You push off the %s and leap %dward"
	base_time = 40
	slip_chance = 80 //Veeery imprecise
	do_tick = FALSE //Jumping doesn't need to tick, it can't be interrupted.
	//Once you start you will finish, even if you die in mid air

/datum/vertical_travel_method/jump/can_perform(var/dir)
	.=..()
	if (.)
		if (isrobot(M))
			return FALSE //Robots can't jump

		if (gravity)
			/*
				Jumping under gravity is not currently supported.
				In future, certain hardsuit modules, mutations, cybernetic enhancements and antag powers
				will allow leaping between floors
			*/
			return FALSE

		//In order to jump, you need a solid surface under you to push off of
		var/turf/T
		var/testdir
		if (dir == UP)

			T = origin
			testdir = DOWN
		else
			//Or in the case of pushing downwards, you need a ceiling above you
			T = GetAbove(origin)
			testdir = UP

		//Can't push off of nothing
		if (!T)
			return FALSE

		if (T.CanZPass(M, testdir))
			return FALSE


		//If we get here, we can jump.
		subject = T //Save this turf for use in the visible messages

		//Now lets do some refinement to make sure we get the right subject for the message

		//If the turf is a hole, then its not the turf itself we're pushing off of
		//In that case lets look for objects in the turf
		if (T.is_hole)

			//This is kind of simple. It seems there's no easy way to do "find the object that's blocking me"
			//Z pass code is split across a variety of functions and variables.
			//TODO: Refactor all that, and then this
			var/atom/a = locate(/obj/structure/catwalk, T)
			if (a)
				subject = a
			else
				subject = T.getEffectShield()


/datum/vertical_travel_method/jump/start_animation()
	.=..()
	if (direction == DOWN)
		var/matrix/mat = M.transform
		mat.Turn(180)
		M.transform = mat

		mat = M.transform
		mat.Scale(0.9)
		M.set_plane(FLOOR_PLANE)
		M.layer = 1
		animate(M, alpha = 100, pixel_y = -16, transform = mat,  time = duration*1.4, easing = BACK_EASING)
	else
		animate(M, alpha = 0, pixel_y = 64, time = duration*1.4, easing = BACK_EASING)



/datum/vertical_travel_method/jump/calculate_time()
	duration = base_time //Doesn't change based on direction or gravity