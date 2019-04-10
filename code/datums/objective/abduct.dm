//Objective to take a player alive, and get them off the ship. Presumably aboard your own ship/datum/objective/assassinate

/datum/objective/abduct/get_panel_entry()
	var/target = src.target ? "[src.target.current.real_name], the [src.target.assigned_role]" : "no_target"
	return "Capture <a href='?src=\ref[src];switch_target=1'>[target]</a> alive and take them away from the ship."

/datum/objective/abduct/update_explanation()
	if(target && target.current)
		explanation_text = "Capture [target.current.real_name], the [target.assigned_role], alive; and take them away from the ship."
	else
		explanation_text = "Target has not arrived today. Is it a coincidence?"

/datum/objective/abduct/check_completion()
	if (failed)
		return FALSE

	if(!target || !target.current)
		return FALSE

	if(target.current.stat == DEAD)
		return FALSE
	var/list/all_items = get_owner_inventory() //This will get atoms aboard the faction ship
	if (!(target.current in all_items))
		return FALSE
	return TRUE
