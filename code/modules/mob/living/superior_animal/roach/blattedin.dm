/datum/reagent/toxin/blattedin/touch_mob(mob/living/superior_animal/roach/bug, amount)
	if(istype(bug))
		if(bug.stat == DEAD)
			if(!bug.blattedin_revives_left || prob(70))//Roaches sometimes can come back to life from healing vapors
				return
			bug.blattedin_revives_left = max(0, bug.blattedin_revives_left - 1)
		bug.heal_organ_damage(amount * 0.5)
	else
		..()