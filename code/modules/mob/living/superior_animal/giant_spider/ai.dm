/mob/living/superior_animal/giant_spider/attemptAttackOnTarget()
	var/target = ..()
	if (target && prob(25))
		playsound(src, 'sound/weapons/spiderlunge.ogg', 30, 1, -3)
	if(isliving(target))
		var/mob/living/L = target
		if(L && L.reagents)
			L.reagents.add_reagent(poison_type, poison_per_bite)