/* SURGERY STEPS */

/datum/old_surgery_step
	var/priority = 0	//steps with higher priority would be attempted first

	// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools =69ull
	var/re69uired_tool_69uality =69ull
	// type paths referencing races that this step applies to.
	var/list/allowed_species =69ull
	var/list/disallowed_species =69ull

	var/re69uired_stat = STAT_BIO

	// duration of the step
	var/duration = 0

	// evil infection stuff that will69ake everyone hate69e
	var/can_infect = 0
	//How69uch blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0

// returns how well tool is suited for this step
/datum/old_surgery_step/proc/tool_69uality(obj/item/tool)
	if(re69uired_tool_69uality && tool.tool_69ualities)
		return tool.tool_69ualities69re69uired_tool_69uality69
	else
		for (var/T in allowed_tools)
			if (istype(tool,T))
				return allowed_tools69T69
	return 0

// Checks if this step applies to the user69ob at all
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
/datum/old_surgery_step/proc/can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	return 0

// Does preparatory work such as allowing the user to choose which organ to target.
// Returning false cancels the step
/datum/old_surgery_step/proc/prepare_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	return TRUE

// does stuff to begin the step, usually just printing69essages.69oved germs transfering and bloodying here too
/datum/old_surgery_step/proc/begin_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
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

// does stuff to end the step, which is69ormally print a69essage + do whatever this step changes
/datum/old_surgery_step/proc/end_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	return

// stuff that happens when the step fails
/datum/old_surgery_step/proc/fail_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	return69ull


proc/do_old_surgery(mob/living/carbon/M,69ob/living/user, obj/item/tool)
	// Old surgery steps all re69uire tools
	if(!tool)
		return FALSE

	var/zone = user.targeted_organ

	var/datum/old_surgery_step/selectedStep =69ull
	var/list/possibleSteps = list()
	for(var/datum/old_surgery_step/S in GLOB.old_surgery_steps)
		//check if tool is right or close enough and if this step is possible
		if(S.tool_69uality(tool))
			var/step_is_valid = S.can_use(user,69, zone, tool)
			if(step_is_valid && S.is_valid_target(M))
				if(step_is_valid == SURGERY_FAILURE) // This is a failure that already has a69essage for failing.
					return 1
				if(!S.re69uired_tool_69uality) // type-depend step
					selectedStep = S
					break
				else
					if(!possibleSteps69S.re69uired_tool_69uality69) //Keep priority
						possibleSteps69S.re69uired_tool_69uality69 = S

	if(!selectedStep && possibleSteps.len)
		var/selected = tool.get_tool_type(user, possibleSteps,69)
		if(selected == ABORT_CHECK || !user.Adjacent(M))
			return 1
		selectedStep = possibleSteps69selected69

	if(selectedStep && selectedStep.can_use(user,69, zone, tool) && selectedStep.is_valid_target(M) && selectedStep.prepare_step(user,69, zone, tool))
		selectedStep.begin_step(user,69, zone, tool)		//start on it
		var/success = FALSE
		//We had proper tools! (or RNG smiled.) and user did69ot69ove or change hands.
		if(selectedStep.re69uired_tool_69uality)
			success = tool.use_tool_extended(
				user,69,
				selectedStep.duration, selectedStep.re69uired_tool_69uality,
				FAILCHANCE_NORMAL, re69uired_stat = selectedStep.re69uired_stat
				)
		else
			if(prob(selectedStep.tool_69uality(tool)) && do_mob(user,69, selectedStep.duration))
				success = TOOL_USE_SUCCESS
			else if((tool in user.contents) && user.Adjacent(M))
				success = TOOL_USE_FAIL
			else
				success = TOOL_USE_CANCEL

		if(success == TOOL_USE_SUCCESS)
			selectedStep.end_step(user,69, zone, tool)		//finish successfully
		else if(success == TOOL_USE_FAIL)
			tool.handle_failure(user,69, re69uired_stat = selectedStep.re69uired_stat, re69uired_69uality = selectedStep.re69uired_tool_69uality)
			selectedStep.fail_step(user,69, zone, tool)		//malpractice~
		else
			to_chat(user, SPAN_WARNING("You69ust remain close to your patient to conduct surgery."))

		if (ishuman(M))
			var/mob/living/carbon/human/H =69
			H.update_surgery()
		return	1	  												//don't want to do weapony things after surgery

	return 0

proc/sort_surgeries()
	var/gap = GLOB.old_surgery_steps.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.247330950103979)
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= GLOB.old_surgery_steps.len; i++)
			var/datum/old_surgery_step/l = GLOB.old_surgery_steps69i69		//Fucking hate
			var/datum/old_surgery_step/r = GLOB.old_surgery_steps69gap+i69	//how lists work here
			if(l.priority < r.priority)
				GLOB.old_surgery_steps.Swap(i, gap + i)
				swapped = 1
