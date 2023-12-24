/datum/old_surgery_step/robotics
	can_infect = 0
/datum/old_surgery_step/robotics/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (isslime(target))
		return 0
	if (target_zone == BP_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	if (affected.status & ORGAN_DESTROYED)
		return 0
	if (!BP_IS_ROBOTIC(affected))
		return 0
	return 1




/datum/old_surgery_step/robotics/install_mmi
	allowed_tools = list(/obj/item/device/mmi = 100)

	duration = 70

/datum/old_surgery_step/robotics/install_mmi/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

	if(target_zone != BP_HEAD)
		return

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!(affected && affected.open == 2))
		return 0

	if(!istype(M))
		return 0

	if(!M.brainmob || !M.brainmob.client || !M.brainmob.ckey || M.brainmob.stat >= DEAD)
		to_chat(user, SPAN_DANGER("That brain is not usable."))
		return SURGERY_FAILURE

	if(BP_IS_ORGANIC(affected) || BP_IS_ASSISTED(affected))
		to_chat(user, SPAN_DANGER("You cannot install a computer brain into a meat skull."))
		return SURGERY_FAILURE

	if(!target.species)
		to_chat(user, SPAN_DANGER("You have no idea what species this person is. Report this on the bug tracker."))
		return SURGERY_FAILURE

	if(!target.species.has_process[BP_BRAIN])
		to_chat(user, SPAN_DANGER("You're pretty sure [target.species.name_plural] don't normally have a brain."))
		return SURGERY_FAILURE

	if(!isnull(target.internal_organs[BP_BRAIN]))
		to_chat(user, SPAN_DANGER("Your subject already has a brain."))
		return SURGERY_FAILURE

	return 1

/datum/old_surgery_step/robotics/install_mmi/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts installing \the [tool] into [target]'s [affected.name].", \
	"You start installing \the [tool] into [target]'s [affected.name].")
	..()

/datum/old_surgery_step/robotics/install_mmi/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has installed \the [tool] into [target]'s [affected.name]."), \
	SPAN_NOTICE("You have installed \the [tool] into [target]'s [affected.name]."))

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/mmi_holder/holder = new(target, 1)
	target.internal_organs_by_efficiency[BP_BRAIN] += holder
	user.drop_from_inventory(tool)
	tool.forceMove(holder)
	holder.stored_mmi = tool
	holder.update_from_mmi()

	if(M.brainmob && M.brainmob.mind)
		M.brainmob.mind.transfer_to(target)

/datum/old_surgery_step/robotics/install_mmi/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("[user]'s hand slips."),
		SPAN_WARNING("Your hand slips.")
	)
