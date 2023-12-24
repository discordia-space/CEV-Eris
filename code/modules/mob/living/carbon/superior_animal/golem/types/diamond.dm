/mob/living/carbon/superior_animal/golem/diamond
	name = "diamond golem"
	desc = "A moving pile of rocks with diamond specks in it."
	icon_state = "golem_diamond"
	icon_living = "golem_diamond"

	// Health related variables
	maxHealth = GOLEM_HEALTH_ULTRA
	health = GOLEM_HEALTH_ULTRA

	// Movement related variables
	move_to_delay = GOLEM_SPEED_SLUG
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_LOW
	melee_damage_upper = GOLEM_DMG_MED

	// Damage multiplier when destroying surroundings
	surrounds_mult = 5.0

	// Armor related variables
	armor = list(
		ARMOR_BLUNT = GOLEM_ARMOR_LOW,
		ARMOR_BULLET = GOLEM_ARMOR_HIGH,
		ARMOR_ENERGY = GOLEM_ARMOR_MED,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

	// Loot related variables
	ore = /obj/item/ore/diamond

// Special capacity of diamond golem: rush towards the drill without caring about pathplanning
/mob/living/carbon/superior_animal/golem/diamond/handle_ai()

	objectsInView = null

	//CONSCIOUS UNCONSCIOUS DEAD

	if(!check_AI_act())
		return FALSE

	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			if(!busy) // if not busy with a special task
				stop_automated_movement = FALSE
			target_mob = DD
			if(target_mob)
				stance = HOSTILE_STANCE_ATTACK

		if(HOSTILE_STANCE_ATTACK)
			destroySurroundings()
			stop_automated_movement = TRUE
			stance = HOSTILE_STANCE_ATTACKING
			set_glide_size(DELAY2GLIDESIZE(move_to_delay))
			walk_towards(src, target_mob, 1, move_to_delay)

		if(HOSTILE_STANCE_ATTACKING)
			destroySurroundings()
			prepareAttackOnTarget()

	//Speaking
	if(speak_chance && prob(speak_chance))
		visible_emote(emote_see)

	return TRUE
