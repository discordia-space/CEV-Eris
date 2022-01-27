/mob/living/carbon/superior_animal/golem/iron
	name = "iron golem"
	desc = "A69oving pile of rocks with iron specks in it."
	icon_state = "golem_iron"
	icon_living = "golem_iron"

	// Health related69ariables
	maxHealth = GOLEM_HEALTH_HIGH
	health = GOLEM_HEALTH_HIGH

	//69ovement related69ariables
	move_to_delay = GOLEM_SPEED_SLUG
	turns_per_move = 5

	// Damage related69ariables
	melee_damage_lower = GOLEM_DMG_FEEBLE
	melee_damage_upper = GOLEM_DMG_LOW

	// Armor related69ariables
	armor = list(
		melee = GOLEM_ARMOR_HIGH,
		bullet = GOLEM_ARMOR_HIGH,
		energy = GOLEM_ARMOR_LOW,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related69ariables
	ore = /obj/item/ore/iron
