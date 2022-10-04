/datum/component/modification/organ/process
	exclusive_type = /obj/item/modification/organ/internal/process
	trigger_signal = COMSIG_ABERRANT_PROCESS

/datum/component/modification/organ/process/boost
	var/multiplier

/datum/component/modification/organ/process/boost/get_function_info()
	var/description = "<span style='color:orange'>Functional information (processing):</span> amplifies outputs"
	description += "\n<span style='color:orange'>Output increase:</span> [multiplier * 100]%"

	return description

/datum/component/modification/organ/process/boost/trigger(atom/movable/holder, mob/living/carbon/owner, list/input)
	if(!holder || !owner || !input)
		return

	if(input.len)
		for(var/element in input)
			input[element] += multiplier

		SEND_SIGNAL(holder, COMSIG_ABERRANT_OUTPUT, holder, owner, input)


/datum/component/modification/organ/process/map
	adjustable = TRUE
	var/mode = "normal"

/datum/component/modification/organ/process/map/get_function_info()
	var/description = "<span style='color:orange'>Functional information (processing):</span> connects inputs to outputs"
	description += "\n<span style='color:orange'>Mode:</span> [mode]"

	return description

/datum/component/modification/organ/process/map/modify()
	var/list/adjustable_qualities = list("normal", "random")

	var/decision = input("Choose an input to output mapping mode","Adjusting Organoid") as null|anything in adjustable_qualities
	if(!decision)
		return

	mode = decision

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
		SEND_SIGNAL(holder, COMSIG_ABERRANT_OUTPUT, holder, owner, input)


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

		SEND_SIGNAL(holder, COMSIG_ABERRANT_OUTPUT, holder, owner, condensed_input)
