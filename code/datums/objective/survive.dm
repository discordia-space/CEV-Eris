/datum/objective/survive
	explanation_text = "Stay alive until the end."

/datum/objective/survive/check_completion()
	if(!owner.current || owner.current.stat == DEAD || isbrain(owner.current))
		return FALSE
	if(issilicon(owner.current) && owner.current != owner.original)
		return FALSE
	return TRUE


/datum/objective/survive/merc
	explanation_text = "Return to your ship and withdraw to base within 90 minutes of being detected."

/datum/objective/survive/merc/check_completion()
	var/datum/shuttle/autodock/multi/antag/mercenary/MS = SSshuttle.get_shuttle("Mercenary")

	if (!MS)
		//Shuttle was destroyed?
		return FALSE


	if (MS.current_location != MS.home_waypoint)
		//The shuttle is not back at home base, fail
		return FALSE

	return TRUE