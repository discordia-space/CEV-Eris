/datum/roleset/borer
	roles = list(ROLE_BORER = 1)

/datum/roleset/borer/spawn_roleset()
	var/mob/M = safepick(ghost_candidates_list(ROLE_BORER))
	if(!M)
		return FALSE

	log_roleset("[M.name] was choosen for the cortical borer role and was succesfully antagonized.")
	make_antagonist_ghost(M,ROLE_BORER)
	return TRUE