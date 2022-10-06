// In this file: steps for fixing organ damage, bleeding, bone fractures, necrosis and facial damage

/datum/surgery_step/fix_organ
	target_organ_type = /obj/item/organ/internal
	allowed_tools = list(
		/obj/item/stack/medical/advanced/bruise_pack = 100,
		/obj/item/stack/medical/bruise_pack = 20,
	)

	duration = 80

/datum/surgery_step/robotic/fix_organ/require_tool_message(mob/living/user)
	to_chat(user, SPAN_WARNING("You need an advanced trauma kit, or at least some bandages, to complete this step."))

/datum/surgery_step/fix_organ/proc/get_tool_name(obj/item/stack/tool)
	var/tool_name = "\the [tool]"
	if (istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	if (istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"
	return tool_name

/datum/surgery_step/fix_organ/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	return BP_IS_ORGANIC(organ) && organ.is_open() && organ.damage > 0

/datum/surgery_step/fix_organ/begin_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts treating damage to [organ.get_surgery_name()] with [get_tool_name(tool)]."),
		SPAN_NOTICE("You start treating damage to [organ.get_surgery_name()] with [get_tool_name(tool)].")
	)

	var/obj/item/organ/external/limb = organ.get_limb()
	if(limb)
		organ.owner_custom_pain("The pain in your [limb.name] is living hell!", 1)

/datum/surgery_step/fix_organ/end_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] treats damage to [organ.get_surgery_name()] with [get_tool_name(tool)]."),
		SPAN_NOTICE("You treat damage to [organ.get_surgery_name()] with [get_tool_name(tool)].")
	)
	if(tool.use(1))
		organ.damage = 0

/datum/surgery_step/fix_organ/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(5, 0)



/datum/surgery_step/fix_bleeding
	required_tool_quality = QUALITY_CLAMPING
	duration = 80

	blood_level = 1
	can_infect = TRUE

/datum/surgery_step/fix_bleeding/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	return BP_IS_ORGANIC(organ) && organ.open && (organ.status & ORGAN_BLEEDING)

/datum/surgery_step/fix_bleeding/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts clamping bleeders in [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start clamping bleeders in [organ.get_surgery_name()] with \the [tool].")
	)
	organ.owner_custom_pain("The pain in your [organ.name] is maddening!", 1)

/datum/surgery_step/fix_bleeding/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] clamps bleeders in [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You clamp bleeders in [organ.get_surgery_name()] with \the [tool].")
	)
	organ.clamp_wounds()

/datum/surgery_step/fix_bleeding/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, tearing blood vessels in [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, tearing blood vessels in [organ.get_surgery_name()] with \the [tool]!"),
	)
	organ.take_damage(10, 0, sharp=TRUE)



/datum/surgery_step/fix_necrosis
	required_tool_quality = QUALITY_CUTTING
	duration = 140

	can_infect = 1
	blood_level = 1

/datum/surgery_step/fix_necrosis/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	return BP_IS_ORGANIC(organ) && organ.is_open() && (organ.status & ORGAN_DEAD)

/datum/surgery_step/fix_necrosis/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts cutting away necrotic tissue in [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start cutting away necrotic tissue in [organ.get_surgery_name()] with \the [tool].")
	)

/datum/surgery_step/fix_necrosis/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] has cut away necrotic tissue in [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You have cut away necrotic tissue in [organ.get_surgery_name()] with \the [tool].")
	)
	organ.status &= ~ORGAN_DEAD
	organ.owner_custom_pain("The pain in your [organ.name] is living hell!", 1)
	// The pain message is displayed after the step is done, because dead limbs can't show pain messages

