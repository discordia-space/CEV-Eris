/mob/living/carbon/superior_animal/roach/findTarget()
	. = ..()
	if(. && stat != DEAD)
		//visible_emote("charges at [.]!") //commented out to reduce chat lag
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)

/mob/living/carbon/superior_animal/roach/proc/clearEatTarget()
	if(eat_target)
		UnregisterSignal(eat_target, COMSIG_NULL_SECONDARY_TARGET)
		eat_target = null
