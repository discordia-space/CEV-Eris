/datum/component/modification/organ/input
	exclusive_type = /obj/item/modification/organ/internal/input
	trigger_signal = COMSIG_ABERRANT_INPUT

	var/check_mode
	var/list/accepted_inputs = list()
	var/list/input_qualities = list()

/datum/component/modification/organ/input/reagents
	adjustable = TRUE

/datum/component/modification/organ/input/reagents/get_function_info()
	var/source
	switch(check_mode)
		if(CHEM_TOUCH)
			source = "skin"
		if(CHEM_INGEST)
			source = "stomach"
		if(CHEM_BLOOD)
			source = "bloodstream"
		else
			source = "none"

	var/inputs
	for(var/input in accepted_inputs)
		var/datum/reagent/R = input
		inputs += initial(R.name) + ", "

	inputs = copytext(inputs, 1, length(inputs) - 1)

	var/description = "<span style='color:green'>Functional information (input):</span> metabolizes reagents"
	description += "\n<span style='color:green'>Source:</span> [source]"
	description += "\n<span style='color:green'>Reagents metabolized:</span> [inputs]"

	return description

/datum/component/modification/organ/input/reagents/modify(obj/item/I, mob/living/user)
	if(!input_qualities.len)
		return

	var/list/can_adjust = list("metabolic source", "reagent")

	var/decision_adjust = input("What do you want to adjust?","Adjusting Organoid") as null|anything in can_adjust
	if(!decision_adjust)
		return

	var/list/adjustable_qualities = list()

	if(decision_adjust == "metabolic source")
		adjustable_qualities = list(
			"skin" = CHEM_TOUCH,
			"stomach" = CHEM_INGEST,
			"bloodstream" = CHEM_BLOOD
		)

		var/decision = input("Choose a metabolic source:","Adjusting Organoid") as null|anything in adjustable_qualities
		if(!decision)
			return

		check_mode = adjustable_qualities[decision]

	if(decision_adjust == "reagent")
		var/decision = input("Choose a reagent:","Adjusting Organoid") as null|anything in input_qualities
		if(!decision)
			return

		var/list/reagent_group = input_qualities[decision]

		for(var/input in accepted_inputs)
			var/new_reagent_input = pick(reagent_group)		// pick() allows one input type to fill muliple slots, thus enabling multiple outputs
			accepted_inputs[accepted_inputs.Find(input)] = new_reagent_input

/datum/component/modification/organ/input/reagents/trigger(atom/movable/holder, mob/living/carbon/owner)
	if(!holder || !owner)
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/organ_multiplier = ((S.max_damage - S.damage) / S.max_damage) * (S.aberrant_cooldown_time / (2 SECONDS))	// Life() is called every 2 seconds

	var/list/input = list()

	var/datum/reagents/metabolism/RM = owner.get_metabolism_handler(check_mode)
	for(var/datum/reagent/R in RM.reagent_list)
		for(var/reagent_path in accepted_inputs)
			var/threshold_met = FALSE
			if(istype(R, reagent_path))
				if(R.volume > 0)
					threshold_met = TRUE
					var/removed = R.metabolism * organ_multiplier		// Consumes reagent based on organ health and how many ticks in between organ processes
					R.remove_self(removed)
			input |= reagent_path
			input[reagent_path] |= threshold_met

	SEND_SIGNAL(holder, COMSIG_ABERRANT_PROCESS, holder, owner, input)


/datum/component/modification/organ/input/damage
	adjustable = TRUE

/datum/component/modification/organ/input/damage/get_function_info()
	var/inputs
	for(var/input in accepted_inputs)
		switch(input)
			if(BRUTE)
				inputs += "brute, "
			if(BURN)
				inputs += "burn, "
			if(TOX)
				inputs += "toxin, "
			if(OXY)
				inputs += "suffocation, "
			if(CLONE)
				inputs += "DNA degredation, "
			if(HALLOSS)
				inputs += "pain, "
			if("brain")
				inputs += "brain, "
			if(PSY)
				inputs += "sanity, "
		
	inputs = copytext(inputs, 1, length(inputs) - 1)

	var/description = "<span style='color:green'>Functional information (input):</span> injury response"
	description += "\n<span style='color:green'>Damage types:</span> [inputs]"

	return description

/datum/component/modification/organ/input/damage/modify(obj/item/I, mob/living/user)
	if(!input_qualities.len)
		return

	for(var/input in accepted_inputs)
		var/list/possibilities = input_qualities.Copy()

		if(accepted_inputs.len > 1)
			for(var/dmg_name in possibilities)
				var/dmg_type = possibilities[dmg_name]
				if(input != dmg_type && accepted_inputs.Find(dmg_type))
					possibilities.Remove(dmg_name)

		var/decision = input("Choose a damaging stimulus (current: [input])","Adjusting Organoid") as null|anything in possibilities
		if(!decision)
			continue

		accepted_inputs[accepted_inputs.Find(input)] = input_qualities[decision]

