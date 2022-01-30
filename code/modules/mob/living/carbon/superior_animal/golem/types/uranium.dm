/mob/living/carbon/superior_animal/golem/uranium
	name = "uranium golem"
	desc = "A moving pile of rocks with uranium specks in it."
	icon_state = "golem_uranium"
	icon_living = "golem_uranium"

	// Health related variables
	maxHealth = GOLEM_HEALTH_MED
	health = GOLEM_HEALTH_MED

	// Movement related variables
	move_to_delay = GOLEM_SPEED_LOW
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_FEEBLE
	melee_damage_upper = GOLEM_DMG_FEEBLE

	// Armor related variables
	armor = list(
		melee = GOLEM_ARMOR_HIGH,
		bullet = GOLEM_ARMOR_MED,
		energy = GOLEM_ARMOR_ULTRA,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related variables
	ore = /obj/item/ore/uranium

    // Uranium golem does not attack
    viewRange = 0  // Cannot attack if it cannot see
