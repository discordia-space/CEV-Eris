/datum/objective/escape
	explanation_text = "Escape on the shuttle or an escape pod alive and free."


/datum/objective/escape/check_completion()
	if(issilicon(owner.current))
		return FALSE
	if(isbrain(owner.current))
		return FALSE
	if(!evacuation_controller.has_evacuated())
		return FALSE
	if(!owner.current || owner.current.stat == 2)
		return FALSE
	var/turf/location = get_area(owner.current)
	if(!location)
		return FALSE
	if(istype(location, /area/shuttle/escape_pod1/centcom) || istype(location, /area/shuttle/escape_pod2/centcom))
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			if(!H.handcuffed)
				return TRUE
	return FALSE