/datum/component/modification/organ/input/damage/trigger(atom/movable/holder, mob/living/carbon/owner)
	if(!holder || !owner)
		return

	var/mob/living/carbon/human/H = owner
	var/list/input = list()

	for(var/desired_damage_type in accepted_inputs)
		var/current_damage = 0
		var/threshold_met = FALSE
		switch(desired_damage_type)
			if(BRUTE)
				current_damage = owner.getBruteLoss()
			if(BURN)
				current_damage = owner.getFireLoss()
			if(TOX)
				current_damage = owner.getToxLoss()
			if(OXY)
				current_damage = owner.getOxyLoss()
			if(CLONE)
				current_damage = owner.getCloneLoss()
			if(HALLOSS)
				current_damage = owner.getHalLoss()
			if("brain")
				current_damage = owner.getBrainLoss()
			if(PSY)
				current_damage = H.sanity.max_level - H.sanity.level
					
		if(current_damage > 0)
			threshold_met = TRUE

		input += desired_damage_type
		input[desired_damage_type] = threshold_met

	SEND_SIGNAL(holder, COMSIG_ABERRANT_PROCESS, holder, owner, input)


/datum/component/modification/organ/input/power_source
	adjustable = TRUE

/datum/component/modification/organ/input/power_source/get_function_info()
	var/inputs
	for(var/input in accepted_inputs)
		var/atom/movable/AM = input
		switch(input)
			if(/obj/item/cell/small)
				inputs += "small power cell, "
			if(/obj/item/cell/medium)
				inputs += "medium power cell, "
			if(/obj/item/cell/large)
				inputs += "large power cell, "
			else
				inputs += initial(AM.name) + ", "

	inputs = copytext(inputs, 1, length(inputs) - 1)

	var/description = "<span style='color:green'>Functional information (input):</span> drains held power sources"
	description += "\n<span style='color:green'>Sources accepted:</span> [inputs]"

	return description

/datum/component/modification/organ/input/power_source/modify(obj/item/I, mob/living/user)
	if(!input_qualities.len)
		return

	for(var/input in accepted_inputs)
		var/list/possibilities = input_qualities.Copy()
		
		if(accepted_inputs.len > 1)
			for(var/source in possibilities)
				var/source_type = possibilities[source]
				if(input != source_type && accepted_inputs.Find(source_type))
					possibilities.Remove(source)

		var/atom/movable/AM = input_qualities[input]

		var/decision = input("Choose a power source (current: [AM ? initial(AM.name) : "unknown"])","Adjusting Organoid") as null|anything in possibilities
		if(!decision)
			continue

		accepted_inputs[accepted_inputs.Find(input)] = input_qualities[decision]

/datum/component/modification/organ/input/power_source/trigger(atom/movable/holder, mob/living/carbon/human/owner)
	if(!holder || !owner)
		return
	if(!owner.get_siemens_coefficient_organ(owner.get_organ(check_zone(BP_L_ARM))) && !owner.get_siemens_coefficient_organ(owner.get_organ(check_zone(BP_R_ARM))))
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/organ_multiplier = ((S.max_damage - S.damage) / S.max_damage)

	var/list/input = list()
	var/active_hand_held = owner.get_active_hand()
	var/inactive_hand_held = owner.get_inactive_hand()

	for(var/power_source in accepted_inputs)
		var/atom/movable/AM
		if(istype(active_hand_held, power_source))
			AM = active_hand_held
		if(istype(inactive_hand_held, power_source))
			AM = inactive_hand_held

		var/energy_supplied = 0

		// 1 u = 500J
		if(istype(AM, /obj/item/cell))
			var/obj/item/cell/C = AM
			if(C.charge)
				energy_supplied = C.use(C.charge) / CELLRATE		// Using a rigged cell will make it explode, which is funny

		// 1 plasma sheet = 192 kJ, 1 uranium sheet = 1152 kJ, 1 tritium sheet = 1440 kJ
		if(istype(AM, /obj/item/stack/material))
			var/obj/item/stack/material/M = AM
			if(M.amount)
				switch(M.default_type)
					if(MATERIAL_PLASMA)
						M.amount--
						energy_supplied = 192000
					if(MATERIAL_URANIUM)
						M.amount--
						energy_supplied = 1152000
					if(MATERIAL_TRITIUM)
						M.amount--
						energy_supplied = 1440000
			if(!M.amount)
				owner.remove_from_mob(M)
				qdel(M)
		
		if(energy_supplied)
			var/magnitude = 0

			if(energy_supplied > 4999999)
				magnitude = 5 * organ_multiplier
			if(energy_supplied > 999999)
				magnitude = 3 * organ_multiplier
			if(energy_supplied > 99999)
				magnitude = 2 * organ_multiplier
				
			if(magnitude && ishuman(owner))
				if(prob(2))
					to_chat(owner, SPAN_NOTICE("A pleasant chill runs down your spine. You feel more focused."))
				var/mob/living/carbon/human/H = owner
				H.stats.addTempStat(STAT_COG, magnitude * 2, S.aberrant_cooldown_time + 2 SECONDS, "[parent]")
				H.sanity.changeLevel(magnitude - 2)

		input += power_source
		input[power_source] = energy_supplied ? TRUE : FALSE

	SEND_SIGNAL(holder, COMSIG_ABERRANT_PROCESS, holder, owner, input)
