/datum/objective/debrain

/datum/objective/debrain/get_panel_entry()
	var/target = src.target ? "[src.target.current.real_name], the [src.target.assigned_role]" : "no_target"
	return "Steal the brain of <a href='?src=\ref[src];switch_target=1'>[target]</a>."

/datum/objective/debrain/update_explanation()
	if(target && target.current)
		explanation_text = "Steal the brain of [target.current.real_name]."
	else
		explanation_text = "Target has not arrived today. Did he know that I would come?"

/datum/objective/debrain/check_completion()
	if (failed)
		return FALSE
	if(!target) //If it's a free objective.
		return TRUE
	if(owner && (!owner.current || owner.current.stat == DEAD))//If you're otherwise dead.
		return FALSE
	if(!target.current || !isbrain(target.current))
		return FALSE
	var/atom/A = target.current
	var/list/contents = get_owner_inventory()
	if ((A in contents))
		return TRUE
	return FALSE
