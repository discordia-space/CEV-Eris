/datum/objective/secdocs
	var/obj/item/weapon/secdocs/documents = null

/datum/objective/secdocs/set_target(var/obj/item/weapon/secdocs/ndocs)
	documents = ndocs
	update_explanation()

/datum/objective/secdocs/check_completion()
	if(owner && owner.current)
		var/list/L = owner.current.get_contents()
		if(documents in L)
			return TRUE
	return FALSE

/datum/objective/secdocs/protect/update_explanation()
	if(documents && documents.landmark)
		explanation_text = "Protect from stealing \the \"[documents.name]\". [documents.landmark.navigation]"
	else
		explanation_text = "Do your job."


/datum/objective/secdocs/steal/update_explanation()
	if(documents && target && target.current)
		explanation_text = "Find and steal \the \"[documents.name]\" from [target.current.name]. "
	else
		explanation_text = "Do something..."



