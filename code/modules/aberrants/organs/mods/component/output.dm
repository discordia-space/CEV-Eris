/datum/component/modification/organ/output
	exclusive_type = /obj/item/modification/organ/internal/output
	trigger_signal = COMSIG_ABERRANT_OUTPUT

	var/list/possible_outputs = list()
	var/list/output_qualities = list()

/datum/component/modification/organ/output/reagents
	adjustable = TRUE
	var/mode = CHEM_BLOOD

/datum/component/modification/organ/output/reagents/get_function_info()
	var/metabolism = mode == CHEM_BLOOD ? "bloodstream" : "stomach"

	var/outputs
	for(var/output in possible_outputs)
		var/datum/reagent/R = output
		outputs += initial(R.name) + " ([possible_outputs[output]]u), "

	outputs = copytext(outputs, 1, length(outputs) - 1)

	var/description = "<span style='color:blue'>Functional information (output):</span> produces reagents in [metabolism]"
	description += "\n<span style='color:blue'>Reagents produced:</span> [outputs]"

	return description

/datum/component/modification/organ/output/reagents/modify(obj/item/I, mob/living/user)
	if(!LAZYLEN(output_qualities))
		return

	var/list/can_adjust = list("metabolic target", "reagent")

	var/decision_adjust = input("What do you want to adjust?","Adjusting Organoid") as null|anything in can_adjust
	if(!decision_adjust)
		return

	var/list/adjustable_qualities = list()

	if(decision_adjust == "metabolic target")
		adjustable_qualities = list(
			"stomach" = CHEM_INGEST,
			"bloodstream" = CHEM_BLOOD
		)

		var/decision = input("Choose a metabolic target","Adjusting Organoid") as null|anything in adjustable_qualities
		if(!decision)
			return

		mode = adjustable_qualities[decision]

		if(istype(parent, /obj/item/modification/organ))
			var/obj/item/modification/organ/O = parent
			if(mode == CHEM_INGEST)
				O.name = "gastric organoid"
				O.desc = "Functional tissue of one or more organs in graftable form. Produces reagents in the stomach."
				O.description_info = "Produces reagents in the stomach when triggered.\n\n\
									Use a laser cutting tool to change the metabolism target or reagent type.\n\
									Reagents can only be swapped for like reagents."
			else if(mode == CHEM_BLOOD)
				O.name = "hepatic organoid"
				O.desc = "Functional tissue of one or more organs in graftable form. Secretes reagents into the bloodstream."
				O.description_info = "Produces reagents in the bloodstream when triggered.\n\n\
									Use a laser cutting tool to change the metabolism target or reagent type.\n\
									Reagents can only be swapped for like reagents."

	if(decision_adjust == "reagent")
		for(var/output in possible_outputs)
			var/list/possibilities = output_qualities.Copy()

			if(LAZYLEN(possible_outputs) > 1)
				for(var/effect_name in possibilities)
					var/effect_type = possibilities[effect_name]
					if(output != effect_type && possible_outputs.Find(effect_type))
						possibilities.Remove(effect_name)

			var/decision = input("Choose a reagent:","Adjusting Organoid") as null|anything in possibilities
			if(!decision)
				return

			var/output_amount = possible_outputs[output]
			possible_outputs[possible_outputs.Find(output)] = output_qualities[decision]
			possible_outputs[output_qualities[decision]] = output_amount

/datum/component/modification/organ/output/reagents/trigger(atom/movable/holder, mob/living/carbon/owner, list/input)
	if(!holder || !owner || !input || !mode)
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/organ_multiplier = (S.max_damage - S.damage) / S.max_damage
	var/datum/reagents/metabolism/RM = owner.get_metabolism_handler(mode)
	var/triggered = FALSE

	if(LAZYLEN(input))
		for(var/i in input)
			var/index = input.Find(i)
			var/is_input_valid = input[i] ? TRUE : FALSE
			if(is_input_valid && index <= LAZYLEN(possible_outputs))
				var/input_multiplier = input[i]
				var/datum/reagent/output = possible_outputs[index]
				var/amount_to_add = possible_outputs[output] * organ_multiplier * input_multiplier
				RM.add_reagent(initial(output.id), amount_to_add)
				triggered = TRUE

	if(triggered)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_COOLDOWN)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_SECONDARY, owner)


