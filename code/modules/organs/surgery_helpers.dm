
// Spread germs from surgeon to the organ
/obj/item/organ/proc/spread_germs_from(mob/living/carbon/human/user, obj/item/tool)
	if(!istype(user)) // Robots and such are considered sterile
		return

	var/new_germ_level = user.germ_level
	if(user.gloves)
		new_germ_level = user.gloves.germ_level

	if(tool)
		new_germ_level =69ax(new_germ_level, tool.germ_level)

	germ_level =69ax(germ_level,69ew_germ_level) //as funny as scrubbing69icrobes out with clean gloves is -69o.


// Get a69ame to be displayed in surgery69essages
/obj/item/organ/proc/get_surgery_name()
	if(!owner)	// Loose organ shows its own69ame only
		return src

	// Attached one refers to its current owner too
	if(surgery_name)
		return "69owner69's 69surgery_name69"
	else
		return "69owner69's 69name69"


// Status data used in UI windows
/obj/item/organ/proc/get_status_data()
	var/list/status_data = list()
	status_data69"cut_away"69 = status & ORGAN_CUT_AWAY
	status_data69"bleeding"69 = status & ORGAN_BLEEDING
	status_data69"broken"69 = status & ORGAN_BROKEN
	status_data69"destroyed"69 = status & ORGAN_DESTROYED
	status_data69"splintered"69 = status & ORGAN_SPLINTED
	status_data69"dead"69 = status & ORGAN_DEAD
	status_data69"mutated"69 = status & ORGAN_MUTATED
	status_data69"robotic"69 = BP_IS_ROBOTIC(src)

	return status_data


// Atom to use in do_after targeting for the surgery
/obj/item/organ/proc/get_surgery_target()
	if(owner)
		return owner

	if(istype(loc, /obj/item/organ))
		return loc

	return src


// flick_lights a pain69essage to the owner, if the body part can feel pain at all
/obj/item/organ/proc/owner_custom_pain(message, flash_strength)
	if(can_feel_pain())
		owner.custom_pain(message, flash_strength)


// Deals agony damage to the owner, if the body part can feel pain at all
/obj/item/organ/proc/owner_pain(strength)
	if(can_feel_pain() && strength)
		var/multiplier =69ax(0, 1 - (owner.analgesic / 100))

		if(multiplier)
			owner.adjustHalLoss(strength *69ultiplier)


// Get a list of surgically treatable conditions
// To be overridden in subtypes
/obj/item/organ/proc/get_conditions()
	return list()

/obj/item/organ/proc/get_actions(var/obj/item/organ/external/parent)
	var/list/actions_list = list()

	if(BP_IS_ROBOTIC(src))
		actions_list.Add(list(list(
			"name" = (status & ORGAN_CUT_AWAY) ? "Connect" : "Disconnect",
			"organ" = "\ref69src69",
			"step" = /datum/surgery_step/robotic/connect_organ
		)))
	else
		actions_list.Add(list(list(
			"name" = (status & ORGAN_CUT_AWAY) ? "Attach" : "Separate",
			"organ" = "\ref69src69",
			"step" = (status & ORGAN_CUT_AWAY) ? /datum/surgery_step/attach_organ : /datum/surgery_step/detach_organ
		)))

	return actions_list

/obj/item/organ/internal/proc/get_process_data()
	var/list/processes = list()
	for(var/efficiency in organ_efficiency)
		processes += list(
			list(
				"title" = "69capitalize(efficiency)69 efficiency",
				"efficiency" = organ_efficiency69efficiency69,
				)
			)
	return processes

// Is body part open for69ost surgerical operations?
// To be overridden in subtypes
/obj/item/organ/proc/is_open()
	return FALSE


// Handling of attacks in organ-centric surgery - called from attackby and attack_hand
// To be overridden in subtypes
/obj/item/organ/proc/do_surgery(mob/living/user, obj/item/tool,69ar/surgery_status = CAN_OPERATE_ALL)
	return FALSE

