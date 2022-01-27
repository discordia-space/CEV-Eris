// Uncomment this define to check for possible lengthy processing of emp_act()s.
// If emp_act() takes69ore than defined deciseconds (1/10 seconds) an admin69essage and log is created.
// I do not recommend having this uncommented on69ain server, it probably causes a bit69ore lag, especially with larger EMPs.

// #define EMPDEBUG 10

proc/empulse(turf/epicenter, heavy_range, light_range, log=0, strength=1)
	if(!epicenter) return

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	if(log)
		message_admins("EMP with size (69heavy_range69, 69light_range69) in area 69epicenter.loc.name69 ")
		log_game("EMP with size (69heavy_range69, 69light_range69) in area 69epicenter.loc.name69 ")

	if(heavy_range > 1)
		var/obj/effect/overlay/pulse = new(epicenter)
		pulse.icon = 'icons/effects/effects.dmi'
		pulse.icon_state = "emppulse"
		pulse.name = "emp pulse"
		pulse.anchored = TRUE
		spawn(20)
			69del(pulse)

	if(heavy_range > light_range)
		light_range = heavy_range

	for(var/mob/M in range(heavy_range, epicenter))
		M << 'sound/effects/EMPulse.ogg'

	var/effect =69ax(strength, 0)

	for(var/atom/T in range(light_range, epicenter))
		#ifdef EMPDEBUG
		var/time = world.timeofday
		#endif
		var/distance = get_dist(epicenter, T)
		if(distance < 0)
			distance = 0
		if(distance < heavy_range)
			T.emp_act(effect)
		else if(distance == heavy_range)
			if(prob(50))
				T.emp_act(effect)
			else
				T.emp_act(effect + 1)
		else if(distance <= light_range)
			T.emp_act(effect + 1)
		#ifdef EMPDEBUG
		if((world.timeofday - time) >= EMPDEBUG)
			log_and_message_admins("EMPDEBUG: 69T.name69 - 69T.type69 - took 69world.timeofday - time69ds to process emp_act()!")
		#endif
	return 1
