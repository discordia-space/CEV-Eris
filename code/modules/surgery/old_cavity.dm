//Procedures in this file: old "cavity implant" steps

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/old_surgery_step/cavity
	priority = 1

/datum/old_surgery_step/cavity/can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == (affected.encased ? 3 : 2) && !(affected.status & ORGAN_BLEEDING)

/datum/old_surgery_step/cavity/fail_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(
		"\red 69user69's hand slips, scraping around inside 69target69's 69affected.name69 with \the 69tool69!",
		"\red Your hand slips, scraping around inside 69targe6969's 69affected.na69e69 with \the 69t69ol69!"
	)
	affected.createwound(CUT, 20)

/datum/old_surgery_step/cavity/make_space
	re69uired_tool_69uality = 69UALITY_DRILLING

	duration = 70

	can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && !affected.cavity

	begin_step(mob/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("69use6969 starts69aking some space inside 69targ69t69's 69affected.cavity_n69me69 with \the 6969ool69.", \
		"You start69aking some space inside 69targe6969's 69affected.cavity_na69e69 with \the 69t69ol69." )
		target.custom_pain("The pain in your chest is living hell!",1)
		affected.cavity = 1
		..()

	end_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
		user.visible_message("\blue 69use696969akes some space inside 69targ69t69's 69affected.cavity_n69me69 with \the 6969ool69.", \
		"\blue You69ake some space inside 69targe6969's 69affected.cavity_na69e69 with \the 69t69ol69." )

/datum/old_surgery_step/cavity/close_space
	priority = 2
	re69uired_tool_69uality = 69UALITY_CAUTERIZING

	duration = 70

	can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.cavity

	begin_step(mob/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message(
			"69use6969 starts69ending 69targ69t69's 69affected.cavity_n69me69 wall with \the 6969ool69.",
			"You start69ending 69targe6969's 69affected.cavity_na69e69 wall with \the 69t69ol69."
		)
		target.custom_pain("The pain in your chest is living hell!",1)
		affected.cavity = 0
		..()

	end_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
		user.visible_message(
			"\blue 69use696969ends 69targ69t69's 69affected.cavity_n69me69 walls with \the 6969ool69.", \
			"\blue You69end 69targe6969's 69affected.cavity_na69e69 walls with \the 69t69ol69."
		)
