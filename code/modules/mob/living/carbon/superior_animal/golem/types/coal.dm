/mob/living/carbon/superior_animal/golem/coal
	name = "coal golem"
	desc = "A69oving pile of rocks with coal clumps in it."
	icon_state = "golem_coal"
	icon_living = "golem_coal"

	// Health related69ariables
	maxHealth = GOLEM_HEALTH_MED
	health = GOLEM_HEALTH_MED

	//69ovement related69ariables
	move_to_delay = GOLEM_SPEED_MED
	turns_per_move = 5

	// Damage related69ariables
	melee_damage_lower = GOLEM_DMG_LOW
	melee_damage_upper = GOLEM_DMG_MED

	// Armor related69ariables
	armor = list(
		melee = GOLEM_ARMOR_MED,
		bullet = GOLEM_ARMOR_MED,
		energy = GOLEM_ARMOR_LOW,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related69ariables
	ore = /obj/item/ore/coal
