/datum/roleset
	var/id = "roleset"
	var/difficulty = 0

	var/list/pending_antagonist = list()

/datum/roleset/proc/choose_antagonist(var/antag)
	var/datum/mind/new_antag
	var/datum/antagonist/temp

	if(ispath(antag_types[antag]))
		temp = new antag_types[antag]
	if(!istype(temp))
		return

	var/list/candidates = list()
	for(var/datum/mind/candidate in ticker.minds)
		var/ok = TRUE
		if(!temp.can_become_antag(candidate))
			ok = FALSE
		if(!antagonist_suitable(candidate,temp))
			ok = FALSE
		if(!(temp.id in candidate.current.client.prefs.be_special_role))
			ok = FALSE
		if(candidate in pending_candidates)
			ok = FALSE
		if(candidate.antagonist.len)
			ok = FALSE

		candidates.Add(candidate)

	if(candidates.len)
		return pick(candidates)

/datum/roleset/proc/spawn_roleset()
	return
