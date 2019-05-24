//Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/remove_bone_shards
	requedQuality = QUALITY_RETRACTING

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/remove_bone_shards/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !BP_IS_ROBOTIC(affected) && affected.open >= 2 && affected.stage == 0

/datum/surgery_step/remove_bone_shards/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.stage == 0)
		user.visible_message("[user] starts repairing damaged bones in [target]'s [affected.name] with \the [tool]." , \
		"You start removing bone shards in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!",1)
	..()

/datum/surgery_step/remove_bone_shards/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\blue [user] removed bone shards with [tool] in [target]'s bone in [affected.name]", \
		"\blue You removed bone shards of [target]'s [affected.name] with \the [tool].")
	affected.stage = 1

/datum/surgery_step/remove_bone_shards/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, damaging [target]'s [affected.name]!" , \
	"\red Your hand slips, damaging [target]'s [affected.name]!")
	affected.createwound(BRUISE, 5)

/datum/surgery_step/set_bone
	requedQuality = QUALITY_BONE_SETTING

	min_duration = 60
	max_duration = 70

/datum/surgery_step/set_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.organ_tag != BP_HEAD && !BP_IS_ROBOTIC(affected) && affected.open >= 2 && affected.stage == 1

/datum/surgery_step/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to set the bone in [target]'s [affected.name] in place with \the [tool]." , \
		"You are beginning to set the bone in [target]'s [affected.name] in place with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!",1)
	..()

/datum/surgery_step/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.status & ORGAN_BROKEN)
		user.visible_message("\blue [user] sets the bone in [target]'s [affected.name] in place with \the [tool].", \
			"\blue You set the bone in [target]'s [affected.name] in place with \the [tool].")
		affected.stage = 2
	else
		user.visible_message("\blue [user] sets the bone in [target]'s [affected.name]\red in the WRONG place with \the [tool].", \
			"\blue You set the bone in [target]'s [affected.name]\red in the WRONG place with \the [tool].")
		affected.fracture()

/datum/surgery_step/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!" , \
		"\red Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!")
	affected.createwound(BRUISE, 5)

/datum/surgery_step/mend_skull
	requedQuality = QUALITY_BONE_SETTING

	min_duration = 60
	max_duration = 70

/datum/surgery_step/mend_skull/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.organ_tag == BP_HEAD && !BP_IS_ROBOTIC(affected) && affected.open >= 2 && affected.stage == 1

/datum/surgery_step/mend_skull/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning to piece together [target]'s skull with \the [tool]."  , \
		"You are beginning to piece together [target]'s skull with \the [tool].")
	..()

/datum/surgery_step/mend_skull/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\blue [user] sets [target]'s skull with \the [tool]." , \
		"\blue You set [target]'s skull with \the [tool].")
	affected.stage = 2

/datum/surgery_step/mend_skull/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, damaging [target]'s face with \the [tool]!"  , \
		"\red Your hand slips, damaging [target]'s face with \the [tool]!")
	var/obj/item/organ/external/head/h = affected
	h.createwound(BRUISE, 10)
	h.disfigured = 1

/datum/surgery_step/finish_bone
	requedQuality = QUALITY_BONE_SETTING

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/finish_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open >= 2 && !BP_IS_ROBOTIC(affected) && affected.stage == 2

/datum/surgery_step/finish_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].", \
	"You start to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/finish_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\blue [user] has mended the damaged bones in [target]'s [affected.name] with \the [tool]."  , \
		"\blue You have mended the damaged bones in [target]'s [affected.name] with \the [tool]." )
	affected.status &= ~ORGAN_BROKEN
	affected.status &= ~ORGAN_SPLINTED
	affected.stage = 0
	affected.perma_injury = 0

/datum/surgery_step/finish_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!" , \
	"\red Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!")