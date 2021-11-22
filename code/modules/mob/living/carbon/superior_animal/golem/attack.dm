/mob/living/carbon/superior_animal/golem/isValidAttackTarget(var/atom/O)
	// Golems can actively try to attack the drill
	if(istype(O, /obj/machinery/mining/deep_drill))
		return 1
	return ..()
