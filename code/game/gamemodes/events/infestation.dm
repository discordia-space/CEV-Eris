/*
Infestation is the primary combat event. It has a broad pool of mobs, both hostile and peaceful,
Infestation spawns monsters via burrows, and relies on the burrow network to operate.
If players somehow manage to destroy every burrow on the ship, this event will be unable to spawn
It focuses on spawning large numbers of moderate-to-weak monsters, and includes some elements of surprise
*/
/datum/storyevent/infestation
	id = "infestation"
	name = "infestation"

	weight = 2
	//Since it's a large pool of content, infestation has twice the weight of other events

	event_type = /datum/event/infestation
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE*1.2,
	EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE*1.2,
	EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR*1.2)
	tags = list(TAG_COMBAT, TAG_DESTRUCTIVE, TAG_NEGATIVE)
//============================================


#define INFESTATION_MICE "mice"
#define INFESTATION_SPACE_BATS "bats"
#define INFESTATION_SPIDERLINGS "spiderlings"
#define INFESTATION_SPIDERS "spider"
#define INFESTATION_ROACHES "large insects"
#define INFESTATION_HIVEBOTS "ancient synthetics"
#define INFESTATION_SLIMES "slimes"

/datum/event/infestation
	startWhen = 1
	announceWhen = 10
	endWhen = 90
	var/num_areas = 1
	var/num_spawns_per_area
	var/list/obj/structure/burrow/chosen_burrows = list()
	var/failures //If we're unable to locate a suitable source or target burrow, increment this
	var/event_name = "Slime Leak"
	var/chosen_mob = INFESTATION_SLIMES
	var/chosen_verb = "have leaked into"
	var/infestation_time = 3 MINUTES
	var/list/chosen_mob_classification = list()
	var/list/possible_mobs_mundane = list(
		INFESTATION_MICE = 17,
		INFESTATION_SPIDERLINGS = 8,
	)

	var/possible_mobs_moderate = list(
		INFESTATION_SPACE_BATS = 10,
		INFESTATION_SPIDERS = 7,//This is a combination of spiderlings and adult spiders
		INFESTATION_ROACHES = 7
	)

	var/possible_mobs_major = list(
		INFESTATION_SPIDERS = 8,
		INFESTATION_HIVEBOTS = 6,
		INFESTATION_SLIMES = 5
	)

/datum/event/infestation/setup()
	announceWhen = rand(20,80) //Very large random window for announcement,
	num_areas = 2
	switch(severity)
		if (EVENT_LEVEL_MODERATE)
			num_areas = 3
		if (EVENT_LEVEL_MAJOR)
			num_areas = 4
	choose_area()
	choose_mobs()

/datum/event/infestation/start()
	spawn_mobs()

//Upon ending, if we had any failures, refund some points to the storyteller
//A set of mobs that failed to spawn due to not finding burrows is fully refunded
//Mobs that were spawned but never emerged because players destroyed the burrows, are only refunded 50%
/datum/event/infestation/end()
	if (failures)
		storyevent.cancel(severity, 1 - (failures / num_areas))



//We'll do a tick to watch the burrows and make sure everything is going as planned
/datum/event/infestation/tick()
	for (var/obj/structure/burrow/B in chosen_burrows)
		if (QDELETED(B) || QDELETED(chosen_burrows[B]))
			//One or both burrows was destroyed during sending!
			//This probably means someone destroyed it and this act should be rewarded
			failures += 0.5 //We increment failures by half a point, so some of the points will be refunded
			if (B)
				for (var/mob/M in B.sending_mobs)
					qdel(M) //We delete the mobs we were going to send, they won't come anymore

			continue

		//If both burrows are still there, then things are progressing fine





/datum/event/infestation/proc/choose_area()
	//For each area we plan to spawn in, we need both an origin and a destination burrow
	failures = 0
	chosen_burrows = list()
	for (var/i = 0; i < num_areas;i++)
		//The origin must be in maintenance somewhere
		var/obj/structure/burrow/origin = SSmigration.choose_burrow_target(null, TRUE, 100)

		//And the destination must be in crew living areas. Not maintenance
		var/obj/structure/burrow/destination = SSmigration.choose_burrow_target(null, FALSE, 100)
		if (!origin || !destination)
			//If we failed to find either burrow, then this spawn fails
			failures++
			continue

		//As long as we've got both, add em to the lists
		chosen_burrows[origin] = destination

