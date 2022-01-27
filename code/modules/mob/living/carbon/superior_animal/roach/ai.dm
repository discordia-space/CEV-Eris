/mob/living/carbon/superior_animal/roach/findTarget()
	. = ..()
	if(.)
		//visible_emote("charges at 69.69!") //commented out to reduce chat lag
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)