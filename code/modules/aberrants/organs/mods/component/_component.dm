/datum/component/modification/organ
	install_time = WORKTIME_FAST
	//install_tool_quality = null
	install_difficulty = FAILCHANCE_VERY_EASY + 5
	install_stat = STAT_BIO
	install_sound = 'sound/effects/squelch1.ogg'

	mod_time = WORKTIME_FAST
	mod_tool_quality = QUALITY_LASER_CUTTING
	mod_difficulty = FAILCHANCE_HARD - 5
	mod_stat = STAT_BIO
	mod_sound = 'sound/effects/squelch1.ogg'

	removal_time = WORKTIME_SLOW
	removal_tool_quality = QUALITY_LASER_CUTTING
	removal_difficulty = FAILCHANCE_HARD - 5
	removal_stat = STAT_BIO

	examine_msg = "Can be attached to organ scaffolds and aberrant organs."
	examine_stat = STAT_BIO
	examine_difficulty = STAT_LEVEL_EXPERT - 5
	examine_stat_secondary = STAT_COG
	examine_difficulty_secondary = STAT_LEVEL_BASIC - 5

	adjustable = FALSE
	destroy_on_removal = FALSE
	removable = TRUE
	breakable = FALSE

	apply_to_types = list(/obj/item/organ/internal/scaffold)
	apply_to_qualities = list(MODIFICATION_ORGANIC, MODIFICATION_ASSISTED)	// So organic mods don't get applied to robotic organs and vice versa

	// Internal organ stuff
	var/somatic = FALSE							// If TRUE, will add a verb that allows for at-will use. Still subject to cooldowns.

/datum/component/modification/organ/Initialize()
	if(somatic)
		trigger_signal = COMSIG_ABERRANT_INPUT_VERB
		//modifications[ORGAN_OWNER_VERB] = list(/datum/component/modification/organ/verb/somatic_trigger)
		//modifications[ITEM_VERB_PROC] = /datum/component/modification/organ/verb/somatic_trigger
	. = ..()

/datum/component/modification/organ/check_item(obj/item/I, mob/living/user)
	..()

	if(istype(I, /obj/item/organ))
		var/obj/item/organ/O = I

		var/organ_nature = modifications[ORGAN_NATURE] ? modifications[ORGAN_NATURE] : O.nature

		if(LAZYFIND(apply_to_qualities, organ_nature))
			return TRUE

	return FALSE

/datum/component/modification/organ/apply(obj/item/organ/O, mob/living/user)
	. = ..()

	// Mutation index checks
	// If the mod failed to install, do nothing
	if(!.)
		return FALSE


	// If the organ was already modded, do nothing
	if(!O.owner || LAZYLEN(O.item_upgrades) > 1)
		return TRUE

	O.owner.mutation_index++

