/obj/item/organ/internal/scaffold/aberrant/scrub_toxin
	rarity_value = 40
	bad_type = /obj/item/organ/internal/scaffold/aberrant/scrub_toxin
	use_generated_name = FALSE
	input_mod_path = /obj/item/modification/organ/internal/input/reagents
	process_mod_path = /obj/item/modification/organ/internal/process/boost
	output_mod_path = /obj/item/modification/organ/internal/output/chemical_effects
	specific_input_type_pool = list(/datum/reagent/toxin)	// This should let it scrub ANY toxin
	output_pool = TYPE_2_HORMONES
	output_info = list(NOT_USED)

/obj/item/organ/internal/scaffold/aberrant/scrub_toxin/New()
	..()
	var/obj/item/modification/organ/internal/process/P
	for(var/obj/item/modification/organ/internal/mod in item_upgrades)
		if(istype(mod, /obj/item/modification/organ/internal/process))
			P = mod

	var/datum/component/modification/organ/process/PC = P.GetComponent(/datum/component/modification/organ/process)
	PC.organ_efficiency_mod = list()		// Clear organ efficiencies since this is mimicking an organ process. Also, organ will need its own name.
	organ_efficiency = list()
	refresh_upgrades()

/obj/item/organ/internal/scaffold/aberrant/scrub_toxin/blood
	name = "filtration node"
	desc = "A finely engineered organ. Scrubs toxins from the bloodstream."
	input_mode = CHEM_BLOOD

/obj/item/organ/internal/scaffold/aberrant/scrub_toxin/ingest
	name = "hepatic lobe"
	desc = "A finely engineered organ. Scrubs ingested toxins."
	input_mode = CHEM_INGEST

/obj/item/organ/internal/scaffold/aberrant/scrub_toxin/touch
	name = "exocrine gland"
	desc = "A finely engineered organ. Scrubs toxins absorbed through the skin."
	input_mode = CHEM_TOUCH

/obj/item/organ/internal/scaffold/aberrant/gastric
	name = "gastric sac"
	desc = "A finely engineered organ for your second breakfast. Turns a reagent into nutriment."
	//desc = "A finely engineered organ. Lets you finish a meal before you go out to eat."
	rarity_value = 40
	price_tag = 200
	use_generated_name = FALSE
	input_mod_path = /obj/item/modification/organ/internal/input/reagents
	process_mod_path = /obj/item/modification/organ/internal/process/boost
	output_mod_path = /obj/item/modification/organ/internal/output/reagents_ingest
	specific_input_type_pool = list(/datum/reagent/other/crayon_dust, /datum/reagent/other/paint, /datum/reagent/other/ultraglue, /datum/reagent/other/space_cleaner,
									/datum/reagent/toxin/amatoxin, /datum/reagent/toxin/carpotoxin, /datum/reagent/toxin/fertilizer, /datum/reagent/toxin/mold)
	input_mode = CHEM_INGEST
	output_pool = list(/datum/reagent/organic/nutriment)
	output_info = list(LOW_OUTPUT)

/obj/item/organ/internal/scaffold/aberrant/gastric/New()
	..()
	var/obj/item/modification/organ/internal/process/P
	for(var/obj/item/modification/organ/internal/mod in item_upgrades)
		if(istype(mod, /obj/item/modification/organ/internal/process))
			P = mod

	var/datum/component/modification/organ/process/PC = P.GetComponent(/datum/component/modification/organ/process)
	PC.organ_efficiency_mod = list()		// Clear organ efficiencies since this is mimicking an organ process. Also, organ will need its own name.
	organ_efficiency = list()
	refresh_upgrades()

/obj/item/organ/internal/scaffold/aberrant/damage_response
	name = "endocrine gland"
	desc = "A finely engineered organ. Secretes chemicals in response to pain or injury."
	rarity_value = 40
	price_tag = 200
	use_generated_name = FALSE
	input_mod_path = /obj/item/modification/organ/internal/input/damage
	process_mod_path = /obj/item/modification/organ/internal/process/boost
	output_mod_path = /obj/item/modification/organ/internal/output/reagents_blood
	specific_input_type_pool = DAMAGE_TYPES_BASIC
	input_mode = NOT_USED
	output_pool = list(/datum/reagent/medicine/tricordrazine, /datum/reagent/medicine/polystem, /datum/reagent/medicine/dylovene)
	output_info = list(LOW_OUTPUT)

/obj/item/organ/internal/scaffold/aberrant/damage_response/New()
	..()
	var/obj/item/modification/organ/internal/process/P
	for(var/obj/item/modification/organ/internal/mod in item_upgrades)
		if(istype(mod, /obj/item/modification/organ/internal/process))
			P = mod

	var/datum/component/modification/organ/process/PC = P.GetComponent(/datum/component/modification/organ/process)
	PC.organ_efficiency_mod = list()		// Clear organ efficiencies since this is mimicking an organ process. Also, organ will need its own name.
	organ_efficiency = list()
	refresh_upgrades()
