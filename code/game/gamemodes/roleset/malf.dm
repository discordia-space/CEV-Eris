/datum/roleset/malf
	roles = list(ROLE_MALFUNCTION = 1)

/datum/roleset/malf/spawn_roleset()
	var/datum/mind/M = safepick(candidates_list(ROLE_MALFUNCTION))
	if(!M)
		return FALSE

	make_antagonist(M,ROLE_MALFUNCTION)
	log_roleset("[M.name] was choosen for the malf role and was succesfully antagonized.")
	return TRUE