var/list/event_last_fired = list()

// Returns how many characters are currently active(not logged out, not AFK for more than 10 minutes)
// with a specific role.
// Note that this isn't sorted by department, because e.g. having a roboticist shouldn't make meteors spawn.
/proc/number_active_with_role()
	var/list/active_with_role = list()
	active_with_role["Engineer"] = 0
	active_with_role["Medical"] = 0
	active_with_role["Security"] = 0
	active_with_role["Scientist"] = 0
	active_with_role["AI"] = 0
	active_with_role["Cyborg"] = 0
	active_with_role["Janitor"] = 0
	active_with_role["Gardener"] = 0

	for(var/mob/M in player_list)
		// longer than 10 minutes AFK counts them as inactive
		if(!M.mind || !M.client || M.client.is_afk(10 MINUTES))
			continue

		active_with_role["Any"]++

		if(isrobot(M))
			var/mob/living/silicon/robot/R = M
			if(R.module)
				if(istype(R.module, /obj/item/weapon/robot_module/engineering))
					active_with_role["Engineer"]++
				else if(istype(R.module, /obj/item/weapon/robot_module/security))
					active_with_role["Security"]++
				else if(istype(R.module, /obj/item/weapon/robot_module/medical))
					active_with_role["Medical"]++
				else if(istype(R.module, /obj/item/weapon/robot_module/research))
					active_with_role["Scientist"]++

		if(M.mind.assigned_role in engineering_positions)
			active_with_role["Engineer"]++

		if(M.mind.assigned_role in medical_positions)
			active_with_role["Medical"]++

		if(M.mind.assigned_role in security_positions)
			active_with_role["Security"]++

		if(M.mind.assigned_role in science_positions)
			active_with_role["Scientist"]++

		if(M.mind.assigned_role == "AI")
			active_with_role["AI"]++

		if(M.mind.assigned_role == "Cyborg")
			active_with_role["Cyborg"]++

		if(M.mind.assigned_role == "Janitor")
			active_with_role["Janitor"]++

		if(M.mind.assigned_role == "Gardener")
			active_with_role["Gardener"]++

	return active_with_role
