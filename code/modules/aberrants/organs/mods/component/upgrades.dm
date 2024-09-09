/datum/component/modification/organ/stromal
	apply_to_types = list(/obj/item/organ/internal)
	examine_msg = "Can be attached to internal organs."
	examine_difficulty = STAT_LEVEL_BASIC

/datum/component/modification/organ/stromal/on_examine(mob/user, list/reference)
	var/function_info = get_function_info()
	if(function_info)
		reference.Add(SPAN_NOTICE(function_info))
	if(examine_msg)
		reference.Add(SPAN_WARNING(examine_msg))

/datum/component/modification/organ/stromal/get_function_info()
	var/function_info = "<i>"

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

	var/organ_efficiency_multiplier = modifications[ORGAN_EFFICIENCY_MULT]
	var/specific_organ_size_multiplier = modifications[ORGAN_SPECIFIC_SIZE_MULT]
	var/max_blood_storage_multiplier = modifications[ORGAN_MAX_BLOOD_STORAGE_MULT]
	var/blood_req_multiplier = modifications[ORGAN_BLOOD_REQ_MULT]
	var/nutriment_req_multiplier = modifications[ORGAN_NUTRIMENT_REQ_MULT]
	var/oxygen_req_multiplier = modifications[ORGAN_OXYGEN_REQ_MULT]
	var/min_bruised_damage_multiplier = modifications[ORGAN_MIN_BRUISED_DAMAGE_MULT]
	var/min_broken_damage_multiplier = modifications[ORGAN_MIN_BROKEN_DAMAGE_MULT]
	var/max_damage_multiplier = modifications[ORGAN_MAX_DAMAGE_MULT]

	var/list/organ_efficiency_mod = modifications[ORGAN_EFFICIENCY_NEW_MOD]
	var/specific_organ_size_mod = modifications[ORGAN_SPECIFIC_SIZE_MOD]
	var/max_blood_storage_mod = modifications[ORGAN_MAX_BLOOD_STORAGE_MOD]
	var/blood_req_mod = modifications[ORGAN_BLOOD_REQ_MOD]
	var/nutriment_req_mod = modifications[ORGAN_NUTRIMENT_REQ_MOD]
	var/oxygen_req_mod = modifications[ORGAN_OXYGEN_REQ_MOD]
	var/min_bruised_damage_mod = modifications[ORGAN_MIN_BRUISED_DAMAGE_MOD]
	var/min_broken_damage_mod = modifications[ORGAN_MIN_BROKEN_DAMAGE_MOD]
	var/max_damage_mod = modifications[ORGAN_MAX_DAMAGE_MOD]

	var/nature_adjustment = modifications[ORGAN_NATURE]
	var/scanner_hidden = modifications[ORGAN_SCANNER_HIDDEN]

	var/aberrant_cooldown_time_base = modifications[ORGAN_ABERRANT_COOLDOWN] / 10

	var/eff_details
	if(LAZYLEN(organ_efficiency_base) || LAZYLEN(organ_efficiency_mod))
		eff_details += "\nAdds organ functions: "
		for(var/organ in organ_efficiency_base)
			var/added_efficiency = organ_efficiency_base[organ]
			eff_details += organ + " ([added_efficiency]), "
		for(var/organ in organ_efficiency_mod)
			var/added_efficiency = organ_efficiency_mod[organ]
			eff_details += organ + " ([added_efficiency]), "
		eff_details = copytext(eff_details, 1, length(eff_details) - 1) + "\n"
	function_info += eff_details

	if(organ_efficiency_multiplier)
		function_info += "[organ_efficiency_multiplier >= 0 ? "Increases" : "Decreases"] overall efficiency by [abs(organ_efficiency_multiplier) * 100]%\n"

	if(specific_organ_size_base)
		function_info += "[specific_organ_size_base >= 0 ? "Increases" : "Decreases"] size by [abs(specific_organ_size_base)]\n"
	if(max_blood_storage_base)
		function_info += "[max_blood_storage_base >= 0 ? "Increases" : "Decreases"] maximum blood storage by [abs(max_blood_storage_base)]\n"
	if(blood_req_base)
		function_info += "[blood_req_base >= 0 ? "Increases" : "Decreases"] blood requirement by [abs(blood_req_base)]\n"
	if(nutriment_req_base)
		function_info += "[nutriment_req_base >= 0 ? "Increases" : "Decreases"] nutriment requirement by [abs(nutriment_req_base)]\n"
	if(oxygen_req_base)
		function_info += "[oxygen_req_base >= 0 ? "Increases" : "Decreases"] oxygen requirement by [abs(oxygen_req_base)]\n"
	if(max_upgrade_base)
		function_info += "[max_upgrade_base >= 0 ? "Increases" : "Decreases"] maximum upgrades by [abs(max_upgrade_base)]\n"
	if(min_bruised_damage_base)
		function_info += "[min_bruised_damage_base >= 0 ? "Increases" : "Decreases"] bruised threshold by [abs(min_bruised_damage_base)]\n"
	if(min_broken_damage_base)
		function_info += "[min_broken_damage_base >= 0 ? "Increases" : "Decreases"] broken threshold by [abs(min_broken_damage_base)]\n"
	if(max_damage_base)
		function_info += "[max_damage_base >= 0 ? "Increases" : "Decreases"] maximum health by [abs(max_damage_base)]\n"
	if(aberrant_cooldown_time_base)
		function_info += "[aberrant_cooldown_time_base >= 0 ? "Increases" : "Decreases"] aberrant cooldown time by [abs(aberrant_cooldown_time_base)] seconds\n"

	if(specific_organ_size_multiplier)
		function_info += "[specific_organ_size_multiplier >= 0 ? "Increases" : "Decreases"] size by [abs(specific_organ_size_multiplier) * 100]%\n"
	if(max_blood_storage_multiplier)
		function_info += "[max_blood_storage_multiplier >= 0 ? "Increases" : "Decreases"] maximum blood storage by [abs(max_blood_storage_multiplier) * 100]%\n"
	if(blood_req_multiplier)
		function_info += "[blood_req_multiplier >= 0 ? "Increases" : "Decreases"] blood requirement by [abs(blood_req_multiplier) * 100]%\n"
	if(nutriment_req_multiplier)
		function_info += "[nutriment_req_multiplier >= 0 ? "Increases" : "Decreases"] nutriment requirement by [abs(nutriment_req_multiplier) * 100]%\n"
	if(oxygen_req_multiplier)
		function_info += "[oxygen_req_multiplier >= 0 ? "Increases" : "Decreases"] oxygen requirement by [abs(oxygen_req_multiplier) * 100]%\n"
	if(min_bruised_damage_multiplier)
		function_info += "[min_bruised_damage_multiplier >= 0 ? "Increases" : "Decreases"] bruised threshold by [abs(min_bruised_damage_multiplier) * 100]%\n"
	if(min_broken_damage_multiplier)
		function_info += "[min_broken_damage_multiplier >= 0 ? "Increases" : "Decreases"] broken threshold by [abs(min_broken_damage_multiplier) * 100]%\n"
	if(max_damage_multiplier)
		function_info += "[max_damage_multiplier >= 0 ? "Increases" : "Decreases"] maximum health by [abs(max_damage_multiplier) * 100]%\n"

	if(specific_organ_size_mod)
		function_info += "[specific_organ_size_mod >= 0 ? "Increases" : "Decreases"] size by a flat value of [abs(specific_organ_size_mod)]\n"
	if(max_blood_storage_mod)
		function_info += "[max_blood_storage_mod >= 0 ? "Increases" : "Decreases"] maximum blood storage by a flat value of [abs(max_blood_storage_mod)]\n"
	if(blood_req_mod)
		function_info += "[blood_req_mod >= 0 ? "Increases" : "Decreases"] blood requirement by a flat value of [abs(blood_req_mod)]\n"
	if(nutriment_req_mod)
		function_info += "[nutriment_req_mod >= 0 ? "Increases" : "Decreases"] nutriment requirement by a flat value of [abs(nutriment_req_mod)]\n"
	if(oxygen_req_mod)
		function_info += "[oxygen_req_mod >= 0 ? "Increases" : "Decreases"] oxygen requirement by a flat value of [abs(oxygen_req_mod)]\n"
	if(min_bruised_damage_mod)
		function_info += "[min_bruised_damage_mod >= 0 ? "Increases" : "Decreases"] bruised threshold by a flat value of [abs(min_bruised_damage_mod)]\n"
	if(min_broken_damage_mod)
		function_info += "[min_broken_damage_base >= 0 ? "Increases" : "Decreases"] broken threshold by a flat value of [abs(min_broken_damage_mod)]\n"
	if(max_damage_mod)
		function_info += "[max_damage_base >= 0 ? "Increases" : "Decreases"] maximum health by a flat value of [abs(max_damage_mod)]\n"

	if(nature_adjustment)
		function_info += "Changes organ nature to [nature_adjustment]\n"
	if(scanner_hidden)
		function_info += "Hides the organ from scanners\n"

	function_info = copytext(function_info, 1, length(function_info))
	function_info += "</i>"

	return function_info

