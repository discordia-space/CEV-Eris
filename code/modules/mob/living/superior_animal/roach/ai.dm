/mob/living/carbon/superior_animal/roach/findTarget()
	. = ..()
	if(.)
		visible_emote("charges at [.]!")
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)


/mob/living/carbon/superior_animal/roach/attemptAttackOnTarget()
	. = ..()

	var/mob/living/M = .
	if(istype(M) && !M.weakened && prob(5))
		M.Weaken(3)
		M.visible_message(SPAN_DANGER("\the [src] knocks down \the [M]!"))