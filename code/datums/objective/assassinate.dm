/datum/objective/assassinate

/datum/objective/assassinate/get_panel_entry()
	var/dat = list(..())
	dat += "</br><a href='?src=\ref[src];switch_target=1'>Switch target</a>"
	return jointext(dat, null)

/datum/objective/assassinate/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["switch_target"])

/datum/objective/assassinate/find_target()
	..()
	if(target && target.current)
		explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/assassinate/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current) || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return TRUE
		return FALSE
	return TRUE