/datum/component/modification/organ/output/chemical_effects	// More organ-like than producing reagents
	adjustable = TRUE

/datum/component/modification/organ/output/chemical_effects/get_function_info()
	var/outputs
	for(var/output in possible_outputs)
		var/datum/reagent/hormone/H
		if(ispath(output, /datum/reagent/hormone))
			H = output

		outputs += "[initial(H.name)] (type ["[initial(H.hormone_type)]"]), "

	outputs = copytext(outputs, 1, length(outputs) - 1)

	var/description = "<span style='color:blue'>Functional information (output):</span> secretes hormones"
	description += "\n<span style='color:blue'>Effects produced:</span> [outputs]"

	return description

/datum/component/modification/organ/output/chemical_effects/modify(obj/item/I, mob/living/user)
	if(!LAZYLEN(output_qualities))
		return

	for(var/output in possible_outputs)
		var/list/possibilities = output_qualities.Copy()

		if(LAZYLEN(possible_outputs) > 1)
			for(var/effect_name in possibilities)
				var/effect_type = possibilities[effect_name]
				if(output != effect_type && possible_outputs.Find(effect_type))
					possibilities.Remove(effect_name)

		var/decision = input("Choose a hormone effect (current: [output])","Adjusting Organoid") as null|anything in possibilities
		if(!decision)
			continue

		var/new_output = output_qualities[decision]
		var/amount = possible_outputs[output]

		possible_outputs[possible_outputs.Find(output)] = new_output
		possible_outputs[new_output] = amount

/datum/component/modification/organ/output/chemical_effects/trigger(atom/movable/holder, mob/living/carbon/owner, list/input)
	if(!holder || !owner || !input)
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/organ_multiplier = ((S.max_damage - S.damage) / S.max_damage) * (S.aberrant_cooldown_time / (2 SECONDS))	// Life() is called every 2 seconds
	var/datum/reagents/metabolism/RM = owner.get_metabolism_handler(CHEM_BLOOD)
	var/triggered = FALSE

	if(LAZYLEN(input))
		for(var/i in input)
			var/index = input.Find(i)
			var/is_input_valid = input[i] ? TRUE : FALSE
			if(is_input_valid && index <= LAZYLEN(possible_outputs))
				var/input_multiplier = input[i]
				var/datum/reagent/output = possible_outputs[index]
				var/amount_to_add = initial(output.metabolism) * organ_multiplier * input_multiplier
				RM.add_reagent(initial(output.id), amount_to_add)
				triggered = TRUE

	if(triggered)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_COOLDOWN)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_SECONDARY, owner)


/datum/component/modification/organ/output/stat_boost
	adjustable = TRUE

/datum/component/modification/organ/output/stat_boost/get_function_info()
	var/outputs
	for(var/stat in possible_outputs)
		outputs += stat + " ([possible_outputs[stat]]), "

	outputs = copytext(outputs, 1, length(outputs) - 1)

	var/description = "<span style='color:blue'>Functional information (output):</span> augments physical/mental affinity"
	description += "\n<span style='color:blue'>Affinities:</span> [outputs]"

	return description

/datum/component/modification/organ/output/stat_boost/modify(obj/item/I, mob/living/user)
	if(!LAZYLEN(output_qualities))
		return

	for(var/output in possible_outputs)
		var/list/possibilities = output_qualities.Copy()
		var/output_amount = possible_outputs[output]
		if(LAZYLEN(possible_outputs) > 1)
			for(var/stat in possibilities)
				if(output != stat && possible_outputs.Find(stat))
					possibilities.Remove(stat)

		var/decision = input("Choose an affinity (current: [output])","Adjusting Organoid") as null|anything in possibilities
		if(!decision)
			continue

		possible_outputs[possible_outputs.Find(output)] = decision
		possible_outputs[decision] = output_amount

