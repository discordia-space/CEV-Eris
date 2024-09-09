/datum/component/modification/organ/input
	exclusive_type = /obj/item/modification/organ/internal/input
	trigger_signal = COMSIG_ABERRANT_INPUT

	var/check_mode
	var/threshold
	var/list/accepted_inputs = list()
	var/list/input_qualities = list()

// =================================================
// ================     ORGANIC     ================
// =================================================
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

	var/description = "\n<span style='color:green'>Functional information (input):</span> metabolizes reagents"
	description += "\n<span style='color:green'>Source:</span> [source]"
	description += "\n<span style='color:green'>Reagents metabolized:</span> [inputs]"

	return description

/datum/component/modification/organ/input/reagents/modify(obj/item/I, mob/living/user)
	if(!LAZYLEN(input_qualities))
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
		for(var/input in accepted_inputs)
			var/list/possibilities = input_qualities.Copy()

			if(LAZYLEN(accepted_inputs) > 1)
				for(var/reagent in possibilities)
					if(input != reagent && accepted_inputs.Find(reagent))
						possibilities.Remove(reagent)

			var/decision = input("Choose a reagent:","Adjusting Organoid") as null|anything in input_qualities
			if(!decision)
				return

			var/list/new_reagent_input = input_qualities[decision]

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
				if(R.volume > threshold)
					threshold_met = TRUE
					var/removed = R.metabolism * organ_multiplier		// Consumes reagent based on organ health and how many ticks in between organ processes
					R.remove_self(removed)
			input |= reagent_path
			input[reagent_path] |= threshold_met

	SEND_SIGNAL(holder, COMSIG_ABERRANT_PROCESS, owner, input)


/datum/component/modification/organ/input/damage
	adjustable = TRUE

/datum/component/modification/organ/input/damage/get_function_info()
	var/inputs
	for(var/input in accepted_inputs)
		switch(input)
			if(BRUTE)
				inputs += "brute ([threshold]), "
			if(BURN)
				inputs += "burn ([threshold]), "
			if(TOX)
				inputs += "toxin ([threshold]), "
			if(OXY)
				inputs += "suffocation ([threshold]), "
			if(CLONE)
				inputs += "DNA degredation ([threshold]), "
			if(HALLOSS)
				inputs += "pain ([threshold]), "
			if("brain")
				inputs += "brain ([threshold]), "
			if(PSY)
				inputs += "sanity ([threshold]), "
		
	inputs = copytext(inputs, 1, length(inputs) - 1)

	var/description = "\n<span style='color:green'>Functional information (input):</span> injury response"
	description += "\n<span style='color:green'>Damage types (threshold):</span> [inputs]"

	return description

/datum/component/modification/organ/input/damage/modify(obj/item/I, mob/living/user)
	if(!LAZYLEN(input_qualities))
		return

	for(var/input in accepted_inputs)
		var/list/possibilities = input_qualities.Copy()

		if(LAZYLEN(accepted_inputs) > 1)
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
					
		if(current_damage > threshold)
			threshold_met = TRUE

		input += desired_damage_type
		input[desired_damage_type] = threshold_met

	SEND_SIGNAL(holder, COMSIG_ABERRANT_PROCESS, owner, input)

/datum/component/modification/organ/input/consume
	adjustable = TRUE
	somatic = TRUE

/datum/component/modification/organ/input/consume/get_function_info()
	var/inputs
	for(var/input in accepted_inputs)
		var/atom/movable/AM = input
		inputs += initial(AM.name) + ", "

	inputs = copytext(inputs, 1, length(inputs) - 1)

	var/description = "\n<span style='color:green'>Functional information (input):</span> consumes held object"
	description += "\n<span style='color:green'>Digestable materials:</span> [inputs]"

	return description

/datum/component/modification/organ/input/consume/modify(obj/item/I, mob/living/user)
	if(!LAZYLEN(input_qualities))
		return

	for(var/input in accepted_inputs)
		var/list/possibilities = input_qualities.Copy()
		
		if(LAZYLEN(accepted_inputs) > 1)
			for(var/source in possibilities)
				var/source_type = possibilities[source]
				if(input != source_type && accepted_inputs.Find(source_type))
					possibilities.Remove(source)

		var/atom/movable/AM = input

		var/decision = input("Choose a digestable material (current: [AM ? initial(AM.name) : "unknown"])","Adjusting Organoid") as null|anything in possibilities
		if(!decision)
			continue

		accepted_inputs[accepted_inputs.Find(input)] = input_qualities[decision]

