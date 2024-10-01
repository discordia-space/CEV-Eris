/obj/item/modification/organ/internal/input
	name = "organoid (input)"
	icon_state = "input_organoid"
	bad_type = /obj/item/modification/organ/internal/input

/obj/item/modification/organ/internal/input/reagents
	name = "metabolic organoid"
	desc = "Functional tissue of one or more organs in graftable form. Enhances metabolism of reagents."
	description_info = "Requires the specified reagent(s) to be present in one of the three metabolism holders: bloodstream, ingested, or touch. \
						The reagent will be removed at a rate equal to its metabolism times the length of the organ\'s cooldown in ticks. \
						Then, the process will trigger.\n\n\
						Use a laser cutting tool to change the metabolism source or reagent type.\n\
						Reagents can only be swapped for like reagents."

/obj/item/modification/organ/internal/input/reagents/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/input_args)
	var/datum/component/modification/organ/input/reagents/I = AddComponent(/datum/component/modification/organ/input/reagents)

	var/list/inputs = input_args[1]
	var/list/input_selection = input_args[3]
	var/list/new_input_qualities = list()

	for(var/input in inputs)
		I.accepted_inputs += input
	I.check_mode = input_args[2]

	for(var/quality in input_selection)
		if(ispath(quality, /datum/reagent))
			var/datum/reagent/R = quality
			var/reagent_name = initial(R.name)
			new_input_qualities |= reagent_name
			new_input_qualities[reagent_name] = quality

	I.input_qualities = new_input_qualities
	..()

/obj/item/modification/organ/internal/input/damage
	name = "nociceptive organoid"
	desc = "Functional tissue of one or more organs in graftable form. Responds to damaging stimuli."
	description_info = "Requires the specified damage type(s) to be present. The process is triggered when at least one point of damage is taken \
						(can be inflicted before attaching the organ), but no damage is healed.\n\n\
						Use a laser cutting tool to change the damage type."

/obj/item/modification/organ/internal/input/damage/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/input_args)
	var/datum/component/modification/organ/input/damage/I = AddComponent(/datum/component/modification/organ/input/damage)

	var/list/inputs = input_args[1]
	var/list/input_selection = input_args[3]
	var/list/new_input_qualities = list()

	for(var/input in inputs)
		I.accepted_inputs += input
	I.threshold = input_args[2]

	for(var/quality in input_selection)
		if(istext(quality))
			var/dmg_name
			switch(quality)
				if(BRUTE)
					dmg_name = "brute"
				if(BURN)
					dmg_name = "burn"
				if(OXY)
					dmg_name = "suffocation"
				if(HALLOSS)
					dmg_name = "pain"
				else
					dmg_name = quality

			new_input_qualities |= dmg_name
			new_input_qualities[dmg_name] = quality

	I.input_qualities = new_input_qualities
	..()

/obj/item/modification/organ/internal/input/consume
	name = "mandibular organoid"
	desc = "Functional tissue of one or more organs in graftable form. Consumes objects."
	description_info = "On use, consumes a held object and ingests any contained reagents.\n\n\
						Use a laser cutting tool to change the consumable object type."

/obj/item/modification/organ/internal/input/consume/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/input_args)
	var/datum/component/modification/organ/input/consume/I = AddComponent(/datum/component/modification/organ/input/consume)

	var/list/inputs = input_args[1]
	var/list/input_selection = input_args[2]
	var/list/new_input_qualities = list()

	for(var/input in inputs)
		if(!ispath(input))
			continue
		I.accepted_inputs += input

	for(var/quality in input_selection)
		if(ispath(quality))
			var/atom/movable/AM = quality
			var/object_name = initial(AM.name)
			new_input_qualities |= object_name
			new_input_qualities[object_name] = quality

	I.input_qualities = new_input_qualities

	I.modifications[ITEM_VERB_NAME] = "Consume held object"
	..()

/obj/item/modification/organ/internal/input/power_source
	name = "bioelectric organoid"
	desc = "Functional tissue of one or more organs in graftable form. Converts power sources into bioavailable nutrients."
	description_info = "Requries the specified power source to be held in the bare hand of the organ's owner. Any amount of charge in a cell or sheets \
						in a stack will trigger the process, but larger cells and rarer materials will provide a slight cognition and sanity boost.\n\n\
						Use a laser cutting tool to change the power source type."
	icon_state = "input_organoid-hive"
	use_generated_icon = FALSE

/obj/item/modification/organ/internal/input/power_source/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/input_args)
	var/datum/component/modification/organ/input/power_source/I = AddComponent(/datum/component/modification/organ/input/power_source)

	var/list/inputs = input_args[1]
	var/list/input_selection = input_args[3]
	var/list/new_input_qualities = list()

	for(var/input in inputs)
		if(!ispath(input))
			continue
		I.accepted_inputs += input
	I.threshold = input_args[2]

	for(var/quality in input_selection)
		if(ispath(quality))
			var/atom/movable/AM = quality
			var/source_name
			switch(quality)
				if(/obj/item/cell/small)
					source_name = "small power cell"
				if(/obj/item/cell/medium)
					source_name = "medium power cell"
				if(/obj/item/cell/large)
					source_name = "large power cell"
				else
					source_name = initial(AM.name)

			new_input_qualities |= source_name
			new_input_qualities[source_name] = quality

	I.input_qualities = new_input_qualities
	..()
