/mob/living/carbon/superior_animal/bear/Life()
	. = ..()
	if (.)
		//It gradually calms down over about 5 minutes if left alone
		if (anger && prob(6))
			anger = max(anger-1, 0)