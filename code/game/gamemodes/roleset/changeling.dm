/datum/roleset/changeling
	roles = list(ROLE_CHANGELING = 1)

/datum/roleset/changeling/spawn_roleset()
	var/datum/mind/M = safepick(candidates_list(ROLE_CHANGELING))
	if(!M)
		return FALSE

	make_antagonist(M,ROLE_CHANGELING)
	log_roleset("[M.name] was choosen for the changeling role and was succesfully antagonized.")
	return TRUE