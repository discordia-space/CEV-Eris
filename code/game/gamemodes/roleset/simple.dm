/datum/storyevent/roleset/borer
	id = "borer"
	role_id = ROLE_BORER

	weight = 0.5

	req_crew = 15


/datum/storyevent/roleset/traitor
	id = "traitor"
	role_id = ROLE_TRAITOR

	weight = 1

/datum/storyevent/roleset/inquisitor
	id = "inquisitor"
	role_id = ROLE_INQUISITOR
	weight = 0.2
	req_crew = 7

/datum/storyevent/roleset/inquisitor/get_special_weight(var/new_weight)
	/*var/c_count = 0
	for(var/mob/M in christians)
		if(M.client &&  M.stat != DEAD && ishuman(M))
			c_count++

	var/maxc = (c_count > 7) ? c_count : 7
	new_weight *= weight_mult(weight,maxc,0,maxc)

	return new_weight*/

/datum/storyevent/roleset/malf
	id = "malf"
	role_id = ROLE_MALFUNCTION

	req_crew = 15


/datum/storyevent/roleset/marshal
	id = "marshal"
	role_id = ROLE_MARSHAL
	req_crew = 20

/datum/storyevent/roleset/marshal/get_special_weight(var/new_weight)
	var/a_count = 0
	for(var/datum/antagonist/A in current_antags)
		if(A.owner && A.is_active() && !A.is_dead())
			a_count++

	var/maxc = (a_count > 3) ? a_count : 3
	new_weight *= weight_mult(weight,maxc,0,maxc)

	return new_weight

/datum/storyevent/roleset/changeling
	id = "changeling"
	role_id = ROLE_CHANGELING

	req_crew = 7

