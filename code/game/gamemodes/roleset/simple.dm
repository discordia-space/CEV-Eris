/datum/storyevent/roleset/borer
	id = "borer"
	role_id = ROLE_BORER

	min_cost = 10
	max_cost = 18

	req_crew = 15
	req_heads = -1
	req_sec = 2
	req_eng = -1
	req_med = 4
	req_sci = -1
	req_stage = -1

	spawn_times_max = 1

/datum/storyevent/roleset/traitor
	id = "traitor"
	role_id = ROLE_TRAITOR
	multispawn = TRUE

	min_cost = 5
	max_cost = 10

	req_crew = 7
	req_heads = -1
	req_sec = 3
	req_eng = -1
	req_med = 1
	req_sci = -1
	req_stage = -1

	spawn_times_max = 7

/datum/storyevent/roleset/inquisitor
	id = "inquisitor"
	role_id = ROLE_INQUISITOR
	multispawn = TRUE

	min_cost = 5
	max_cost = 10

	req_crew = 7
	req_heads = -1
	req_sec = 3
	req_eng = -1
	req_med = -1
	req_sci = -1

	spawn_times_max = 3

/datum/storyevent/roleset/inquisitor/get_special_weight(var/weight)
	var/c_count = 0
	for(var/mob/M in christians)
		if(M.client &&  M.stat != DEAD && ishuman(M))
			c_count++

	var/maxc = (c_count > 7) ? c_count : 7
	weight *= weight_mult(weight,maxc,0,maxc)

	return weight

/datum/storyevent/roleset/malf
	id = "malf"
	role_id = ROLE_MALFUNCTION

	min_cost = 15
	max_cost = 30

	req_crew = 15
	req_heads = 2
	req_sec = 3
	req_eng = 5
	req_med = -1
	req_sci = -1

	spawn_times_max = 1

/datum/storyevent/roleset/marshal
	id = "marshal"
	role_id = ROLE_MARSHAL
	multispawn = TRUE

	min_cost = 5
	max_cost = 10

	req_crew = 7
	req_heads = -1
	req_sec = 6
	req_eng = -1
	req_med = -1
	req_sci = -1

	spawn_times_max = 4

/datum/storyevent/roleset/marshal/get_special_weight(var/weight)
	var/a_count = 0
	for(var/datum/antagonist/A in current_antags)
		if(A.owner && A.is_active() && !A.is_dead())
			a_count++

	var/maxc = (a_count > 3) ? a_count : 3
	weight *= weight_mult(weight,maxc,0,maxc)

	return weight

/datum/storyevent/roleset/changeling
	id = "changeling"
	role_id = ROLE_CHANGELING
	multispawn = TRUE

	min_cost = 6
	max_cost = 10

	req_crew = 7
	req_heads = -1
	req_sec = 4
	req_eng = -1
	req_med = 2
	req_sci = -1
	req_stage = -1

	spawn_times_max = 4
