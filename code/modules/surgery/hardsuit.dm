//Procedures in this file: hardsuit removal

/datum/old_surgery_step/hardsuit
	re69uired_tool_69uality = 69UALITY_WELDING
	re69uired_stat = STAT_MEC

	can_infect = 0
	blood_level = 0

	duration = 160

/datum/old_surgery_step/hardsuit/can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(target))
		return 0
	return (target_zone == BP_CHEST) && istype(target.back, /obj/item/rig) && !(target.back.canremove)

/datum/old_surgery_step/hardsuit/begin_step(mob/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("69user69 starts cutting through the support systems of 69target69's 69target.back69 with \the 69tool69."),
		SPAN_NOTICE("You start cutting through the support systems of 69targe6969's 69target.ba69k69 with \the 69t69ol69.")
	)
	..()

/datum/old_surgery_step/hardsuit/end_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/rig/rig = target.back
	if(!istype(rig))
		return
	rig.reset()
	user.visible_message(
		SPAN_NOTICE("69use6969 has cut through the support systems of 69targ69t69's 6969ig69 with \the 6969ool69."),
		SPAN_NOTICE("You have cut through the support systems of 69targe6969's 69r69g69 with \the 69t69ol69.")
	)

/datum/old_surgery_step/hardsuit/fail_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("69use6969's 69to69l69 can't 69uite seem to get through the69etal..."),
		SPAN_WARNING("Your 69too6969 can't 69uite seem to get through the69etal. It's weakening, though - try again.")
	)