/datum/roleset/inquisitor
	id = "inquisitor"
	roles = list(ROLE_INQUISITOR = 1)

/datum/roleset/inquisitor/spawn_roleset()
	var/datum/mind/M = safepick(candidates_list(ROLE_INQUISITOR))
	if(!M)
		return FALSE

	make_antagonist(M,ROLE_INQUISITOR)
	log_roleset("[M.name] was choosen for the inquisitor role and was succesfully antagonized.")
	return TRUE