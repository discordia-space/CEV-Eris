/datum/storyevent/roleset/faction/dcrew
	id = "dcrew"
	name = "derelict crew member"
	role_id = ROLE_DCREW
	weight = 0.4
	ocurrences_max = 1
	req_crew = 5
	
	//Until we code some way to reset the bases, can't allow this to happen more than once per round

	base_quantity = 2
	scaling_threshold = 5

	leaders = 1

	faction_id = FACTION_DCREW
	faction_type = /datum/faction/dcrew
