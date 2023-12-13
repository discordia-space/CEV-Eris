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
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = GOLEM_ARMOR_LOW,
		ARMOR_ENERGY = GOLEM_ARMOR_LOW,
		ARMOR_BOMB =0,
		ARMOR_BIO =0,
		ARMOR_RAD =0
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

	// Cooldown of special ability
	var/teleport_cooldown = 0

/mob/living/carbon/superior_animal/golem/ansible/New(loc, obj/machinery/mining/deep_drill/drill, datum/golem_controller/parent)
	..()
	set_light(3, 3, "#82C2D8")

/mob/living/carbon/superior_animal/golem/ansible/Destroy()
	set_light(0)
	. = ..()

// Special capacity of ansible golem: it will focus and teleport a miner near other golems
/mob/living/carbon/superior_animal/golem/ansible/proc/teleport_target()

	// Teleport target near random golem
	if(target_mob && controller)
		go_to_bluespace(target_mob.loc, 1, TRUE, target_mob, get_step(pick(controller.golems), pick(cardinal)), \
						0, TRUE, null, null, 'sound/effects/teleport.ogg', 'sound/effects/teleport.ogg')

/mob/living/carbon/superior_animal/golem/ansible/proc/focus_target()

	// Display focus animation
	var/image/img = image('icons/mob/golems.dmi', target_mob)
	target_mob << img
	flick("ansible_focus", img)

	// Callback to function that will teleport the target
	// Animation lasts 90 frames with 0.6 tick delay between frames
	addtimer(CALLBACK(src, PROC_REF(teleport_target)), 54)

/mob/living/carbon/superior_animal/golem/ansible/handle_ai()
	if(isliving(target_mob) && (world.time - teleport_cooldown > 1 MINUTE))  // Do not teleport the drill
		teleport_cooldown = world.time
		focus_target()
	. = ..()
