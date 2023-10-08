/datum/storyevent/roleset/faction/pirate
	id = "pirate"
	name = "pirates"
	role_id = ROLE_PIRATE
	weight = 0.4
	occurrences_max = 1
	req_crew = 5
	tags = list(TAG_DESTRUCTIVE, TAG_NEGATIVE)
	
	// Until we code some way to reset the pirate base, can't allow this to happen more than once per round

	min_quantity = 2	// Don't fire unless we have at least 2 candidates in the pool
	base_quantity = 2
	scaling_threshold = 5

	leaders = 1

	faction_id = FACTION_PIRATES
	faction_type = /datum/faction/pirate
