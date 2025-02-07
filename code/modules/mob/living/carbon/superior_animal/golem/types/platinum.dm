/mob/living/carbon/superior_animal/golem/platinum
	name = "platinum golem"
	desc = "A hulking pile of rocks with platinum rings running through it."
	icon_state = "golem_platinum"
	icon_living = "golem_platinum"

	// Health related variables
	maxHealth = GOLEM_HEALTH_MED
	health = GOLEM_HEALTH_MED

	// Movement related variables
	move_to_delay = GOLEM_SPEED_SLUG
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_FEEBLE
	melee_damage_upper = GOLEM_DMG_LOW

	// Armor related variables
	armor = list(
		melee = 0,
		bullet = GOLEM_ARMOR_HIGH,
		energy = GOLEM_ARMOR_MED,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related variables
	ore = /obj/item/ore/osmium
