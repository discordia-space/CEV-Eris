/datum/objective/baptize

/datum/objective/baptize/get_panel_entry()
	var/target = src.target ? "69src.target.current.real_name69, the 69src.target.assigned_role69" : "no_target"
	return "Baptize <a href='?src=\ref69src69;switch_target=1'>69target69</a>."

/datum/objective/baptize/update_explanation()
	if(target && target.current)
		explanation_text = "Baptize 69target.current.real_name69, the 69target.assigned_role69."
	else
		explanation_text = "Target has not arrived today. Is it a coincidence?"

/datum/objective/baptize/update_completion()
	if (failed)
		return FALSE

	if(!completed || target && target.current)
		if(target.current in disciples)
			completed = TRUE

/datum/objective/baptize/get_targets_list()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in SSticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != 2) && \
 		!possible_target.current.get_core_implant(/obj/item/implant/core_implant/cruciform))
			possible_targets.Add(possible_target)
	return possible_targets

