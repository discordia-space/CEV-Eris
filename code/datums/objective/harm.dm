/datum/objective/harm
	var/last_harm_points = 0

/datum/objective/harm/get_panel_entry()
	var/target = src.target ? "69src.target.current.real_name69, the 69src.target.assigned_role69" : "no_target"
	return "Make an example of <a href='?src=\ref69src69;switch_target=1'>69target69</a>."

/datum/objective/harm/update_explanation()
	if(target && target.current)
		explanation_text = "Make an example of 69target.current.real_name69, the 69target.assigned_role69. Break one of their bones, detach one of their limbs or disfigure their face.69ake sure they're alive when you do it."
	else
		explanation_text = "Target has not arrived today. Did he know that I would come?"

/datum/objective/harm/get_info()
	return "(69last_harm_points69 injure points)"

/datum/objective/harm/update_completion()
	if (failed)
		return FALSE
	if(completed)
		return
	var/harm_points = 0

	if(target && target.current && ishuman(target.current))
		if(target.current.stat == DEAD)
			return

		var/mob/living/carbon/human/H = target.current
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_BROKEN)
				harm_points += 2

		for(var/limb_tag in H.species.has_limbs) //todo check prefs for robotic limbs and amputations.
			var/list/organ_data = H.species.has_limbs69limb_tag69
			var/limb_type = organ_data69"path"69
			var/found
			for(var/obj/item/organ/external/E in H.organs)
				if(limb_type == E.type)
					found = TRUE
					break
			if(!found)
				harm_points += 2

		var/obj/item/organ/external/head/head = H.get_organ(BP_HEAD)

		if(head && head.disfigured) // If you cut off the head, it's not quite "harm"
			harm_points += 1

		if(harm_points >= 4)
			completed = TRUE

		last_harm_points = harm_points
