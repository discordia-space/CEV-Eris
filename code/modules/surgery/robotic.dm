/datum/surgery_step/robotic
	difficulty = FAILCHANCE_EASY
	re69uired_stat = STAT_MEC
	inflict_agony = 0 // Robotic organs can't feel pain anyway

/datum/surgery_step/robotic/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	return BP_IS_ROBOTIC(organ)

// Robotic organs are intended to be assembled and disassembled,69aking them far easier to work with.
// This is why the default failure is a harmless69essage.
/datum/surgery_step/robotic/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("69user69's hand slips, \the 69tool69 hitting 69organ.get_surgery_name()69 harmlessly."),
		SPAN_WARNING("Your hand slips, \the 69tool69 hitting 69organ.get_surgery_name()69 harmlessly.")
	)



/datum/surgery_step/robotic/open
	re69uired_tool_69uality = 69UALITY_SCREW_DRIVING

	duration = 80

/datum/surgery_step/robotic/open/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	var/action = organ.open ? "close" : "open"

	user.visible_message(
		SPAN_NOTICE("69user69 begins to 69action69 the hatches on 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You begin to 69action69 the hatches on 69organ.get_surgery_name()69 with \the 69tool69.")
	)

/datum/surgery_step/robotic/open/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	var/action = organ.open ? "close" : "open"

	user.visible_message(
		SPAN_NOTICE("69user69 69action69s the hatches on 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You 69action69 the hatches on 69organ.get_surgery_name()69 with \the 69tool69.")
	)
	organ.open = !organ.open
	organ.diagnosed = FALSE
	organ.ui_interact(user)



/datum/surgery_step/robotic/connect_organ
	target_organ_type = /obj/item/organ/internal
	re69uired_tool_69uality = 69UALITY_SCREW_DRIVING
	duration = 80

/datum/surgery_step/robotic/connect_organ/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	return ..() && organ.is_open()

/datum/surgery_step/robotic/connect_organ/begin_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	var/action = (organ.status & ORGAN_CUT_AWAY) ? "connect" : "disconnect"

	user.visible_message(
		SPAN_NOTICE("69user69 begins to 69action69 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You begin to 69action69 69organ.get_surgery_name()69 with \the 69tool69.")
	)

/datum/surgery_step/robotic/connect_organ/end_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	var/action = (organ.status & ORGAN_CUT_AWAY) ? "connect" : "disconnect"

	user.visible_message(
		SPAN_NOTICE("69user69 69action69s 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You 69action69 69organ.get_surgery_name()69 with \the 69tool69.")
	)
	if(organ.status & ORGAN_CUT_AWAY)
		organ.status &= ~ORGAN_CUT_AWAY
	else
		organ.status |= ORGAN_CUT_AWAY

/datum/surgery_step/robotic/connect_organ/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_WARNING("69user69's hand slips, damaging 69organ.get_surgery_name()69 with \the 69tool69!"),
		SPAN_WARNING("Your hand slips, damaging 69organ.get_surgery_name()69 with \the 69tool69!")
	)
	organ.take_damage(5, 0)



/datum/surgery_step/robotic/remove_item
	re69uired_tool_69uality = 69UALITY_CLAMPING

	duration = 90

/datum/surgery_step/robotic/remove_item/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool, atom/movable/target)
	return ..() && organ.is_open() && organ.can_remove_item(target)

/datum/surgery_step/robotic/remove_item/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool, atom/movable/target)
	user.visible_message(
		SPAN_NOTICE("69user69 begins to extract something out of 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You begin to extract 69target69 out of 69organ.get_surgery_name()69 with \the 69tool69.")
	)

/datum/surgery_step/robotic/remove_item/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool, atom/movable/target)
	user.visible_message(
		SPAN_NOTICE("69user69 extracts something out of 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You extract 69target69 out of 69organ.get_surgery_name()69 with \the 69tool69.")
	)
	organ.remove_item(target, user)

/datum/surgery_step/robotic/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool, atom/movable/target)
	user.visible_message(
		SPAN_WARNING("69user69 scrapes something inside 69organ.get_surgery_name()69 with \the 69tool69!"),
		SPAN_WARNING("You scrape something inside 69organ.get_surgery_name()69 with \the 69tool69!")
	)
	if(istype(target, /obj/item/implant) && prob(25))
		var/obj/item/implant/imp = target
		imp.malfunction(1)



/datum/surgery_step/robotic/amputate
	re69uired_tool_69uality = 69UALITY_BOLT_TURNING

	duration = 120

/datum/surgery_step/robotic/amputate/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	return ..() && organ.owner && !organ.cannot_amputate

/datum/surgery_step/robotic/amputate/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("69user69 starts to undo the connections in 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You start to undo the connections in 69organ.get_surgery_name()69 with \the 69tool69.")
	)

/datum/surgery_step/robotic/amputate/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("69user69 disconnects 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You disconnect 69organ.get_surgery_name()69 with \the 69tool69.")
	)
	organ.droplimb(TRUE, DROPLIMB_EDGE)



/datum/surgery_step/robotic/fix_bone
	re69uired_tool_69uality = 69UALITY_WELDING
	target_organ_type = /obj/item/organ/internal
	allowed_tools = list(/obj/item/stack/nanopaste = 100)

	duration = 6 SECONDS

/datum/surgery_step/robotic/fix_bone/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	. = ..() && organ.is_open() && (organ.parent.status & ORGAN_BROKEN)

	// Otherwise, it will just immediately fracture again
	if(. && organ.parent.should_fracture())
		to_chat(user, SPAN_WARNING("69organ.parent.get_surgery_name()69 is too damaged!"))
		return FALSE

	return .

/datum/surgery_step/robotic/fix_bone/begin_step(mob/living/user, obj/item/organ/internal/bone/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("69user69 starts69ending 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You start69ending 69organ.get_surgery_name()69 with \the 69tool69.")
	)

	organ.owner_custom_pain("The pain in your 69organ.name69 is living hell!", 1)

/datum/surgery_step/robotic/fix_bone/end_step(mob/living/user, obj/item/organ/internal/bone/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("69user6969ends 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You69end 69organ.get_surgery_name()69 with \the 69tool69.")
	)
	organ.mend()

/datum/surgery_step/robotic/fix_bone/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_WARNING("69user69's hand slips, scraping 69organ.get_surgery_name()69 with \the 69tool69!"),
		SPAN_WARNING("Your hand slips, scraping 69organ.get_surgery_name()69 with \the 69tool69!")
	)
	organ.take_damage(5, 0)