// Get a name to be displayed in surgery messages
/obj/item/organ/proc/get_surgery_name()
	if(!owner)	// Loose organ shows its own name only
		return src

	// Attached one refers to its current owner too
	if(surgery_name)
		return "[owner]'s [surgery_name]"
	else
		return "[owner]'s [name]"


// Status data used in UI windows
/obj/item/organ/proc/get_status_data()
	var/list/status_data = list()
	status_data["cut_away"] = status & ORGAN_CUT_AWAY
	status_data["bleeding"] = status & ORGAN_BLEEDING
	status_data["broken"] = status & ORGAN_BROKEN
	status_data["destroyed"] = status & ORGAN_DESTROYED
	status_data["splintered"] = status & ORGAN_SPLINTED
	status_data["dead"] = status & ORGAN_DEAD
	status_data["mutated"] = status & ORGAN_MUTATED
	status_data["robotic"] = BP_IS_ROBOTIC(src)

	return status_data


// Atom to use in do_after targeting for the surgery
/obj/item/organ/proc/get_surgery_target()
	if(owner)
		return owner

	if(istype(loc, /obj/item/organ))
		return loc

	return src


// flickers a pain message to the owner, if the body part can feel pain at all
/obj/item/organ/proc/owner_custom_pain(message, flash_strength)
	if(can_feel_pain())
		owner.custom_pain(message, flash_strength)


// Deals agony damage to the owner, if the body part can feel pain at all
/obj/item/organ/proc/owner_pain(strength)
	if(can_feel_pain() && strength)
		var/multiplier = max(0, 1 - (owner.analgesic / 100))

		if(multiplier)
			owner.adjustHalLoss(strength * multiplier)


// Get a list of surgically treatable conditions
// To be overridden in subtypes
/obj/item/organ/proc/get_conditions()
	return list()

/obj/item/organ/proc/get_actions(var/obj/item/organ/external/parent)
	var/list/actions_list = list()

	if(BP_IS_ROBOTIC(src))
		actions_list.Add(list(list(
			"name" = (status & ORGAN_CUT_AWAY) ? "Connect" : "Disconnect",
			"organ" = "\ref[src]",
			"step" = /datum/surgery_step/robotic/connect_organ
		)))
	else if(BP_IS_ASSISTED(src))
		actions_list.Add(list(list(
			"name" = (status & ORGAN_CUT_AWAY) ? "Attach" : "Separate",
			"organ" = "\ref[src]",
			"step" = (status & ORGAN_CUT_AWAY) ? /datum/surgery_step/assisted/attach_organ : /datum/surgery_step/assisted/detach_organ
		)))
	else
		actions_list.Add(list(list(
			"name" = (status & ORGAN_CUT_AWAY) ? "Attach" : "Separate",
			"organ" = "\ref[src]",
			"step" = (status & ORGAN_CUT_AWAY) ? /datum/surgery_step/attach_organ : /datum/surgery_step/detach_organ
		)))


	return actions_list

/obj/item/organ/internal/proc/get_process_data()
	var/processes = ""
	for(var/efficiency in organ_efficiency)
		processes += "[capitalize(efficiency)] ([organ_efficiency[efficiency]]), "
	processes = copytext(processes, 1, length(processes) - 1)
	return processes

// Is body part open for most surgerical operations?
// To be overridden in subtypes
/obj/item/organ/proc/is_open()
	return FALSE


// Handling of attacks in organ-centric surgery - called from attackby and attack_hand
// To be overridden in subtypes
/obj/item/organ/proc/do_surgery(mob/living/user, obj/item/tool, var/surgery_status = CAN_OPERATE_ALL)
	return FALSE

