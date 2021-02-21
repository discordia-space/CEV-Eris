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

/datum/objective/timed/excelsior
	var/detect_timer = 60 MINUTES
	var/active = FALSE
	var/convert_decrease = 8 MINUTES
	var/mandate_increase = 12 MINUTES

/datum/objective/timed/excelsior/New()
	..()
	explanation_text = "Expand and grow in power before the ship's systems detect your presence! The detection countdown of [time2hours(detect_timer)] Hour starts once you force-implant a new comrade. It is lowered by [time2minutes(convert_decrease)] Minutes for each additional recruit, and increased by [time2minutes(mandate_increase)] Minutes for each completed mandate"

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
	detect_timer += mandate_increase
