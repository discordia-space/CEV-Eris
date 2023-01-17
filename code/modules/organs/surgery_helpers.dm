
// Spread germs from surgeon to the organ
/obj/item/organ/proc/spread_germs_from(mob/living/carbon/human/user, obj/item/tool)
	if(!istype(user)) // Robots and such are considered sterile
		return

	var/new_germ_level = user.germ_level
	if(user.gloves)
		new_germ_level = user.gloves.germ_level

	if(tool)
		new_germ_level = max(new_germ_level, tool.germ_level)

	germ_level = max(germ_level, new_germ_level) //as funny as scrubbing microbes out with clean gloves is - no.


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
	else
		var/is_aberrant = istype(src, /obj/item/organ/internal/scaffold)
		if(item_upgrades.len < max_upgrades)
			actions_list.Add(list(list(
				"name" = is_aberrant ? "Attach Mod/Organoid" : "Attach Mod",
				"organ" = "\ref[src]",
				"step" = /datum/surgery_step/attach_mod
			)))
		if(item_upgrades.len)
			actions_list.Add(list(list(
				"name" = is_aberrant ? "Remove Mod/Organoid" : "Remove Mod",
				"organ" = "\ref[src]",
				"step" = /datum/surgery_step/remove_mod
			)))
		if(is_aberrant)	// Currently, scaffolds are the only type that warrant examining in-body
			actions_list.Add(list(list(
				"name" = "Examine",
				"organ" = "\ref[src]",
				"step" = /datum/surgery_step/examine
			)))
		actions_list.Add(list(list(
			"name" = (status & ORGAN_CUT_AWAY) ? "Attach" : "Separate",
			"organ" = "\ref[src]",
			"step" = (status & ORGAN_CUT_AWAY) ? /datum/surgery_step/attach_organ : /datum/surgery_step/detach_organ
		)))


	return actions_list

/obj/item/organ/internal/proc/get_process_data()
	var/list/processes = list()
	for(var/efficiency in organ_efficiency)
		processes += list(
			list(
				"title" = "[capitalize(efficiency)] efficiency",
				"efficiency" = organ_efficiency[efficiency],
				)
			)
	return processes

// Is body part open for most surgerical operations?
// To be overridden in subtypes
/obj/item/organ/proc/is_open()
	return FALSE


// Handling of attacks in organ-centric surgery - called from attackby and attack_hand
// To be overridden in subtypes
/obj/item/organ/proc/do_surgery(mob/living/user, obj/item/tool, var/surgery_status = CAN_OPERATE_ALL)
	return FALSE

