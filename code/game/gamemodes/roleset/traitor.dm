/datum/roleset/traitor
	id = ROLESET_TRAITOR
	difficulty = 1

/datum/roleset/traitor/can_spawn()
	return get_candidates_count(ROLE_TRAITOR) >= 1

/datum/roleset/traitor/spawn_roleset()
	var/datum/mind/M = choose_candidate(ROLE_TRAITOR)
	if(!M)
		log_roleset("Traitor roleset spawn failed: can't find candidate.")
		return
	make_antagonist(M,ROLE_TRAITOR)
	log_roleset("[M.name] was choosen for the traitor role and was succesfully antagonized.")


/datum/roleset/double_agents
	id = ROLESET_VERSUS_TRAITOR
	difficulty = 2

/datum/roleset/double_agents/can_spawn()
	return get_candidates_count(ROLE_TRAITOR) >= 2

/datum/roleset/double_agents/spawn_roleset()
	var/datum/mind/first = choose_candidate(ROLE_TRAITOR)
	if(!first)
		log_roleset("Double agents roleset spawn failed: can't find candidates.")
		return FALSE

	pending_candidates.Add(first)

	var/datum/mind/second = choose_candidate(ROLE_TRAITOR)
	if(!second)
		log_roleset("Double agents roleset spawn failed: can't find second candidate.")
		return FALSE

	pending_candidates.Cut()

	var/datum/antagonist/a1 = get_antag_instance(ROLE_TRAITOR)
	var/datum/antagonist/a2 = get_antag_instance(ROLE_TRAITOR)

	a1.owner = first
	a2.owner = second

	var/datum/objective/assassinate/O = new (a1)
	O.target = second.current
	O.update_explanation()

	new/datum/objective/escape(a1)

	O = new (a2)
	O.target = first.current
	O.update_explanation()

	new/datum/objective/escape(a2)

	a1.create_antagonist(first)
	a2.create_antagonist(second)

	log_roleset("[first.name] and [second.name] were choosen for the double agents role and were succesfully antagonized.")
