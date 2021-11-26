#define GOLEM_HEALTH_LOW 50
#define GOLEM_HEALTH_MED 100
#define GOLEM_HEALTH_HIGH 150
#define GOLEM_HEALTH_ULTRA 200

#define GOLEM_ARMOR_LOW 20
#define GOLEM_ARMOR_MED 35
#define GOLEM_ARMOR_HIGH 50
#define GOLEM_ARMOR_ULTRA 65

#define GOLEM_DMG_LOW 15
#define GOLEM_DMG_MED 25
#define GOLEM_DMG_HIGH 40
#define GOLEM_DMG_ULTRA 55

#define GOLEM_SPEED_SLUG 3
#define GOLEM_SPEED_LOW 4
#define GOLEM_SPEED_MED 5
#define GOLEM_SPEED_HIGH 6.5

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
	attacktext = "bonked"
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

	// Armor related variables
	var/melee = 0
	var/bullet = 0
	var/energy = 0
	var/bomb = 0
	var/bio = 0
	var/rad = 0

	// Type of ore to spawn when the golem dies
	var/ore

	// The ennemy of all golemkind
	var/obj/machinery/mining/deep_drill/DD

/mob/living/carbon/superior_animal/golem/New(loc, obj/machinery/mining/deep_drill/drill)
	..()
	if(drill)
		DD = drill
		if(prob(50))
			target_mob = drill
			stance = HOSTILE_STANCE_ATTACK

/mob/living/carbon/superior_animal/golem/Destroy()
	DD = null
	..()

/mob/living/carbon/superior_animal/golem/getarmor(def_zone, type)
	return vars[type]

/mob/living/carbon/superior_animal/golem/death(gibbed, message = deathmessage)
	. = ..()

	// Spawn ores
	if(ore)
		var/nb_ores = rand(3, 5)
		for(var/i in 1 to nb_ores)
			new ore(loc)

	// Poof
	qdel(src)
