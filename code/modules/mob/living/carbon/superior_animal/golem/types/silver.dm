/mob/living/carbon/superior_animal/golem/silver
	name = "silver golem"
	desc = "A69oving pile of rocks with silver specks in it."
	icon_state = "golem_silver"
	icon_living = "golem_silver"

	// Health related69ariables
	maxHealth = GOLEM_HEALTH_LOW
	health = GOLEM_HEALTH_LOW

	//69ovement related69ariables
	move_to_delay = GOLEM_SPEED_HIGH
	turns_per_move = 5

	// Damage related69ariables
	melee_damage_lower = GOLEM_DMG_MED
	melee_damage_upper = GOLEM_DMG_HIGH
	melee_sharp = TRUE

	// Armor related69ariables
	armor = list(
		melee = GOLEM_ARMOR_MED,
		bullet = GOLEM_ARMOR_LOW,
		energy = GOLEM_ARMOR_LOW,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related69ariables
	ore = /obj/item/ore/silver
