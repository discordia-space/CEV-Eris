/datum/surgery_step/internal/install_module
	priority = 3 // Before internal organs

	allowed_tools = list(
		/obj/item/organ_module = 100
	)

	min_duration = 70
	max_duration = 90

/datum/surgery_step/internal/install_module/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0

	var/obj/item/organ_module/OM = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected.organ_tag in OM.allowed_organs)
		to_chat(user, SPAN_WARNING("[OM] isn't created for [affected]."))
		return 0
	return affected && !affected.module && affected.open >= 2

/datum/surgery_step/internal/install_module/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message(
		"[user] starts installing [tool] into [target]'s [affected].",
		"You start installing [tool] into [target]'s [affected]."
	)

	target.custom_pain("The pain in your [affected.name] is living hell!",1)
	..()

/datum/surgery_step/internal/install_module/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message(
		"[user] installed [tool] into [target]'s [affected].",
		"You installed [tool] into [target]'s [affected]."
	)

	if(!affected.module)
		var/obj/item/organ_module/OM = tool
		user.unEquip(OM, affected)
		OM.install(affected)

/datum/surgery_step/internal/install_module/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, scraping tissue inside [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, scraping tissue inside [target]'s [affected.name] with \the [tool]!")
	)
	affected.createwound(CUT, 20)


/datum/surgery_step/internal/module_removal
	priority = 3 // Before internal organs

	requedQuality = QUALITY_RETRACTING

	min_duration = 60
	max_duration = 80

/datum/surgery_step/internal/module_removal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || !affected.module)
		return FALSE

	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I.status & ORGAN_CUT_AWAY)
			return FALSE

	return TRUE

/datum/surgery_step/internal/module_removal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"[user] starts removing [affected.module], from [target]'s [affected] with \the [tool].",
		"You start removing [affected.module] from [target]'s [affected] with \the [tool]."
	)
	target.custom_pain("Someone's ripping out your [affected]!",1)
	..()

/datum/surgery_step/internal/module_removal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_NOTICE("[user] has removed [affected.module] from [target]'s [affected]."),
		SPAN_NOTICE("You have removed [affected.module] from [target]'s [affected].")
	)

	var/obj/item/organ_module/OM = affected.module
	OM.remove(affected)

/datum/surgery_step/internal/module_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!")
	)
	affected.createwound(BRUISE, 20)