/datum/surgery_step/fix_necrosis/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, slicing an artery inside [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, slicing an artery inside [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(20, 0, sharp=TRUE, edge=TRUE)



// TODO: make "face" and "vocal cords" organs, move those types of damage there
/datum/surgery_step/fix_face
	required_tool_quality = QUALITY_CUTTING
	duration = 100
	blood_level = 1
	can_infect = TRUE

/datum/surgery_step/fix_face/can_use(mob/living/user, obj/item/organ/external/head/organ, obj/item/tool)
	return istype(organ) && organ.is_open() && organ.disfigured

/datum/surgery_step/fix_face/begin_step(mob/living/user, obj/item/organ/external/head/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] begins to fix facial structure and vocal cords on [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You begin to fix facial structure and vocal cords on [organ.get_surgery_name()] with \the [tool].")
	)
	organ.owner_custom_pain("You can feel your face being cut apart!", 1)

/datum/surgery_step/fix_face/end_step(mob/living/user, obj/item/organ/external/head/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] fixes facial structure and vocal cords on [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You fix facial structure and vocal cords on [organ.get_surgery_name()] with \the [tool].")
	)
	organ.disfigured = FALSE

/datum/surgery_step/fix_face/fail_step(mob/living/user, obj/item/organ/external/head/organ, obj/item/tool)
	if(organ.owner)
		user.visible_message(
			SPAN_WARNING("[user]'s hand slips, slicing [organ.owner]'s throat wth \the [tool]!"),
			SPAN_WARNING("Your hand slips, slicing [organ.owner]'s throat wth \the [tool]!")
		)
		organ.owner.losebreath += 10
	else
		user.visible_message(
			SPAN_WARNING("[user]'s hand slips, making a deep gash on [organ.get_surgery_name()] with \the [tool]!"),
			SPAN_WARNING("Your hand slips, making a deep gash on [organ.get_surgery_name()] with \the [tool]!")
		)
	organ.take_damage(60, 0, sharp=TRUE, edge=TRUE)

/datum/surgery_step/fix_brute
		allowed_tools = list(
			/obj/item/stack/medical/advanced/bruise_pack = 100,
			/obj/item/stack/medical/advanced/bruise_pack/nt = 100,
		)
		difficulty = FAILCHANCE_HARD
		duration = 100

/datum/surgery_step/fix_brute/require_tool_message(mob/living/user)
	to_chat(user, SPAN_WARNING("You need an advanced trauma kit to complete this step."))

/datum/surgery_step/fix_brute/proc/get_tool_name(obj/item/stack/tool)
	var/tool_name = "\the regenerative membrane"
	return tool_name

/datum/surgery_step/fix_brute/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	if(organ.brute_dam <= 0)
		to_chat(user, SPAN_NOTICE("This limb is undamaged!"))
		return SURGERY_FAILURE
	return TRUE

/datum/surgery_step/fix_brute/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] begins to treat damage to [organ.get_surgery_name()]'s subcutaneous tissue with \the [tool]."),
		SPAN_NOTICE("You begin to treat damage to [organ.get_surgery_name()]'s subcutaneous tissue with \the [tool].")
	)

/datum/surgery_step/fix_brute/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack) || istype(tool, /obj/item/stack/medical/advanced/bruise_pack/nt))
		var/obj/item/stack/S = tool
		if(S.use(1))
			user.visible_message(
			SPAN_NOTICE("[user] finishes treating damage to [organ.get_surgery_name()] with \the [tool]."),
			SPAN_NOTICE("You finish treating damage to [organ.get_surgery_name()] with \the [tool].")
			)
			organ.heal_damage(25, 0, TRUE)
		else
			to_chat(user, SPAN_NOTICE("\The [tool] is used up."))

/datum/surgery_step/fix_brute/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging the subcutaneous tissue of [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging the subcutaneous tissue of [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(rand(5, 10), 0)

/datum/surgery_step/fix_burn
		allowed_tools = list(
			/obj/item/stack/medical/advanced/ointment = 100,
			/obj/item/stack/medical/advanced/ointment/nt = 100,
		)
		difficulty = FAILCHANCE_HARD
		duration = 100

/datum/surgery_step/fix_burn/require_tool_message(mob/living/user)
	to_chat(user, SPAN_WARNING("You need an advanced burn kit to complete this step."))

/datum/surgery_step/fix_burn/proc/get_tool_name(obj/item/stack/tool)
	var/tool_name = "\the regenerative membrane"
	return tool_name

/datum/surgery_step/fix_burn/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	if(organ.burn_dam <= 0)
		to_chat(user, SPAN_NOTICE("This limb is undamaged!"))
		return SURGERY_FAILURE

	return TRUE


/datum/surgery_step/fix_burn/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] begins to treat damage to [organ.get_surgery_name()]'s subcutaneous tissue with \the [tool]."),
		SPAN_NOTICE("You begin to treat damage to [organ.get_surgery_name()]'s subcutaneous tissue with \the [tool].")
	)

/datum/surgery_step/fix_burn/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	if(istype(tool, /obj/item/stack/medical/advanced/ointment) || istype(tool, /obj/item/stack/medical/advanced/ointment/nt))
		var/obj/item/stack/S = tool
		if(S.use(1))
			user.visible_message(
			SPAN_NOTICE("[user] finishes treating damage to [organ.get_surgery_name()] with \the [tool]."),
			SPAN_NOTICE("You finish treating damage to [organ.get_surgery_name()] with \the [tool].")
			)
			organ.heal_damage(0, 25, TRUE)
		else 
			to_chat(user, SPAN_NOTICE("\The [tool] is used up."))

/datum/surgery_step/fix_burn/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging the subcutaneous tissue of [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging the subcutaneous tissue of [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(0, rand(5, 10))
