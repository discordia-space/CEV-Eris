/mob/living/carbon/superior_animal/roach/Life()
	. = ..()
	if(has_gun && target_mob && prob(50)) OpenFire(target_mob)