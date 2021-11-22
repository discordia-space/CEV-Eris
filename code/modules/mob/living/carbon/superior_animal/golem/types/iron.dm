/mob/living/carbon/superior_animal/golem/iron
	name = "iron golem"
	desc = "A moving pile of rocks."
	icon_state = "golem_iron"
	icon_living = "golem_iron"

	// Health related variables
	maxHealth = GOLEM_HEALTH_HIGH
	health = GOLEM_HEALTH_HIGH

	// Movement related variables
	move_to_delay = 10
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_LOW
	melee_damage_upper = GOLEM_DMG_LOW

	// Armor related variables
	melee = GOLEM_ARMOR_HIGH
	bullet = GOLEM_ARMOR_HIGH
	energy = GOLEM_ARMOR_LOW

	// Loot related variables
	ore = /obj/item/ore/iron
