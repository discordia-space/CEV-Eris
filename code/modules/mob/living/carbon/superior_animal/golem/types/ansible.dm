#define ANSIBLE_TELEPORT_RANGE 7 //range from the ansible golem that the target can be teleported to, not the total distance the target can teleport

/mob/living/carbon/superior_animal/golem/ansible
	name = "ansible golem"
	desc = "A moving pile of rocks dotted with ansible crystals, each bursting with energy."
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

	// Ranged attack related variables
	ranged = TRUE // Will it shoot?
	rapid = FALSE // Will it shoot fast?
	projectiletype = /obj/item/projectile/beam/psychic
	projectilesound = 'sound/weapons/Laser.ogg'
	casingtype = null
	ranged_cooldown = 3 SECOND
	fire_verb = "fires"
	acceptableTargetDistance = 6
	kept_distance = 5
	retreat_on_too_close = TRUE

	// Cooldown of special ability
	var/teleport_cooldown = -90 SECONDS // negative so that it isn't on cooldown at round start

/mob/living/carbon/superior_animal/golem/ansible/New()
	..()
	set_light(3, 3, "#82C2D8")

/mob/living/carbon/superior_animal/golem/ansible/Destroy()
	set_light(0)
	. = ..()

/mob/living/carbon/superior_animal/golem/ansible/death()
	if(prob(10)) //10% chance to drop a bs crystal. since ansible golems are only present on max difficulty this seems like a fair reward.
		var/obj/item/bluespace_crystal/crystal = new /obj/item/bluespace_crystal(loc)
		visible_message(SPAN_NOTICE("A [crystal.name] falls out of [src] as it disintegrates."))
	..()

// Special capacity of ansible golem: it will focus and teleport a miner near other golems
/mob/living/carbon/superior_animal/golem/ansible/proc/teleport_target()

	// Teleport target to a random golem near the ansible golem
	if(target_mob)
		go_to_bluespace(get_turf(src), 1, TRUE, target_mob, pick(getMobsInRangeChunked(src, ANSIBLE_TELEPORT_RANGE, TRUE)))

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
