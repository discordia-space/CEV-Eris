/mob/living/carbon/superior_animal/golem/ansible
	name = "ansible golem"
	desc = "A moving pile of rocks with ansible crystals in it."
	icon_state = "golem_ansible_idle"
	icon_living = "golem_ansible_idle"

	// Health related variables
	maxHealth = GOLEM_HEALTH_LOW
	health = GOLEM_HEALTH_LOW

	// Movement related variables
	move_to_delay = GOLEM_SPEED_MED
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_FEEBLE
	melee_damage_upper = GOLEM_DMG_FEEBLE

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
	ore = /obj/item/stock_parts/subspace/crystal

	// Ranged attack related variables
	ranged = TRUE // Will it shoot?
	rapid = FALSE // Will it shoot fast?
	projectiletype = /obj/item/projectile/beam/psychic
	projectilesound = 'sound/weapons/Laser.ogg'
	casingtype = null
	ranged_cooldown = 3 SECOND
	fire_verb = "fires"
	acceptableTargetDistance = 6
	kept_distance = 3

/mob/living/carbon/superior_animal/golem/ansible/New(loc, obj/machinery/mining/deep_drill/drill, datum/golem_controller/parent)
	..()
	set_light(3, 3, "#82C2D8")

/mob/living/carbon/superior_animal/golem/ansible/Destroy()
	set_light(0)
	. = ..()
