/datum/antagonist/proc/create_objectives(var/survive = FALSE)

	if(!possible_objectives || !possible_objectives.len)
		return
	world << "Antagonist creating its own objectives"
	for (var/i = 0; i < objective_quantity; i++)
		var/chosen_obj = pickweight(possible_objectives)

		if(!ispath(chosen_obj))
			log_debug("Error! \[/datum/antagonist/proc/create_objectives] \"[role_text]\" role's objectives are broken!")
			return

		new chosen_obj(src)

	if(survive)
		create_survive_objective()


// used only for factions antagonists
/datum/antagonist/proc/set_objectives(var/list/new_objectives)
	world << "antagonist recievin objectives"
	for (var/A in new_objectives)
		world << "\ref[A]"

	if(!owner || !owner.current)
		return

	if(objectives.len)
		owner.current << "<span class='danger'><font size=3>Your objectives were updated.</font></span>"

	objectives.Cut()
	objectives.Add(new_objectives)

	show_objectives()

/datum/antagonist/proc/create_survive_objective()
	if(ispath(survive_objective))
		new survive_objective(src)
