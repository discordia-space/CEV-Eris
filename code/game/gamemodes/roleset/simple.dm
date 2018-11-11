/datum/storyevent/roleset/borer
	id = "borer"
	name = "cortical borers"
	role_id = ROLE_BORER
	weight = 0.4


	base_quantity = 2
	scaling_threshold = 15


/datum/storyevent/roleset/traitor
	id = "traitor"
	name = "traitor"
	role_id = ROLE_TRAITOR
	weight = 1.2
	scaling_threshold = 10

/datum/storyevent/roleset/inquisitor
	id = "inquisitor"
	name = "inquisitor"
	role_id = ROLE_INQUISITOR
	weight = 0.2
	req_crew = 10
	event_pools = list(EVENT_LEVEL_ROLESET = -30) //This is an antitag, it has a negative cost to allow more antags to exist

/datum/storyevent/roleset/inquisitor/get_special_weight(var/new_weight)
	var/c_count = 0
	for(var/mob/M in christians)
		if(M.client &&  M.stat != DEAD && ishuman(M))
			c_count++

	var/maxc = (c_count > 7) ? c_count : 7
	new_weight *= weight_mult(weight,maxc,0,maxc)

	return new_weight

/datum/storyevent/roleset/malf
	id = "malf"
	name = "malfunctioning AI"
	role_id = ROLE_MALFUNCTION
	req_crew = 15


/datum/storyevent/roleset/marshal
	id = "marshal"
	name = "marshal"
	role_id = ROLE_MARSHAL
	weight = 0.2
	req_crew = 10
	event_pools = list(EVENT_LEVEL_ROLESET = -30) //This is an antitag, it has a negative cost to allow more antags to exist

/datum/storyevent/roleset/marshal/get_special_weight(var/new_weight)
	var/a_count = 0
	for(var/datum/antagonist/A in current_antags)
		if(A.owner && A.is_active() && !A.is_dead())
			a_count++

	return new_weight * max(a_count, 1)


/datum/storyevent/roleset/changeling
	id = "changeling"
	name = "changeling"
	role_id = ROLE_CHANGELING

	base_quantity = 2
	scaling_threshold = 15
