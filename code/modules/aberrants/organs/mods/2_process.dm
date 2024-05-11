/obj/item/modification/organ/internal/process
	name = "organoid (processing)"
	icon_state = "process_organoid"
	bad_type = /obj/item/modification/organ/internal/process

/obj/item/modification/organ/internal/process/map
	name = "tubular organoid"
	desc = "Functional tissue of one or more organs in graftable form. Connects inputs to outputs."
	description_info = "Maps inputs to outputs. Works for any number of inputs and outputs.\n\n\
						Use a laser cutting tool to modify the organ efficiency."

/obj/item/modification/organ/internal/process/map/Initialize(loc, generate_organ_stats = TRUE, predefined_modifier = 0.05, num_eff = 2)
	AddComponent(/datum/component/modification/organ/process/map)
	..(loc, TRUE, 0.05, 2)

/obj/item/modification/organ/internal/process/cooldown
	name = "circadian organoid"
	desc = "Functional tissue of one or more organs in graftable form. Connects inputs to outputs and alters organ processing duration."
	description_info = "Maps inputs to outputs. Works for any number of inputs and outputs.\n\n\
						Use a laser cutting tool to modify the organ efficiency."

/obj/item/modification/organ/internal/process/cooldown/Initialize(loc, generate_organ_stats = TRUE, predefined_modifier = 0.05, num_eff = 2, list/process_args)
	var/datum/component/modification/organ/process/map/P = AddComponent(/datum/component/modification/organ/process/map)
	P.modifications[ORGAN_ABERRANT_COOLDOWN] = LAZYLEN(process_args) ? process_args[1] : STANDARD_ABERRANT_COOLDOWN
	..(loc, TRUE, 0.05, 2)

/obj/item/modification/organ/internal/process/multiplier
	name = "enzymal organoid"
	desc = "Functional tissue of one or more organs in graftable form. Accelerates biochemical processes, increasing output magnitude."
	description_info = "Maps inputs to outputs. Increases output magnitude.\n\n\
						Use a laser cutting tool to modify the organ efficiency."

/obj/item/modification/organ/internal/process/multiplier/Initialize(loc, generate_organ_stats = TRUE, predefined_modifier = 0.05, num_eff = 2, list/process_args)
	var/datum/component/modification/organ/process/multiplier/P = AddComponent(/datum/component/modification/organ/process/multiplier)

	var/multiplier = LAZYLEN(process_args) ? process_args[1] : 0.20

	if(multiplier < 0)
		name = "enzymal organoid (inhibitor)"
		desc = "Functional tissue of one or more organs in graftable form. Decelerates biochemical processes, decreasing output magnitude."
		description_info = "Maps inputs to outputs. Decreases output magnitude.\n\n\
							Use a laser cutting tool to modify the organ efficiency."
	else
		name = "enzymal organoid (catalyst)"

	P.modifications[ORGAN_ABERRANT_PROCESS_MULT] = multiplier
	..(loc, TRUE, 0.05, 2)
