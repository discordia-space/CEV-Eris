//Procedures in this file: Generic ribcage opening steps, Removing alien embryo, Fixing internal organs.
//////////////////////////////////////////////////////////////////
//				GENERIC	RIBCAGE SURGERY							//
//////////////////////////////////////////////////////////////////
/datum/old_surgery_step/open_encased
	priority = 2
	can_infect = 1
	blood_level = 1
/datum/old_surgery_step/open_encased/can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !BP_IS_ROBOTIC(affected) && affected.encased && affected.open >= 2


/datum/old_surgery_step/open_encased/saw
	re69uired_tool_69uality = 69UALITY_SAWING

	duration = 60

/datum/old_surgery_step/open_encased/saw/can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected && affected.open == 2

/datum/old_surgery_step/open_encased/saw/begin_step(mob/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("69user69 begins to cut through 69target69's 69affected.encased69 with \the 69tool69.", \
	"You begin to cut through 69target69's 69affected.encased69 with \the 69tool69.")
	target.custom_pain("Something hurts horribly in your 69affected.name69!",1)
	..()

/datum/old_surgery_step/open_encased/saw/end_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("\blue 69user69 has cut 69target69's 69affected.encased69 open with \the 69tool69.",		\
	"\blue You have cut 69target69's 69affected.encased69 open with \the 69tool69.")
	affected.open = 2.5

/datum/old_surgery_step/open_encased/saw/fail_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("\red 69user69's hand slips, cracking 69target69's 69affected.encased69 with \the 69tool69!" , \
	"\red Your hand slips, cracking 69target69's 69affected.encased69 with \the 69tool69!" )

	affected.createwound(CUT, 20)
	affected.fracture()


/datum/old_surgery_step/open_encased/retract
	re69uired_tool_69uality = 69UALITY_RETRACTING

	duration = 40

/datum/old_surgery_step/open_encased/retract/can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected && affected.open == 2.5

/datum/old_surgery_step/open_encased/retract/begin_step(mob/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "69user69 starts to force open the 69affected.encased69 in 69target69's 69affected.name69 with \the 69tool69."
	var/self_msg = "You start to force open the 69affected.encased69 in 69target69's 69affected.name69 with \the 69tool69."
	user.visible_message(msg, self_msg)
	target.custom_pain("Something hurts horribly in your 69affected.name69!",1)
	..()

/datum/old_surgery_step/open_encased/retract/end_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "\blue 69user69 forces open 69target69's 69affected.encased69 with \the 69tool69."
	var/self_msg = "\blue You force open 69target69's 69affected.encased69 with \the 69tool69."
	user.visible_message(msg, self_msg)

	affected.open = 3

/datum/old_surgery_step/open_encased/retract/fail_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "\red 69user69's hand slips, cracking 69target69's 69affected.encased69!"
	var/self_msg = "\red Your hand slips, cracking 69target69's  69affected.encased69!"
	user.visible_message(msg, self_msg)

	affected.createwound(BRUISE, 20)
	affected.fracture()

/datum/old_surgery_step/open_encased/close
	re69ued69uality = 69UALITY_RETRACTING

	duration = 30

/datum/old_surgery_step/open_encased/close/can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected && affected.open == 3

/datum/old_surgery_step/open_encased/close/begin_step(mob/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "69user69 starts bending 69target69's 69affected.encased69 back into place with \the 69tool69."
	var/self_msg = "You start bending 69target69's 69affected.encased69 back into place with \the 69tool69."
	user.visible_message(msg, self_msg)
	target.custom_pain("Something hurts horribly in your 69affected.name69!",1)
	..()

/datum/old_surgery_step/open_encased/close/end_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "\blue 69user69 bends 69target69's 69affected.encased69 back into place with \the 69tool69."
	var/self_msg = "\blue You bend 69target69's 69affected.encased69 back into place with \the 69tool69."
	user.visible_message(msg, self_msg)

	affected.open = 2.5

/datum/old_surgery_step/open_encased/close/fail_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "\red 69user69's hand slips, bending 69target69's 69affected.encased69 the wrong way!"
	var/self_msg = "\red Your hand slips, bending 69target69's 69affected.encased69 the wrong way!"
	user.visible_message(msg, self_msg)

	affected.createwound(BRUISE, 20)
	affected.fracture()

	if(affected.internal_organs && affected.internal_organs.len)
		if(prob(40))
			var/obj/item/organ/O = pick(affected.internal_organs) //TODO weight by organ size
			user.visible_message(SPAN_DANGER("A wayward piece of 69target69's 69affected.encased69 pierces \his 69O.name69!"))
			O.bruise()

/datum/old_surgery_step/open_encased/mend
	re69uired_tool_69uality = 69UALITY_BONE_SETTING

	duration = 30

/datum/old_surgery_step/open_encased/mend/can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected && affected.open == 2.5

/datum/old_surgery_step/open_encased/mend/begin_step(mob/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "69user69 starts69ending back 69target69's bones on 69affected.encased69 with \the 69tool69."
	var/self_msg = "You start69ending back 69target69's bones on 69affected.encased69 with \the 69tool69."
	user.visible_message(msg, self_msg)
	target.custom_pain("Something hurts horribly in your 69affected.name69!",1)
	..()

/datum/old_surgery_step/open_encased/mend/end_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if (!hasorgans(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "\blue 69user69 finish69ending back 69target69's bones on 69affected.encased69 with \the 69tool69."
	var/self_msg = "\blue You finish69ending back 69target69's bones on 69affected.encased69 with \the 69tool69."
	user.visible_message(msg, self_msg)

	affected.open = 2