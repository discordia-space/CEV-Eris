// Flavorful holder object for organoids. Organoids should almost never spawn outside of these.
/obj/item/organ/internal/scaffold/aberrant/teratoma
	name = "teratoma"
	desc = "An abnormal growth of organ tissue."
	description_info = "A functionless organ with space for a single organoid. Use a laser cutting tool to remove the organoid and recycle the leftover teratoma tissue in the disgorger."
	ruined_name = "ruined teratoma"
	ruined_desc = "An abnormal growth of organ tissue. Ruined by use."
	ruined_description_info = "Useless organ tissue. Recycle this in a disgorger."
	ruined_color = "#696969"
	icon_state = "teratoma"

	maxUpgrades = 1
	use_generated_name = FALSE
	use_generated_color = FALSE
	req_num_inputs = null
	req_num_outputs = null

/obj/item/organ/internal/scaffold/aberrant/teratoma/New()
	if(input_mod_path)
		if(!ispath(input_mod_path))
			input_mod_path = pick(subtypesof(/obj/item/modification/organ/internal/input))
	else if(process_mod_path)
		if(!ispath(process_mod_path))
			process_mod_path = pick(subtypesof(/obj/item/modification/organ/internal/process))
	else if(output_mod_path)
		if(!ispath(output_mod_path))
			output_mod_path = pick(subtypesof(/obj/item/modification/organ/internal/output))
	else if(special_mod_path)
		if(!ispath(special_mod_path))
			special_mod_path = pick(subtypesof(/obj/item/modification/organ/internal/special/on_pickup) +\
									subtypesof(/obj/item/modification/organ/internal/special/on_item_examine) +\
									subtypesof(/obj/item/modification/organ/internal/special/on_cooldown/chemical_effect) +\
									subtypesof(/obj/item/modification/organ/internal/special/on_cooldown/stat_boost))
		else
			special_mod_path = pick(subtypesof(special_mod_path))	// Janky, but there aren't enough secondary effects to matter yet

	switch(input_mod_path)
		if(/obj/item/modification/organ/internal/input/damage)
			if(!specific_input_type_pool?.len)
				if(req_num_inputs > 1)
					specific_input_type_pool = ALL_DAMAGE_TYPES
					if(req_num_inputs > 2)
						input_threshold = 15
					else
						input_threshold = 30
				else
					specific_input_type_pool = DAMAGE_TYPES_BASIC
					input_threshold = 45

			input_mode = NOT_USED

		if(/obj/item/modification/organ/internal/input/power_source)
			if(!specific_input_type_pool?.len)
				specific_input_type_pool = ALL_USABLE_POWER_SOURCES
			input_mode = NOT_USED
			input_threshold = 0

		if(/obj/item/modification/organ/internal/input/reagents)
			if(!input_mode)
				input_mode = pick(CHEM_TOUCH, CHEM_INGEST, CHEM_BLOOD)
			if(!specific_input_type_pool?.len)
				var/list/possible_reagent_classes = list()
				possible_reagent_classes |= list(REAGENTS_ROACH, REAGENTS_SPIDER, REAGENTS_DISPENSER, REAGENTS_TOXIN)
				if(input_mode == CHEM_INGEST)
					possible_reagent_classes |= list(REAGENTS_EDIBLE, REAGENTS_ALCOHOL)
				if(input_mode == CHEM_BLOOD)
					possible_reagent_classes |= list(REAGENTS_MEDICINE_BASIC, REAGENTS_DRUGS)
				specific_input_type_pool = pick(possible_reagent_classes)
			input_threshold = 0

	switch(output_mod_path)
		if(/obj/item/modification/organ/internal/output/reagents_blood)
			if(!output_pool?.len)
				var/list/possible_reagent_classes = list()
				possible_reagent_classes |= list(REAGENTS_DRUGS, REAGENTS_ROACH, REAGENTS_MEDICINE_SIMPLE, REAGENTS_MEDICINE_INTERMEDIATE)
				output_pool = pick(possible_reagent_classes)
			if(!output_info?.len)
				for(var/i in 1 to req_num_outputs)
					output_info += pick(LOW_OUTPUT)

		if(/obj/item/modification/organ/internal/output/reagents_ingest)
			if(!output_pool?.len)
				var/list/possible_reagent_classes = list()
				possible_reagent_classes |= list(REAGENTS_EDIBLE, REAGENTS_ALCOHOL, REAGENTS_ROACH, REAGENTS_MEDICINE_SIMPLE, REAGENTS_MEDICINE_INTERMEDIATE)
				output_pool = pick(possible_reagent_classes)
			if(!output_info?.len)
				for(var/i in 1 to req_num_outputs)
					output_info += pick(LOW_OUTPUT)

		if(/obj/item/modification/organ/internal/output/chemical_effects)
			if(!output_pool?.len)
				var/list/possible_hormone_types = list()
				possible_hormone_types = list(TYPE_1_HORMONES, TYPE_2_HORMONES)
				output_pool = pick(possible_hormone_types)
			if(!output_info?.len)
				for(var/i in 1 to req_num_outputs)
					output_info += NOT_USED

		if(/obj/item/modification/organ/internal/output/stat_boost)
			if(!output_pool?.len)
				output_pool = ALL_STATS
			if(!output_info?.len)
				for(var/i in 1 to req_num_outputs)
					output_info += MID_OUTPUT

		if(/obj/item/modification/organ/internal/output/damaging_insight_gain)
			if(!output_pool?.len)
				output_pool = list(BRUTE, BURN, TOX, OXY, CLONE, PSY)
			for(var/i in 1 to req_num_outputs)
				output_info += 1

		if(/obj/item/modification/organ/internal/output/activate_organ_functions)
			if(!output_pool?.len)
				output_pool = ALL_STANDARD_ORGAN_EFFICIENCIES
			for(var/i in 1 to req_num_outputs)
				output_info += 1

	..()

