//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/generic
	can_infect = 1
/datum/surgery_step/generic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (isslime(target))
		return 0
	if (target_zone == BP_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	if (affected.is_stump())
		return 0
	if (BP_IS_ROBOTIC(affected))
		return 0
	return 1

/datum/surgery_step/generic/cut_with_laser
	requedQuality = QUALITY_LASER_CUTTING
	priority = 2
	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/cut_with_laser/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != BP_MOUTH

/datum/surgery_step/generic/cut_with_laser/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool].", \
	"You start the bloodless incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name]!",1)
	..()

/datum/surgery_step/generic/cut_with_laser/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\blue [user] has made a bloodless incision on [target]'s [affected.name] with \the [tool].", \
	"\blue You have made a bloodless incision on [target]'s [affected.name] with \the [tool].",)
	//Could be cleaner ...
	affected.open = 1

	if(istype(target))
		affected.setBleeding()

	affected.createwound(CUT, 1)
	affected.clamp()
	spread_germs_to_organ(affected, user)

/datum/surgery_step/generic/cut_with_laser/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!", \
	"\red Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!")
	affected.createwound(CUT, 7.5)
	affected.createwound(BURN, 12.5)

/datum/surgery_step/generic/cut_open
	requedQuality = QUALITY_CUTTING

	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/cut_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != BP_MOUTH

/datum/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the incision on [target]'s [affected.name] with \the [tool].", \
	"You start the incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!",1)
	..()

/datum/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\blue [user] has made an incision on [target]'s [affected.name] with \the [tool].", \
	"\blue You have made an incision on [target]'s [affected.name] with \the [tool].",)
	affected.open = 1

	if(istype(target))
		affected.setBleeding()
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 50, 1)

	affected.createwound(CUT, 1)

/datum/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!", \
	"\red Your hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!")
	affected.createwound(CUT, 10)

/datum/surgery_step/generic/clamp_bleeders
	requedQuality = QUALITY_CLAMPING

	min_duration = 40
	max_duration = 60

/datum/surgery_step/generic/clamp_bleeders/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open && (affected.status & ORGAN_BLEEDING)

/datum/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool].", \
	"You start clamping bleeders in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is maddening!",1)
	..()

/datum/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\blue [user] clamps bleeders in [target]'s [affected.name] with \the [tool].",	\
	"\blue You clamp bleeders in [target]'s [affected.name] with \the [tool].")
	affected.clamp()
	spread_germs_to_organ(affected, user)

/datum/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, tearing blood vessals and causing massive bleeding in [target]'s [affected.name] with \the [tool]!",	\
	"\red Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!",)
	affected.createwound(CUT, 10)

/datum/surgery_step/generic/retract_skin
	requedQuality = QUALITY_RETRACTING

	min_duration = 30
	max_duration = 40

/datum/surgery_step/generic/retract_skin/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 1 //&& !(affected.status & ORGAN_BLEEDING)

/datum/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "[user] starts to pry open the incision on [target]'s [affected.name] with \the [tool]."
	var/self_msg = "You start to pry open the incision on [target]'s [affected.name] with \the [tool]."
	if (target_zone == BP_CHEST)
		msg = "[user] starts to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
		self_msg = "You start to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
	if (target_zone == BP_GROIN)
		msg = "[user] starts to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
		self_msg = "You start to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
	user.visible_message(msg, self_msg)
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!",1)
	..()

/datum/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "\blue [user] keeps the incision open on [target]'s [affected.name] with \the [tool]."
	var/self_msg = "\blue You keep the incision open on [target]'s [affected.name] with \the [tool]."
	if (target_zone == BP_CHEST)
		msg = "\blue [user] keeps the incision open on [target]'s torso with \the [tool]."
		self_msg = "\blue You keep the incision open on [target]'s torso with \the [tool]."
	if (target_zone == BP_GROIN)
		msg = "\blue [user] keeps the incision open on [target]'s lower abdomen with \the [tool]."
		self_msg = "\blue You keep the incision open on [target]'s lower abdomen with \the [tool]."
	user.visible_message(msg, self_msg)
	affected.open = 2

/datum/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "\red [user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!"
	var/self_msg = "\red Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!"
	if (target_zone == BP_CHEST)
		msg = "\red [user]'s hand slips, damaging several organs in [target]'s torso with \the [tool]!"
		self_msg = "\red Your hand slips, damaging several organs in [target]'s torso with \the [tool]!"
	if (target_zone == BP_GROIN)
		msg = "\red [user]'s hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]"
		self_msg = "\red Your hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!"
	user.visible_message(msg, self_msg)
	target.apply_damage(12, BRUTE, affected, sharp=1)

/datum/surgery_step/generic/cauterize
	requedQuality = QUALITY_CAUTERIZING

	min_duration = 70
	max_duration = 100

/datum/surgery_step/generic/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open && affected.open <= 2.5 && target_zone != BP_MOUTH

/datum/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to cauterize the incision on [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to cauterize the incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Your [affected.name] is being burned!",1)
	..()

/datum/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\blue [user] cauterizes the incision on [target]'s [affected.name] with \the [tool].", \
	"\blue You cauterize the incision on [target]'s [affected.name] with \the [tool].")
	affected.open = 0
	affected.germ_level = 0
	affected.stopBleeding()

/datum/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!", \
	"\red Your hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!")
	target.apply_damage(3, BURN, affected)

/datum/surgery_step/generic/amputate
	requedQuality = QUALITY_SAWING

	min_duration = 110
	max_duration = 160

/datum/surgery_step/generic/amputate/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (target_zone == BP_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	return !affected.cannot_amputate

/datum/surgery_step/generic/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to amputate [target]'s [affected.name] with \the [tool]." , \
	"You are beginning to cut through [target]'s [affected.amputation_point] with \the [tool].")
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!",1)
	..()

/datum/surgery_step/generic/amputate/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\blue [user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool].", \
	"\blue You amputate [target]'s [affected.name] with \the [tool].")
	affected.droplimb(1,DROPLIMB_EDGE)

/datum/surgery_step/generic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("\red [user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!", \
	"\red Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!")
	affected.createwound(CUT, 30)
	affected.fracture()
