/datum/antagonist/proc/can_become_antag(var/datum/mind/player)
	if(!player.current || !player.current.client)
		return FALSE
	if(jobban_isbanned(player.current, bantype))
		return FALSE
	if(player.assigned_role in restricted_jobs)
		return FALSE
	if(config.protect_roles_from_antagonist && (player.assigned_role in protected_jobs))
		return FALSE
	if(outer && !player.active)
		return FALSE
	if(!outer && (player.current.stat || !player.active))
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

/datum/antagonist/proc/get_vents()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in config.station_levels)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent
	return vents