/obj/item/organ/internal/scaffold/aberrant/teratoma/ruin()
	..()
	use_generated_name = FALSE
	maxUpgrades = 0
	price_tag = 25
	matter = list(MATERIAL_BIOMATTER = 5)
	STOP_PROCESSING(SSobj, src)

// input
/obj/item/organ/internal/scaffold/aberrant/teratoma/input
	name = "teratoma (input)"
	req_num_inputs = 1
	input_mod_path = TRUE

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/uncommon
	name = "bulging teratoma (input)"
	req_num_inputs = 2

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/rare
	name = "throbbing teratoma (input)"
	req_num_inputs = 4


/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents
	name = "metabolic teratoma"
	description_info = "A teratoma that houses a metabolic organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Requires the specified reagent(s) to be present in one of the three metabolism holders: bloodstream, ingested, or touch. \
						When the correct reagent is in the correct holder, the reagent will be removed at a rate equal to its metabolism times \
						the length of the organ\'s cooldown in ticks. Then, the process will trigger."
	input_mod_path = /obj/item/modification/organ/internal/input/reagents

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/roach
	name = "metabolic teratoma (roach)"
	specific_input_type_pool = REAGENTS_ROACH

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/spider
	name = "metabolic teratoma (spider)"
	specific_input_type_pool = REAGENTS_SPIDER

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/toxin
	name = "metabolic teratoma (toxins)"
	specific_input_type_pool = REAGENTS_TOXIN

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/edible
	name = "metabolic teratoma (edible)"
	specific_input_type_pool = REAGENTS_EDIBLE

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/alcohol
	name = "metabolic teratoma (alcohol)"
	specific_input_type_pool = REAGENTS_ALCOHOL

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/drugs
	name = "metabolic teratoma (drugs)"
	specific_input_type_pool = REAGENTS_DRUGS

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/dispenser
	name = "metabolic teratoma (chemical)"
	specific_input_type_pool = REAGENTS_DISPENSER


