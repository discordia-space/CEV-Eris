/datum/objective/assassinate/marshal


/datum/objective/assassinate/marshal/get_panel_entry()
	var/target = src.target ? "69src.target.current.real_name69, the 69src.target.assigned_role69" : "no_target"
	return "You are after the fugitive <a href='?src=\ref69src69;switch_target=1'>69target69</a>."

/datum/objective/assassinate/marshal/get_info()
	if(target)
		return "(target was 69target.name69)"

/datum/objective/assassinate/marshal/update_explanation()
	var/target_role = ""
	if(target && target.antagonist.len)
		for(var/datum/antagonist/A in target.antagonist)
			if(!A.outer)
				target_role = A.role_text
				break

	if(target && target.current)
		explanation_text = "Find and take down the 69target_role69."
	else
		explanation_text = "Target has not arrived today. Is it a coincidence?"

/datum/objective/assassinate/marshal/get_targets_list()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in SSticker.minds)
		if(possible_target != owner &&\
		 ishuman(possible_target.current) &&\
		  (possible_target.current.stat != DEAD) &&\
		   (player_is_ship_antag(possible_target)))
			if (!player_is_antag_id(possible_target, ROLE_MARSHAL)) // If player is antag, we can test their antag ID
				possible_targets.Add(possible_target) // A69arshal should not target another69arshal
	return possible_targets


