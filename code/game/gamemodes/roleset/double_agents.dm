/datum/storyevent/roleset/double_agents
	id = "double_agents"
	name = "double agents"
	role_id = ROLE_TRAITOR
	base_quantity = 2
	scaling_threshold = 0
	/*
	req_crew = 10
	req_heads = -1
	req_sec = 2
	req_eng = -1
	req_med = -1
	req_sci = -1

	trigger_times_max = 2
	*/

/datum/storyevent/roleset/double_agents/trigger_event()
	var/list/candidates = candidates_list(ROLE_TRAITOR)
	if(candidates.len < 2)
		return FALSE

	var/datum/mind/first = pick(candidates)
	candidates.Remove(first)
	var/datum/mind/second = pick(candidates)

	var/datum/antagonist/a1 = create_antag_instance(ROLE_TRAITOR)
	var/datum/antagonist/a2 = create_antag_instance(ROLE_TRAITOR)

	a1.create_antagonist(first, announce = FALSE)
	a2.create_antagonist(second, announce = FALSE)

	create_objectives(a1,a2)

	return TRUE

/datum/storyevent/roleset/double_agents/create_objectives(var/datum/antagonist/A, var/datum/antagonist/B)
	var/datum/objective/assassinate/O = new(A)
	O.set_target(B.owner)

	O = new(B)
	O.set_target(A.owner)

	A.create_survive_objective()
	B.create_survive_objective()

	A.greet()
	B.greet()