/obj/item/organ/internal/scaffold/aberrant/teratoma/input/damage
	name = "nociceptive teratoma"
	description_info = "A teratoma that houses a nociceptive organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Requires the specified damage type(s) to be present. The process is triggered when at least one point of damage is taken \
						(can be inflicted before attaching the organ), but no damage is healed."
	input_mod_path = /obj/item/modification/organ/internal/input/damage

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/power_source
	name = "bioelectric teratoma"
	description_info = "A teratoma that houses a bioelectric organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Requries the specified power source to be held in the bare hand of the organ's owner. Any amount of charge in a cell or sheets \
						in a stack will trigger the process, but larger cells and rarer materials will provide a slight cognition and sanity boost."
	input_mod_path = /obj/item/modification/organ/internal/input/power_source


/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/uncommon
	name = "bulging metabolic teratoma"
	req_num_inputs = 2

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/uncommon/roach
	name = "bulging metabolic teratoma (roach)"
	specific_input_type_pool = REAGENTS_ROACH

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/uncommon/spider
	name = "bulging metabolic teratoma (spider)"
	specific_input_type_pool = REAGENTS_SPIDER

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/uncommon/toxin
	name = "bulging metabolic teratoma (toxins)"
	specific_input_type_pool = REAGENTS_TOXIN

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/uncommon/edible
	name = "bulging metabolic teratoma (edible)"
	specific_input_type_pool = REAGENTS_EDIBLE

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/uncommon/alcohol
	name = "bulging metabolic teratoma (alcohol)"
	specific_input_type_pool = REAGENTS_ALCOHOL

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/uncommon/drugs
	name = "bulging metabolic teratoma (drugs)"
	specific_input_type_pool = REAGENTS_DRUGS

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/uncommon/dispenser
	name = "bulging metabolic teratoma (chemical)"
	specific_input_type_pool = REAGENTS_DISPENSER

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/damage/uncommon
	name = "bulging nociceptive teratoma"
	req_num_inputs = 2

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/power_source/uncommon
	name = "bulging bioelectric teratoma"
	req_num_inputs = 2


/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/rare
	name = "throbbing metabolic teratoma"
	req_num_inputs = 4

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/rare/roach
	name = "throbbing metabolic teratoma (roach)"
	specific_input_type_pool = REAGENTS_ROACH

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/rare/spider
	name = "throbbing metabolic teratoma (spider)"
	specific_input_type_pool = REAGENTS_SPIDER

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/rare/toxin
	name = "throbbing metabolic teratoma (toxins)"
	specific_input_type_pool = REAGENTS_TOXIN

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/rare/edible
	name = "throbbing metabolic teratoma (edible)"
	specific_input_type_pool = REAGENTS_EDIBLE

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/rare/alcohol
	name = "throbbing metabolic teratoma (alcohol)"
	specific_input_type_pool = REAGENTS_ALCOHOL

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/rare/drugs
	name = "throbbing metabolic teratoma (drugs)"
	specific_input_type_pool = REAGENTS_DRUGS

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/rare/dispenser
	name = "throbbing metabolic teratoma (chemical)"
	specific_input_type_pool = REAGENTS_DISPENSER


/obj/item/organ/internal/scaffold/aberrant/teratoma/input/damage/rare
	name = "throbbing nociceptive teratoma"
	req_num_inputs = 4

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/power_source/rare
	name = "throbbing bioelectric teratoma"
	req_num_inputs = 4

// process
/obj/item/organ/internal/scaffold/aberrant/teratoma/process
	name = "teratoma (processing)"
	process_mod_path = TRUE

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/map
	name = "tubular teratoma"
	description_info = "A teratoma that houses a tubular organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Maps inputs to outputs. Works for any number of inputs and outputs."
	process_mod_path = /obj/item/modification/organ/internal/process/map

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/condense
	name = "sphincter teratoma"
	description_info = "A teratoma that houses a sphincter organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Maps inputs to a single output. If there are multiple outputs, it only uses the first."
	process_mod_path = /obj/item/modification/organ/internal/process/condense

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/boost
	name = "enzymal teratoma"
	description_info = "A teratoma that houses an enzymal organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Maps inputs to outputs. Increases output magnitude."
	process_mod_path = /obj/item/modification/organ/internal/process/boost

