/////////////////////////////////////////////
//NOT USED BECAUSE OF NEW REVOLUTION SYSTEM// - Now true
/////////////////////////////////////////////

/datum/objective/faction/excelsior/get_panel_entry()
	var/target = src.target ? "[src.target.current.real_name], the [src.target.assigned_role]" : "no_target"
	return "Assassinate, capture or convert <a href='?src=\ref[src];switch_target=1'>[target]</a>."

/datum/objective/faction/excelsior/update_explanation()
	if(target && target.current)
		explanation_text = "Assassinate, capture or convert [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Hm-m-m... Viva la revolucion!"

/datum/objective/faction/excelsior/check_completion()
	if (failed)
		return FALSE
	if(faction && target && target.current)
		var/mob/living/carbon/human/H = target.current
		if(!istype(H))
			return TRUE

		if(H.stat == DEAD)
			return TRUE
		// Check if they're converted
		if(player_is_antag_faction(target, ROLE_EXCELSIOR_REV, faction))
			return TRUE

		if(!isOnStationLevel(target.current) && !isOnAdminLevel(target.current))
			return TRUE

	if(!target)
		return TRUE

	return FALSE
