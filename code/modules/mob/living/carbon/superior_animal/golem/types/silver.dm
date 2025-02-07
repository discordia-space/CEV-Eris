/mob/living/carbon/superior_animal/golem/silver
	name = "silver golem"
	desc = "A moving pile of rocks lined with menacing silver spikes."
	icon_state = "golem_silver"
	icon_living = "golem_silver"

	// Health related variables
	maxHealth = GOLEM_HEALTH_LOW
	health = GOLEM_HEALTH_LOW

	// Movement related variables
	move_to_delay = GOLEM_SPEED_HIGH
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_MED
	melee_damage_upper = GOLEM_DMG_HIGH
	melee_sharp = TRUE

	// Armor related variables
	armor = list(
		melee = 0,
		bullet = GOLEM_ARMOR_LOW,
		energy = GOLEM_ARMOR_LOW,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related variables
	ore = /obj/item/ore/silver

	// Ranged attack related variables
	ranged = TRUE // Will it shoot?
	rapid = FALSE // Will it shoot fast?
	projectiletype = /obj/item/projectile/plasma/stun/golem
	projectilesound = 'sound/weapons/energy/burn.ogg'
	casingtype = null
	ranged_cooldown = 3 SECOND
	fire_verb = "fires"
	acceptableTargetDistance = 6
	kept_distance = 5

/obj/item/projectile/plasma/stun/golem //special projectile that passes straight through golems
	name = "stun plasma bolt"
	taser_effect = 1
	damage_types = list(HALLOSS = 30, BURN = 5)
	impact_type = /obj/effect/projectile/stun/golem

/obj/item/projectile/plasma/stun/golem/bump(atom/A as mob|obj|turf|area, forced = FALSE)
	if(istype(A, /mob/living/carbon/superior_animal/golem))
		return FALSE
	. = ..()

