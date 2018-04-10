/datum/storyevent/roleset/double_agents
	id = "double_agents"
	role_id = null
	multispawn = TRUE

	min_cost = 14
	max_cost = 22

	req_crew = 10
	req_heads = -1
	req_sec = 2
	req_eng = -1
	req_med = -1
	req_sci = -1

	spawn_times_max = 2

/datum/storyevent/roleset/double_agents/spawn_event()
	var/list/candidates = candidates_list(ROLE_TRAITOR)
	if(candidates.len < 2)
		return FALSE

	var/datum/mind/first = pick(candidates)
	candidates.Remove(first)
	var/datum/mind/second = pick(candidates)

	var/datum/antagonist/a1 = get_antag_instance(ROLE_TRAITOR)
	var/datum/antagonist/a2 = get_antag_instance(ROLE_TRAITOR)

	a1.create_antagonist(first, announce = FALSE)
	a2.create_antagonist(second, announce = FALSE)

	create_objectives(a1,a2)

	return TRUE

/datum/storyevent/roleset/double_agents/create_objectives(var/datum/antagonist/A, var/datum/antagonist/B)
	var/datum/objective/assassinate/O = new(A)
	O.set_target(B.owner)
	A.objectives.Add(O)

	O = new(B)
	O.set_target(A.owner)
	B.objectives.Add(O)

	A.create_survive_objective()
	B.create_survive_objective()

	A.greet()
	B.greet()
