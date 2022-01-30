/mob/living/carbon/superior_animal/golem/plasma
	name = "plasma golem"
	desc = "A moving pile of rocks with plasma specks in it."
	icon_state = "golem_plasma"
	icon_living = "golem_plasma"

	// Health related variables
	maxHealth = GOLEM_HEALTH_LOW
	health = GOLEM_HEALTH_LOW

	// Movement related variables
	move_to_delay = GOLEM_SPEED_MED
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_FEEBLE
	melee_damage_upper = GOLEM_DMG_LOW

	// Armor related variables
	armor = list(
		melee = 0,
		bullet = GOLEM_ARMOR_LOW,
		energy = GOLEM_ARMOR_HIGH,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related variables
	ore = /obj/item/ore/plasma

    // Ranged attack related variables
    ranged = TRUE // Will it shoot?
	rapid = FALSE // Will it shoot fast?
	projectiletype = /obj/item/projectile/plasma
	projectilesound = 'sound/weapons/energy/burn.ogg'
	casingtype = null
	ranged_cooldown = 1 SECOND
	fire_verb = "fires"
	acceptableTargetDistance = 6
	kept_distance = 3
