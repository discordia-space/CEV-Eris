//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
//						FACE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/face
	priority = 2
	can_infect = 0
/datum/surgery_step/face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected || BP_IS_ROBOTIC(affected))
		return 0
	return target_zone == BP_MOUTH

/datum/surgery_step/generic/cut_face/
	requedQuality = QUALITY_CUTTING

	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/cut_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == 0

/datum/surgery_step/generic/cut_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to cut open [target]'s face and neck with \the [tool].", \
	"You start to cut open [target]'s face and neck with \the [tool].")
	..()

/datum/surgery_step/generic/cut_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("\blue [user] has cut open [target]'s face and neck with \the [tool]." , \
	"\blue You have cut open [target]'s face and neck with \the [tool].",)
	target.op_stage.face = 1

/datum/surgery_step/generic/cut_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, slicing [target]'s throat wth \the [tool]!" , \
	"\red Your hand slips, slicing [target]'s throat wth \the [tool]!" )
	affected.createwound(CUT, 60)
	target.losebreath += 10

/datum/surgery_step/face/mend_vocal
	requedQuality = QUALITY_CLAMPING

	min_duration = 70
	max_duration = 90

/datum/surgery_step/face/mend_vocal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face == 1

/datum/surgery_step/face/mend_vocal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts mending [target]'s vocal cords with \the [tool].", \
	"You start mending [target]'s vocal cords with \the [tool].")
	..()

/datum/surgery_step/face/mend_vocal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("\blue [user] mends [target]'s vocal cords with \the [tool].", \
	"\blue You mend [target]'s vocal cords with \the [tool].")
	target.op_stage.face = 2

/datum/surgery_step/face/mend_vocal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("\red [user]'s hand slips, clamping [target]'s trachea shut for a moment with \the [tool]!", \
	"\red Your hand slips, clamping [user]'s trachea shut for a moment with \the [tool]!")
	target.losebreath += 10

/datum/surgery_step/face/fix_face
	requedQuality = QUALITY_RETRACTING

	min_duration = 80
	max_duration = 100

/datum/surgery_step/face/fix_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face == 2

/datum/surgery_step/face/fix_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts pulling the skin on [target]'s face back in place with \the [tool].", \
	"You start pulling the skin on [target]'s face back in place with \the [tool].")
	..()

/datum/surgery_step/face/fix_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("\blue [user] pulls the skin on [target]'s face back in place with \the [tool].",	\
	"\blue You pull the skin on [target]'s face back in place with \the [tool].")
	target.op_stage.face = 3

/datum/surgery_step/face/fix_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, tearing skin on [target]'s face with \the [tool]!", \
	"\red Your hand slips, tearing skin on [target]'s face with \the [tool]!")
	target.apply_damage(10, BRUTE, affected, sharp=1, sharp=1)

/datum/surgery_step/face/cauterize
	requedQuality = QUALITY_CAUTERIZING

	min_duration = 70
	max_duration = 100

/datum/surgery_step/face/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face > 0

/datum/surgery_step/face/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning to cauterize the incision on [target]'s face and neck with \the [tool]." , \
	"You are beginning to cauterize the incision on [target]'s face and neck with \the [tool].")
	..()

/datum/surgery_step/face/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\blue [user] cauterizes the incision on [target]'s face and neck with \the [tool].", \
	"\blue You cauterize the incision on [target]'s face and neck with \the [tool].")
	affected.open = 0
	affected.stopBleeding()
	if (target.op_stage.face == 3)
		var/obj/item/organ/external/head/h = affected
		h.disfigured = 0
	target.op_stage.face = 0

/datum/surgery_step/face/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, leaving a small burn on [target]'s face with \the [tool]!", \
	"\red Your hand slips, leaving a small burn on [target]'s face with \the [tool]!")
	target.apply_damage(4, BURN, affected)