/datum/event/infestation/proc/choose_mobs()

	var/unidentified = FALSE
	switch (severity)
		if (EVENT_LEVEL_MUNDANE)
			chosen_mob = pick(possible_mobs_mundane)
			num_spawns_per_area = possible_mobs_mundane[chosen_mob]
		if (EVENT_LEVEL_MODERATE)
			chosen_mob = pick(possible_mobs_moderate)
			num_spawns_per_area = possible_mobs_moderate[chosen_mob]
		if (EVENT_LEVEL_MAJOR)
			chosen_mob = pick(possible_mobs_major)
			num_spawns_per_area = possible_mobs_major[chosen_mob]
	num_spawns_per_area *= RAND_DECIMAL(0.75, 1.5)
	num_spawns_per_area = round(num_spawns_per_area, 1)

	switch(chosen_mob)
		if(INFESTATION_HIVEBOTS)
			event_name = "Minor Hivebot Invasion"
			chosen_verb = "have invaded"
			chosen_mob_classification += /mob/living/simple_animal/hostile/hivebot
			chosen_mob_classification += /mob/living/simple_animal/hostile/hivebot/range
		if(INFESTATION_SPACE_BATS)
			event_name = "Bat Roost"
			chosen_verb = "have been roosting in"
			chosen_mob_classification += /mob/living/simple_animal/hostile/scarybat
		if(INFESTATION_MICE)
			event_name = "Mouse Nest"
			chosen_verb = "have been breeding in"
			chosen_mob_classification += /mob/living/simple_animal/mouse //Mice pick random colors on spawn
		if(INFESTATION_SLIMES)
			event_name = "Slime Leak"
			chosen_verb = "have leaked into"
			chosen_mob_classification += /obj/spawner/mob/slime/rainbow
		if(INFESTATION_SPIDERLINGS)
			event_name = "Spiderling Infestation"
			chosen_verb = "have burrowed into"
			chosen_mob_classification[/obj/effect/spider/spiderling] = 1
			chosen_mob_classification[/obj/effect/spider/eggcluster] = 0.2
		if(INFESTATION_SPIDERS)
			event_name = "Spider Infestation"
			chosen_verb = "have burrowed into"
			chosen_mob_classification += /obj/spawner/mob/spiders
		if(INFESTATION_ROACHES)
			event_name = "Giant Roach Infestation"
			chosen_verb = "have burrowed into"
			chosen_mob_classification += /obj/spawner/mob/roaches

	//Chance for identification to fail even for normal mobs, to frustrate metagamers
	if (prob(15))
		unidentified = TRUE

	//If unidentified is true, players are only told the location(s) and not any useful information
	//about what is there.
	if (unidentified)
		event_name = "Unidentified Lifeforms"
		chosen_mob = "[pick("unidentified", "unknown", "unrecognised", "indeterminate")] [pick("creatures","lifeforms","critters","biosignatures", "organics")]"
		chosen_verb = pick("have been detected in", "have boarded the ship at", "are currently infesting", "are currently rampaging in")

//We spawn a set of mobs inside each origin burrow
/datum/event/infestation/proc/spawn_mobs()
	for (var/obj/structure/burrow/B in chosen_burrows)
		for(var/i = 1, i <= num_spawns_per_area,i++)
			var/spawned_mob = pickweight(chosen_mob_classification)
			new spawned_mob(B)

		//Send the migration
		B.migrate_to(chosen_burrows[B], infestation_time, 0)
		log_and_message_admins("Infestation [event_name] sending mobs to [jumplink(chosen_burrows[B])]")




/datum/event/infestation/announce()
	//Occasional chance to play the same generic announcement as spiders and carp
	//Just to screw with the metagamers even more
	if (prob(8))
		command_announcement.Announce("Unidentified lifesigns detected coming aboard [station_name]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')
	else
		var/list/areanames = list()
		for (var/b in chosen_burrows)
			var/obj/structure/burrow/B = chosen_burrows[b]
			if (QDELETED(B))
				continue
			var/area/A = get_area(B)
			areanames += strip_improper(A.name)
		if (areanames.len)
			switch(severity)
				if (EVENT_LEVEL_MUNDANE)
					command_announcement.Announce("Bioscans indicate that [chosen_mob] [chosen_verb] [english_list(areanames)]. Clear them out before this starts to affect productivity.", event_name, new_sound = 'sound/AI/vermin.ogg')
				if (EVENT_LEVEL_MODERATE)
					command_announcement.Announce("Bioscans indicate that [chosen_mob] [chosen_verb] [english_list(areanames)]. Ironhammer are advised to approach with caution.", event_name, new_sound = 'sound/AI/vermin.ogg')
				if (EVENT_LEVEL_MAJOR)
					command_announcement.Announce("Shipwide Alert: Bioscans indicate that [chosen_mob] [chosen_verb] [english_list(areanames)]. Crew are advised to evacuate those areas immediately.", event_name, new_sound = 'sound/AI/vermin.ogg')
