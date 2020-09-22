/datum/storyevent/roleset/faction/dcrew
	id = "dcrew"
	name = "dcrew"
	role_id = ROLE_DCREW
	weight = 0.4
	ocurrences_max = 1
	req_crew = 5
	
	//Until we code some way to reset the bases, can't allow this to happen more than once per round

	base_quantity = 5   //let some people have fun.. only 2 ghosts is not enough for a pacific role
	scaling_threshold = 10

	leaders = 2

	faction_id = FACTION_DCREW
	faction_type = /datum/faction/dcrew
