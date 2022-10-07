/datum/component/modification/organ
	install_time = WORKTIME_FAST
	//install_tool_quality = null
	install_difficulty = 35
	install_stat = STAT_BIO
	install_sound = 'sound/effects/squelch1.ogg'

	mod_time = WORKTIME_FAST
	mod_tool_quality = QUALITY_LASER_CUTTING			
	mod_difficulty = FAILCHANCE_HARD
	mod_stat = STAT_BIO
	mod_sound = 'sound/effects/squelch1.ogg'

	removal_time = WORKTIME_SLOW
	removal_tool_quality = QUALITY_LASER_CUTTING
	removal_difficulty = FAILCHANCE_CHALLENGING
	removal_stat = STAT_BIO

	adjustable = FALSE
	destroy_on_removal = FALSE 
	removable = TRUE
	breakable = FALSE

	apply_to_types = list(/obj/item/organ/internal/scaffold)
	//blacklisted_types = list(/obj/item/organ/internal/scaffold/hive)

	examine_msg = "Can be attached to organ scaffolds and aberrant organs."
	examine_stat = STAT_BIO
	examine_difficulty = STAT_LEVEL_EXPERT - 5
	examine_stat_secondary = STAT_COG
	examine_difficulty_secondary = STAT_LEVEL_BASIC - 5

	// Internal organ stuff
	var/list/owner_verb_adds = list()

	// Additive adjustments
	var/list/organ_efficiency_mod = list()
	var/specific_organ_size_mod = null
	var/max_blood_storage_mod = null
	var/blood_req_mod = null
	var/nutriment_req_mod = null
	var/oxygen_req_mod = null
	var/min_bruised_damage_mod = null
	var/min_broken_damage_mod = null
	var/max_damage_mod = null

	// Multiplicative adjustments
	var/organ_efficiency_multiplier = null
	var/specific_organ_size_multiplier = null
	var/max_blood_storage_multiplier = null
	var/blood_req_multiplier = null
	var/nutriment_req_multiplier = null
	var/oxygen_req_multiplier = null
	var/min_bruised_damage_multiplier = null
	var/min_broken_damage_multiplier = null
	var/max_damage_multiplier = null

	var/max_upgrade_mod = null
	var/scanner_hidden = FALSE