/datum/component/modification/organ/parenchymal
	apply_to_types = list(/obj/item/organ/internal)
	examine_msg = "Can be attached to internal organs."
	examine_difficulty = STAT_LEVEL_BASIC
	adjustable = TRUE

/datum/component/modification/organ/parenchymal/modify(obj/item/I, mob/living/user)
	var/list/organ_efficiency_base = modifications[ORGAN_EFFICIENCY_NEW_BASE]

	LAZYINITLIST(organ_efficiency_base)

	var/specific_organ_size_base
	var/max_blood_storage_base
	var/blood_req_base
	var/nutriment_req_base
	var/oxygen_req_base

	var/list/possibilities = ALL_STANDARD_ORGAN_EFFICIENCIES

	for(var/organ in organ_efficiency_base)
		if(LAZYLEN(organ_efficiency_base) > 1)
			for(var/organ_eff in possibilities)
				if(organ != organ_eff && LAZYFIND(organ_efficiency_base, organ_eff))
					LAZYREMOVE(possibilities, organ_eff)

		var/decision = input("Choose an organ type (current: [organ])","Adjusting Organoid") as null|anything in possibilities
		if(!decision)
			decision = organ

		var/list/organ_stats = ALL_ORGAN_STATS[decision]
		var/modifier = round(organ_efficiency_base[organ] / 100, 0.01)

		if(!modifier)
			return

		organ_efficiency_base -= organ
		organ_efficiency_base[decision] += round(organ_stats[1] * modifier, 1)
		specific_organ_size_base 		+= round(organ_stats[2] * modifier, 0.01)
		max_blood_storage_base			+= round(organ_stats[3] * modifier, 1)
		blood_req_base 					+= round(organ_stats[4] * modifier, 0.01)
		nutriment_req_base 				+= round(organ_stats[5] * modifier, 0.01)
		oxygen_req_base 				+= round(organ_stats[6] * modifier, 0.01)
	
	modifications[ORGAN_SPECIFIC_SIZE_BASE] = specific_organ_size_base
	modifications[ORGAN_MAX_BLOOD_STORAGE_BASE] = max_blood_storage_base
	modifications[ORGAN_BLOOD_REQ_BASE] = blood_req_base
	modifications[ORGAN_NUTRIMENT_REQ_BASE] = nutriment_req_base
	modifications[ORGAN_OXYGEN_REQ_BASE] = oxygen_req_base
