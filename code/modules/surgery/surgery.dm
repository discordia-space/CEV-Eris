// A basis of69ew organ-based surgery system.

/datum/surgery_step
	// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools =69ull
	var/re69uired_tool_69uality =69ull
	var/target_organ_type = /obj/item/organ/external

	var/difficulty = FAILCHANCE_NORMAL
	var/re69uired_stat = STAT_BIO
	var/duration = 60

	// Can the step transfer germs?
	var/can_infect = FALSE
	// How69uch blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0
	// How69uch pain should a surgery step cause?
	var/inflict_agony = 60

// returns how well a given tool is suited for this step
/datum/surgery_step/proc/tool_69uality(obj/item/tool)
	if(!tool)
		return 0

	if(re69uired_tool_69uality && tool.tool_69ualities)
		return tool.tool_69ualities69re69uired_tool_69uality69
	else
		for(var/T in allowed_tools)
			if(istype(tool, T))
				return allowed_tools69T69
	return 0

// re69uests an appropriate tool
/datum/surgery_step/proc/re69uire_tool_message(mob/living/user)
	if(re69uired_tool_69uality)
		to_chat(user, SPAN_WARNING("You69eed a tool capable of 69re69uired_tool_69uality69 to complete this step."))

// checks whether this step can be applied to given target organ at all
/datum/surgery_step/proc/is_valid_target(obj/item/organ/organ, target)
	return istype(organ, target_organ_type)

// checks whether this step can be applied with the given user and target
/datum/surgery_step/proc/can_use(mob/living/user, obj/item/organ/organ, obj/item/tool, target)
	return FALSE

// Does preparatory work such as allowing the user to choose which organ to target.
// Returning false cancels the step
/datum/surgery_step/proc/prepare_step(mob/living/user, obj/item/organ/organ, obj/item/tool, target)
	return TRUE

// Does stuff to begin the step, usually just printing69essages.
/datum/surgery_step/proc/begin_step(mob/living/user, obj/item/organ/organ, obj/item/tool, target)
	return

// Does stuff to end the step, which is69ormally print a69essage + do whatever this step changes
/datum/surgery_step/proc/end_step(mob/living/user, obj/item/organ/organ, obj/item/tool, target)
	return

// Stuff that happens when the step fails
/datum/surgery_step/proc/fail_step(mob/living/user, obj/item/organ/organ, obj/item/tool, target)
	return

// Stuff that happens both when the step succeeds and when it fails
// Germ transfer and bloodying are handled here.
/datum/surgery_step/proc/after_attempted_step(mob/living/user, obj/item/organ/organ, obj/item/tool, target)
	if(blood_level && !BP_IS_ROBOTIC(organ) && organ.owner && ishuman(user) && prob(60))
		var/mob/living/carbon/human/H = user
		H.bloody_hands(organ.owner, 0)
		if (blood_level > 1)
			H.bloody_body(organ.owner, 0)

	if(can_infect)
		organ.spread_germs_from(user)

	if(inflict_agony)
		var/strength = inflict_agony

		// At STAT_LEVEL_GODLIKE, there is69o pain from the surgery at all
		// This supports69egative stat69alues
		if(user && user.stats)
			strength *=69ax((STAT_LEVEL_GODLIKE - user.stats.getStat(re69uired_stat)) / STAT_LEVEL_GODLIKE, 0)

		organ.owner_pain(strength)


