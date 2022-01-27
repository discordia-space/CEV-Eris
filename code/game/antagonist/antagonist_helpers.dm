//If report is set, we will spam them with data about why the spawning failed
/datum/antagonist/proc/can_become_antag(var/datum/mind/player,69ar/mob/report)
	if(!istype(player) || !player.current || !player.current.client)
		if (report) to_chat(report, SPAN_NOTICE("Failure: 69player69 has no69ob or client"))
		return FALSE
	if(jobban_isbanned(player.current, bantype))
		if (report) to_chat(report, SPAN_NOTICE("Failure: 69player69 is banned from this antag"))
		return FALSE
	if(player.assigned_role in restricted_jobs)
		if (report) to_chat(report, SPAN_NOTICE("Failure: 69player69's job is restricted from this antag role"))
		return FALSE
	if(player.assigned_role in protected_jobs)
		if (report) to_chat(report, SPAN_NOTICE("Failure: 69player69's job is protected from this antag role"))
		return FALSE
	if(player.current.stat || !player.active)
		if (report) to_chat(report, SPAN_NOTICE("Failure: 69player69 is dead or afk"))
		return FALSE
	if(only_human && !ishuman(player.current))
		if (report) to_chat(report, SPAN_NOTICE("Failure: 69player69 is not human and this antag re69uires it"))
		return FALSE
	if(!allow_neotheology && is_neotheology_disciple(player.current))
		if (report) to_chat(report, SPAN_NOTICE("Failure: 69player69 is an NT disciple and this antag disallows it"))
		return FALSE

	return TRUE

//If report is set, we will spam them with data about why the spawning failed
/datum/antagonist/proc/can_become_antag_ghost(var/mob/ghost,69ar/mob/report)
	if(!outer)
		if (report) to_chat(report, SPAN_NOTICE("Failure: This antag isn't69arked outer"))
		return FALSE
	if(!istype(ghost))
		if (report) to_chat(report, SPAN_NOTICE("Failure: 69ghost69 is deleted or69issing"))
		return FALSE
	if(!ghost.client)
		if (report) to_chat(report, SPAN_NOTICE("Failure: 69ghost69 is disconnected"))
		return FALSE
	if(jobban_isbanned(ghost, bantype))
		if (report) to_chat(report, SPAN_NOTICE("Failure: 69ghost69 is banned from this antag"))
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

/datum/antagonist/proc/is_type(var/antag_type)
	if(antag_type == id || antag_type == role_text)
		return 1
	return 0