#define GOLEM_HEALTH_LOW 20
#define GOLEM_HEALTH_MED 40
#define GOLEM_HEALTH_HIGH 60
#define GOLEM_HEALTH_ULTRA 80

#define GOLEM_ARMOR_LOW 5
#define GOLEM_ARMOR_MED 8
#define GOLEM_ARMOR_HIGH 12
#define GOLEM_ARMOR_ULTRA 18

#define GOLEM_DMG_FEEBLE 5
#define GOLEM_DMG_LOW 15
#define GOLEM_DMG_MED 25
#define GOLEM_DMG_HIGH 40
#define GOLEM_DMG_ULTRA 55

#define GOLEM_SPEED_SLUG 9
#define GOLEM_SPEED_LOW 7
#define GOLEM_SPEED_MED 5
#define GOLEM_SPEED_HIGH 3

#define GOLEM_REGENERATION 10  // Healing by special ability of uranium golems

// Normal types of golems
GLOBAL_LIST_INIT(golems_normal, list(/mob/living/carbon/superior_animal/golem/coal,
                                     /mob/living/carbon/superior_animal/golem/iron))

// Special types of golems
GLOBAL_LIST_INIT(golems_special, list(/mob/living/carbon/superior_animal/golem/silver,
									  /mob/living/carbon/superior_animal/golem/plasma,
									  /mob/living/carbon/superior_animal/golem/platinum,
									  /mob/living/carbon/superior_animal/golem/diamond,
									  /mob/living/carbon/superior_animal/golem/ansible,
									  /mob/living/carbon/superior_animal/golem/uranium))

// OneStar patrol borg that defends OneStar facilities
/mob/living/carbon/superior_animal/golem
	icon = 'icons/mob/golems.dmi'

	mob_size = MOB_MEDIUM

	//spawn_values
	rarity_value = 37.5
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_MOB_GOLEM
	faction = "golem"

	deathmessage = "shatters in a pile of rubbles."
	attacktext = list("bonked")
	attack_sound = 'sound/weapons/smash.ogg'
	speak_emote = list("rattles")
	emote_see = list("makes a deep rattling sound")
	speak_chance = 5

	see_in_dark = 10
	meat_type = null
	meat_amount = 0
	stop_automated_movement_when_pulled = 0

	destroy_surroundings = TRUE

	contaminant_immunity = TRUE
	cold_protection = 1
	heat_protection = 1
	breath_required_type = 0
	breath_poison_type = 0
	min_breath_required_type = 0
	min_breath_poison_type = 0
	min_air_pressure = 0 //below this, brute damage is dealt
	max_air_pressure = 10000 //above this, brute damage is dealt
	min_bodytemperature = 0 //below this, burn damage is dealt
	max_bodytemperature = 10000 //above this, burn damage is dealt

	// Damage multiplier when destroying surroundings
	var/surrounds_mult = 0.5

	// Type of ore to spawn when the golem dies
	var/ore

	// The ennemy of all golemkind
	var/obj/machinery/mining/deep_drill/DD

	// Controller that spawned the golem
	var/datum/golem_controller/controller

/mob/living/carbon/superior_animal/golem/New(loc, obj/machinery/mining/deep_drill/drill, datum/golem_controller/parent)
	..()
	if(parent)
		controller = parent  // Link golem with golem controller
		controller.golems += src
	if(drill)
		DD = drill
		if(prob(50))
			target_mob = drill
			stance = HOSTILE_STANCE_ATTACK

/mob/living/carbon/superior_animal/golem/Destroy()
	DD = null
	..()

/mob/living/carbon/superior_animal/golem/death(gibbed, message = deathmessage)
	if(controller) // Unlink from controller
		controller.golems -= src
		controller = null

	. = ..()

	// Spawn ores
	if(ore)
		var/nb_ores = rand(8, 13)
		for(var/i in 1 to nb_ores)
			new ore(loc)

		// Specials have a small chance to also drop a golem core
		if(prob(30) && !istype(src, /mob/living/carbon/superior_animal/golem/coal) && !istype(src, /mob/living/carbon/superior_animal/golem/iron))
			new /obj/item/golem_core(loc)

	// Poof
	qdel(src)

/mob/living/carbon/superior_animal/golem/gib(anim = icon_gib, do_gibs = FALSE)
	. = ..(anim, FALSE)  // No gibs when gibbing a golem (no blood)

/mob/living/carbon/superior_animal/golem/destroySurroundings()
	// Get next turf the golem wants to walk on
	var/turf/T = get_step_towards(src, target_mob)

	if(iswall(T))  // Wall breaker attack
		T.attack_generic(src, rand(surrounds_mult * melee_damage_lower, surrounds_mult * melee_damage_upper), pick(attacktext), TRUE)
	else
		var/obj/structure/obstacle = locate(/obj/structure) in T
		if(obstacle && !istype(obstacle, /obj/structure/golem_burrow))
			obstacle.attack_generic(src, rand(surrounds_mult * melee_damage_lower, surrounds_mult * melee_damage_upper), pick(attacktext), TRUE)

/mob/living/carbon/superior_animal/golem/handle_ai()
	// Chance to re-aggro the drill if doing nothing
	if((stance == HOSTILE_STANCE_IDLE) && prob(10))
		if(!busy) // if not busy with a special task
			stop_automated_movement = FALSE
		target_mob = DD
		if(target_mob)
			stance = HOSTILE_STANCE_ATTACK
	. = ..()