/datum/component/modification/organ/apply_base_values(obj/item/organ/internal/holder)
	ASSERT(holder)

	var/using_generated_name = FALSE
	var/using_generated_color = FALSE

	var/new_name = modifications[ATOM_NAME]
	var/prefix = modifications[ATOM_PREFIX]
	var/new_desc = modifications[ATOM_DESC]
	var/new_color = modifications[ATOM_COLOR]

	var/max_upgrade_base = modifications[UPGRADE_MAXUPGRADES]

	var/list/organ_efficiency_base = modifications[ORGAN_EFFICIENCY_NEW_BASE]
	var/specific_organ_size_base = modifications[ORGAN_SPECIFIC_SIZE_BASE]
	var/max_blood_storage_base = modifications[ORGAN_MAX_BLOOD_STORAGE_BASE]
	var/blood_req_base = modifications[ORGAN_BLOOD_REQ_BASE]
	var/nutriment_req_base = modifications[ORGAN_NUTRIMENT_REQ_BASE]
	var/oxygen_req_base = modifications[ORGAN_OXYGEN_REQ_BASE]
	var/min_bruised_damage_base = modifications[ORGAN_MIN_BRUISED_DAMAGE_BASE]
	var/min_broken_damage_base = modifications[ORGAN_MIN_BROKEN_DAMAGE_BASE]
	var/max_damage_base = modifications[ORGAN_MAX_DAMAGE_BASE]

	var/nature_adjustment = modifications[ORGAN_NATURE]
	var/scanner_hidden = modifications[ORGAN_SCANNER_HIDDEN]
	var/blood_type = modifications[ORGAN_BLOOD_TYPE]

	var/aberrant_cooldown_time_base = modifications[ORGAN_ABERRANT_COOLDOWN]

	//var/list/owner_verb_adds = modifications[ORGAN_OWNER_VERB]

	var/obj/item/organ/internal/scaffold/S
	if(istype(holder, /obj/item/organ/internal/scaffold))
		S = holder

	if(S)
		using_generated_name = S.use_generated_name
		using_generated_color = S.use_generated_color
		if(aberrant_cooldown_time_base)
			S.aberrant_cooldown_time += aberrant_cooldown_time_base

	if(new_name && using_generated_name)
		holder.name = new_name
	if(prefix)
		holder.prefixes += prefix
	if(new_desc)
		holder.desc = new_desc
	if(new_color && !using_generated_color)
		holder.color = new_color

	if(!islist(holder.organ_efficiency))
		holder.organ_efficiency = list()

	if(LAZYLEN(organ_efficiency_base))
		for(var/organ in organ_efficiency_base)
			var/added_efficiency = organ_efficiency_base[organ]
			holder.organ_efficiency[organ] += round(added_efficiency, 1)

		if(ishuman(holder.owner))
			var/mob/living/carbon/human/H = holder.owner
			for(var/process in organ_efficiency_base)
				if(!islist(H.internal_organs_by_efficiency[process]))
					H.internal_organs_by_efficiency[process] = list()
				H.internal_organs_by_efficiency[process] |= holder

	if(specific_organ_size_base)
		holder.specific_organ_size += round(specific_organ_size_base, 0.01)
	if(max_blood_storage_base)
		holder.max_blood_storage += round(max_blood_storage_base, 0.01)
	if(blood_req_base)
		holder.blood_req += round(blood_req_base, 0.01)
	if(nutriment_req_base)
		holder.nutriment_req += round(nutriment_req_base, 0.01)
	if(oxygen_req_base)
		holder.oxygen_req += round(oxygen_req_base, 0.01)
	if(max_upgrade_base)
		holder.max_upgrades += max_upgrade_base
	if(min_bruised_damage_base)
		holder.min_bruised_damage += min_bruised_damage_base
	if(min_broken_damage_base)
		holder.min_broken_damage += min_broken_damage_base
	if(max_damage_base)
		holder.max_damage += max_damage_base

	if(scanner_hidden)
		holder.scanner_hidden = scanner_hidden
	if(nature_adjustment)
		holder.nature = nature_adjustment
	if(blood_type)
		holder.b_type = blood_type

/datum/component/modification/organ/apply_mult_values(obj/item/organ/internal/holder)
	ASSERT(holder)

	var/organ_efficiency_multiplier = modifications[ORGAN_EFFICIENCY_MULT]
	var/specific_organ_size_multiplier = modifications[ORGAN_SPECIFIC_SIZE_MULT]
	var/max_blood_storage_multiplier = modifications[ORGAN_MAX_BLOOD_STORAGE_MULT]
	var/blood_req_multiplier = modifications[ORGAN_BLOOD_REQ_MULT]
	var/nutriment_req_multiplier = modifications[ORGAN_NUTRIMENT_REQ_MULT]
	var/oxygen_req_multiplier = modifications[ORGAN_OXYGEN_REQ_MULT]
	var/min_bruised_damage_multiplier = modifications[ORGAN_MIN_BRUISED_DAMAGE_MULT]
	var/min_broken_damage_multiplier = modifications[ORGAN_MIN_BROKEN_DAMAGE_MULT]
	var/max_damage_multiplier = modifications[ORGAN_MAX_DAMAGE_MULT]

	if(organ_efficiency_multiplier)
		for(var/organ in holder.organ_efficiency)
			holder.organ_efficiency[organ] = round(holder.organ_efficiency[organ] * (1 + organ_efficiency_multiplier), 1)

	if(specific_organ_size_multiplier)
		holder.specific_organ_size *= 1 + round(specific_organ_size_multiplier, 0.01)
	if(max_blood_storage_multiplier)
		holder.max_blood_storage *= 1 + round(max_blood_storage_multiplier, 0.01)
	if(blood_req_multiplier)
		holder.blood_req *= 1 + round(blood_req_multiplier, 0.01)
	if(nutriment_req_multiplier)
		holder.nutriment_req *= 1 + round(nutriment_req_multiplier, 0.01)
	if(oxygen_req_multiplier)
		holder.oxygen_req *= 1 + round(oxygen_req_multiplier, 0.01)
	if(min_bruised_damage_multiplier)
		holder.min_bruised_damage *= 1 + round(min_bruised_damage_multiplier, 0.01)
	if(min_broken_damage_multiplier)
		holder.min_broken_damage *= 1 + round(min_broken_damage_multiplier, 0.01)
	if(max_damage_multiplier)
		holder.max_damage *= 1 + round(max_damage_multiplier, 0.01)