// output
/obj/item/organ/internal/scaffold/aberrant/teratoma/output
	name = "teratoma (output)"
	req_num_outputs = 1
	output_mod_path = TRUE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/uncommon
	name = "bulging teratoma (output)"
	req_num_outputs = 2

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/rare
	name = "throbbing teratoma (output)"
	req_num_outputs = 4

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood
	name = "hepatic teratoma"
	description_info = "A teratoma that houses an hepatic organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Produces reagents in the bloodstream when triggered."
	req_num_outputs = 1
	output_mod_path = /obj/item/modification/organ/internal/output/reagents_blood

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/roach
	name = "hepatic teratoma (roach)"
	output_pool = REAGENTS_ROACH

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/drugs
	name = "hepatic teratoma (drugs)"
	output_pool = REAGENTS_DRUGS

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/medicine_simple
	name = "hepatic teratoma (medicine)"
	output_pool = REAGENTS_MEDICINE_SIMPLE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/medicine_intermediate
	name = "hepatic teratoma (medicine II)"
	output_pool = REAGENTS_MEDICINE_INTERMEDIATE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest
	name = "gastric teratoma"
	description_info = "A teratoma that houses a gastric organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Produces reagents in the stomach when triggered."
	req_num_outputs = 1
	output_mod_path = /obj/item/modification/organ/internal/output/reagents_ingest

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest/edible
	name = "gastric teratoma (edible)"
	output_pool = REAGENTS_EDIBLE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest/alcohol
	name = "gastric teratoma (alcohol)"
	output_pool = REAGENTS_ALCOHOL

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects
	name = "endocrinal teratoma"
	description_info = "A teratoma that houses an endocrinal organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Produces hormones in the bloodstream when triggered."
	req_num_outputs = 1
	output_mod_path = /obj/item/modification/organ/internal/output/chemical_effects

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects/type_1
	name = "endocrinal teratoma (type 1)"
	output_pool = TYPE_1_HORMONES

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects/type_2
	name = "endocrinal teratoma (type 2)"
	output_pool = TYPE_2_HORMONES

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/stat_boost
	name = "intracrinal teratoma"
	description_info = "A teratoma that houses an intracrinal organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Slightly increase stats when triggered."
	req_num_outputs = 1
	output_mod_path = /obj/item/modification/organ/internal/output/stat_boost


/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/uncommon
	name = "bulging hepatic teratoma"
	req_num_outputs = 2

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/uncommon/roach
	name = "bulging hepatic teratoma (roach)"
	output_pool = REAGENTS_ROACH

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/uncommon/drugs
	name = "bulging hepatic teratoma (drugs)"
	output_pool = REAGENTS_DRUGS

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/uncommon/medicine_simple
	name = "bulging hepatic teratoma (medicine)"
	output_pool = REAGENTS_MEDICINE_SIMPLE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/uncommon/medicine_intermediate
	name = "bulging hepatic teratoma (medicine II)"
	output_pool = REAGENTS_MEDICINE_INTERMEDIATE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest/uncommon
	name = "bulging gastric teratoma"
	req_num_outputs = 2

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest/uncommon/edible
	name = "bulging gastric teratoma (edible)"
	output_pool = REAGENTS_EDIBLE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest/uncommon/alcohol
	name = "bulging gastric teratoma (alcohol)"
	output_pool = REAGENTS_ALCOHOL

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects/uncommon
	name = "bulging endocrinal teratoma"
	req_num_outputs = 2

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects/uncommon/type_1
	name = "bulging endocrinal teratoma (type 1)"
	output_pool = TYPE_1_HORMONES

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects/uncommon/type_2
	name = "bulging endocrinal teratoma (type 2)"
	output_pool = TYPE_2_HORMONES

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/stat_boost/uncommon
	name = "bulging intracrinal teratoma"
	req_num_outputs = 2


