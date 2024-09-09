/datum/surgery_step/assisted
	blood_level = 0
	inflict_agony = 30	// Half the tissue, half the pain

/datum/surgery_step/assisted/attach_organ
	target_organ_type = /obj/item/organ/internal
	required_tool_quality = QUALITY_CAUTERIZING
	duration = 80

/datum/surgery_step/assisted/attach_organ/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	return BP_IS_ASSISTED(organ) && organ.is_open() && (organ.status & ORGAN_CUT_AWAY)

/datum/surgery_step/assisted/attach_organ/begin_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts to reattach [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start to reattach [organ.get_surgery_name()] with \the [tool].")
	)

	var/obj/item/organ/external/limb = organ.get_limb()
	if(limb)
		organ.owner_custom_pain("Someone's digging needles into your [limb.name]!", 1)

/datum/surgery_step/assisted/attach_organ/end_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] reattaches [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You reattach [organ.get_surgery_name()] with \the [tool].")
	)

	organ.status &= ~ORGAN_CUT_AWAY
	organ.handle_organ_eff() //organ is attached. Refreshing eff. list

/datum/surgery_step/assisted/attach_organ/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(16, BRUTE)

/datum/surgery_step/assisted/detach_organ
	target_organ_type = /obj/item/organ/internal
	required_tool_quality = QUALITY_CUTTING
	duration = 80

/datum/surgery_step/assisted/detach_organ/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	return BP_IS_ASSISTED(organ) && organ.is_open() && !(organ.status & ORGAN_CUT_AWAY)

/datum/surgery_step/assisted/detach_organ/begin_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts to separate [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start to separate [organ.get_surgery_name()] with \the [tool].")
	)

	var/obj/item/organ/external/limb = organ.get_limb()
	if(limb)
		organ.owner_custom_pain("The pain in your [limb.name] is living hell!", 1)

/datum/surgery_step/assisted/detach_organ/end_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] separates [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You separate [organ.get_surgery_name()] with \the [tool].")
	)
	organ.status |= ORGAN_CUT_AWAY
	organ.handle_organ_eff() //detach of organ. Refreshing eff. list

/datum/surgery_step/assisted/detach_organ/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(16, BRUTE)

/datum/surgery_step/assisted/break_bone
	target_organ_type = /obj/item/organ/internal/bone
	required_tool_quality = QUALITY_HAMMERING
	duration = 80

/datum/surgery_step/assisted/break_bone/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	return BP_IS_ASSISTED(organ) && organ.is_open() && !(organ.parent.status & ORGAN_BROKEN)

/datum/surgery_step/assisted/break_bone/begin_step(mob/living/user, obj/item/organ/internal/bone/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts breaking [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start breaking [organ.get_surgery_name()] with \the [tool].")
	)

	organ.owner_custom_pain("The pain in your [organ.name] is living hell!", 1)

/datum/surgery_step/assisted/break_bone/end_step(mob/living/user, obj/item/organ/internal/bone/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] breaks [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You break [organ.get_surgery_name()] with \the [tool].")
	)
	organ.fracture()

/datum/surgery_step/assisted/break_bone/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, scraping [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, scraping [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(8, BRUTE, sharp = TRUE)

/datum/surgery_step/assisted/mend_bone
	target_organ_type = /obj/item/organ/internal
	required_tool_quality = QUALITY_BONE_SETTING
	duration = 100

/datum/surgery_step/assisted/mend_bone/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	. = BP_IS_ASSISTED(organ) && organ.is_open() && (organ.parent.status & ORGAN_BROKEN)

	// Otherwise, it will just immediately fracture again
	if(. && organ.parent.should_fracture())
		to_chat(user, SPAN_WARNING("[organ.parent.get_surgery_name()] is too damaged!"))
		return FALSE

	return .

/datum/surgery_step/assisted/mend_bone/begin_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts mending [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start mending [organ.get_surgery_name()] with \the [tool].")
	)

	organ.owner_custom_pain("The pain in your [organ.name] is living hell!", 1)

/datum/surgery_step/assisted/mend_bone/end_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_NOTICE("[user] mends [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You mend [organ.get_surgery_name()] with \the [tool].")
	)
	organ.mend()

/datum/surgery_step/assisted/mend_bone/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/stack/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, scraping [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, scraping [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(8, BRUTE)

/datum/surgery_step/assisted/replace_bone
	target_organ_type = /obj/item/organ/internal
	allowed_tools = list(/obj/item/organ/internal/bone = 75) //Bone replacement surgery is hard
	duration = 120

/datum/surgery_step/assisted/replace_bone/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/tool)
	var/obj/item/organ/internal/bone/B = tool
	return BP_IS_ASSISTED(organ) && organ.is_open() && istype(B) && B.organ_tag == organ.organ_tag

/datum/surgery_step/assisted/replace_bone/begin_step(mob/living/user, obj/item/organ/internal/bone/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts replacing [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You start replacing [organ.get_surgery_name()] with \the [tool].")
	)

	organ.owner_custom_pain("The pain in your [organ.name] is living hell!", 1)

/datum/surgery_step/assisted/replace_bone/end_step(mob/living/user, obj/item/organ/internal/bone/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] replaces [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You replace [organ.get_surgery_name()] with \the [tool].")
	)
	if(istype(tool, /obj/item/organ/internal/bone))
		var/obj/item/organ/internal/replacement = tool
		var/obj/item/organ/external/bone_parent = organ.parent
		if(bone_parent)
			organ.removed()
			replacement.status &= ~ORGAN_CUT_AWAY
			bone_parent.add_item(replacement, user, FALSE)
			bone_parent.handle_bones()

/datum/surgery_step/assisted/replace_bone/fail_step(mob/living/user, obj/item/organ/internal/bone/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, breaking [organ.get_surgery_name()]!"),
		SPAN_WARNING("Your hand slips, breaking [organ.get_surgery_name()]!")
	)
	organ.fracture()