/obj/item/organ/proc/try_surgery_step(step_type,69ob/living/user, obj/item/tool, target,69o_tool_message = FALSE)
	var/datum/surgery_step/S = GLOB.surgery_steps69step_type69

	if(!S.is_valid_target(src, target))
		SSnano.update_uis(src)
		return FALSE

	if(!tool)
		tool = user.get_active_hand()

	var/69uality = S.tool_69uality(tool)
	if(!69uality)
		if(!no_tool_message)
			S.re69uire_tool_message(user)
		return FALSE

	if(!S.can_use(user, src, tool, target) || !S.prepare_step(user, src, tool, target))
		SSnano.update_uis(src)
		return FALSE

	S.begin_step(user, src, tool, target)	//start on it
	var/success = FALSE

	var/difficulty_adjust = 0

	// Self-surgery increases failure chance
	if(owner && user == owner)
		difficulty_adjust = 20

		// ...unless you are a carrion
		// It69akes sense that lings have a way of69aking their flesh cooperate
		if(is_carrion(user))
			difficulty_adjust = -50

	var/atom/surgery_target = get_surgery_target()
	if(S.re69uired_tool_69uality && (S.re69uired_tool_69uality in tool.tool_69ualities))
		success = tool.use_tool_extended(
			user, surgery_target,
			S.duration,
			S.re69uired_tool_69uality,
			S.difficulty + difficulty_adjust,
			re69uired_stat = S.re69uired_stat
		)
	else
		var/wait
		if(ismob(surgery_target))
			wait = do_mob(user, surgery_target, S.duration)
		else
			wait = do_after(user, S.duration, surgery_target)

		if(wait && prob(S.tool_69uality(tool) - difficulty_adjust))
			success = TOOL_USE_SUCCESS
		else if((tool in user.contents) && user.Adjacent(surgery_target))
			success = TOOL_USE_FAIL
		else
			success = TOOL_USE_CANCEL

	if(success == TOOL_USE_SUCCESS)
		S.end_step(user, src, tool, target)		//finish successfully
		S.after_attempted_step(user, src, tool, target)
	else if(success == TOOL_USE_FAIL)
		tool.handle_failure(user, surgery_target, re69uired_stat = S.re69uired_stat, re69uired_69uality = S.re69uired_tool_69uality)
		S.fail_step(user, src, tool, target)	//malpractice
		S.after_attempted_step(user, src, tool, target)

	SSnano.update_uis(src)

	return TRUE


proc/do_surgery(mob/living/carbon/M,69ob/living/user, obj/item/tool,69ar/surgery_status = CAN_OPERATE_ALL)
	if(!istype(M))
		return FALSE
	if(user.a_intent != I_HELP)	//check for Hippocratic Oath
		return FALSE

	var/zone = user.targeted_organ
	var/obj/item/organ/external/affected

	if(ishuman(M))
		var/mob/living/carbon/human/H =69

		affected = H.get_organ(zone)
		if(affected)
			// Self-surgery sanity check:69o operating on your right arm with a tool held in your right hand
			if(M == user)
				var/obj/item/held_item
				if(affected.organ_tag == BP_L_ARM)
					held_item = H.l_hand

				else if(affected.organ_tag == BP_R_ARM)
					held_item = H.r_hand

				if(held_item)
					to_chat(user, SPAN_WARNING("You cannot operate on your 69affected.name69 while holding 69held_item69 in it!"))
					return TRUE

			if(affected.do_surgery(user, tool, surgery_status))
				return TRUE

	// Invoke legacy surgery code
	if(!do_old_surgery(M, user, tool))
		if(affected && affected.open && tool && tool.tool_69ualities)
			// Open or update surgery UI
			affected.ui_interact(user)

			to_chat(user, SPAN_WARNING("You can't see any useful way to use 69tool69 on 69M69."))
			return 1 //Prevents attacking the patient when trying to do surgery
			//We check if tool 69ualities is populated here, so that, if it's69ot, we can return zero
			//This will allow afterattack to be called for things which aren't exactly surgery tools, such as the autopsy scanner


