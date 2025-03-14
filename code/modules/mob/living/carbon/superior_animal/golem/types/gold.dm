#define GOLD_SPIKE_COOLDOWN 50 // 5 seconds
#define GOLD_SPIKE_WINDUP 20
#define GOLD_SPIKE_DAMAGE 40 //equivalent to GOLEM_DMG_HIGH

/mob/living/carbon/superior_animal/golem/gold
	name = "gold golem"
	desc = "A moving pile of rocks with hyper-malleable gold flowing through its cracks."
	icon_state = "golem_gold"
	icon_living = "golem_gold"

	// Health related variables
	maxHealth = GOLEM_HEALTH_HIGH
	health = GOLEM_HEALTH_HIGH

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
		energy = GOLEM_ARMOR_LOW,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	kept_distance = 5
	retreat_on_too_close = TRUE

	// Loot related variables
	mineral_name = ORE_GOLD

	var/spike_cooldown = 0

/mob/living/carbon/superior_animal/golem/gold/handle_ai()
	if(isliving(target_mob) && ((spike_cooldown + GOLD_SPIKE_COOLDOWN) < world.time))
		spike_cooldown = world.time
		spike_attack()
	. = ..()

/mob/living/carbon/superior_animal/golem/gold/proc/spike_attack()
	var/list/turfstoattack = list()
	turfstoattack += get_turf(target_mob) // always attack the turf with the target
	for(var/turf/potentialturf in range(1,target_mob))
		if(prob(50) && !(/obj/golem_spike in potentialturf.contents)) // don't stack golem spikes
			turfstoattack += potentialturf

	for(var/turf/targetturf in turfstoattack)
		var/obj/golem_spike/spike = new /obj/golem_spike(targetturf)
		spike.parent = src

/obj/golem_spike
	icon = 'icons/mob/golems.dmi'
	icon_state = "goldspike_tip"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/parent
	var/attacktext = list(
				"skewered",
				"impaled,",
				"punctured")

/obj/golem_spike/Initialize()
	. = ..()
	playsound(src, pick(crumble_sound), 20)
	spawn(GOLD_SPIKE_WINDUP)
		icon_state = "goldspike_full"
		var/turf/turf = get_turf(src)
		for(var/mob/living/victim in turf.contents)
			if(!istype(victim, /mob/living/carbon/superior_animal/golem))
				victim.attack_generic(parent, GOLD_SPIKE_DAMAGE, pick(attacktext), FALSE, TRUE, FALSE, 1)
				playsound(src, 'sound/weapons/slice.ogg', 30)
				victim.shake_animation(4)
		animate(src, alpha = 0, time = 20, easing = BACK_EASING|EASE_IN)
		QDEL_IN(src, 20)


#undef GOLD_SPIKE_COOLDOWN
#undef GOLD_SPIKE_WINDUP
#undef GOLD_SPIKE_DAMAGE

