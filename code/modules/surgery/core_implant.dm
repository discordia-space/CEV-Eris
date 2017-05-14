//Procedures in this file: Core implant (cruciform) removal
//////////////////////////////////////////////////////////////////
//						CORE IMPLANT							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/core_implant
	priority = 2

/datum/surgery_step/core_implant/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/obj/item/core_implant/implant = locate(/obj/item/core_implant) in target
	return affected && affected.open && implant && target_zone == implant.install_zone

//////////////////////////////////////////////////////////////////
//						CORE IMPLANT CUT						//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/core_implant/cut
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,		\
	/obj/item/weapon/material/knife = 75,	\
	/obj/item/weapon/material/shard = 50, 		\
	)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/core_implant/cut/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/core_implant/implant = locate(/obj/item/core_implant) in target
	return ..() && implant.active

/datum/surgery_step/core_implant/cut/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/core_implant/implant = locate(/obj/item/core_implant) in target
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts cutting [implant]'s connection to [target]'s [affected] with \the [tool].", \
	"You start cutting [implant]'s connection to [target]'s [affected] with \the [tool].")
	..()

/datum/surgery_step/core_implant/cut/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/core_implant/implant = locate(/obj/item/core_implant) in target
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] cut [implant]'s connection to [target]'s [affected] with \the [tool].</span>", \
	"<span class='notice'>You cut [implant]'s connection to [target]'s [affected] with \the [tool].</span>")
	implant.deactivate()

/datum/surgery_step/core_implant/cut/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s [affected] with \the [tool].</span>", \
	"<span class='warning'>Your hand slips, slicing [target]'s [affected] with \the [tool].</span>")
	affected.createwound(CUT, 60)


//////////////////////////////////////////////////////////////////
//						CORE IMPLANT RETRACT					//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/core_implant/retract
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/crowbar = 75,	\
	/obj/item/weapon/material/kitchen/utensil/fork = 50
	)

	min_duration = 30
	max_duration = 50

/datum/surgery_step/core_implant/retract/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/core_implant/implant = locate(/obj/item/core_implant) in target
	return ..() && !implant.active

/datum/surgery_step/core_implant/retract/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/core_implant/implant = locate(/obj/item/core_implant) in target
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts removing [implant] from [target]'s [affected] with \the [tool].", \
	"You starts removing [implant] from [target]'s [affected] with \the [tool].")
	..()

/datum/surgery_step/core_implant/retract/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/core_implant/implant = locate(/obj/item/core_implant) in target
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] removed [implant] from [target]'s [affected] with \the [tool].</span>", \
	"<span class='notice'>You removed [implant] from [target]'s [affected] with \the [tool].</span>")
	implant.uninstall()

/datum/surgery_step/core_implant/retract/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, injuring [target]'s [affected] with \the [tool].</span>", \
	"<span class='warning'>Your hand slips, injuring [target]'s [affected] with \the [tool].</span>")
	target.apply_damage(12, BRUTE, affected, sharp=1)
