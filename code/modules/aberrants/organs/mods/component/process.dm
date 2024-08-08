/datum/component/modification/organ/process
	exclusive_type = /obj/item/modification/organ/internal/process
	adjustable = TRUE
	trigger_signal = COMSIG_ABERRANT_PROCESS

/datum/component/modification/organ/process/modify()
	var/list/organ_efficiency_base
	var/specific_organ_size_base
	var/max_blood_storage_base
	var/blood_req_base
	var/nutriment_req_base
	var/oxygen_req_base

	if(!islist(modifications[ORGAN_EFFICIENCY_NEW_BASE]))
		modifications[ORGAN_EFFICIENCY_NEW_BASE] = list()

	organ_efficiency_base = modifications[ORGAN_EFFICIENCY_NEW_BASE]

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

/datum/component/modification/organ/process/multiplier
/datum/component/modification/organ/process/multiplier/get_function_info()
	var/multiplier = modifications[ORGAN_ABERRANT_PROCESS_MULT]
	var/is_positive = (multiplier > 0)

	var/description = "<span style='color:orange'>Functional information (processing):</span> [is_positive ? "amplifies" : "reduces"] output"
	description += "\n<span style='color:orange'>Output change:</span> [is_positive ? "+" : "-"][multiplier * 100]%"

	return description

/datum/component/modification/organ/process/multiplier/trigger(atom/movable/holder, mob/living/carbon/owner, list/input)
	if(!holder || !owner || !input)
		return

	if(LAZYLEN(input))
		for(var/element in input)
			input[element] *= 1 + modifications[ORGAN_ABERRANT_PROCESS_MULT]

		SEND_SIGNAL(holder, COMSIG_ABERRANT_OUTPUT, owner, input)


/datum/component/modification/organ/process/map
	var/mode = "normal"

/datum/component/modification/organ/process/map/get_function_info()
	var/description = "<span style='color:orange'>Functional information (processing):</span> connects inputs to outputs"
	description += "\n<span style='color:orange'>Mode:</span> [mode]"

	return description

/*	Multi-input aberrant organs are still supported, but not present in-game
/datum/component/modification/organ/process/map/modify()
	var/list/adjustable_qualities = list("normal", "random")

	var/decision = input("Choose an input to output mapping mode","Adjusting Organoid") as null|anything in adjustable_qualities
	if(!decision)
		return

	mode = decision
*/

/datum/component/modification/organ/process/map/trigger(atom/movable/holder, mob/living/carbon/owner, list/input)
	if(!holder || !owner || !input || !input.len)
		return

	var/list/shuffled_input = list()
	var/list/packet_order = list()

	if(mode == "random")
		for(var/i in 1 to input.len)
			packet_order += "[i]"
			packet_order["[i]"] = i
			
		shuffle(packet_order)

		for(var/i in 1 to input.len)
			var/key = input[text2num(packet_order[i])]
			var/value = input[key]
			shuffled_input.Add(key)
			shuffled_input[key] = value

		input = shuffled_input

	if(input.len)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_OUTPUT, owner, input)


/*	Multi-input aberrant organs are still supported, but not present in-game
/datum/component/modification/organ/process/condense
/datum/component/modification/organ/process/condense/get_function_info()
	var/description = "<span style='color:orange'>Functional information (processing):</span> condenses inputs into a single output"

	return description

/datum/component/modification/organ/process/condense/trigger(atom/movable/holder, mob/living/carbon/owner, list/input)
	if(!holder || !owner || !input)
		return

	var/list/condensed_input = list("condensed input" = 0)

	if(input.len)
		for(var/element in input)
			condensed_input["condensed input"] |= input[element]

		SEND_SIGNAL_OLD(holder, COMSIG_ABERRANT_OUTPUT, holder, owner, condensed_input)
*/
