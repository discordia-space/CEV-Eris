//Infestation is the primary combat event. It has a broad pool of mobs, both hostile and peaceful,
//which it can spawn in any non-maintenance area of the ship.
//It focuses on spawning large numbers of moderate-to-weak monsters, and includes some elements of surprise

/datum/storyevent/infestation
	id = "infestation"
	name = "infestation"

	weight = 2
	//Since it's a large pool of content, infestation has twice the weight of other events

	event_type = /datum/event/infestation
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE,
	EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE,
	EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR)
	tags = list(TAG_COMBAT, TAG_DESTRUCTIVE, TAG_NEGATIVE)
//============================================


#define INFESTATION_MICE "mice"
#define INFESTATION_LIZARDS "lizards"
#define INFESTATION_SPACE_BATS "space bats"
#define INFESTATION_SPIDERLINGS "spiderlings"
#define INFESTATION_SPIDERS "spiderlings"
#define INFESTATION_ROACHES "giant insects"
#define INFESTATION_HIVEBOTS "hivebots"
#define INFESTATION_SLIMES "slimes"
#define INFESTATION_YITHIAN "yithian"
#define INFESTATION_TINDALOS "tindalos"
#define INFESTATION_DIYAAB "diyaab"
#define INFESTATION_SAMAK "samak"
#define INFESTATION_SHANTAK "shantak"
/datum/event/infestation
	startWhen = 1
	announceWhen = 10
	endWhen = 11
	var/num_areas = 1
	var/num_spawns_per_area
	var/list/area/chosen_areas
	var/event_name = "Slime Leak"
	var/chosen_mob = INFESTATION_SLIMES
	var/chosen_verb = "have leaked into"
	var/list/chosen_mob_types = list()
	var/list/possible_mobs = list(
		INFESTATION_MICE = 20,
		INFESTATION_LIZARDS = 12,
		INFESTATION_SPIDERLINGS = 6,
		INFESTATION_YITHIAN = 6,
		INFESTATION_TINDALOS = 6,
		INFESTATION_DIYAAB = 6,
		INFESTATION_SPACE_BATS = 5
	)

/datum/event/infestation/moderate
	possible_mobs = list(
		INFESTATION_SPACE_BATS = 12,
		INFESTATION_SAMAK = 10,
		INFESTATION_SHANTAK = 10,
		INFESTATION_SPIDERS = 10,//This is a combination of spiderlings and adult spiders
		INFESTATION_ROACHES = 10
	)
/datum/event/infestation/major
	possible_mobs = list(
		INFESTATION_SPIDERS = 3,
		INFESTATION_HIVEBOTS = 1,
		INFESTATION_SLIMES = 4
	)

/datum/event/infestation/setup()
	switch(severity)
		if (EVENT_LEVEL_MODERATE)
			num_areas = 2
		if (EVENT_LEVEL_MAJOR)
			num_areas = 3
	choose_area()
	choose_mobs()

/datum/event/infestation/start()
	spawn_mobs()

/datum/event/infestation/proc/choose_area()
	for (var/i = 1; i <= num_areas; i++)
		chosen_areas += random_ship_area(TRUE)