/datum/component/modification/organ/apply_mod_values(obj/item/organ/internal/holder)
	ASSERT(holder)

	var/list/organ_efficiency_mod = modifications[ORGAN_EFFICIENCY_NEW_MOD]
	var/specific_organ_size_mod = modifications[ORGAN_SPECIFIC_SIZE_MOD]
	var/max_blood_storage_mod = modifications[ORGAN_MAX_BLOOD_STORAGE_MOD]
	var/blood_req_mod = modifications[ORGAN_BLOOD_REQ_MOD]
	var/nutriment_req_mod = modifications[ORGAN_NUTRIMENT_REQ_MOD]
	var/oxygen_req_mod = modifications[ORGAN_OXYGEN_REQ_MOD]
	var/min_bruised_damage_mod = modifications[ORGAN_MIN_BRUISED_DAMAGE_MOD]
	var/min_broken_damage_mod = modifications[ORGAN_MIN_BROKEN_DAMAGE_MOD]
	var/max_damage_mod = modifications[ORGAN_MAX_DAMAGE_MOD]

	if(!islist(holder.organ_efficiency))
		holder.organ_efficiency = list()

	if(LAZYLEN(organ_efficiency_mod))
		for(var/organ in organ_efficiency_mod)
			var/added_efficiency = organ_efficiency_mod[organ]
			holder.organ_efficiency[organ] += round(added_efficiency, 1)

		if(ishuman(holder.owner))
			var/mob/living/carbon/human/H = holder.owner
			for(var/process in organ_efficiency_mod)
				if(!islist(H.internal_organs_by_efficiency[process]))
					H.internal_organs_by_efficiency[process] = list()
				H.internal_organs_by_efficiency[process] |= holder

	if(specific_organ_size_mod)
		holder.specific_organ_size += round(specific_organ_size_mod, 0.01)
	if(max_blood_storage_mod)
		holder.max_blood_storage += round(max_blood_storage_mod, 0.01)
	if(blood_req_mod)
		holder.blood_req += round(blood_req_mod, 0.01)
	if(nutriment_req_mod)
		holder.nutriment_req += round(nutriment_req_mod, 0.01)
	if(oxygen_req_mod)
		holder.oxygen_req += round(oxygen_req_mod, 0.01)
	if(min_bruised_damage_mod)
		holder.min_bruised_damage += min_bruised_damage_mod
	if(min_broken_damage_mod)
		holder.min_broken_damage += min_broken_damage_mod
	if(max_damage_mod)
		holder.max_damage += max_damage_mod

/datum/component/modification/organ/add_values(obj/item/organ/internal/holder)
	ASSERT(holder)

	if(somatic)
		var/somatic_action_name = modifications[ITEM_VERB_NAME]
		//var/somatic_verb = somatic ? modifications[ITEM_VERB_PROC] : "somatic_trigger"
		var/somatic_hands_free = modifications[ITEM_VERB_HANDS_FREE]
		var/list/somatic_verb_args = modifications[ITEM_VERB_ARGS]

		holder.action_button_name = somatic_action_name ? somatic_action_name : "Activate [holder.name]"
		holder.action_button_proc = null
		holder.action_button_is_hands_free = somatic_hands_free
		if(LAZYLEN(somatic_verb_args))
			holder.action_button_arguments = somatic_verb_args.Copy()

