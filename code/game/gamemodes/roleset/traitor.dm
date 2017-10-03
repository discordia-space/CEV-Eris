/datum/roleset/traitor
	id = "traitor"
	roles = list(ROLE_TRAITOR = 1)

/datum/roleset/traitor/spawn_roleset()
	var/datum/mind/M = safepick(candidates_list(ROLE_TRAITOR))
	if(!M)
		return FALSE

	make_antagonist(M,ROLE_TRAITOR)
	log_roleset("[M.name] was choosen for the traitor role and was succesfully antagonized.")
	return TRUE


/datum/roleset/double_agents
	id = "double_agents"
	roles = list(ROLE_TRAITOR = 2)

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

	log_roleset("[first.name] and [second.name] were choosen for the double agents role and were succesfully antagonized.")
	return TRUE