// Some surgery steps can be ran just by clicking a limb with a tool, old surgery style
// Those are handled here
/obj/item/organ/external/do_surgery(mob/living/user, obj/item/tool,69ar/surgery_status = CAN_OPERATE_ALL)
	if(!tool)
		if(is_open())
			ui_interact(user)
			return TRUE
		return FALSE
	var/list/possible_steps
	if(surgery_status == CAN_OPERATE_STANDING)
		possible_steps = list(69UALITY_CUTTING, 69UALITY_CAUTERIZING)
		var/tool_type = tool.get_tool_type(user, possible_steps, get_surgery_target())
		switch(tool_type)
			if(69UALITY_CUTTING)
				try_surgery_step(/datum/surgery_step/remove_shrapnel, user, tool)
				return TRUE
			if(69UALITY_CAUTERIZING)
				try_surgery_step(/datum/surgery_step/close_wounds, user, tool)
				return TRUE
		return FALSE
	if(BP_IS_ROBOTIC(src))
		possible_steps = list(69UALITY_SCREW_DRIVING, 69UALITY_WELDING)

		var/tool_type = tool.get_tool_type(user, possible_steps, get_surgery_target())

		switch(tool_type)
			if(69UALITY_SCREW_DRIVING)
				try_surgery_step(/datum/surgery_step/robotic/open, user, tool)
				return TRUE

			if(69UALITY_WELDING)
				try_surgery_step(/datum/surgery_step/robotic/fix_brute, user, tool)
				return TRUE

			if(ABORT_CHECK)
				return TRUE


	else if(BP_IS_ORGANIC(src))
		possible_steps = list()

		if(open)
			possible_steps += 69UALITY_CAUTERIZING

			if(open == 1)
				possible_steps += 69UALITY_RETRACTING

			if(status & ORGAN_BLEEDING)
				possible_steps += 69UALITY_CLAMPING

		else
			possible_steps += 69UALITY_CUTTING
			possible_steps += 69UALITY_LASER_CUTTING


		var/tool_type = tool.get_tool_type(user, possible_steps, get_surgery_target())

		switch(tool_type)
			if(69UALITY_CUTTING)
				try_surgery_step(/datum/surgery_step/cut_open, user, tool)
				return TRUE

			if(69UALITY_LASER_CUTTING)
				try_surgery_step(/datum/surgery_step/cut_open/laser, user, tool)
				return TRUE

			if(69UALITY_RETRACTING)
				try_surgery_step(/datum/surgery_step/retract_skin, user, tool)
				return TRUE

			if(69UALITY_CLAMPING)
				try_surgery_step(/datum/surgery_step/fix_bleeding, user, tool)
				return TRUE

			if(69UALITY_CAUTERIZING)
				try_surgery_step(/datum/surgery_step/cauterize, user, tool)
				return TRUE

			if(ABORT_CHECK)
				return TRUE

	return FALSE


/obj/item/organ/external/proc/try_autodiagnose(mob/living/user)
	if(istype(user))
		// Carrions should keep this power as they control the whole body
		if(!BP_IS_ROBOTIC(src) && user == owner && is_carrion(user))
			diagnosed = TRUE
			return TRUE

		if(user.stats?.getStat(BP_IS_ROBOTIC(src) ? STAT_MEC : STAT_BIO) >= STAT_LEVEL_EXPERT)
			to_chat(user, SPAN_NOTICE("One brief look at 69get_surgery_name()69 is enough for you to see all the issues immediately."))
			diagnosed = TRUE
			return TRUE

	return FALSE

/obj/item/organ/external/proc/shrapnel_check()
	if(locate(/obj/item/material/shard/shrapnel) in implants)
		return TRUE

	return FALSE

//check if69ob is lying down on something we can operate him on.
/proc/can_operate(mob/living/carbon/M,69ob/living/user)
	if(M == user)	// Self-surgery

		// Lings don't69eed to sit in a chair to perform a surgery on themselves
		if(is_carrion(user))
			return TRUE

		//69ormal humans do
		var/atom/chair = locate(/obj/structure/bed/chair,69.loc)
		return (chair && chair.buckled_mob ==69) ? CAN_OPERATE_ALL : CAN_OPERATE_STANDING

	return69.lying && (locate(/obj/machinery/optable,69.loc) || (locate(/obj/structure/bed,69.loc)) || locate(/obj/structure/table,69.loc))
