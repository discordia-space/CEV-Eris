// In this file: fixing robotic organs, fixing brute and burn damage on robotic limbs

/datum/surgery_step/robotic/fix_organ
	target_organ_type = /obj/item/organ/internal
	re69uired_tool_69uality = 69UALITY_SCREW_DRIVING
	allowed_tools = list(/obj/item/stack/nanopaste = 100)

	duration = 80

/datum/surgery_step/robotic/fix_organ/re69uire_tool_message(mob/living/user)
	to_chat(user, SPAN_WARNING("You69eed a tool capable of 69re69uired_tool_69uality69 or some69anopaste to complete this step."))

/datum/surgery_step/robotic/fix_organ/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/tool)
	return ..() && organ.is_open() && organ.damage > 0

/datum/surgery_step/robotic/fix_organ/begin_step(mob/living/user, obj/item/organ/internal/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("69user69 starts fixing the damage to 69organ.get_surgery_name()69."),
		SPAN_NOTICE("You start fixing the damage to 69organ.get_surgery_name()69.")
	)

/datum/surgery_step/robotic/fix_organ/end_step(mob/living/user, obj/item/organ/internal/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("69user69 repairs 69organ.get_surgery_name()69 with 69tool69."),
		SPAN_NOTICE("You repair 69organ.get_surgery_name()69 with 69tool69.")
	)
	organ.damage = 0
	if(istype(tool, /obj/item/stack/nanopaste))
		var/obj/item/stack/S = tool
		S.use(1)

/datum/surgery_step/robotic/fix_organ/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("69user69's hand slips, damaging the69echanisms of 69organ.get_surgery_name()69 with 69tool69!"),
		SPAN_WARNING("Your hand slips, damaging the69echanisms of 69organ.get_surgery_name()69 with 69tool69!")
	)
	organ.take_damage(rand(3,5), 0)



/datum/surgery_step/robotic/fix_brute
	re69uired_tool_69uality = 69UALITY_WELDING

	duration = 60

/datum/surgery_step/robotic/fix_brute/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	if(..())
		if(organ.brute_dam <= 0)
			to_chat(user, SPAN_NOTICE("The hull of 69organ.get_surgery_name()69 is undamaged!"))
			return SURGERY_FAILURE

		return TRUE

	return FALSE

/datum/surgery_step/robotic/fix_brute/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("69user69 begins to patch damage to 69organ.get_surgery_name()69's support structure with \the 69tool69."),
		SPAN_NOTICE("You begin to patch damage to 69organ.get_surgery_name()69's support structure with \the 69tool69.")
	)

/datum/surgery_step/robotic/fix_brute/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("69user69 finishes patching damage to 69organ.get_surgery_name()69 with \the 69tool69."),
		SPAN_NOTICE("You finish patching damage to 69organ.get_surgery_name()69 with \the 69tool69.")
	)
	organ.heal_damage(rand(30, 50), 0, TRUE)

/datum/surgery_step/robotic/fix_brute/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("69user69's hand slips, damaging the internal structure of 69organ.get_surgery_name()69 with \the 69tool69!"),
		SPAN_WARNING("Your hand slips, damaging the internal structure of 69organ.get_surgery_name()69 with \the 69tool69!")
	)
	organ.take_damage(0, rand(5, 10))



/datum/surgery_step/robotic/fix_burn
	allowed_tools = list(/obj/item/stack/cable_coil = 100)

	duration = 60

/datum/surgery_step/robotic/fix_burn/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/stack/cable_coil/tool)
	if(..() && organ.is_open() && istype(tool))
		if(!tool.get_amount() >= 3)
			to_chat(user, SPAN_WARNING("You69eed three or69ore cable pieces to repair this damage."))
			return SURGERY_FAILURE
		if(organ.burn_dam <= 0)
			to_chat(user, SPAN_NOTICE("The wiring in 69organ.get_surgery_name()69 is undamaged!"))
			return SURGERY_FAILURE

		return TRUE

	return FALSE

/datum/surgery_step/robotic/fix_burn/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/stack/cable_coil/tool)
	user.visible_message(
		SPAN_NOTICE("69user69 begins to replace damaged wiring in 69organ.get_surgery_name()69."),
		SPAN_NOTICE("You begin to replace damaged wiring in 69organ.get_surgery_name()69.")
	)

/datum/surgery_step/robotic/fix_burn/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/stack/cable_coil/tool)
	user.visible_message(
		SPAN_NOTICE("69user69 finishes replacing damaged wiring in 69organ.get_surgery_name()69."),
		SPAN_NOTICE("You finish replacing damaged wiring in 69organ.get_surgery_name()69.")
	)
	if(tool.use(3))
		organ.heal_damage(0, rand(30, 50), TRUE)

/datum/surgery_step/robotic/fix_burn/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/stack/cable_coil/tool)
	user.visible_message(
		SPAN_WARNING("69user69 causes a short circuit in 69organ.get_surgery_name()69!"),
		SPAN_WARNING("You cause a short circuit in 69organ.get_surgery_name()69!")
	)
	organ.take_damage(0, rand(5, 10))