/datum/component/modification/organ/input/consume/trigger(atom/movable/holder, mob/living/carbon/human/owner)
	if(!holder || !owner)
		return
	if(owner.check_mouth_coverage())
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/organ_multiplier = ((S.max_damage - S.damage) / S.max_damage)

	var/list/input = list()
	var/active_hand_held = owner.get_active_hand()
	var/inactive_hand_held = owner.get_inactive_hand()

	for(var/digestable in accepted_inputs)
		var/obj/O
		if(istype(inactive_hand_held, digestable) && isobj(inactive_hand_held))
			O = inactive_hand_held
		if(istype(active_hand_held, digestable) && isobj(active_hand_held))
			O = active_hand_held

		if(!O)
			to_chat(owner, SPAN_WARNING("You attempt to consume something, but you have nothing edible in your hand."))
			return

		var/nutrition_supplied = 0

		if(LAZYLEN(O.matter))
			var/datum/reagents/contained_reagents = O.reagents
			if(contained_reagents)
				contained_reagents.trans_to_holder(owner.ingested, contained_reagents.total_volume)

			for(var/material in O.matter)
				nutrition_supplied += O.matter[material]
				owner.adjustNutrition(nutrition_supplied * organ_multiplier)

			// Same message as carrion sans taste description
			playsound(owner.loc, 'sound/items/eatfood.ogg', 70, TRUE, 0)
			owner.visible_message(SPAN_DANGER("[owner] devours \the [O]!"), SPAN_NOTICE("You consume \the [O]."))
			qdel(O)
		
		if(nutrition_supplied > threshold)
			var/magnitude = 0

			if(nutrition_supplied > 40)
				magnitude = 8 * organ_multiplier
			else if(nutrition_supplied > 20)
				magnitude = 6 * organ_multiplier
			else if(nutrition_supplied > 10)
				magnitude = 4 * organ_multiplier
				
			if(magnitude)
				if(prob(2))
					to_chat(owner, SPAN_NOTICE("A warm sensation fills your belly. You feel satiated."))
				owner.stats.addTempStat(STAT_VIG, magnitude, S.aberrant_cooldown_time + 2 SECONDS, "[parent]")
				owner.sanity.changeLevel(magnitude)

		input += digestable
		input[digestable] = (nutrition_supplied > 0) ? TRUE : FALSE

	SEND_SIGNAL(holder, COMSIG_ABERRANT_PROCESS, owner, input)


// =================================================
// ================     ASSISTED     ===============
// =================================================

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

	var/description = "\n<span style='color:green'>Functional information (input):</span> drains held power sources"
	description += "\n<span style='color:green'>Sources accepted:</span> [inputs]"

	return description

/datum/component/modification/organ/input/power_source/modify(obj/item/I, mob/living/user)
	if(!LAZYLEN(input_qualities))
		return

	for(var/input in accepted_inputs)
		var/list/possibilities = input_qualities.Copy()
		
		if(LAZYLEN(accepted_inputs) > 1)
			for(var/source in possibilities)
				var/source_type = possibilities[source]
				if(input != source_type && accepted_inputs.Find(source_type))
					possibilities.Remove(source)

		var/decision = input("Choose a power source (current: [input])","Adjusting Organoid") as null|anything in possibilities
		if(!decision)
			continue

		accepted_inputs[accepted_inputs.Find(input)] = input_qualities[decision]

/datum/component/modification/organ/input/power_source/trigger(atom/movable/holder, mob/living/carbon/human/owner)
	if(!holder || !owner)
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/organ_multiplier = ((S.max_damage - S.damage) / S.max_damage)
	var/siemens_coefficient = min((owner.get_siemens_coefficient_organ(owner.get_organ(check_zone(BP_L_ARM))) + owner.get_siemens_coefficient_organ(owner.get_organ(check_zone(BP_R_ARM)))) / 2, 1)

	if(siemens_coefficient < 0.5)
		return

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
				energy_supplied = C.use(C.charge) * siemens_coefficient / CELLRATE		// Using a rigged cell will make it explode, which is funny

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
		
		if(energy_supplied > threshold)
			var/magnitude = 0

			if(energy_supplied > 4999999)
				magnitude = 5 * organ_multiplier
			else if(energy_supplied > 999999)
				magnitude = 3 * organ_multiplier
			else if(energy_supplied > 99999)
				magnitude = 2 * organ_multiplier
				
			if(magnitude)
				if(prob(2))
					to_chat(owner, SPAN_NOTICE("A pleasant chill runs down your spine. You feel more focused."))
				owner.stats.addTempStat(STAT_COG, magnitude * 2, S.aberrant_cooldown_time + 2 SECONDS, "[parent]")
				owner.sanity.changeLevel(magnitude - 2)

		input += power_source
		input[power_source] = energy_supplied ? TRUE : FALSE

	SEND_SIGNAL(holder, COMSIG_ABERRANT_PROCESS, owner, input)

// =================================================
// ================     ROBOTIC     ================
// =================================================