/datum/component/modification/organ/uninstall(obj/item/organ/O, mob/living/user)
	..()
	if(istype(O, /obj/item/organ/internal/scaffold))
		var/obj/item/organ/internal/scaffold/S = O
		S.try_ruin()

	// If the organ has no owner or is still modded, do nothing
	if(!O.owner || LAZYLEN(O.item_upgrades))
		return

	O.owner.mutation_index--

/*
/datum/component/modification/organ/on_examine(/obj/mod, list/reference)
	LAZYINITLIST(reference)

	var/using_sci_goggles = FALSE
	var/details_unlocked = FALSE

	var/list/organ_efficiency_base = modifications[ORGAN_EFFICIENCY_NEW_BASE]
	var/list/organ_efficiency_mod = modifications[ORGAN_EFFICIENCY_NEW_MOD]

	var/specific_organ_size_base = modifications[ORGAN_SPECIFIC_SIZE_BASE]
	var/blood_req_base = modifications[ORGAN_BLOOD_REQ_BASE]
	var/nutriment_req_base = modifications[ORGAN_NUTRIMENT_REQ_BASE]
	var/oxygen_req_base = modifications[ORGAN_OXYGEN_REQ_BASE]

	var/aberrant_cooldown_time_base = modifications[ORGAN_ABERRANT_COOLDOWN]

	if(isghost(user))
		details_unlocked = TRUE
	else if(user.stats)
		// Goggles check
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(istype(H.glasses, /obj/item/clothing/glasses/powered/science))
				var/obj/item/clothing/glasses/powered/G = H.glasses
				using_sci_goggles = G.active	// Meat vision

		// Stat check
		details_unlocked = (user.stats.getStat(examine_stat) >= examine_difficulty) ? TRUE : FALSE
		if(examine_stat_secondary && details_unlocked)
			details_unlocked = (user.stats.getStat(examine_stat_secondary) >= examine_difficulty_secondary) ? TRUE : FALSE

	if(examine_msg)
		reference.Add(SPAN_WARNING(examine_msg))

	if(adjustable)
		reference.Add(SPAN_WARNING("Can be adjusted with a laser cutting tool."))

	if(using_sci_goggles || details_unlocked)
		var/info = "Organoid size: [specific_organ_size_base ? specific_organ_size_base : "0"]"
		info += "\nRequirements: <span style='color:red'>[blood_req_base ? blood_req_base : "0"]\
								</span>/<span style='color:blue'>[oxygen_req_base ? oxygen_req_base : "0"]\
								</span>/<span style='color:orange'>[nutriment_req_base ? nutriment_req_base : "0"]</span>"

		var/organs
		for(var/organ in organ_efficiency_base)
			organs += organ + " ([organ_efficiency_base[organ]]), "
		for(var/organ in organ_efficiency_mod)
			organs += organ + " ([organ_efficiency_mod[organ]]), "
		organs = copytext(organs, 1, length(organs) - 1)
		info += "\nOrgan tissues present: <span style='color:pink'>[organs ? organs : "none"]</span>"
		if(aberrant_cooldown_time_base)
			info += "\nAverage organ process duration: [aberrant_cooldown_time_base / (1 SECOND)] seconds"

		reference.Add(SPAN_NOTICE(info))

		var/function_info = get_function_info()
		if(function_info)
			reference.Add(SPAN_NOTICE(function_info))
	else
		reference.Add(SPAN_WARNING("You lack the biological knowledge and/or mental ability  required to understand its functions."))
*/

/*	Commented out until I figure out how to make this work with the owner verb changes
/datum/component/modification/organ/verb/somatic_trigger()
	set category = "Organs and Implants"
	set name = "Activate Organ"
	set desc = "Starts the process of an aberrant organ."

	var/obj/item/organ/O

	if(istype(src, /obj/item/organ))
		O = src

	if(istype(src, /obj/item/organ/internal/scaffold))
		var/obj/item/organ/internal/scaffold/S = src
		if(S.on_cooldown)
			to_chat(usr, SPAN_NOTICE("\The [src] is not ready to be activated."))
			return

	if(O && O.owner)
		SEND_SIGNAL(src, COMSIG_ABERRANT_INPUT_VERB, O.owner)
*/
