/obj/item/modification/organ/internal/output
	name = "organoid (output)"
	icon_state = "output_organoid"

/obj/item/modification/organ/internal/output/reagents_blood
	name = "hepatic organoid"
	desc = "Functional tissue of one or more organs in graftable form. Secretes reagents into the bloodstream."
	description_info = "Produces reagents in the bloodstream when triggered.\n\n\
						Use a laser cutting tool to change the metabolism target or reagent type.\n\
						Reagents can only be swapped for like reagents."

/obj/item/modification/organ/internal/output/reagents_blood/New(loc, generate_organ_stats = FALSE, predefined_modifier = null, list/output_types, list/additional_output_info)
	var/datum/component/modification/organ/output/reagents/O = AddComponent(/datum/component/modification/organ/output/reagents)

	for(var/output in output_types)
		O.possible_outputs += output
		O.possible_outputs[output] = output_types[output]
		O.mode = CHEM_BLOOD

	var/list/new_output_qualities = list()

	for(var/quality in additional_output_info)
		if(ispath(quality, /datum/reagent))
			var/datum/reagent/R = quality
			var/reagent_name = initial(R.name)
			new_output_qualities |= reagent_name
			new_output_qualities[reagent_name] = quality
	
	O.output_qualities = new_output_qualities
	..()

/obj/item/modification/organ/internal/output/reagents_ingest
	name = "gastric organoid"
	desc = "Functional tissue of one or more organs in graftable form. Produces reagents in the stomach."
	description_info = "Produces reagents in the stomach when triggered.\n\n\
						Use a laser cutting tool to change the metabolism target or reagent type.\n\
						Reagents can only be swapped for like reagents."

/obj/item/modification/organ/internal/output/reagents_ingest/New(loc, generate_organ_stats = FALSE, predefined_modifier = null, list/output_types, list/additional_output_info)
	var/datum/component/modification/organ/output/reagents/O = AddComponent(/datum/component/modification/organ/output/reagents)

	for(var/output in output_types)
		O.possible_outputs += output
		O.possible_outputs[output] = output_types[output]
		O.mode = CHEM_INGEST

	var/list/new_output_qualities = list()

	for(var/quality in additional_output_info)
		if(ispath(quality, /datum/reagent))
			var/datum/reagent/R = quality
			var/reagent_name = initial(R.name)
			new_output_qualities |= reagent_name
			new_output_qualities[reagent_name] = quality
	
	O.output_qualities = new_output_qualities
	..()

/obj/item/modification/organ/internal/output/chemical_effects
	name = "endocrinal organoid"
	desc = "Functional tissue of one or more organs in graftable form. Secretes hormones."
	description_info = "Produces hormones in the bloodstream when triggered.\n\n\
						Use a laser cutting tool to change the hormone type.\n\
						Hormone effects of the same type do not stack."

/obj/item/modification/organ/internal/output/chemical_effects/New(loc, generate_organ_stats = FALSE, predefined_modifier = null, list/output_types, list/additional_output_info)
	var/datum/component/modification/organ/output/chemical_effects/O = AddComponent(/datum/component/modification/organ/output/chemical_effects)

	for(var/output in output_types)
		O.possible_outputs += output
		O.possible_outputs[output] = output_types[output]

	var/list/new_output_qualities = list()

	for(var/quality in additional_output_info)
		var/effect
		switch(quality)
			if(/datum/reagent/hormone/bloodrestore, /datum/reagent/hormone/bloodrestore/alt)
				effect = "blood restoration"
			if(/datum/reagent/hormone/bloodclot, /datum/reagent/hormone/bloodclot/alt)
				effect = "blood clotting"
			if(/datum/reagent/hormone/painkiller, /datum/reagent/hormone/painkiller/alt)
				effect = "painkiller"
			if(/datum/reagent/hormone/antitox, /datum/reagent/hormone/antitox/alt)
				effect = "anti-toxin"
			if(/datum/reagent/hormone/oxygenation, /datum/reagent/hormone/oxygenation/alt)
				effect = "oxygenation"
			if(/datum/reagent/hormone/speedboost, /datum/reagent/hormone/speedboost/alt)
				effect = "augmented agility"

		new_output_qualities |= effect
		new_output_qualities[effect] = quality
	
	O.output_qualities = new_output_qualities
	..()

/obj/item/modification/organ/internal/output/stat_boost
	name = "intracrinal organoid"
	desc = "Functional tissue of one or more organs in graftable form. Secretes stimulating hormones."
	description_info = "Slightly increases stats when triggered.\n\n\
						Use a laser cutting tool to change the target stat."

/obj/item/modification/organ/internal/output/stat_boost/New(loc, generate_organ_stats = FALSE, predefined_modifier = null, list/output_types, list/additional_output_info)
	var/datum/component/modification/organ/output/stat_boost/O = AddComponent(/datum/component/modification/organ/output/stat_boost)

	for(var/output in output_types)
		O.possible_outputs += output
		O.possible_outputs[output] = output_types[output]
	
	O.output_qualities = additional_output_info.Copy()
	..()

/obj/item/modification/organ/internal/output/damaging_insight_gain
	name = "enigmatic organoid"
	desc = "Functional tissue of one or more organs in graftable form. It's function is unknown."

/obj/item/modification/organ/internal/output/damaging_insight_gain/New(loc, generate_organ_stats = FALSE, predefined_modifier = null, list/output_types)
	var/datum/component/modification/organ/output/damaging_insight_gain/O = AddComponent(/datum/component/modification/organ/output/damaging_insight_gain)

	for(var/output in output_types)
		O.possible_outputs += output
		O.possible_outputs[output] = output_types[output]
	..()

/obj/item/modification/organ/internal/output/activate_organ_functions
	name = "dependent organoid"
	desc = "Functional tissue of one or more organs in graftable form. Only performs organ functions when triggered."

/obj/item/modification/organ/internal/output/activate_organ_functions/New(loc, generate_organ_stats = FALSE, predefined_modifier = null, list/output_types)
	var/datum/component/modification/organ/output/activate_organ_functions/O = AddComponent(/datum/component/modification/organ/output/activate_organ_functions)

	for(var/output in output_types)
		var/modifier = output_types[output]
		var/list/organ_stats = ALL_ORGAN_STATS[output]
		O.active_organ_efficiency_mod.Add(output)
		O.active_organ_efficiency_mod[output] = organ_stats[1] * modifier
		O.specific_organ_size_mod = organ_stats[2] * modifier
		O.max_blood_storage_mod = organ_stats[3] * modifier
		O.active_blood_req_mod = organ_stats[4] * modifier
		O.active_nutriment_req_mod = organ_stats[5] * modifier
		O.active_oxygen_req_mod = organ_stats[6] * modifier
		O.active_owner_verb_adds = organ_stats[8]
		O.new_name = output
	..()
