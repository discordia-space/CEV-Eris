/*
	This file handles vertical travel using a worn jetpack. Including tons of fancy animation,
	sound and visual fx
*/
/datum/vertical_travel_method/jetpack
	var/obj/item/weapon/tank/jetpack/thrust
	var/burst_interval = 4
	var/next_burst = 0
	start_verb_visible = "%m starts a controlled %d3t with the %s"
	start_verb_personal = "You start a controlled %d3t with the %s"
	base_time = 60



/datum/vertical_travel_method/jetpack/start_animation()
	.=..()
	thrust.doing_zmove = TRUE
	if (direction == DOWN)
		M.pixel_y += 8
		var/matrix/mat = matrix()
		mat.Scale(0.9)
		M.plane = FLOOR_PLANE
		M.layer = 1
		animate(M, alpha = 100, pixel_y = -16, transform = mat,  time = time, easing = SINE_EASING)
	else
		animate(M, alpha = 0, pixel_y = 64*dirmult, time = time, easing = SINE_EASING)


//Jetpacks do a periodic visual effect while ztravelling
//This is also where they consume fuel
/datum/vertical_travel_method/jetpack/tick()
	if (world.time >= next_burst)

		//Multiplying the cost by the burst interval allows this cost to be independant of the interval
		if (thrust.allow_thrust(JETPACK_MOVE_COST*burst_interval * 0.3, M, TRUE))
			var/obj/effect/effect/E = thrust.trail.do_effect(origin, SOUTH)
			//Since the user will have their pixel offset animated by the transition, we must compensate the visuals
			//We will calculate a pixel offset for the thrust particle based on the progress
			var/max = 64
			if (dir == DOWN)
				max = -16

			E.pixel_y = max * progress()

			next_burst = world.time + burst_interval
		else
			//If the jetpack doesn't have enough thrust to continue, we will fail and fall down
			abort()