//Procedures in this file: Robotic limbs attachment, meat limbs attachment
//////////////////////////////////////////////////////////////////
//						LIMB SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/limb/
	priority = 3 // Must be higher than /datum/surgery_step/internal
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected)
			return 0
		var/list/organ_data = target.species.has_limbs["[target_zone]"]
		return !isnull(organ_data)

/datum/surgery_step/limb/attach
	allowed_tools = list(/obj/item/organ/external = 100)

	min_duration = 50
	max_duration = 70

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = tool
		user.visible_message("[user] starts attaching [E.name] to [target]'s [E.amputation_point].", \
		"You start attaching [E.name] to [target]'s [E.amputation_point].")

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = tool
		user.visible_message(SPAN_NOTICE("[user] has attached [target]'s [E.name] to the [E.amputation_point]."),	\
		SPAN_NOTICE("You have attached [target]'s [E.name] to the [E.amputation_point]."))
		user.drop_from_inventory(E)
		E.replaced(target)
		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = tool
		user.visible_message(SPAN_WARNING(" [user]'s hand slips, damaging [target]'s [E.amputation_point]!"), \
		SPAN_WARNING(" Your hand slips, damaging [target]'s [E.amputation_point]!"))
		target.apply_damage(10, BRUTE, null, sharp=1)

/datum/surgery_step/limb/connect
	requedQuality = QUALITY_CLAMPING
	can_infect = 1

	min_duration = 100
	max_duration = 120

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = target.get_organ(target_zone)
		return E && !E.is_stump() && (E.status & ORGAN_DESTROYED)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = target.get_organ(target_zone)
		user.visible_message("[user] starts connecting tendons and muscles in [target]'s [E.amputation_point] with [tool].", \
		"You start connecting tendons and muscle in [target]'s [E.amputation_point].")

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = target.get_organ(target_zone)
		user.visible_message(SPAN_NOTICE("[user] has connected tendons and muscles in [target]'s [E.amputation_point] with [tool]."),	\
		SPAN_NOTICE("You have connected tendons and muscles in [target]'s [E.amputation_point] with [tool]."))
		E.status &= ~ORGAN_DESTROYED
		if(E.children)
			for(var/obj/item/organ/external/C in E.children)
				C.status &= ~ORGAN_DESTROYED
		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = tool
		user.visible_message(SPAN_WARNING(" [user]'s hand slips, damaging [target]'s [E.amputation_point]!"), \
		SPAN_WARNING(" Your hand slips, damaging [target]'s [E.amputation_point]!"))
		target.apply_damage(10, BRUTE, null, sharp=1)

/datum/surgery_step/limb/prosthesis
	allowed_tools = list(/obj/item/prosthesis = 100)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/prosthesis/p = tool
			if (p.part)
				if (!(target_zone in p.part))
					return FALSE
			return isnull(target.get_organ(target_zone))

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message(
			"[user] starts attaching \the [tool] to [target].",
			"You start attaching \the [tool] to [target]."
		)

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/prosthesis/L = tool
		user.visible_message(
			SPAN_NOTICE("[user] has attached \the [tool] to [target]."),
			SPAN_NOTICE("You have attached \the [tool] to [target].")
		)

		if(L.part)
			for(var/part_name in L.part)
				if(target.get_organ(part_name))
					continue
				var/datum/organ_description/organ_data = target.species.has_limbs[part_name]
				if(!organ_data)
					continue
				var/new_limb_type = L.part[part_name]
				new new_limb_type(target, organ_data)

		/*TODO:ORGANS should be called by organ in `installed()` don't forget remove*/
		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()

		qdel(tool)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message(SPAN_WARNING(" [user]'s hand slips, damaging [target]'s flesh!"), \
		SPAN_WARNING(" Your hand slips, damaging [target]'s flesh!"))
		target.apply_damage(10, BRUTE, null, sharp=1)
