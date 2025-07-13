//If report is set, we will spam them with data about why the spawning failed
/datum/antagonist/proc/can_become_antag(datum/mind/player, mob/report)
	if(!istype(player) || !player.current || !player.current.client)
		if (report) to_chat(report, span_notice("Failure: [player] has no mob or client"))
		return FALSE
	if(jobban_isbanned(player.current, bantype))
		if (report) to_chat(report, span_notice("Failure: [player] is banned from this antag"))
		return FALSE
	if(player.assigned_role in restricted_jobs)
		if (report) to_chat(report, span_notice("Failure: [player]'s job is restricted from this antag role"))
		return FALSE
	if(player.assigned_role in protected_jobs)
		if (report) to_chat(report, span_notice("Failure: [player]'s job is protected from this antag role"))
		return FALSE
	if(player.current.stat || !player.active)
		if (report) to_chat(report, span_notice("Failure: [player] is dead or afk"))
		return FALSE
	if(only_human && !ishuman(player.current))
		if (report) to_chat(report, span_notice("Failure: [player] is not human and this antag requires it"))
		return FALSE
	if(!allow_neotheology && is_neotheology_disciple(player.current))
		if (report) to_chat(report, span_notice("Failure: [player] is an NT disciple and this antag disallows it"))
		return FALSE

	return TRUE

//If report is set, we will spam them with data about why the spawning failed
/datum/antagonist/proc/can_become_antag_ghost(mob/ghost, mob/report)
	if(!outer)
		if (report) to_chat(report, span_notice("Failure: This antag isn't marked outer"))
		return FALSE
	if(!istype(ghost))
		if (report) to_chat(report, span_notice("Failure: [ghost] is deleted or missing"))
		return FALSE
	if(!ghost.client)
		if (report) to_chat(report, span_notice("Failure: [ghost] is disconnected"))
		return FALSE
	if(jobban_isbanned(ghost, bantype))
		if (report) to_chat(report, span_notice("Failure: [ghost] is banned from this antag"))
		return FALSE

	return TRUE

/datum/antagonist/proc/is_dead()
	if(!owner || !owner.current || owner.current.stat == DEAD || !owner.active)
		return TRUE
	return FALSE

/datum/antagonist/proc/is_active()
	if(is_dead())
		return FALSE
	if(!owner.current.client && !owner.current.teleop)
		return FALSE
	return TRUE

/datum/antagonist/proc/is_type(antag_type)
	if(antag_type == id || antag_type == role_text)
		return 1
	return 0
