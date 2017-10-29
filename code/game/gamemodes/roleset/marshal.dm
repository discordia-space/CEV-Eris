/datum/roleset/marshal
	id = "marshal"
	roles = list(ROLE_MASRHAL = 1)

/datum/roleset/marshal/can_spawn()
	for(var/datum/antagonist/A in current_antags)
		if(!A.outer)
			return TRUE
	return FALSE

/datum/roleset/marshal/spawn_roleset()
	var/datum/mind/M = safepick(candidates_list(ROLE_MARSHAL))
	if(!M)
		return FALSE

	make_antagonist(M,ROLE_MARSHAL)
	log_roleset("[M.name] was choosen for the marshal role and was succesfully antagonized.")
	return TRUE
