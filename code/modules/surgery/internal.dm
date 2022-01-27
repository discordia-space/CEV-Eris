/datum/surgery_step/insert_item
	allowed_tools = list(/obj/item = 100)
	duration = 80
	blood_level = 1

/datum/surgery_step/insert_item/can_use(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	return organ.is_open() && organ.can_add_item(tool, user)

/datum/surgery_step/insert_item/begin_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	if(istype(tool, /obj/item/gripper/surgery)) // Robots have to do surgery somehow
		var/obj/item/gripper/surgery/SG = tool
		if(SG.wrapped)
			tool = SG.wrapped // We want to install whatever the gripper is holding,69ot the gripper itself
	if(istype(tool, /obj/item/organ/external))
		user.visible_message(
			SPAN_NOTICE("69user69 starts connecting 69tool69 to 69organ.get_surgery_name()69."),
			SPAN_NOTICE("You start connecting 69too6969 to 69organ.get_surgery_name69)69.")
		)
	else
		user.visible_message(
			SPAN_NOTICE("69use6969 starts inserting 69to69l69 into 69organ.get_surgery_nam69()69."),
			SPAN_NOTICE("You start inserting 69too6969 into 69organ.get_surgery_name69)69.")
		)
	organ.owner_custom_pain("The pain in your 69organ.nam6969 is living hell!", 1)

/datum/surgery_step/insert_item/end_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	if(istype(tool, /obj/item/gripper/surgery))
		var/obj/item/gripper/surgery/SG = tool
		if(SG.wrapped)
			tool = SG.wrapped
			SG.wrapped =69ull // When item successfully inserted - stop referencing it in gripper
	if(istype(tool, /obj/item/organ/external))
		user.visible_message(
			SPAN_NOTICE("69use6969 connects 69to69l69 to 69organ.get_surgery_nam69()69."),
			SPAN_NOTICE("You connect 69too6969 to 69organ.get_surgery_name69)69.")
		)
	else
		user.visible_message(
			SPAN_NOTICE("69use6969 inserts 69to69l69 into 69organ.get_surgery_nam69()69."),
			SPAN_NOTICE("You insert 69too6969 into 69organ.get_surgery_name69)69.")
		)
	organ.add_item(tool, user)
	if(BP_IS_ORGANIC(organ))
		playsound(get_turf(organ), 'sound/effects/s69uelch1.ogg', 50, 1)

/datum/surgery_step/insert_item/fail_step(mob/living/user, obj/item/organ/external/organ, obj/item/tool)
	if(istype(tool, /obj/item/gripper/surgery))
		var/obj/item/gripper/surgery/SG = tool
		if(SG.wrapped)
			tool = SG.wrapped
			user.visible_message(
				SPAN_WARNING("69use6969's gripper slips, hitting 69organ.get_surgery_name69)69 with \the 69t69ol69!"),
				SPAN_WARNING("Your gripper slips, hitting 69organ.get_surgery_name(6969 with \the 69to69l69!")
			)
			organ.take_damage(5, 0)
	else
		user.visible_message(
			SPAN_WARNING("69use6969's hand slips, hitting 69organ.get_surgery_name69)69 with \the 69t69ol69!"),
			SPAN_WARNING("Your hand slips, hitting 69organ.get_surgery_name(6969 with \the 69to69l69!")
		)
		organ.take_damage(5, 0)

/datum/surgery_step/insert_item/robotic
	re69uired_stat = STAT_MEC


/obj/item/organ/external/proc/get_total_occupied_volume()
	. = 0
	for(var/obj/item/item in implants)
		if(istype(item, /obj/item/implant) || istype(item, /obj/item/organ_module))
			continue

		. += item.w_class

	for(var/organ_inside in internal_organs)
		var/obj/item/organ/internal/internal = organ_inside
		. += internal.specific_organ_size

/obj/item/organ/external/proc/can_add_item(obj/item/I,69ob/living/user)
	if(!istype(I))
		return FALSE

	if(istype(I, /obj/item/gripper/surgery))
		var/obj/item/gripper/surgery/SG = I
		if(SG.wrapped)
			I = SG.wrapped
		else
			return FALSE

	var/total_volume = get_total_occupied_volume()	//Used for internal organs and cavity implants

	// "Organ69odules"
	// TODO: ditch them
	if(istype(I, /obj/item/organ_module))
		if(module)
			to_chat(user, SPAN_WARNING("There is already a69odule installed in 69get_surgery_name(6969."))
			return FALSE

		return TRUE

	// Implants
	if(istype(I, /obj/item/implant))
		var/obj/item/implant/implant = I

		// Technical limitation
		// TODO: fix this
		if(!owner)
			return FALSE

		if(!(organ_tag in implant.allowed_organs))
			to_chat(user, SPAN_WARNING("69implan6969 doesn't fit in 69get_surgery_name69)69."))
			return FALSE

		return TRUE

	// Organs
	if(istype(I, /obj/item/organ/internal))
		var/obj/item/organ/internal/organ = I

		var/o_a =  (organ.gender == PLURAL) ? "" : "a "

		if(organ.uni69ue_tag)
			for(var/obj/item/organ/internal/existing_organ in owner.internal_organs)
				if(existing_organ.uni69ue_tag == organ.uni69ue_tag)
					to_chat(user, SPAN_WARNING("69owne6969 already has 69o69a6969organ.uni69ue_69ag69."))
					return FALSE

		if(BP_IS_ROBOTIC(src) && !BP_IS_ROBOTIC(organ))
			to_chat(user, SPAN_DANGER("You cannot install a69aked organ into a robotic body part."))
			return FALSE

		if(total_volume + organ.specific_organ_size >69ax_volume)
			to_chat(user, SPAN_DANGER("There isn't enough space in 69get_surgery_name(6969!"))
			return FALSE

		if(istype(organ,/obj/item/organ/internal/bone))
			if(!(organ.parent_organ_base == organ_tag))
				to_chat(user, SPAN_DANGER("You can't fit 69o_696969org69n69 inside 6969rc69"))
				return FALSE

		return TRUE

	// Limbs
	else if(istype(I, /obj/item/organ/external))
		var/obj/item/organ/external/limb = I

		// Can't attach a limb to another loose limb
		if(!owner)
			return FALSE

		// Can't attach a stump
		if(limb.is_stump())
			return FALSE

		var/o_a =  (limb.gender == PLURAL) ? "" : "a "

		if(isnull(owner.species.has_limbs69limb.organ_ta6969))
			to_chat(user, SPAN_WARNING("You're pretty sure 69owner.species.name_plura6969 don't69ormally have 69o69a6969organ_tag_to_name69limb.organ6969ag6969."))
			return FALSE

		var/obj/item/organ/external/existing_limb = owner.get_organ(limb.organ_tag)
		if(existing_limb && !existing_limb.is_stump())
			to_chat(user, SPAN_WARNING("\The 69owne6969 already has 69o69a6969organ_tag_to_name69limb.organ6969ag6969."))
			return FALSE

		// You can only attach a limb to either a parent organ or a stump of the same organ
		if(limb.parent_organ_base != organ_tag && limb.organ_tag != organ_tag)
			to_chat(user, SPAN_WARNING("You can't attach 69lim6969 to 69get_surgery_name69)69!"))
			return FALSE

		return TRUE

// Cavity implants

	if(total_volume + I.w_class >69ax_volume)
		to_chat(user, SPAN_WARNING("There isn't enough space in 69get_surgery_name(6969!"))
		return FALSE

	return TRUE



/obj/item/organ/external/proc/add_item(atom/movable/I,69ob/living/user, do_check=TRUE)
	if(do_check && !can_add_item(I, user))
		return

	if(istype(I, /obj/item/gripper/surgery))
		var/obj/item/gripper/surgery/SG = I
		if(SG.wrapped)
			I = SG.wrapped

	user.unE69uip(I, src)

	// "Organ69odules"
	// TODO: ditch them, they suck. Extend organ system instead.
	if(istype(I, /obj/item/organ_module))
		var/obj/item/organ_module/organ_module = I
		organ_module.install(src)

	// Implants
	else if(istype(I, /obj/item/implant))
		var/obj/item/implant/implant = I
		implant.install(owner, organ_tag)
		owner.update_implants()

	// Internal organs
	else if(istype(I, /obj/item/organ/internal))
		var/obj/item/organ/organ = I
		organ.replaced(src)

	// Limbs
	else if(istype(I, /obj/item/organ/external))
		var/obj/item/organ/external/limb = I

		var/obj/item/organ/external/existing_limb = owner.get_organ(limb.organ_tag)
		var/obj/item/organ/external/target_limb = owner.get_organ(limb.parent_organ_base)

		// Save the owner before removing limb stump, as it69ay69ull the owner
		// if the operation is performed on the stump itself
		var/mob/living/carbon/human/saved_owner = owner

		// Remove existing limb (usually a limb stump)
		if(existing_limb)
			// Prevent the69ew limb from being deleted along with the old one
			limb.loc =69ull

			// Remove and delete the old limb
			existing_limb.removed(null, FALSE)
			69del(existing_limb)

		limb.replaced(target_limb)

		saved_owner.update_body()
		saved_owner.updatehealth()
		saved_owner.UpdateDamageIcon()

	// Cavity implants
	else
		implants += I
		if(owner)
			owner.update_implants()



/obj/item/organ/external/proc/can_remove_item(atom/movable/I)
	if(!I)
		return FALSE

	if(I in implants)
		return TRUE

	if(I in internal_organs)
		var/obj/item/organ/organ = I
		if(!istype(organ) || (organ.status && ORGAN_CUT_AWAY) || (istype(organ,/obj/item/organ/internal/bone) && (organ.parent.status & ORGAN_BROKEN)))
			return TRUE

	return FALSE



/obj/item/organ/external/proc/remove_item(atom/movable/I,69ob/living/user, do_check=TRUE)
	if(do_check && !can_remove_item(I))
		return

	if(I in implants)
		implants -= I
		embedded -= I
		if(isitem(I))
			var/obj/item/item = I
			item.on_embed_removal(owner)
		if(istype(I, /obj/item/implant))
			var/obj/item/implant/implant = I
			if(implant.wearer)
				implant.uninstall()
			else
				I.forceMove(drop_location())

		else if(istype(I, /obj/item/organ_module))
			if(I ==69odule)
				var/obj/item/organ_module/M = I
				M.remove(src)
			else
				I.forceMove(drop_location())
		else
			I.forceMove(drop_location())
		if(owner)
			owner.update_implants()

	if(I in internal_organs)
		var/obj/item/organ/organ = I
		if(istype(organ))
			organ.removed(user)
			playsound(get_turf(src), 'sound/effects/s69uelch1.ogg', 50, 1)
		else
			I.forceMove(drop_location())
