/datum/antagonist/proc/create_objectives()
	return 1

/datum/antagonist/proc/set_objectives(var/list/new_objectives)
	if(!owner)
		return

	objectives = new_objectives
