/obj/item/modification/organ/internal/output
	name = "organoid (output)"
	icon_state = "output_organoid"
	bad_type = /obj/item/modification/organ/internal/output

/obj/item/modification/organ/internal/output/reagents_blood
	name = "hepatic organoid"
	desc = "Functional tissue of one or more organs in graftable form. Secretes reagents into the bloodstream."
	description_info = "Produces reagents in the bloodstream when triggered.\n\n\
						Use a laser cutting tool to change the metabolism target or reagent type.\n\
						Reagents can only be swapped for like reagents."

/obj/item/modification/organ/internal/output/reagents_blood/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/output_args)
	var/datum/component/modification/organ/output/reagents/O = AddComponent(/datum/component/modification/organ/output/reagents)

	var/list/outputs = output_args[1]
	var/list/output_selection = output_args[2]
	var/list/new_output_qualities = list()

	for(var/output in outputs)
		O.possible_outputs += output
		O.possible_outputs[output] = outputs[output]
		O.mode = CHEM_BLOOD

	for(var/quality in output_selection)
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

/obj/item/modification/organ/internal/output/reagents_ingest/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/output_args)
	var/datum/component/modification/organ/output/reagents/O = AddComponent(/datum/component/modification/organ/output/reagents)

	var/list/outputs = output_args[1]
	var/list/output_selection = output_args[2]
	var/list/new_output_qualities = list()

	for(var/output in outputs)
		O.possible_outputs += output
		O.possible_outputs[output] = outputs[output]
		O.mode = CHEM_INGEST

	for(var/quality in output_selection)
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

/obj/item/modification/organ/internal/output/chemical_effects/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/output_args)
	var/datum/component/modification/organ/output/chemical_effects/O = AddComponent(/datum/component/modification/organ/output/chemical_effects)

	var/list/outputs = output_args[1]
	var/list/output_selection = output_args[2]
	var/list/new_output_qualities = list()

	for(var/output in outputs)
		O.possible_outputs += output
		O.possible_outputs[output] = outputs[output]

	for(var/quality in output_selection)
		var/datum/reagent/hormone/H
		var/effect = initial(H.name)
		if(ispath(quality, /datum/reagent/hormone))
			H = quality

		new_output_qualities |= initial(H.name)
		new_output_qualities[effect] = quality

	O.output_qualities = new_output_qualities
	..()

/obj/item/modification/organ/internal/output/stat_boost
	name = "intracrinal organoid"
	desc = "Functional tissue of one or more organs in graftable form. Secretes stimulating hormones."
	description_info = "Slightly increases stats when triggered.\n\n\
						Use a laser cutting tool to change the target stat."

/obj/item/modification/organ/internal/output/stat_boost/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/output_args)
	var/datum/component/modification/organ/output/stat_boost/O = AddComponent(/datum/component/modification/organ/output/stat_boost)

	var/list/outputs = output_args[1]
	var/list/output_selection = output_args[2]

	for(var/output in outputs)
		O.possible_outputs += output
		O.possible_outputs[output] = outputs[output]

	O.output_qualities = output_selection.Copy()
	..()

/obj/item/modification/organ/internal/output/produce
	name = "ovarian organoid"
	desc = "Functional tissue of one or more organs in graftable form. The cradle of life."
	description_info = "Causes the user to vomit an object.\n\n\
						Use a laser cutting tool to change the target stat."

/obj/item/modification/organ/internal/output/produce/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/output_args)
	var/datum/component/modification/organ/output/produce/O = AddComponent(/datum/component/modification/organ/output/produce)

	var/list/outputs = output_args[1]
	var/list/output_selection = output_args[2]

	for(var/output in outputs)
		O.possible_outputs += output
		O.possible_outputs[output] = outputs[output]

	O.output_qualities = output_selection.Copy()
	O.modifications[ORGAN_ABERRANT_COOLDOWN] = 2 MINUTES	// Don't want these popping out too often
	..()

/obj/item/modification/organ/internal/output/chem_smoke
	name = "eructal organoid"
	desc = "Functional tissue of one or more organs in graftable form. Expels stored reagents as a gas cloud."
	description_info = "Causes the user to emit a gas cloud containing reagents in their blood, stomach, or an internal gas sac.\n\n\
						Use a laser cutting tool to change the target stat."
	var/list/modes = STANDARD_CHEM_SMOKE_MODES

/obj/item/modification/organ/internal/output/chem_smoke/Initialize(loc, generate_organ_stats = FALSE, predefined_modifier = null, num_eff = 0, list/output_args)
	var/datum/component/modification/organ/output/chem_smoke/O = AddComponent(/datum/component/modification/organ/output/chem_smoke)

	var/list/outputs = output_args[1]
	var/list/output_selection = output_args[2]

	for(var/output in outputs)
		O.possible_outputs += output
		O.possible_outputs[output] = outputs[output]

	O.modes = modes.Copy()
	O.output_qualities = output_selection.Copy()
	O.modifications[ORGAN_ABERRANT_COOLDOWN] = 2 MINUTES
	..()
