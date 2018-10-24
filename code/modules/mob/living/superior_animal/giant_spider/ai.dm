/mob/living/carbon/superior_animal/giant_spider/attemptAttackOnTarget()
	var/target = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(L && L.reagents)
			L.reagents.add_reagent(poison_type, poison_per_bite)