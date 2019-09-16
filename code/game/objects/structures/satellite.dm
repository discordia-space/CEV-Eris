/obj/structure/satellite
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "sputnik"
	desc = "It looks like ancient satellite."
	var/cooldown = FALSE

/obj/structure/satellite/attack_hand(mob/living/user as mob)
	if(cooldown == FALSE)
		cooldown = TRUE
		emp_in(src.loc, 4, 6, 0)
		sleep(360)
		cooldown = FALSE

/obj/structure/satellite/proc/emp_in(turf/epicenter, heavy_range, light_range, log=0)
	for(var/mob/M in range(heavy_range, epicenter))
		playsound(loc, 'sound/effects/EMPulse.ogg')

	for(var/atom/T in range(light_range, epicenter))
		var/distance = get_dist(epicenter, T)
		if(distance > 1)
			if(distance < heavy_range)
				T.emp_act(1)
			else if(distance == heavy_range)
				if(prob(50))
					T.emp_act(1)
				else
					T.emp_act(2)
			else if(distance <= light_range)
				T.emp_act(2)
	return TRUE

/obj/structure/satellite/science
	var/nosignal = FALSE

/obj/structure/satellite/science/attack_hand(mob/living/user as mob)
	if(istype(user, /mob/living/carbon/human))
		if(nosignal == FALSE)
			nosignal = TRUE
			var/mob/living/carbon/human/H = user
			var/mystat = pick(STAT_MEC, STAT_COG, STAT_TGH, STAT_VIG, STAT_BIO)
			H.stats.changeStat(mystat, H.stats:getStat(mystat) + 20)