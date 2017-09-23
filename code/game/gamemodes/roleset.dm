/datum/roleset
	var/id = "roleset"
	var/difficulty = 0

	var/list/pending_candidates = list()	//Buffer for resolving conflicts while choosing several roles


/datum/roleset/proc/spawn_allowed()	//Is this roleset suitable to spawn in this situation?
	return TRUE

/datum/roleset/proc/can_spawn()		//Is there enough candidates for this roleset and spawn won't cause any conflicts?
	return TRUE

/datum/roleset/proc/antagonist_suitable(var/datum/mind/player, var/datum/antagonist/antag)
	return TRUE

/datum/roleset/proc/get_candidates_count(var/a_type)	//For use for internal necessaries
	var/list/L = candidates_list(a_type)
	return L.len

/datum/roleset/proc/choose_candidate(var/antag)
	var/list/L = candidates_list(antag)
	if(L.len)
		return pick(L)

/datum/roleset/proc/candidates_list(var/antag, var/oneantag = TRUE)
	var/datum/antagonist/temp

	if(ispath(antag_types[antag]))
		temp = new antag_types[antag]
	if(!istype(temp))
		return

	var/list/candidates = list()
	for(var/datum/mind/candidate in ticker.minds)
		if(!candidate.current)
			continue
		if(!temp.can_become_antag(candidate))
			continue
		if(!antagonist_suitable(candidate,temp))
			continue
		if(!(temp.id in candidate.current.client.prefs.be_special_role))
			continue
		if(candidate in pending_candidates)
			continue
		if(oneantag && candidate.antagonist.len)
			continue

		candidates.Add(candidate)

	return candidates

/datum/roleset/proc/spawn_roleset()
	return


/datum/roleset/proc/log_roleset(var/text)
	log_admin("ROLESET: [text] \[STRT\]")
