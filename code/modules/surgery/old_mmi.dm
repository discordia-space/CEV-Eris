/datum/old_surgery_step/robotics
	can_infect = 0
/datum/old_surgery_step/robotics/can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	if (isslime(target))
		return 0
	if (target_zone == BP_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected ==69ull)
		return 0
	if (affected.status & ORGAN_DESTROYED)
		return 0
	if (!BP_IS_ROBOTIC(affected))
		return 0
	return 1




/datum/old_surgery_step/robotics/install_mmi
	allowed_tools = list(/obj/item/device/mmi = 100)

	duration = 70

/datum/old_surgery_step/robotics/install_mmi/can_use(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)

	if(target_zone != BP_HEAD)
		return

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!(affected && affected.open == 2))
		return 0

	if(!istype(M))
		return 0

	if(!M.brainmob || !M.brainmob.client || !M.brainmob.ckey ||69.brainmob.stat >= DEAD)
		to_chat(user, SPAN_DANGER("That brain is69ot usable."))
		return SURGERY_FAILURE

	if(BP_IS_ORGANIC(affected) || BP_IS_ASSISTED(affected))
		to_chat(user, SPAN_DANGER("You cannot install a computer brain into a69eat skull."))
		return SURGERY_FAILURE

	if(!target.species)
		to_chat(user, SPAN_DANGER("You have69o idea what species this person is. Report this on the bug tracker."))
		return SURGERY_FAILURE

	if(!target.species.has_process69BP_BRAIN69)
		to_chat(user, SPAN_DANGER("You're pretty sure 69target.species.name_plural69 don't69ormally have a brain."))
		return SURGERY_FAILURE

	if(!isnull(target.internal_organs69BP_BRAIN69))
		to_chat(user, SPAN_DANGER("Your subject already has a brain."))
		return SURGERY_FAILURE

	return 1

/datum/old_surgery_step/robotics/install_mmi/begin_step(mob/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("69user69 starts installing \the 69tool69 into 69target69's 69affected.name69.", \
	"You start installing \the 69tool69 into 69target69's 69affected.name69.")
	..()

/datum/old_surgery_step/robotics/install_mmi/end_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("69user69 has installed \the 69tool69 into 69target69's 69affected.name69."), \
	SPAN_NOTICE("You have installed \the 69tool69 into 69target69's 69affected.name69."))

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/mmi_holder/holder =69ew(target, 1)
	target.internal_organs_by_efficiency69BP_BRAIN69 += holder
	user.drop_from_inventory(tool)
	tool.loc = holder
	holder.stored_mmi = tool
	holder.update_from_mmi()

	if(M.brainmob &&69.brainmob.mind)
		M.brainmob.mind.transfer_to(target)

/datum/old_surgery_step/robotics/install_mmi/fail_step(mob/living/user,69ob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(
		SPAN_WARNING("69user69's hand slips."),
		SPAN_WARNING("Your hand slips.")
	)