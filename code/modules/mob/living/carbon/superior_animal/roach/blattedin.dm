/datum/reagent/toxin/blattedin/touch_mob(var/mob/M, var/amount)
	if(istype(M, /mob/living/carbon/superior_animal/roach))
		var/mob/living/carbon/superior_animal/roach/bug = M
		if(bug.stat == DEAD)
			if((bug.blattedin_revives_left >= 0) && prob(70))//Roaches sometimes can come back to life from healing vapors
				bug.blattedin_revives_left = max(0, bug.blattedin_revives_left - 1)
				bug.rejuvenate()
		else
			bug.heal_organ_damage(amount * 0.5)
	else
		..()