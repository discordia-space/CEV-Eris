/datum/antagonist/proc/create_objectives()
	return TRUE

/datum/antagonist/proc/set_objectives(var/list/new_objectives)

	objectives = new_objectives

	if(!owner || !owner.current)
		return

	owner.current << "<span class='danger'><font size=3>Your objectives were updated.</font></span>"
	show_objectives()