/datum/component/modification/organ/output/stat_boost/trigger(atom/movable/holder, mob/living/carbon/owner, list/input)
	if(!holder || !owner || !input)
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/organ_multiplier = (S.max_damage - S.damage) / S.max_damage
	var/delay = S.aberrant_cooldown_time + 2 SECONDS
	var/triggered = FALSE

	if(LAZYLEN(input) && iscarbon(owner))
		for(var/i in input)
			var/index = input.Find(i)
			var/is_input_valid = input[i] ? TRUE : FALSE
			if(is_input_valid && index <= LAZYLEN(possible_outputs))
				var/input_multiplier = input[i]
				var/stat = possible_outputs[index]
				var/magnitude = possible_outputs[stat] * organ_multiplier * input_multiplier
				owner.stats.addTempStat(stat, magnitude, delay, "aberrant_output")
				triggered = TRUE

	if(triggered)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_COOLDOWN)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_SECONDARY, owner)


/datum/component/modification/organ/output/produce
	adjustable = TRUE

/datum/component/modification/organ/output/produce/get_function_info()
	var/outputs
	for(var/output in possible_outputs)
		var/atom/movable/AM = output
		outputs += initial(AM.name) + " ([possible_outputs[AM]]), "

	outputs = copytext(outputs, 1, length(outputs) - 1)

	var/description = "<span style='color:blue'>Functional information (output):</span> produces objects"
	description += "\n<span style='color:blue'>Products (quantity):</span> [outputs]"

	return description

/datum/component/modification/organ/output/produce/modify(obj/item/I, mob/living/user)
	if(!LAZYLEN(output_qualities))
		return

	for(var/output in possible_outputs)
		var/atom/movable/AM = output
		var/name = initial(AM.name)
		var/list/possibilities_by_name = list()
		var/output_amount = possible_outputs[output]

		for(var/possible_path in output_qualities)
			var/atom/possible = possible_path
			var/possible_name = initial(possible.name)
			possibilities_by_name |= possible_name
			possibilities_by_name[possible_name] = possible_path

		if(LAZYLEN(possible_outputs) > 1)
			for(var/object_name in possibilities_by_name)
				var/object_path = possibilities_by_name[object_name]
				if(output != object_path && possible_outputs.Find(object_path))
					possibilities_by_name.Remove(object_name)

		var/decision = input("Choose a product (current: [name])","Adjusting Organoid") as null|anything in possibilities_by_name
		if(!decision)
			continue

		var/decision_path = possibilities_by_name[decision]
		possible_outputs[possible_outputs.Find(output)] = decision_path
		possible_outputs[decision_path] = output_amount

/datum/component/modification/organ/output/produce/trigger(atom/movable/holder, mob/living/carbon/owner, list/input)
	if(!holder || !owner || !input)
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/organ_multiplier = (S.max_damage - S.damage) / S.max_damage
	var/triggered = FALSE

	if(LAZYLEN(input) && iscarbon(owner))
		for(var/i in input)
			var/index = input.Find(i)
			var/is_input_valid = input[i] ? TRUE : FALSE
			if(is_input_valid && index <= LAZYLEN(possible_outputs))
				var/input_multiplier = input[i]
				var/object_count = round(input_multiplier * organ_multiplier)
				var/object_path = possible_outputs[index]
				for(var/count in 1 to object_count)
					new object_path(get_turf(owner))
				triggered = TRUE

	if(triggered)
		if(prob(50))
			playsound(owner, 'sound/effects/squelch1.ogg', 50, 1)
		else
			playsound(owner, 'sound/effects/splat.ogg', 50, 1)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_COOLDOWN)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_SECONDARY, owner)

/datum/component/modification/organ/output/chem_smoke
	adjustable = TRUE
	var/current_mode = null
	var/list/modes = list()
	var/datum/reagents/gas_sac
	var/datum/effect/effect/system/smoke_spread/chem/gas_cloud

/datum/component/modification/organ/output/chem_smoke/Initialize(...)
	. = ..()
	gas_sac = new /datum/reagents(80, null)	// Null my_atom means no reactions or chem processing
	gas_cloud = new
	gas_cloud.show_log = FALSE

/datum/component/modification/organ/output/chem_smoke/get_function_info()
	var/metabolism
	switch(current_mode)
		if(null)
			metabolism = "internal gas sac"
		if(CHEM_TOUCH)
			metabolism = "skin"
		if(CHEM_INGEST)
			metabolism = "stomach"
		if(CHEM_BLOOD)
			metabolism = "bloodstream"
		else
			metabolism = "nothing"

	var/description = "<span style='color:blue'>Functional information (output):</span> produces gas cloud from [metabolism]"

	if(!current_mode)
		var/outputs
		for(var/reagent in possible_outputs)
			var/datum/reagent/R = reagent
			outputs += initial(R.name) + " ([possible_outputs[R]]u), "
		outputs = copytext(outputs, 1, length(outputs) - 1)
		description +="\n<span style='color:blue'>Reagent(s):</span> [outputs]"

	return description

