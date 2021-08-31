/*
Nests of blue space crystals are spawned across the ship, mostly in maints.
They can be harvested for one use crystals that can be used for random teleportation.
Additionally, not harvested nest will periodically teleport items and people to it.
*/


/datum/storyevent/bluespace_crystal_infestation
	id = "bluespace_crystal_infestation"
	name = "bluespace_crystal_infestation"

	weight = 1

	event_type = /datum/event/bluespace_crystal_infestation
	event_pools = list(
		EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE * 1.2
	)
	tags = list(TAG_POSITIVE)


/datum/event/bluespace_crystal_infestation
	var/area/event_area

/datum/event/bluespace_crystal_infestation/setup()
	var/list/candidates = all_areas.Copy()
	var/area/candidate
	if(!prob(10))  // 10% chance not to spawn in maints.
		for(candidate in candidates)
			if(!candidate.is_maintenance)
				candidates -= candidate
	event_area = pick(candidates)

/datum/event/bluespace_crystal_infestation/start()
	var/space_to_spawn = event_area.random_space()
	log_and_message_admins("Bluespace nest spawned: [jumplink(space_to_spawn)]")
	var/obj/structure/bs_crystal_structure/BSCS = new (space_to_spawn)
	BSCS.entropy_value += 2//8 + 2 = 10
	GLOB.bluespace_entropy += rand(BSCS.entropy_value, BSCS.entropy_value * 3)
