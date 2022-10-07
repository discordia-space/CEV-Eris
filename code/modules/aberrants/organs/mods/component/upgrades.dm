/datum/component/modification/organ/stromal
	apply_to_types = list(/obj/item/organ/internal)
	examine_msg = "Can be attached to internal organs."
	examine_difficulty = STAT_LEVEL_BASIC

/datum/component/modification/organ/stromal/on_examine(mob/user)
	var/function_info = get_function_info()
	if(function_info)
		to_chat(user, SPAN_NOTICE(function_info))
	if(examine_msg)
		to_chat(user, SPAN_WARNING(examine_msg))

/datum/component/modification/organ/stromal/get_function_info()
	var/function_info = "<i>"

	//for(var/owner_verb in owner_verb_adds)
	//	holder.owner_verbs |= owner_verb

	var/eff_details
	if(organ_efficiency_mod.len)
		eff_details += "Adds organ functions: "
		for(var/organ in organ_efficiency_mod)
			var/added_efficiency = organ_efficiency_mod[organ]
			eff_details += organ + " ([added_efficiency]), "
		eff_details = copytext(eff_details, 1, length(eff_details) - 1) + "\n"
	function_info += eff_details

	if(organ_efficiency_multiplier)
		function_info += "[organ_efficiency_multiplier >= 0 ? "Increases" : "Decreases"] overall efficiency by [abs(organ_efficiency_multiplier) * 100]%\n"

	if(specific_organ_size_multiplier)
		function_info += "[specific_organ_size_multiplier >= 0 ? "Decreases" : "Increases"] size by [abs(specific_organ_size_multiplier) * 100]%\n"
	if(max_blood_storage_multiplier)
		function_info += "[max_blood_storage_multiplier >= 0 ? "Increases" : "Decreases"] maximum blood storage by [abs(max_blood_storage_multiplier) * 100]%\n"
	if(blood_req_multiplier)
		function_info += "[blood_req_multiplier >= 0 ? "Decreases" : "Increases"] blood requirement by [abs(blood_req_multiplier) * 100]%\n"
	if(nutriment_req_multiplier)
		function_info += "[nutriment_req_multiplier >= 0 ? "Decreases" : "Increases"] nutriment requirement by [abs(nutriment_req_multiplier) * 100]%\n"
	if(oxygen_req_multiplier)
		function_info += "[oxygen_req_multiplier >= 0 ? "Decreases" : "Increases"] oxygen requirement by [abs(oxygen_req_multiplier) * 100]%\n"
	if(min_bruised_damage_multiplier)
		function_info += "[min_bruised_damage_multiplier >= 0 ? "Increases" : "Decreases"] bruised threshold by [abs(min_bruised_damage_multiplier) * 100]%\n"
	if(min_broken_damage_multiplier)
		function_info += "[min_broken_damage_multiplier >= 0 ? "Increases" : "Decreases"] broken threshold by [abs(min_broken_damage_multiplier) * 100]%\n"
	if(max_damage_multiplier)
		function_info += "[max_damage_multiplier >= 0 ? "Increases" : "Decreases"] maximum health by [abs(max_damage_multiplier) * 100]%\n"

	if(specific_organ_size_mod)
		function_info += "[specific_organ_size_mod >= 0 ? "Increases" : "Decreases"] size by [abs(specific_organ_size_mod)]\n"
	if(max_blood_storage_mod)
		function_info += "[max_blood_storage_mod >= 0 ? "Increases" : "Decreases"] maximum blood storage by [abs(max_blood_storage_mod)]\n"
	if(blood_req_mod)
		function_info += "[blood_req_mod >= 0 ? "Increases" : "Decreases"] blood requirement by [abs(blood_req_mod)]\n"
	if(nutriment_req_mod)
		function_info += "[nutriment_req_mod >= 0 ? "Increases" : "Decreases"] nutriment requirement by [abs(nutriment_req_mod)]\n"
	if(oxygen_req_mod)
		function_info += "[oxygen_req_mod >= 0 ? "Increases" : "Decreases"] oxygen requirement by [abs(oxygen_req_mod)]\n"
	if(max_upgrade_mod)
		function_info += "[max_upgrade_mod >= 0 ? "Increases" : "Decreases"] maximum upgrades by [abs(max_upgrade_mod)]\n"
	if(min_bruised_damage_mod)
		function_info += "[min_bruised_damage_mod >= 0 ? "Increases" : "Decreases"] bruised threshold by [abs(min_bruised_damage_mod)]\n"
	if(min_broken_damage_mod)
		function_info += "[min_broken_damage_mod >= 0 ? "Increases" : "Decreases"] broken threshold by [abs(min_broken_damage_mod)]\n"
	if(max_damage_mod)
		function_info += "[max_damage_mod >= 0 ? "Increases" : "Decreases"] maximum health by [abs(max_damage_mod)]\n"

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
	specific_organ_size_mod = 0
	max_blood_storage_mod = 0
	blood_req_mod = 0
	nutriment_req_mod = 0
	oxygen_req_mod = 0

	var/list/possibilities = ALL_STANDARD_ORGAN_EFFICIENCIES

	for(var/organ in organ_efficiency_mod)
		if(organ_efficiency_mod.len > 1)
			for(var/organ_eff in possibilities)
				if(organ != organ_eff && organ_efficiency_mod.Find(organ_eff))
					possibilities.Remove(organ_eff)

		var/decision = input("Choose an organ type (current: [organ])","Adjusting Organoid") as null|anything in possibilities
		if(!decision)
			decision = organ

		var/list/organ_stats = ALL_ORGAN_STATS[decision]
		var/modifier = round(organ_efficiency_mod[organ] / 100, 0.01)

		organ_efficiency_mod.Remove(organ)
		organ_efficiency_mod.Add(decision)
		organ_efficiency_mod[decision] 	= round(organ_stats[1] * modifier, 1)
		specific_organ_size_mod 		+= round(organ_stats[2] * modifier, 0.01)
		max_blood_storage_mod			+= round(organ_stats[3] * modifier, 1)
		blood_req_mod 					+= round(organ_stats[4] * modifier, 0.01)
		nutriment_req_mod 				+= round(organ_stats[5] * modifier, 0.01)
		oxygen_req_mod 					+= round(organ_stats[6] * modifier, 0.01)
