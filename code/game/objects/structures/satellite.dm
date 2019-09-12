/obj/structure/satellite
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "sputnik"
	var/cooldown = 0

	attack_hand(mob/living/user as mob)
		if(cooldown == 0)
			cooldown = 1
			emp_in(src.loc, 4, 6, 0)
			sleep(360)
			cooldown = 0

/obj/structure/satellite/proc/emp_in(turf/epicenter, heavy_range, light_range, log=0)
	for(var/mob/M in range(heavy_range, epicenter))
		M << 'sound/effects/EMPulse.ogg'

	for(var/atom/T in range(light_range, epicenter))
		#ifdef EMPDEBUG
		var/time = world.timeofday
		#endif
		var/distance = get_dist(epicenter, T)
		if(distance < 2)
			distance = light_range + 1
		if(distance < heavy_range)
			T.emp_act(1)
		else if(distance == heavy_range)
			if(prob(50))
				T.emp_act(1)
			else
				T.emp_act(2)
		else if(distance <= light_range)
			T.emp_act(2)
		#ifdef EMPDEBUG
		if((world.timeofday - time) >= EMPDEBUG)
			log_and_message_admins("EMPDEBUG: [T.name] - [T.type] - took [world.timeofday - time]ds to process emp_act()!")
		#endif
	return 1

/obj/structure/satellite/science
	var/death = 0

	attack_hand(mob/living/user as mob)
		if(istype(user, /mob/living/carbon/human))
			if(death == 0)
				death = 1
				var/mob/living/carbon/human/H = user
				var/mystat = pick(STAT_MEC, STAT_COG, STAT_TGH, STAT_VIG, STAT_BIO)
				H.stats.changeStat(mystat, H.stats:getStat(mystat) + 20)