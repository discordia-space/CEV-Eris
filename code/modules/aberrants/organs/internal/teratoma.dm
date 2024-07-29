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

	max_upgrades = 1
	use_generated_name = FALSE
	use_generated_color = FALSE
	req_num_inputs = null
	req_num_outputs = null

/obj/item/organ/internal/scaffold/aberrant/teratoma/ruin()
	..()
	use_generated_name = FALSE
	max_upgrades = 0
	price_tag = 25
	matter = list(MATERIAL_BIOMATTER = 5)
	STOP_PROCESSING(SSobj, src)

// Input
/obj/item/organ/internal/scaffold/aberrant/teratoma/input
	name = "teratoma (input)"
	req_num_inputs = 1
	input_mod_path = TRUE

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents
	name = "metabolic teratoma"
	description_info = "A teratoma that houses a metabolic organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Requires the specified reagent(s) to be present in one of the three metabolism holders: bloodstream, ingested, or touch. \
						When the correct reagent is in the correct holder, the reagent will be removed at a rate equal to its metabolism times \
						the length of the organ\'s cooldown in ticks. Then, the process will trigger."
	input_mod_path = /obj/item/modification/organ/internal/input/reagents
	input_mode = CHEM_BLOOD

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
	input_mode = CHEM_INGEST
	specific_input_type_pool = REAGENTS_EDIBLE

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/alcohol
	name = "metabolic teratoma (alcohol)"
	input_mode = CHEM_INGEST
	specific_input_type_pool = REAGENTS_ALCOHOL

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/drugs
	name = "metabolic teratoma (drugs)"
	specific_input_type_pool = REAGENTS_DRUGS

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/fungal
	name = "metabolic teratoma (fungal)"
	specific_input_type_pool = REAGENTS_FUNGAL

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/reagents/dispenser
	name = "metabolic teratoma (chemical)"
	specific_input_type_pool = REAGENTS_DISPENSER_BASE

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/consume
	name = "mandibular teratoma"
	description_info = "A teratoma that houses a mandibular organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						On use, consumes a held object and ingests any contained reagents."
	input_mod_path = /obj/item/modification/organ/internal/input/consume
	specific_input_type_pool = STANDARD_ORGANIC_CONSUMABLES

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/damage
	name = "nociceptive teratoma"
	description_info = "A teratoma that houses a nociceptive organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Requires the specified damage type(s) to be present. The process is triggered when at least one point of damage is taken \
						(can be inflicted before attaching the organ), but no damage is healed."
	input_mod_path = /obj/item/modification/organ/internal/input/damage

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/damage/basic
	name = "pygmy nociceptive teratoma"
	specific_input_type_pool = DAMAGE_TYPES_BASIC
	input_threshold = 15

/obj/item/organ/internal/scaffold/aberrant/teratoma/input/damage/all
	name = "nociceptive teratoma"
	specific_input_type_pool = ALL_DAMAGE_TYPES
	input_threshold = 15

// This should be for assisted organ scaffolds when that becomes a thing
/obj/item/organ/internal/scaffold/aberrant/teratoma/input/power_source
	name = "bioelectric teratoma"
	description_info = "A teratoma that houses a bioelectric organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Requries the specified power source to be held in the bare hand of the organ's owner. Any amount of charge in a cell or sheets \
						in a stack will trigger the process, but larger cells and rarer materials will provide a slight cognition and sanity boost."
	input_mod_path = /obj/item/modification/organ/internal/input/power_source
	specific_input_type_pool = ALL_USABLE_POWER_SOURCES
	input_threshold = 5000	// Joules

// process
/obj/item/organ/internal/scaffold/aberrant/teratoma/process
	name = "teratoma (processing)"
	should_process_have_organ_stats = TRUE

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/map
	name = "tubular teratoma"
	description_info = "A teratoma that houses a tubular organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Maps inputs to outputs."
	process_mod_path = /obj/item/modification/organ/internal/process/map

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/multiplier
	name = "enzymal teratoma (catalyst)"
	description_info = "A teratoma that houses an enzymal organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Maps inputs to outputs. Modifies output magnitude."
	process_mod_path = /obj/item/modification/organ/internal/process/multiplier
	process_info = list(0.50)

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/multiplier/negative_low
	name = "pygmy enzymal teratoma (inhibitor)"
	process_info = list(-0.25)

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/multiplier/negative
	name = "enzymal teratoma (inhibitor)"
	process_info = list(-0.50)

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/multiplier/low
	name = "pygmy enzymal teratoma (catalyst)"
	process_info = list(0.25)

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/multiplier/high
	name = "enlarged enzymal teratoma (catalyst)"
	process_info = list(1)

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/cooldown
	name = "circadian teratoma"
	description_info = "A teratoma that houses a circadian organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Maps inputs to outputs. Modifies organ process duration."
	process_mod_path = /obj/item/modification/organ/internal/process/cooldown
	process_info = list(STANDARD_ABERRANT_COOLDOWN / 2)

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/cooldown/long
	name = "enlarged circaidian teratoma"
	process_info = list(STANDARD_ABERRANT_COOLDOWN)

/obj/item/organ/internal/scaffold/aberrant/teratoma/process/cooldown/negative
	name = "pygmy circaidian teratoma"
	process_info = list(-STANDARD_ABERRANT_COOLDOWN / 2)

