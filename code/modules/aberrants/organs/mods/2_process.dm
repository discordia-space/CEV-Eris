/obj/item/modification/organ/internal/process
	name = "organoid (processing)"
	icon_state = "process_organoid"

/obj/item/modification/organ/internal/process/boost
	name = "enzymal organoid"
	desc = "Functional tissue of one or more organs in graftable form. Accelerates biochemical processes, increasing output magnitude."
	description_info = "Maps inputs to outputs. Increases output magnitude."

/obj/item/modification/organ/internal/process/boost/New(loc, generate_organ_stats = TRUE, predefined_modifier = null, list/process_info)
	var/datum/component/modification/organ/process/boost/P = AddComponent(/datum/component/modification/organ/process/boost)

	P.multiplier = process_info.len ? process_info[1] : 0.20
	..()
	
/obj/item/modification/organ/internal/process/condense
	name = "sphincter organoid"
	desc = "Functional tissue of one or more organs in graftable form. Connects multiple inputs to a single output."
	description_info = "Maps inputs to a single output. If there are multiple outputs, it only uses the first."

/obj/item/modification/organ/internal/process/condense/New(loc, generate_organ_stats = TRUE, predefined_modifier = null)
	AddComponent(/datum/component/modification/organ/process/condense)
	..()

/obj/item/modification/organ/internal/process/map
	name = "tubular organoid"
	desc = "Functional tissue of one or more organs in graftable form. Connects inputs to outputs."
	description_info = "Maps inputs to outputs. Works for any number of inputs and outputs.\n\n\
						Use a laser cutting tool to change the mapping type."

/obj/item/modification/organ/internal/process/map/New(loc, generate_organ_stats = TRUE, predefined_modifier = null)
	AddComponent(/datum/component/modification/organ/process/map)
	..()
