/mob/living/carbon/superior_animal/golem/platinum
	name = "platinum golem"
	desc = "A moving pile of rocks with platinum specks in it."
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
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = GOLEM_ARMOR_HIGH,
		ARMOR_ENERGY = GOLEM_ARMOR_MED,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
	)

	// Loot related variables
	ore = /obj/item/ore/osmium

	// Ranged attack related variables
	ranged = TRUE // Will it shoot?
	rapid = FALSE // Will it shoot fast?
	projectiletype = /obj/item/projectile/plasma/stun/heavy
	projectilesound = 'sound/weapons/energy/burn.ogg'
	casingtype = null
	ranged_cooldown = 3 SECOND
	fire_verb = "fires"
	acceptableTargetDistance = 6
	kept_distance = 3
