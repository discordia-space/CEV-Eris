/mob/living/carbon/superior_animal/golem/iron
	name = "iron golem"
	desc = "A moving pile of rocks with iron specks in it."
	icon_state = "golem_iron"
	icon_living = "golem_iron"

	// Health related variables
	maxHealth = GOLEM_HEALTH_HIGH
	health = GOLEM_HEALTH_HIGH

	// Movement related variables
	move_to_delay = GOLEM_SPEED_SLUG
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_FEEBLE
	melee_damage_upper = GOLEM_DMG_LOW

	// Armor related variables
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = GOLEM_ARMOR_HIGH,
		ARMOR_ENERGY = GOLEM_ARMOR_LOW,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

	// Loot related variables
	ore = /obj/item/ore/iron