// output
/obj/item/organ/internal/scaffold/aberrant/teratoma/output
	name = "teratoma (output)"
	req_num_outputs = 1
	output_mod_path = TRUE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood
	name = "hepatic teratoma"
	description_info = "A teratoma that houses an hepatic organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Produces reagents in the bloodstream when triggered."
	output_mod_path = /obj/item/modification/organ/internal/output/reagents_blood
	output_info = list(LOW_OUTPUT)

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/roach
	name = "hepatic teratoma (roach)"
	output_pool = REAGENTS_ROACH

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/spider
	name = "hepatic teratoma (spider)"
	output_pool = REAGENTS_SPIDER

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/drugs
	name = "hepatic teratoma (drugs)"
	output_pool = REAGENTS_DRUGS

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/fungal
	name = "hepatic teratoma (fungal)"
	output_pool = REAGENTS_FUNGAL

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/industrial
	name = "hepatic teratoma (industrial)"
	output_pool = REAGENTS_INDUSTRIAL

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/dispenser_base
	name = "pygmy hepatic teratoma (chemical)"
	output_pool = REAGENTS_DISPENSER_BASE

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/dispenser_one
	name = "hepatic teratoma (chemical)"
	output_pool = REAGENTS_DISPENSER_1

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_blood/dispenser_two
	name = "enlarged hepatic teratoma (chemical)"
	output_pool = REAGENTS_DISPENSER_2

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/reagents_ingest
	name = "gastric teratoma"
	description_info = "A teratoma that houses a gastric organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Produces reagents in the stomach when triggered."
	output_mod_path = /obj/item/modification/organ/internal/output/reagents_ingest
	output_info = list(LOW_OUTPUT)

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
	output_mod_path = /obj/item/modification/organ/internal/output/chemical_effects
	output_info = list(NOT_USED)

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
	output_mod_path = /obj/item/modification/organ/internal/output/stat_boost
	output_pool = ALL_STATS
	output_info = list(HIGH_OUTPUT)

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/produce
	name = "ovarian teratoma"
	description_info = "A teratoma that houses an ovarian organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Causes the user to vomit an object."
	output_mod_path = /obj/item/modification/organ/internal/output/produce
	output_pool = STANDARD_ORGANIC_PRODUCEABLES
	output_info = list(1)

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/produce/light_antag
	output_mod_path = /obj/item/modification/organ/internal/output/produce
	output_pool = LIGHT_ANTAG_ORGANIC_PRODUCEABLES
	output_info = list(1)

/obj/item/organ/internal/scaffold/aberrant/teratoma/output/chem_smoke
	name = "eructal teratoma"
	description_info = "A teratoma that houses an eructal organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Organoid information:\n\
						Causes the user to emit a gas cloud containing reagents in their blood, stomach, or an internal gas sac."
	output_mod_path = /obj/item/modification/organ/internal/output/chem_smoke
	output_pool = REAGENTS_FUNGAL
	output_info = list(10)

// special
/obj/item/organ/internal/scaffold/aberrant/teratoma/special
	name = "teratoma (unknown)"
	special_mod_path = TRUE

/obj/item/organ/internal/scaffold/aberrant/teratoma/special/chemical_effect
	name = "pygmy endocrinal teratoma"
	description_info = "A teratoma that houses a pygmy endocrinal membrane. Use a laser cutting tool to remove the membrane. 35 BIO and 15 COG recommended.\n\n\
						Membrane information:\n\
						Produces a hormone when the primary function triggers."
	special_mod_path = /obj/item/modification/organ/internal/on_cooldown/chemical_effect
	special_info = TYPE_1_HORMONES

/obj/item/organ/internal/scaffold/aberrant/teratoma/special/stat_boost
	name = "pygmy intracrinal teratoma"
	description_info = "A teratoma that houses a pygmy intracrinal membrane. Use a laser cutting tool to remove the membrane. 35 BIO and 15 COG recommended.\n\n\
						Membrane information:\n\
						Slightly increases a stat when the primary function triggers."
	special_mod_path = /obj/item/modification/organ/internal/on_cooldown/stat_boost

/obj/item/organ/internal/scaffold/aberrant/teratoma/special/parasitic
	name = "parasitic teratoma"
	description_info = "A teratoma that houses a parasitic organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Membrane information:\n\
						Inhibits organ functions, but allows for aberrant organ insertion without surgery."
	special_mod_path = /obj/item/modification/organ/internal/symbiotic

/obj/item/organ/internal/scaffold/aberrant/teratoma/special/commensal
	name = "commensalistic teratoma"
	description_info = "A teratoma that houses a commensalistic organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Membrane information:\n\
						Allows for aberrant organ insertion without surgery."
	special_mod_path = /obj/item/modification/organ/internal/symbiotic/commensal

/obj/item/organ/internal/scaffold/aberrant/teratoma/special/mutual
	name = "mutualistic teratoma"
	description_info = "A teratoma that houses a mutualistic organoid. Use a laser cutting tool to remove the organoid. 35 BIO and 15 COG recommended.\n\n\
						Membrane information:\n\
						Allows for aberrant organ insertion without surgery."
	special_mod_path = /obj/item/modification/organ/internal/symbiotic/mutual