/datum/component/modification/organ/output/chem_smoke/modify(obj/item/I, mob/living/user)
	var/list/can_adjust = list("reagent source", "reagent")

	var/decision_adjust = input("What do you want to adjust?","Adjusting Organoid") as null|anything in can_adjust
	if(!decision_adjust)
		return

	var/list/adjustable_qualities = list()
	switch(decision_adjust)
		if("reagent source")
			if(LAZYLEN(modes) < 2)
				to_chat(user, SPAN_NOTICE("\The [parent] does not have any other reagent sources."))
				return

			adjustable_qualities = modes

			var/decision = input("Choose a reagent source","Adjusting Organoid") as null|anything in adjustable_qualities
			if(!decision)
				return

			current_mode = adjustable_qualities[decision]
		if("reagent")
			if(!LAZYLEN(output_qualities))
				to_chat(user, SPAN_NOTICE("\The [parent] does not have any reagents to select."))
				return

			for(var/reagent in output_qualities)
				var/datum/reagent/R = reagent
				var/reagent_name = initial(R.name)
				adjustable_qualities |= reagent_name
				adjustable_qualities[reagent_name] = reagent

			for(var/output in possible_outputs)
				if(LAZYLEN(possible_outputs) > 1)
					for(var/path in adjustable_qualities)
						if(output != path && possible_outputs.Find(path))
							adjustable_qualities.Remove(path)

				var/datum/reagent/R = output
				var/reagent_name = initial(R.name)

				var/decision = input("Choose a reagent (current: [reagent_name])","Adjusting Organoid") as null|anything in adjustable_qualities
				if(!decision)
					return

				var/output_amount = possible_outputs[output]
				possible_outputs[possible_outputs.Find(output)] = adjustable_qualities[decision]
				possible_outputs[output] = output_amount

/datum/component/modification/organ/output/chem_smoke/trigger(atom/movable/holder, mob/living/carbon/owner, list/input)
	if(!holder || !owner || !input)
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	//var/obj/item/organ/external/limb = S.parent
	var/organ_multiplier = (S.max_damage - S.damage) / S.max_damage
	var/datum/reagents/metabolism/RM = owner.get_metabolism_handler(current_mode)
	var/reagent_permeability = owner.reagent_permeability()
	var/triggered = FALSE

	if(reagent_permeability < 0.10)
		return

	if(LAZYLEN(input))
		for(var/i in input)
			var/index = input.Find(i)
			var/is_input_valid = input[i] ? TRUE : FALSE
			if(is_input_valid && index <= LAZYLEN(possible_outputs))
				var/input_multiplier = input[i] * organ_multiplier * reagent_permeability
				var/datum/reagent/cloud_reagent = possible_outputs[index]
				var/gas_cloud_volume = min(possible_outputs[cloud_reagent] * input_multiplier, gas_sac.maximum_volume)	// Every 10 units is 3 tiles of range

				if(RM)
					RM.trans_to_holder(gas_sac, gas_cloud_volume, copy = FALSE)
				else
					gas_sac.add_reagent(initial(cloud_reagent.id), gas_cloud_volume)

				if(gas_sac.total_volume)
					var/location = get_turf(owner)
					gas_cloud.attach(location)
					gas_cloud.set_up(gas_sac, gas_cloud_volume, 0, location)
					owner.visible_message(SPAN_DANGER("\the [owner] exhales strange vapors!"))
					addtimer(CALLBACK(src, .proc/smoke_trigger), 1, TIMER_STOPPABLE)
					triggered = TRUE

	if(triggered)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_COOLDOWN)
		SEND_SIGNAL(holder, COMSIG_ABERRANT_SECONDARY, owner)

/datum/component/modification/organ/output/chem_smoke/proc/smoke_trigger()
	if(gas_cloud)
		gas_cloud.start()
		gas_sac.clear_reagents()
