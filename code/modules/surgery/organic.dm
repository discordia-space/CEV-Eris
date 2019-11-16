/datum/surgery_step/cut_open
	required_tool_quality = QUALITY_CUTTING

	duration = 100
	blood_level = 1
	can_infect = TRUE
	var/incision_name = "an incision"

/datum/surgery_step/cut_open/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	return BP_IS_ORGANIC(organ) && !organ.open

/datum/surgery_step/cut_open/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts [incision_name] on [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start [incision_name] on [organ.get_surgery_name()] with \the [tool].")
	)

	if(required_tool_quality == QUALITY_LASER_CUTTING)
		organ.owner_custom_pain("You feel a horrible, searing pain in your [organ.name]!", 1)
	else
		organ.owner_custom_pain("You feel a horrible pain as if from a sharp knife in your [organ.name]!", 1)

/datum/surgery_step/cut_open/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] has made [incision_name] on [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You have made [incision_name] on [organ.get_surgery_name()] with \the [tool].")
	)

	organ.open = 1

	organ.setBleeding()
	organ.take_damage(1, 0, sharp=TRUE, edge=TRUE)

	if(required_tool_quality == QUALITY_LASER_CUTTING)
		organ.clamp_wounds()
	else
		playsound(organ.get_surgery_target(), 'sound/weapons/bladeslice.ogg', 50, 1)

/datum/surgery_step/cut_open/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, slicing open [organ.get_surgery_name()] in the wrong place with \the [tool]!"),
		SPAN_WARNING("Your hand slips, slicing open [organ.get_surgery_name()] in the wrong place with \the [tool]!")
	)
	organ.take_damage(10, 0, sharp=TRUE, edge=TRUE)


/datum/surgery_step/cut_open/laser
	required_tool_quality = QUALITY_LASER_CUTTING
	blood_level = 0
	can_infect = FALSE
	incision_name = "a clean incision"



/datum/surgery_step/retract_skin
	required_tool_quality = QUALITY_RETRACTING
	duration = 80
	blood_level = 1
	can_infect = TRUE

/datum/surgery_step/retract_skin/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	return BP_IS_ORGANIC(organ) && organ.open == 1

/datum/surgery_step/retract_skin/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts to pry open the incision on [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start to pry open the incision on [organ.get_surgery_name()] with \the [tool].")
	)
	organ.owner_custom_pain("It feels like the skin on your [organ.name] is on fire!", 1)

/datum/surgery_step/retract_skin/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] keeps the incision open on [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You keep the incision open on [organ.get_surgery_name()] with \the [tool].")
	)
	organ.open = 2
	organ.ui_interact(user)

/datum/surgery_step/retract_skin/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, tearing the edges of the incision on [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, tearing the edges of the incision on [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(12, 0, sharp=TRUE)



/datum/surgery_step/cauterize
	required_tool_quality = QUALITY_CAUTERIZING
	duration = 80

/datum/surgery_step/cauterize/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	return BP_IS_ORGANIC(organ) && organ.open

/datum/surgery_step/cauterize/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] begins to cauterize the incision on [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You begin to cauterize the incision on [organ.get_surgery_name()] with \the [tool].")
	)
	organ.owner_custom_pain("Your [organ.name] is being burned!", 1)

/datum/surgery_step/cauterize/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] cauterizes the incision on [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You cauterize the incision on [organ.get_surgery_name()] with \the [tool].")
	)
	organ.open = 0
	organ.germ_level = 0
	organ.diagnosed = FALSE

/datum/surgery_step/cauterize/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, leaving a small burn on [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, leaving a small burn on [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(0, 3)



/datum/surgery_step/attach_organ
	target_organ_type = /obj/item/organ/internal
	required_tool_quality = QUALITY_CAUTERIZING
	duration = 80
	blood_level = 1

/datum/surgery_step/attach_organ/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	return BP_IS_ORGANIC(organ) && organ.is_open() && (organ.status & ORGAN_CUT_AWAY)

/datum/surgery_step/attach_organ/begin_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts to reattach [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start to reattach [organ.get_surgery_name()] with \the [tool].")
	)

	var/obj/item/organ/external/limb = organ.get_limb()
	if(limb)
		organ.owner_custom_pain("Someone's digging needles into your [limb.name]!", 1)

/datum/surgery_step/attach_organ/end_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] reattaches [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You reattach [organ.get_surgery_name()] with \the [tool].")
	)
	organ.status &= ~ORGAN_CUT_AWAY

/datum/surgery_step/attach_organ/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(5, 0)



/datum/surgery_step/detach_organ
	target_organ_type = /obj/item/organ/internal
	required_tool_quality = QUALITY_CUTTING
	duration = 80
	blood_level = 1

/datum/surgery_step/detach_organ/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	return BP_IS_ORGANIC(organ) && organ.is_open() && !(organ.status & ORGAN_CUT_AWAY)

/datum/surgery_step/detach_organ/begin_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts to separate [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start to separate [organ.get_surgery_name()] with \the [tool].")
	)

	var/obj/item/organ/external/limb = organ.get_limb()
	if(limb)
		organ.owner_custom_pain("The pain in your [limb.name] is living hell!", 1)

/datum/surgery_step/detach_organ/end_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] separates [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You separate [organ.get_surgery_name()] with \the [tool].")
	)
	organ.status |= ORGAN_CUT_AWAY

/datum/surgery_step/detach_organ/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(5, 0)



/datum/surgery_step/remove_item
	required_tool_quality = QUALITY_CLAMPING
	duration = 90

/datum/surgery_step/remove_item/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool, atom/movable/target)
	return BP_IS_ORGANIC(organ) && organ.is_open() && organ.can_remove_item(target)

/datum/surgery_step/remove_item/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool, atom/movable/target)
	user.visible_message(
		SPAN_NOTICE("[user] begins to extract something out of [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You begin to extract [target] out of [organ.get_surgery_name()] with \the [tool].")
	)
	organ.owner_custom_pain("The pain in your [organ.name] is living hell!", 1)

/datum/surgery_step/remove_item/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool, atom/movable/target)
	user.visible_message(
		SPAN_NOTICE("[user] extracts something out of [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You extract [target] out of [organ.get_surgery_name()] with \the [tool].")
	)
	organ.remove_item(target, user)

/datum/surgery_step/remove_item/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool, atom/movable/target)
	user.visible_message(
		SPAN_WARNING("[user] scrapes something inside [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("You scrape something inside [organ.get_surgery_name()] with \the [tool]!")
	)
	if(istype(target, /obj/item/weapon/implant) && prob(25))
		var/obj/item/weapon/implant/imp = target
		imp.malfunction(1)



/datum/surgery_step/amputate
	required_tool_quality = QUALITY_SAWING

	duration = 160
	blood_level = 2

/datum/surgery_step/amputate/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	return BP_IS_ORGANIC(organ) && organ.owner && !organ.cannot_amputate

/datum/surgery_step/amputate/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] is beginning to amputate [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You are beginning to cut through [organ.owner]'s [organ.amputation_point] with \the [tool].")
	)
	organ.owner_custom_pain("Your [organ.amputation_point] is being ripped apart!", 1)

/datum/surgery_step/amputate/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] amputates [organ.get_surgery_name()] at the [organ.amputation_point] with \the [tool]."),
		SPAN_NOTICE("You amputate [organ.get_surgery_name()] with \the [tool].")
	)
	organ.droplimb(TRUE, DROPLIMB_EDGE)

/datum/surgery_step/amputate/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, sawing through the bone in [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, sawing through the bone in [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(30, 0, sharp=TRUE, edge=TRUE)
	organ.fracture()