/datum/component/modification/organ/apply_values(obj/item/organ/internal/holder)
	ASSERT(holder)
	
	var/using_generated_name = FALSE
	var/using_generated_color = FALSE

	var/obj/item/organ/internal/scaffold/S
	if(istype(holder, /obj/item/organ/internal/scaffold))
		S = holder

	if(S)
		using_generated_name = S.use_generated_name
		using_generated_color = S.use_generated_color

	if(new_name && using_generated_name)
		holder.name = new_name
	if(prefix)
		holder.prefixes += prefix
	if(new_desc)
		holder.desc = new_desc
	if(new_color && !using_generated_color)
		holder.color = new_color

	for(var/owner_verb in owner_verb_adds)
		holder.owner_verbs |= owner_verb

	if(!islist(holder.organ_efficiency))
		holder.organ_efficiency = list()

	if(organ_efficiency_mod.len)
		for(var/organ in organ_efficiency_mod)
			var/added_efficiency = organ_efficiency_mod[organ]
			if(holder.organ_efficiency.Find(organ))
				holder.organ_efficiency[organ] += round(added_efficiency, 1)
			else
				holder.organ_efficiency.Add(organ)
				holder.organ_efficiency[organ] = round(added_efficiency, 1)

		if(holder.owner && istype(holder.owner, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = holder.owner
			for(var/process in organ_efficiency_mod)
				if(!islist(H.internal_organs_by_efficiency[process]))
					H.internal_organs_by_efficiency[process] = list()
				H.internal_organs_by_efficiency[process] |= holder

	if(organ_efficiency_multiplier)
		for(var/organ in holder.organ_efficiency)
			holder.organ_efficiency[organ] = round(holder.organ_efficiency[organ] * (1 + organ_efficiency_multiplier), 1)

	if(specific_organ_size_multiplier)
		holder.specific_organ_size *= 1 - round(specific_organ_size_multiplier, 0.01)
	if(max_blood_storage_multiplier)
		holder.max_blood_storage *= 1 + round(max_blood_storage_multiplier, 0.01)
	if(blood_req_multiplier)
		holder.blood_req *= 1 - round(blood_req_multiplier, 0.01)
	if(nutriment_req_multiplier)
		holder.nutriment_req *= 1 - round(nutriment_req_multiplier, 0.01)
	if(oxygen_req_multiplier)
		holder.oxygen_req *= 1 - round(oxygen_req_multiplier, 0.01)
	if(min_bruised_damage_multiplier)
		holder.min_bruised_damage *= 1 + round(min_bruised_damage_multiplier, 0.01)
	if(min_broken_damage_multiplier)
		holder.min_broken_damage *= 1 + round(min_broken_damage_multiplier, 0.01)
	if(max_damage_multiplier)
		holder.max_damage *= 1 + round(max_damage_multiplier, 0.01)

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
	if(max_upgrade_mod)
		holder.max_upgrades += max_upgrade_mod
	if(min_bruised_damage_mod)
		holder.min_bruised_damage += min_bruised_damage_mod
	if(min_broken_damage_mod)
		holder.min_broken_damage += min_broken_damage_mod
	if(max_damage_mod)
		holder.max_damage += max_damage_mod

	if(scanner_hidden)
		holder.scanner_hidden = scanner_hidden

/datum/component/modification/organ/uninstall(obj/item/I, mob/living/user)
	..()
	if(istype(I, /obj/item/organ/internal/scaffold))
		var/obj/item/organ/internal/scaffold/S = I
		S.try_ruin()

/datum/component/modification/organ/on_examine(mob/user)
	var/using_sci_goggles = FALSE
	var/details_unlocked = FALSE

	if(ishuman(user))
		// Goggles check
		var/mob/living/carbon/human/H = user
		if(istype(H.glasses, /obj/item/clothing/glasses/powered/science))
			var/obj/item/clothing/glasses/powered/G = H.glasses
			using_sci_goggles = G.active	// Meat vision

		// Stat check
		details_unlocked = (user.stats.getStat(examine_stat) >= examine_difficulty) ? TRUE : FALSE
		if(examine_stat_secondary && details_unlocked)
			details_unlocked = (user.stats.getStat(examine_stat_secondary) >= examine_difficulty_secondary) ? TRUE : FALSE
	else if(istype(user, /mob/observer/ghost))
		details_unlocked = TRUE

	if(examine_msg)
		to_chat(user, SPAN_WARNING(examine_msg))

	if(adjustable)
		to_chat(user, SPAN_WARNING("Can be adjusted with a laser cutting tool."))

	if(using_sci_goggles || details_unlocked)
		var/info = "Organoid size: [specific_organ_size_mod ? specific_organ_size_mod : "0"]"
		info += "\nRequirements: <span style='color:red'>[blood_req_mod ? blood_req_mod : "0"]\
								</span>/<span style='color:blue'>[oxygen_req_mod ? oxygen_req_mod : "0"]\
								</span>/<span style='color:orange'>[nutriment_req_mod ? nutriment_req_mod : "0"]</span>"
		
		var/organs
		for(var/organ in organ_efficiency_mod)
			organs += organ + " ([organ_efficiency_mod[organ]]), "
		organs = copytext(organs, 1, length(organs) - 1)
		info += "\nOrgan tissues present: <span style='color:pink'>[organs ? organs : "none"]</span>"
		
		to_chat(user, SPAN_NOTICE(info))

		var/function_info = get_function_info()
		if(function_info)
			to_chat(user, SPAN_NOTICE(function_info))
	else
		to_chat(user, SPAN_WARNING("You lack the biological knowledge and/or mental ability  required to understand its functions."))
