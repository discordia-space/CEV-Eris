//Procedures in this file: Putting items in body cavity. Implant removal. Items removal.

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/cavity
	priority = 1
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == (affected.encased ? 3 : 2) && !(affected.status & ORGAN_BLEEDING)

	proc/get_max_wclass(var/obj/item/organ/external/affected)
		switch (affected.organ_tag)
			if(BP_HEAD)
				return 1
			if(BP_CHEST)
				return 3
			if(BP_GROIN)
				return 2
		return 0

	proc/get_cavity(var/obj/item/organ/external/affected)
		switch (affected.organ_tag)
			if(BP_HEAD)
				return "cranial"
			if(BP_CHEST)
				return "thoracic"
			if(BP_GROIN)
				return "abdominal"
		return ""

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
		user.visible_message("\red [user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!", \
		"\red Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!")
		affected.createwound(CUT, 20)

/datum/surgery_step/cavity/make_space
	requedQuality = QUALITY_DRILLING

	min_duration = 60
	max_duration = 80

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && !affected.cavity

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].", \
		"You start making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool]." )
		target.custom_pain("The pain in your chest is living hell!",1)
		affected.cavity = 1
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] makes some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].", \
		"\blue You make some space inside [target]'s [get_cavity(affected)] cavity with \the [tool]." )

/datum/surgery_step/cavity/close_space
	priority = 2
	requedQuality = QUALITY_CAUTERIZING

	min_duration = 60
	max_duration = 80

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.cavity

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts mending [target]'s [get_cavity(affected)] cavity wall with \the [tool].", \
		"You start mending [target]'s [get_cavity(affected)] cavity wall with \the [tool]." )
		target.custom_pain("The pain in your chest is living hell!",1)
		affected.cavity = 0
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
		user.visible_message("\blue [user] mends [target]'s [get_cavity(affected)] cavity walls with \the [tool].", \
		"\blue You mend [target]'s [get_cavity(affected)] cavity walls with \the [tool]." )

/datum/surgery_step/cavity/place_item
	priority = 0
	allowed_tools = list(/obj/item = 100)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			if(isrobot(user))
				return
			if(affected && affected.cavity)
				var/total_volume = tool.w_class
				for(var/obj/item/I in affected.implants)
					if(istype(I,/obj/item/weapon/implant))
						continue
					total_volume += I.w_class
				return total_volume <= get_max_wclass(affected)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts putting \the [tool] inside [target]'s [get_cavity(affected)] cavity.", \
		"You start putting \the [tool] inside [target]'s [get_cavity(affected)] cavity." )
		target.custom_pain("The pain in your chest is living hell!",1)
		playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

		user.visible_message("\blue [user] puts \the [tool] inside [target]'s [get_cavity(affected)] cavity.", \
		"\blue You put \the [tool] inside [target]'s [get_cavity(affected)] cavity." )
		if (tool.w_class > get_max_wclass(affected)/2 && prob(50) && !BP_IS_ROBOTIC(affected))
			to_chat(user, "\red You tear some blood vessels trying to fit such a big object in this cavity.")
			var/datum/wound/internal_bleeding/I = new (10)
			affected.wounds += I
			affected.owner.custom_pain("You feel something rip in your [affected.name]!", 1)
		user.drop_item()
		affected.implants += tool
		target.update_implants()
		tool.loc = affected
		affected.cavity = 0

//////////////////////////////////////////////////////////////////
//					IMPLANT/ITEM REMOVAL SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/cavity/implant_removal
	requedQuality = QUALITY_CLAMPING

	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/implant_removal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	//A somewhat hacky solution
	//Disallow this if the target has internal bleeding, so that can be fixed first instead
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return FALSE
	for(var/datum/wound/W in affected.wounds) if(W.internal)
		return FALSE

	var/obj/item/organ/internal/brain/sponge = target.internal_organs_by_name[BP_BRAIN]
	return ..() && (!sponge || !sponge.damage)

/datum/surgery_step/cavity/implant_removal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts poking around inside [target]'s [affected.name] with \the [tool].", \
	"You start poking around inside [target]'s [affected.name] with \the [tool]" )
	target.custom_pain("The pain in your [affected.name] is living hell!",1)
	..()

/datum/surgery_step/cavity/implant_removal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

	var/find_prob = 0

	if (affected.implants.len)
		var/list/implants = list()

		for(var/obj/item/I in affected.implants)
			if(istype(I,/obj/item/weapon/implant))
				var/obj/item/weapon/implant/IM = I
				if(IM.is_external())
					continue
			implants.Add(I)

		if(!implants.len)
			user.visible_message("\blue [user] could not find anything inside [target]'s [affected.name], and pulls \the [tool] out.", \
			"\blue You could not find anything inside [target]'s [affected.name]." )
			return

		var/obj/item/obj = pick(implants)

		if(istype(obj,/obj/item/weapon/implant))
			var/obj/item/weapon/implant/implant = obj
			if (implant.is_legal)
				find_prob +=60
			else
				find_prob +=40
		else
			find_prob +=50

		if (prob(find_prob))
			user.visible_message("\blue [user] takes something out of incision on [target]'s [affected.name] with \the [tool].", \
			"\blue You take [obj] out of incision on [target]'s [affected.name]s with \the [tool]." )
			affected.implants -= obj
			target.update_implants()

			//Handle possessive brain borers.
			if(istype(obj,/mob/living/simple_animal/borer))
				var/mob/living/simple_animal/borer/worm = obj
				if(worm.controlling)
					target.release_control()
				worm.detatch()
				worm.leave_host()
			else
				obj.loc = get_turf(target)
				obj.add_blood(target)
				obj.update_icon()
				if(istype(obj,/obj/item/weapon/implant))
					var/obj/item/weapon/implant/imp = obj
					imp.uninstall()

			playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)
		else
			user.visible_message("\blue [user] removes \the [tool] from [target]'s [affected.name].", \
			"\blue There's something inside [target]'s [affected.name], but you just missed it this time." )
	else
		user.visible_message("\blue [user] could not find anything inside [target]'s [affected.name], and pulls \the [tool] out.", \
		"\blue You could not find anything inside [target]'s [affected.name]." )

/datum/surgery_step/cavity/implant_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	if (affected.implants.len)
		var/fail_prob = 10
		fail_prob += 100 - tool_quality(tool)
		if (prob(fail_prob))
			user.visible_message("\red You scrape something inside [target]'s [affected.name]." )
			var/obj/item/weapon/implant/imp = affected.implants[1]
			spawn(25)
				if (QDELETED(imp))
					return
				imp.malfunction(1)
