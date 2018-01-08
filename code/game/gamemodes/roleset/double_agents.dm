/datum/roleset/double_agents
	id = "double_agents"
	role_id = null

/datum/roleset/double_agents/spawn_roleset()
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

	var/datum/objective/assassinate/O = new (a1)
	O.target = second.current
	O.update_explanation()

	new/datum/objective/escape(a1)

	O = new (a2)
	O.target = first.current
	O.update_explanation()

	new/datum/objective/escape(a2)

	return TRUE

/datum/roleset/double_agents/create_objectives(var/datum/antagonist/A)

