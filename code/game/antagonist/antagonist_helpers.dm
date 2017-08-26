/datum/antagonist/proc/can_become_antag(var/datum/mind/player)
	if(player.current && jobban_isbanned(player, bantype))
		return FALSE
	if(player.assigned_role in restricted_jobs)
		return FALSE
	if(config.protect_roles_from_antagonist && (player.assigned_role in protected_jobs))
		return FALSE
	return TRUE

/datum/antagonis/proc/isouter()
	return istype(src, /datum/antagonist/outer)

/datum/antagonist/proc/is_dead()
	if(!owner || !owner.current || owner.current.stat == DEAD || !ishuman(owner.current))
		return TRUE
	return FALSE

/datum/antagonist/proc/is_active()
	if(is_dead())
		return FALSE
	if(!owner.current.client && !owner.current.teleop)
		return FALSE
	return TRUE

