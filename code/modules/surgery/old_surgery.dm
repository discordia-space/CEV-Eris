/* SURGERY STEPS */

/datum/old_surgery_step
	var/priority = 0	//steps with higher priority would be attempted first

	// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools = null
	var/required_tool_quality = null
	// type paths referencing races that this step applies to.
	var/list/allowed_species = null
	var/list/disallowed_species = null

	var/required_stat = STAT_BIO

	// duration of the step
	var/duration = 0

	// evil infection stuff that will make everyone hate me
	var/can_infect = 0
	//How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0

// returns how well tool is suited for this step
/datum/old_surgery_step/proc/tool_quality(obj/item/tool)
	if(required_tool_quality && tool.tool_qualities)
		return tool.tool_qualities[required_tool_quality]
	else
		for (var/T in allowed_tools)
			if (istype(tool,T))
				return allowed_tools[T]
	return 0

// Checks if this step applies to the user mob at all
/datum/old_surgery_step/proc/is_valid_target(mob/living/carbon/human/target)
	if(!hasorgans(target))
		return 0

	if(allowed_species)
		for(var/species in allowed_species)
			if(target.species.get_bodytype() == species)
				return 1

	if(disallowed_species)
		for(var/species in disallowed_species)
			if(target.species.get_bodytype() == species)
				return 0

	return 1


// checks whether this step can be applied with the given user and target
/datum/old_surgery_step/proc/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return 0

// Does preparatory work such as allowing the user to choose which organ to target.
// Returning false cancels the step
/datum/old_surgery_step/proc/prepare_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return TRUE

// does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
/datum/old_surgery_step/proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (can_infect && affected)
		affected.spread_germs_from(user)
	if (ishuman(user) && prob(60))
		var/mob/living/carbon/human/H = user
		if (blood_level)
			H.bloody_hands(target,0)
		if (blood_level > 1)
			H.bloody_body(target,0)
	return

// does stuff to end the step, which is normally print a message + do whatever this step changes
/datum/old_surgery_step/proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return

// stuff that happens when the step fails
/datum/old_surgery_step/proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return null


proc/do_old_surgery(mob/living/carbon/M, mob/living/user, obj/item/tool)
	// Old surgery steps all require tools
	if(!tool)
		return FALSE

	var/zone = user.targeted_organ

	var/datum/old_surgery_step/selectedStep = null
	var/list/possibleSteps = list()
	for(var/datum/old_surgery_step/S in old_surgery_steps)
		//check if tool is right or close enough and if this step is possible
		if(S.tool_quality(tool))
			var/step_is_valid = S.can_use(user, M, zone, tool)
			if(step_is_valid && S.is_valid_target(M))
				if(step_is_valid == SURGERY_FAILURE) // This is a failure that already has a message for failing.
					return 1
				if(!S.required_tool_quality) // type-depend step
					selectedStep = S
					break
				else
					if(!possibleSteps[S.required_tool_quality]) //Keep priority
						possibleSteps[S.required_tool_quality] = S

	if(!selectedStep && possibleSteps.len)
		var/selected = tool.get_tool_type(user, possibleSteps, M)
		if(selected == ABORT_CHECK || !user.Adjacent(M))
			return 1
		selectedStep = possibleSteps[selected]

	if(selectedStep && selectedStep.can_use(user, M, zone, tool) && selectedStep.is_valid_target(M) && selectedStep.prepare_step(user, M, zone, tool))
		selectedStep.begin_step(user, M, zone, tool)		//start on it
		var/success = FALSE
		//We had proper tools! (or RNG smiled.) and user did not move or change hands.
		if(selectedStep.required_tool_quality)
			success = tool.use_tool_extended(
				user, M,
				selectedStep.duration, selectedStep.required_tool_quality,
				FAILCHANCE_NORMAL, required_stat = selectedStep.required_stat
				)
		else
			if(prob(selectedStep.tool_quality(tool)) && do_mob(user, M, selectedStep.duration))
				success = TOOL_USE_SUCCESS
			else if((tool in user.contents) && user.Adjacent(M))
				success = TOOL_USE_FAIL
			else
				success = TOOL_USE_CANCEL

		if(success == TOOL_USE_SUCCESS)
			selectedStep.end_step(user, M, zone, tool)		//finish successfully
		else if(success == TOOL_USE_FAIL)
			tool.handle_failure(user, M, required_stat = selectedStep.required_stat, required_quality = selectedStep.required_tool_quality)
			selectedStep.fail_step(user, M, zone, tool)		//malpractice~
		else
			to_chat(user, SPAN_WARNING("You must remain close to your patient to conduct surgery."))

		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			H.update_surgery()
		return	1	  												//don't want to do weapony things after surgery

	return 0

proc/sort_surgeries()
	var/gap = old_surgery_steps.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.247330950103979)
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= old_surgery_steps.len; i++)
			var/datum/old_surgery_step/l = old_surgery_steps[i]		//Fucking hate
			var/datum/old_surgery_step/r = old_surgery_steps[gap+i]	//how lists work here
			if(l.priority < r.priority)
				old_surgery_steps.Swap(i, gap + i)
				swapped = 1
