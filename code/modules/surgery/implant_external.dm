//Procedures in this file: External implant install, external implant remove

/datum/surgery_step/external_implant/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	return affected && affected.open == 2 && !(affected.status & ORGAN_BLEEDING)


//////////////////////////////////////////////////////////////////
//					EXTERNAL IMPLANT INSTALL SURGERY			//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/external_implant/install
	allowed_tools = list(
	/obj/item/weapon/implant/external = 100
	)

	min_duration = 100
	max_duration = 110

/datum/surgery_step/external_implant/install/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(tool, /obj/item/weapon/implant/external))
		return FALSE
	var/obj/item/weapon/implant/external/I = tool

	return ..() && (target_zone in I.allowed_organs)

/datum/surgery_step/external_implant/install/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("[user] trying to install [tool] to [target]'s [affected].", \
	"You trying to install [tool] to [target]'s [affected]." )
	..()


/datum/surgery_step/external_implant/install/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(tool, /obj/item/weapon/implant/external))
		return
	var/obj/item/weapon/implant/external/implant = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/I in affected.implants)
		if(istype(I,/obj/item/weapon/implant))
			var/obj/item/weapon/implant/IM = I
			if(IM.is_external())
				if(implant.position_flag & IM.position_flag)
					user << "<span class='warning'>[implant] doesn't fit.</span>"
					return

	user.visible_message("<span class='notice'>[user] installed [tool] to [target]'s [affected].</span>", \
	"<span class='notice'>You installed [tool] to [target]'s [affected].</span>" )

	user.drop_item()
	implant.install(target, target_zone)
	target.update_implants()

/datum/surgery_step/external_implant/install/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("<span class='warning'>[user]'s hand slips, tearing [target]'s [affected.name] with \the [tool]!</span>",
		"<span class='warning'>Your hand slips, tearing the [target]'s [affected.name] with \the [tool]!</span>")

	target.apply_damage(15, BRUTE, affected)


//////////////////////////////////////////////////////////////////
//					EXTERNAL IMPLANT REMOVAL SURGERY			//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/external_implant/remove
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/crowbar = 75,	\
	/obj/item/weapon/material/kitchen/utensil/fork = 50
	)

	min_duration = 80
	max_duration = 90

/datum/surgery_step/external_implant/remove/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/has_imp = FALSE

	for(var/obj/item/I in affected.implants)
		if(istype(I,/obj/item/weapon/implant))
			var/obj/item/weapon/implant/IM = I
			if(IM.is_external())
				has_imp = TRUE
				break

	return ..() && has_imp

/datum/surgery_step/external_implant/remove/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("[user] trying to remove implant from [target]'s [affected].", \
		"You trying to remove implant from [target]'s [affected].")

	..()


/datum/surgery_step/external_implant/remove/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/implants = list()
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/weapon/implant/I in affected.implants)
		if(I.is_external())
			implants.Add(I)

	if(!implants.len)
		return

	var/obj/item/weapon/implant/external/implant = input("Choose an implant to remove.", "Implant", implants[1]) in implants

	if(!implant)
		return

	user.visible_message("<span class='notice'>[user] removed [implant] from [target]'s [affected] with \the [tool].</span>", \
	"<span class='notice'>You removed [implant] from [target]'s [affected] with \the [tool].</span>" )

	implant.uninstall()

	target.update_implants()

/datum/surgery_step/external_implant/remove/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("<span class='warning'>[user]'s hand slips, tearing [target]'s [affected.name] with \the [tool]!</span>",
		"<span class='warning'>Your hand slips, tearing the [target]'s [affected.name] with \the [tool]!</span>")

	target.apply_damage(15, BRUTE, affected)
