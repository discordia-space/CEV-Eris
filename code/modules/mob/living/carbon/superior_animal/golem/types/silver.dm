/mob/living/carbon/superior_animal/golem/silver
	name = "silver golem"
	desc = "A moving pile of rocks with silver specks in it."
	icon_state = "golem_silver"
	icon_living = "golem_silver"

	// Health related variables
	maxHealth = GOLEM_HEALTH_LOW
	health = GOLEM_HEALTH_LOW

	// Movement related variables
	move_to_delay = GOLEM_SPEED_HIGH
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_HIGH
	melee_damage_upper = GOLEM_DMG_HIGH
	melee_sharp = TRUE

	// Armor related variables
	melee = GOLEM_ARMOR_MED
	bullet = GOLEM_ARMOR_LOW
	energy = GOLEM_ARMOR_LOW

	// Loot related variables
	ore = /obj/item/ore/silver
