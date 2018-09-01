/mob/living/superior_animal/roach/Life()
	. = ..()

	if(!.)
		walk(src, 0)
		return 0

	if(client)
		return 0

	if(!stat)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				target_mob = FindTarget()

			if(HOSTILE_STANCE_ATTACK)
				if(destroy_surroundings)
					DestroySurroundings()
				MoveToTarget()

			if(HOSTILE_STANCE_ATTACKING)
				if(destroy_surroundings)
					DestroySurroundings()
				AttackTarget()

	return 1