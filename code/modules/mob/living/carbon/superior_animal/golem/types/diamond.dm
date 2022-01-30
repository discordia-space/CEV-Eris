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

	// Armor related variables
	armor = list(
		melee = GOLEM_ARMOR_HIGH,
		bullet = GOLEM_ARMOR_HIGH,
		energy = GOLEM_ARMOR_MED,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related variables
	ore = /obj/item/ore/diamond
