/datum/antagonist/proc/can_become_antag(var/datum/mind/player)
	if(!istype(player) || !player.current || !player.current.client)
		return FALSE
	if(jobban_isbanned(player.current, bantype))
		return FALSE
	if(player.assigned_role in restricted_jobs)
		return FALSE
	if(player.assigned_role in protected_jobs)
		return FALSE
	if(player.current.stat || !player.active)
		return FALSE
	if(!only_human || !ishuman(player.current))
		return FALSE

	return TRUE

/datum/antagonist/proc/can_become_antag_ghost(var/mob/ghost)
	if(!outer)
		return FALSE
	if(!istype(ghost))
		return FALSE
	if(!ghost.client)
		return FALSE
	if(jobban_isbanned(ghost, bantype))
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

