//Procedures in this file: old "cavity implant" steps

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/old_surgery_step/cavity
	priority = 1

/datum/old_surgery_step/cavity/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == (affected.encased ? 3 : 2) && !(affected.status & ORGAN_BLEEDING)

/datum/old_surgery_step/cavity/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(
		"\red [user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!",
		"\red Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"
	)
	affected.createwound(CUT, 20)

/datum/old_surgery_step/cavity/make_space
	required_tool_quality = QUALITY_DRILLING

	duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && !affected.cavity

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts making some space inside [target]'s [affected.cavity_name] with \the [tool].", \
		"You start making some space inside [target]'s [affected.cavity_name] with \the [tool]." )
		target.custom_pain("The pain in your chest is living hell!",1)
		affected.cavity = 1
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] makes some space inside [target]'s [affected.cavity_name] with \the [tool].", \
		"\blue You make some space inside [target]'s [affected.cavity_name] with \the [tool]." )

/datum/old_surgery_step/cavity/close_space
	priority = 2
	required_tool_quality = QUALITY_CAUTERIZING

	duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.cavity

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message(
			"[user] starts mending [target]'s [affected.cavity_name] wall with \the [tool].",
			"You start mending [target]'s [affected.cavity_name] wall with \the [tool]."
		)
		target.custom_pain("The pain in your chest is living hell!",1)
		affected.cavity = 0
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
		user.visible_message(
			"\blue [user] mends [target]'s [affected.cavity_name] walls with \the [tool].", \
			"\blue You mend [target]'s [affected.cavity_name] walls with \the [tool]."
		)
