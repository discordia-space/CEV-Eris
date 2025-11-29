// In this file: fixing robotic organs, fixing brute and burn damage on robotic limbs

/datum/surgery_step/robotic/fix_organ
	target_organ_type = /obj/item/organ/internal
	required_tool_quality = QUALITY_SCREW_DRIVING
	allowed_tools = list(/obj/item/stack/nanopaste = 100)

	duration = 80

/datum/surgery_step/robotic/fix_organ/require_tool_message(mob/living/user)
	to_chat(user, SPAN_WARNING("You need a tool capable of [required_tool_quality] or some nanopaste to complete this step."))

/datum/surgery_step/robotic/fix_organ/can_use(mob/living/user, obj/item/organ/internal/organ, obj/item/tool)
	return ..() && organ.is_open() && organ.damage > 0

/datum/surgery_step/robotic/fix_organ/begin_step(mob/living/user, obj/item/organ/internal/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] starts fixing the damage to [organ.get_surgery_name()]."),
		SPAN_NOTICE("You start fixing the damage to [organ.get_surgery_name()].")
	)

/datum/surgery_step/robotic/fix_organ/end_step(mob/living/user, obj/item/organ/internal/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] repairs [organ.get_surgery_name()] with [tool]."),
		SPAN_NOTICE("You repair [organ.get_surgery_name()] with [tool].")
	)
	organ.damage = 0
	if(istype(tool, /obj/item/stack/nanopaste))
		var/obj/item/stack/S = tool
		S.use(1)

/datum/surgery_step/robotic/fix_organ/fail_step(mob/living/user, obj/item/organ/internal/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging the mechanisms of [organ.get_surgery_name()] with [tool]!"),
		SPAN_WARNING("Your hand slips, damaging the mechanisms of [organ.get_surgery_name()] with [tool]!")
	)
	organ.take_damage(rand(5,15), 0)



/datum/surgery_step/robotic/fix_brute
	required_tool_quality = QUALITY_WELDING

	duration = 60

/datum/surgery_step/robotic/fix_brute/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	if(..())
		if(organ.brute_dam <= 0)
			to_chat(user, SPAN_NOTICE("The hull of [organ.get_surgery_name()] is undamaged!"))
			return FALSE

		return TRUE

	return FALSE

/datum/surgery_step/robotic/fix_brute/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] begins to patch damage to [organ.get_surgery_name()]'s support structure with \the [tool]."),
		SPAN_NOTICE("You begin to patch damage to [organ.get_surgery_name()]'s support structure with \the [tool].")
	)

/datum/surgery_step/robotic/fix_brute/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] finishes patching damage to [organ.get_surgery_name()] with \the [tool]."),
		SPAN_NOTICE("You finish patching damage to [organ.get_surgery_name()] with \the [tool].")
	)
	organ.heal_damage(rand(30, 50), 0, TRUE)

/datum/surgery_step/robotic/fix_brute/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips, damaging the internal structure of [organ.get_surgery_name()] with \the [tool]!"),
		SPAN_WARNING("Your hand slips, damaging the internal structure of [organ.get_surgery_name()] with \the [tool]!")
	)
	organ.take_damage(0, rand(5, 10))



/datum/surgery_step/robotic/fix_burn
	allowed_tools = list(/obj/item/stack/cable_coil = 100)

	duration = 60

/datum/surgery_step/robotic/fix_burn/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/stack/cable_coil/tool)
	if(..() && organ.is_open() && istype(tool))
		if(!tool.get_amount() >= 3)
			to_chat(user, SPAN_WARNING("You need three or more cable pieces to repair this damage."))
			return SURGERY_FAILURE
		if(organ.burn_dam <= 0)
			to_chat(user, SPAN_NOTICE("The wiring in [organ.get_surgery_name()] is undamaged!"))
			return SURGERY_FAILURE

		return TRUE

	return FALSE

/datum/surgery_step/robotic/fix_burn/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/stack/cable_coil/tool)
	user.visible_message(
		SPAN_NOTICE("[user] begins to replace damaged wiring in [organ.get_surgery_name()]."),
		SPAN_NOTICE("You begin to replace damaged wiring in [organ.get_surgery_name()].")
	)

/datum/surgery_step/robotic/fix_burn/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/stack/cable_coil/tool)
	user.visible_message(
		SPAN_NOTICE("[user] finishes replacing damaged wiring in [organ.get_surgery_name()]."),
		SPAN_NOTICE("You finish replacing damaged wiring in [organ.get_surgery_name()].")
	)
	if(tool.use(3))
		organ.heal_damage(0, rand(30, 50), TRUE)

/datum/surgery_step/robotic/fix_burn/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/stack/cable_coil/tool)
	user.visible_message(
		SPAN_WARNING("[user] causes a short circuit in [organ.get_surgery_name()]!"),
		SPAN_WARNING("You cause a short circuit in [organ.get_surgery_name()]!")
	)
	organ.take_damage(0, rand(5, 10))

/datum/surgery_step/robotic/patch_malfunction
	required_tool_quality = QUALITY_ADHESIVE

	duration = 60

/datum/surgery_step/robotic/patch_malfunction/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	if(..())
		if(!istype(organ, /obj/item/organ/external/robotic))
			return FALSE
		var/obj/item/organ/external/robotic/tofix = organ
		if(organ.brute_dam + organ.burn_dam <= tofix.min_malfunction_damage)
			to_chat(user, SPAN_NOTICE("[organ.get_surgery_name()] isn't damaged enough!"))
			return FALSE

		return TRUE

	return FALSE

/datum/surgery_step/robotic/patch_malfunction/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] begins to glue [organ.get_surgery_name()] back together with [tool]."),
		SPAN_NOTICE("You begin to glue [organ.get_surgery_name()] back together with [tool].")
	)

/datum/surgery_step/robotic/patch_malfunction/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_NOTICE("[user] finishes gluing [organ.get_surgery_name()] together with [tool]."),
		SPAN_NOTICE("You finish glueing [organ.get_surgery_name()] together with [tool].")
	)
	if(!istype(organ, /obj/item/organ/external/robotic))
		return
	var/obj/item/organ/external/robotic/tofix = organ
	var/healpool = max(0, tofix.max_damage / 2 - tofix.min_malfunction_damage) // amount of damage that can effectively be taken AFTER malfunction chance reaches +0, halved
	var/brutepool = min(tofix.brute_dam, healpool) // brute is easier to fix with tape
	healpool -= brutepool
	var/burnpool = min(tofix.burn_dam, healpool/4) // only a quarter efficiency against burn
	var/excess = brutepool + burnpool - tofix.brute_dam - tofix.burn_dam + tofix.min_malfunction_damage // cannot heal past malfunction +0
	var/oldbrutepool = brutepool
	brutepool = max( 0, brutepool-excess)
	excess = max(0, excess - oldbrutepool)
	burnpool = max(0, burnpool - excess)
	organ.heal_damage(brutepool, burnpool, TRUE)

/datum/surgery_step/robotic/patch_malfunction/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user] fails to patch [organ.get_surgery_name()]!"),
		SPAN_WARNING("You waste your efforts attempting to glue [organ.get_surgery_name()] back together with [tool]!")
	)
	