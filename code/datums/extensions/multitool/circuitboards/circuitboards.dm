/datum/extension/multitool/circuitboards/extension_status(var/mob/user)
	if(isAI(user)) // No remote AI access
		return UI_CLOSE

	return ..()