/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/rare
	name = "throbbing hepatic teratoma"
	req_num_outputs = 4

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/rare/roach
	name = "throbbing hepatic teratoma (roach)"
	output_pool = REAGENTS_ROACH

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/rare/drugs
	name = "throbbing hepatic teratoma (drugs)"
	output_pool = REAGENTS_DRUGS

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/rare/medicine_simple
	name = "throbbing hepatic teratoma (medicine)"
	output_pool = REAGENTS_MEDICINE_SIMPLE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/rare/medicine_intermediate
	name = "throbbing hepatic teratoma (medicine II)"
	output_pool = REAGENTS_MEDICINE_INTERMEDIATE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest/rare
	name = "throbbing gastric teratoma"
	req_num_outputs = 4

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest/rare/edible
	name = "throbbing gastric teratoma (edible)"
	output_pool = REAGENTS_EDIBLE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest/rare/alcohol
	name = "throbbing gastric teratoma (alcohol)"
	output_pool = REAGENTS_ALCOHOL

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects/rare
	name = "throbbing endocrinal teratoma"
	req_num_outputs = 4

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects/rare/type_1
	name = "throbbing endocrinal teratoma (type 1)"
	output_pool = TYPE_1_HORMONES

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/chemical_effects/rare/type_2
	name = "throbbing endocrinal teratoma (type 2)"
	output_pool = TYPE_2_HORMONES

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/stat_boost/rare
	name = "throbbing intracrinal teratoma"
	req_num_outputs = 4


// special
/obj/item/organ/internal/scaffold/aberrant/teratoma/special
	name = "teratoma (unknown)"
	special_mod_path = TRUE

/obj/item/organ/internal/scaffold/aberrant/teratoma/special/chemical_effect
	name = "pygmy endocrinal teratoma"
	description_info = "A teratoma that houses a pygmy endocrinal membrane. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Membrane information:\n\
						Produces a hormone when the primary function triggers."
	special_mod_path = /obj/item/modification/organ/internal/special/on_cooldown/chemical_effect

/obj/item/organ/internal/scaffold/aberrant/teratoma/special/stat_boost
	name = "pygmy intracrinal teratoma"
	description_info = "A teratoma that houses a pygmy intracrinal membrane. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Membrane information:\n\
						Slightly increases a stat when the primary function triggers."
	special_mod_path = /obj/item/modification/organ/internal/special/on_cooldown/stat_boost

// random
/obj/item/organ/internal/scaffold/aberrant/teratoma/random
	name = "teratoma (unknown)"
	req_num_inputs = 1
	req_num_outputs = 1

/obj/item/organ/internal/scaffold/aberrant/teratoma/random/New()
	var/path = pick(/obj/item/modification/organ/internal/input,\
		/obj/item/modification/organ/internal/process,\
		/obj/item/modification/organ/internal/output,\
		/obj/item/modification/organ/internal/special\
		)
	switch(path)
		if(/obj/item/modification/organ/internal/input)
			input_mod_path = TRUE
			req_num_outputs = 0
		if(/obj/item/modification/organ/internal/process)
			process_mod_path = TRUE
			req_num_inputs = 0
			req_num_outputs = 0
		if(/obj/item/modification/organ/internal/output)
			output_mod_path = TRUE
			req_num_inputs = 0
		if(/obj/item/modification/organ/internal/special)
			special_mod_path = TRUE
			req_num_inputs = 0
			req_num_outputs = 0
	..()

/obj/item/organ/internal/scaffold/aberrant/teratoma/random/uncommon
	req_num_inputs = 2
	req_num_outputs = 2

/obj/item/organ/internal/scaffold/aberrant/teratoma/random/rare
	req_num_inputs = 4
	req_num_outputs = 4

/obj/item/storage/freezer/medical/contains_teratomas/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new  /obj/item/organ/internal/scaffold/aberrant/teratoma/random(NULLSPACE))
	for(var/count in 1 to 3)	// 79.6% to have at least one extra teratoma
		if(prob(40))
			spawnedAtoms.Add(new  /obj/item/organ/internal/scaffold/aberrant/teratoma/random(NULLSPACE))
	for(var/count in 1 to 3)	// 27.1% to have at least one uncommon teratoma
		if(prob(10))
			spawnedAtoms.Add(new  /obj/item/organ/internal/scaffold/aberrant/teratoma/random/uncommon(NULLSPACE))
	if(prob(5))
		spawnedAtoms.Add(new  /obj/item/organ/internal/scaffold/aberrant/teratoma/random/rare(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
