/datum/storyevent/roleset/faction/excelsior
	id = "excelsior"
	name = "excelsior"
	role_id = ROLE_EXCELSIOR_REV
	faction_id = FACTION_EXCELSIOR
	faction_type = /datum/faction/excelsior
	//min_cost = 10
	//max_cost = 20

	min_quantity = 3	// Don't fire unless we have at least 3 candidates in the pool
	base_quantity = 3 //They're a group antag, we want a few of em
	scaling_threshold = 8

	req_crew = 6
	leaders = -1 //Every excelsior spawned directly is a leader. Non leaders are those recruited during gameplay