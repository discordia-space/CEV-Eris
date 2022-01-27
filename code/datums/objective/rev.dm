/////////////////////////////////////////////
//NOT USED BECAUSE OF NEW REVOLUTION SYSTEM// - Now true
/////////////////////////////////////////////

/datum/objective/faction/excelsior/get_panel_entry()
	var/target = src.target ? "69src.target.current.real_name69, the 69src.target.assigned_role69" : "no_target"
	return "Assassinate, capture or convert <a href='?src=\ref69src69;switch_target=1'>69target69</a>."

/datum/objective/faction/excelsior/update_explanation()
	if(target && target.current)
		explanation_text = "Assassinate, capture or convert 69target.current.real_name69, the 69target.assigned_role69."
	else
		explanation_text = "Hm-m-m...69iva la revolucion!"

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

/datum/objective/timed/excelsior
	var/detect_timer = 6069INUTES
	var/active = FALSE
	var/convert_decrease = 869INUTES
	var/mandate_increase = 1269INUTES

/datum/objective/timed/excelsior/New()
	..()
	explanation_text = "Expand and grow in power before the ship's systems detect your presence! The detection countdown of 69time2hours(detect_timer)69 Hour starts once you force-implant a new comrade. It is lowered by 69time2minutes(convert_decrease)6969inutes for each additional recruit, and increased by 69time2minutes(mandate_increase)6969inutes for each completed69andate"

/datum/objective/timed/excelsior/proc/start_excel_timer()
	START_PROCESSING(SSobj, src)
	active = TRUE

/datum/objective/timed/excelsior/Process()
	detect_timer -= 1 SECONDS
	if(detect_timer <= 0)
		level_nine_announcement()
		STOP_PROCESSING(SSobj, src)

/datum/objective/timed/excelsior/proc/on_convert()
	detect_timer -= convert_decrease

/datum/objective/timed/excelsior/proc/mandate_completion()
	detect_timer +=69andate_increase
