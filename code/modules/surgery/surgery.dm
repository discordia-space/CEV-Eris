/* SURGERY STEPS */

/datum/surgery_step
	var/priority = 0	//steps with higher priority would be attempted first

	// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools = null
	var/requedQuality = null
	// type paths referencing races that this step applies to.
	var/list/allowed_species = null
	var/list/disallowed_species = null

	// duration of the step
	var/min_duration = 0
	var/max_duration = 0

	// evil infection stuff that will make everyone hate me
	var/can_infect = 0
	//How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0

	//returns how well tool is suited for this step
	proc/tool_quality(obj/item/tool)
		if(requedQuality && tool.tool_qualities)
			return tool.tool_qualities[requedQuality]
		else
			for (var/T in allowed_tools)
				if (istype(tool,T))
					return allowed_tools[T]
		return 0

	// Checks if this step applies to the user mob at all
	proc/is_valid_target(mob/living/carbon/human/target)
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
	proc/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return 0

	// Does preparatory work such as allowing the user to choose which organ to target.
	// Returning false cancels the step
	proc/prepare_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return TRUE

	// does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
	proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (can_infect && affected)
			spread_germs_to_organ(affected, user)
		if (ishuman(user) && prob(60))
			var/mob/living/carbon/human/H = user
			if (blood_level)
				H.bloody_hands(target,0)
			if (blood_level > 1)
				H.bloody_body(target,0)
		return

	// does stuff to end the step, which is normally print a message + do whatever this step changes
	proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return

	// stuff that happens when the step fails
	proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return null

proc/spread_germs_to_organ(var/obj/item/organ/external/E, var/mob/living/carbon/human/user)
	if(!istype(user) || !istype(E)) return

	var/germ_level = user.germ_level
	if(user.gloves)
		germ_level = user.gloves.germ_level

	E.germ_level = max(germ_level,E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.

proc/do_surgery(mob/living/carbon/M, mob/living/user, obj/item/tool)
	if(!istype(M))
		return 0
	if (user.a_intent == I_HURT)	//check for Hippocratic Oath
		return 0
	var/zone = user.targeted_organ
	if(zone in M.op_stage.in_progress) //Can't operate on someone repeatedly.
		to_chat(user, SPAN_WARNING("You can't operate on this area while surgery is already in progress."))
		return 1
	var/datum/surgery_step/selectedStep = null
	var/list/possibleSteps = list()
	for(var/datum/surgery_step/S in surgery_steps)
		//check if tool is right or close enough and if this step is possible
		if(S.tool_quality(tool))
			var/step_is_valid = S.can_use(user, M, zone, tool)
			if(step_is_valid && S.is_valid_target(M))
				if(step_is_valid == SURGERY_FAILURE) // This is a failure that already has a message for failing.
					return 1
				if(!S.requedQuality) // type-depend step
					selectedStep = S
					break
				else
					if(!possibleSteps[S.requedQuality]) //Keep priority
						possibleSteps[S.requedQuality] = S

	if(!selectedStep && possibleSteps.len)
		var/selected = tool.get_tool_type(user, possibleSteps, M)
		if(selected == ABORT_CHECK || !user.Adjacent(M))
			return 1
		selectedStep = possibleSteps[selected]

	if(selectedStep && selectedStep.can_use(user, M, zone, tool) && selectedStep.is_valid_target(M) && selectedStep.prepare_step(user, M, zone, tool))
		M.op_stage.in_progress += zone
		selectedStep.begin_step(user, M, zone, tool)		//start on it
		var/success = FALSE
		var/timeDelay = rand(selectedStep.min_duration, selectedStep.max_duration)
		//We had proper tools! (or RNG smiled.) and user did not move or change hands.
		if(selectedStep.requedQuality)
			success = tool.use_tool_extended(user, M, timeDelay, selectedStep.requedQuality, FAILCHANCE_NORMAL, required_stat = STAT_BIO)
		else
			if(prob(selectedStep.tool_quality(tool)) &&  do_mob(user, M, timeDelay))
				success = TOOL_USE_SUCCESS
			else if((tool in user.contents) && user.Adjacent(M))
				success = TOOL_USE_FAIL
			else
				success = TOOL_USE_CANCEL

		if(success == TOOL_USE_SUCCESS)
			selectedStep.end_step(user, M, zone, tool)		//finish successfully
		else if(success == TOOL_USE_FAIL)
			tool.handle_failure(user, M, required_stat = STAT_BIO, required_quality = selectedStep.requedQuality)
			selectedStep.fail_step(user, M, zone, tool)		//malpractice~
		else
			to_chat(user, SPAN_WARNING("You must remain close to your patient to conduct surgery."))
		M.op_stage.in_progress -= zone 									// Clear the in-progress flag.
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			H.update_surgery()
		return	1	  												//don't want to do weapony things after surgery

	if (user.a_intent == I_HELP)
		to_chat(user, SPAN_WARNING("You can't see any useful way to use [tool] on [M]."))

		if (tool.tool_qualities)
			return 1 //Prevents attacking the patient when trying to do surgery
			//We check if tool qualities is populated here, so that, if it's not, we can return zero
			//This will allow afterattack to be called for things which aren't exactly surgery tools, such as the autopsy scanner

	return 0

proc/sort_surgeries()
	var/gap = surgery_steps.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.247330950103979)
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= surgery_steps.len; i++)
			var/datum/surgery_step/l = surgery_steps[i]		//Fucking hate
			var/datum/surgery_step/r = surgery_steps[gap+i]	//how lists work here
			if(l.priority < r.priority)
				surgery_steps.Swap(i, gap + i)
				swapped = 1

/datum/surgery_status/
	var/eyes	=	0
	var/face	=	0
	var/head_reattach = 0
	var/current_organ = "organ"
	var/list/in_progress = list()