/datum/event/infestation/proc/choose_mobs()

	var/unidentified = FALSE
	chosen_mob = pick(possible_mobs)
	num_spawns_per_area = possible_mobs[chosen_mob]
	num_spawns_per_area *= rand(0.75, 1.5)

	switch(chosen_mob)
		if(INFESTATION_HIVEBOTS)
			event_name = "Minor Hivebot Invasion"
			chosen_verb = "have invaded"
			chosen_mob_types += /mob/living/simple_animal/hostile/hivebot
			chosen_mob_types += /mob/living/simple_animal/hostile/hivebot/range
		if(INFESTATION_SPACE_BATS)
			event_name = "Space Bat Nest"
			chosen_verb = "have been breeding in"
			chosen_mob_types += /mob/living/simple_animal/hostile/scarybat
		if(INFESTATION_LIZARDS)
			event_name = "Lizard Nest"
			chosen_verb = "have been breeding in"
			chosen_mob_types += /mob/living/simple_animal/lizard
		if(INFESTATION_MICE)
			event_name = "Mouse Nest"
			chosen_verb = "have been breeding in"
			chosen_mob_types += /mob/living/simple_animal/mouse //Mice pick random colors on spawn
		if(INFESTATION_SLIMES)
			event_name = "Slime Leak"
			chosen_verb = "have leaked into"
			chosen_mob_types += /mob/living/carbon/slime/
		if(INFESTATION_SPIDERLINGS)
			event_name = "Spiderling Infestation"
			chosen_verb = "have burrowed into"
			chosen_mob_types[/obj/effect/spider/spiderling] = 1
			chosen_mob_types[/obj/effect/spider/eggcluster] = 0.2
		if(INFESTATION_SPIDERS)
			event_name = "Spider Infestation"
			chosen_verb = "have burrowed into"
			chosen_mob_types += /obj/random/mob/spiders
		if(INFESTATION_ROACHES)
			event_name = "Giant Roach Infestation"
			chosen_verb = "have burrowed into"
			chosen_mob_types += /obj/random/mob/roaches
		if(INFESTATION_YITHIAN)
			unidentified = TRUE
			chosen_mob_types += /mob/living/simple_animal/yithian
		if(INFESTATION_TINDALOS)
			unidentified = TRUE
			chosen_mob_types += /mob/living/simple_animal/tindalos
		if(INFESTATION_SAMAK)
			unidentified = TRUE
			chosen_mob_types += /mob/living/simple_animal/hostile/samak
		if(INFESTATION_SHANTAK)
			unidentified = TRUE
			chosen_mob_types += /mob/living/simple_animal/hostile/shantak
		if(INFESTATION_DIYAAB)
			unidentified = TRUE
			chosen_mob_types += /mob/living/simple_animal/hostile/diyaab

	//Chance for identification to fail even for normal mobs, to frustrate metagamers
	if (prob(15))
		unidentified = TRUE

	//If unidentified is true, players are only told the location(s) and not any useful information
	//about what is there.
	if (unidentified)
		event_name = "Unidentified Lifeforms"
		chosen_mob = "[pick("unidentified", "unknown", "unrecognised", "indeterminate")] [pick("creatures","lifeforms","critters","aliens","biosignatures", "organics")]"
		chosen_verb = pick("have been detected in", "have boarded the ship at", "are currently infesting", "are currently rampaging in")

/datum/event/infestation/proc/spawn_mobs()
	for (var/area/A in chosen_areas)
		for(var/i = 1, i <= num_spawns_per_area,i++)
			var/spawned_mob = pickweight(chosen_mob_types)
			new spawned_mob(A.random_space())

/datum/event/infestation/announce()
	switch(severity)
		if (EVENT_LEVEL_MUNDANE)
			command_announcement.Announce("Bioscans indicate that [chosen_mob] [chosen_verb] [chosen_areas[1]]. Clear them out before this starts to affect productivity.", event_name, new_sound = 'sound/AI/vermin.ogg')
		if (EVENT_LEVEL_MODERATE)
			command_announcement.Announce("Bioscans indicate that [chosen_mob] [chosen_verb] [chosen_areas[1]] and [chosen_areas[2]]. Ironhammer are advised to approach with caution.", event_name, new_sound = 'sound/AI/vermin.ogg')
		if (EVENT_LEVEL_MAJOR)
			command_announcement.Announce("Shipwide Alert: Bioscans indicate that [chosen_mob] [chosen_verb] [chosen_areas[1]],[chosen_areas[2]] and [chosen_areas[3]]. Crew are advised to evacuate those areas immediately.", event_name, new_sound = 'sound/AI/vermin.ogg')
