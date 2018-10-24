/mob/living/carbon/superior_animal/Life()
	. = ..()

	objectsInView = null

	if(client)
		return .

	switch (stat)
		if (DEAD)
			walk(src, 0)
			return .

		if (UNCONSCIOUS)
			walk(src, 0)
			return .

		//if (CONSCIOUS)

	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			stop_automated_movement = 0
			target_mob = findTarget()
			if (target_mob)
				stance = HOSTILE_STANCE_ATTACK

		if(HOSTILE_STANCE_ATTACK)
			if(destroy_surroundings)
				destroySurroundings()

			stop_automated_movement = 1
			stance = HOSTILE_STANCE_ATTACKING
			walk_to(src, target_mob, 1, move_to_delay)

		if(HOSTILE_STANCE_ATTACKING)
			if(destroy_surroundings)
				destroySurroundings()

			prepareAttackOnTarget()

	//random movement
	if(wander && !stop_automated_movement && !anchored)
		if(isturf(src.loc) && !resting && !buckled && canmove)
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && pulledby))
					var/moving_to = pick(cardinal)
					set_dir(moving_to)
					Move(get_step(src,moving_to))
					turns_since_move = 0

	//Speaking
	if(speak_chance && prob(speak_chance))
		visible_emote(emote_see)