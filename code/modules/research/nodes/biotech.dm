/datum/technology/basic_biotech
	name = "Basic Biotech"
	desc = "Basic Biotech"
	tech_type = RESEARCH_BIOTECH

	x = 0.1
	y = 0.8
	icon = "healthanalyzer"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list(/datum/design/research/item/part/micro_mani, /datum/design/research/item/part/basic_sensor)

/datum/technology/basic_med_machines
	name = "Basic Medical Machines"
	desc = "Basic Medical Machines"
	tech_type = RESEARCH_BIOTECH

	x = 0.25
	y = 0.8
	icon = "operationcomputer"

	required_technologies = list(/datum/technology/basic_biotech)
	required_tech_levels = list()
	cost = 200

	unlocks_designs = list(/datum/design/research/circuit/med_data, /datum/design/research/circuit/operating)
/*
/datum/technology/virology
	name = "Virology"
	desc = "Virology"
	tech_type = RESEARCH_BIOTECH

	x = 0.4
	y = 0.8
	icon = "vialbox"

	required_technologies = list(/datum/technology/basic_med_machines)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()
*/
/datum/technology/adv_med_machines
	name = "Advanced Medical Machines"
	desc = "Advanced Medical Machines"
	tech_type = RESEARCH_BIOTECH

	x = 0.25
	y = 0.6
	icon = "sleeper"

	required_technologies = list(/datum/technology/basic_med_machines)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/hydroponics
	name = "Hydroponics"
	desc = "Hydroponics"
	tech_type = RESEARCH_BIOTECH

	x = 0.1
	y = 0.6
	icon = "hydroponics"

	required_technologies = list(/datum/technology/basic_biotech)
	required_tech_levels = list()
	cost = 400

	unlocks_designs = list(/datum/design/research/circuit/biogenerator)
/*
/datum/technology/basic_food_processing
	name = "Basic Food Processing"
	desc = "Basic Food Processing"
	tech_type = RESEARCH_BIOTECH

	x = 0.1
	y = 0.4
	icon = "microwave"

	required_technologies = list(/datum/technology/hydroponics)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list("deepfryer", "microwave", "oven", "grill")

/datum/technology/adv_food_processing
	name = "Advanced Food Processing"
	desc = "Advanced Food Processing"
	tech_type = RESEARCH_BIOTECH

	x = 0.1
	y = 0.2
	icon = "candymachine"

	required_technologies = list(/datum/technology/basic_food_processing)
	required_tech_levels = list()
	cost = 600

	unlocks_designs = list("gibber", "monkey_recycler", "processor", "candymaker")
*/
/datum/technology/basic_medical_tools
	name = "Basic Medical Tools"
	desc = "Basic Medical Tools"
	tech_type = RESEARCH_BIOTECH

	x = 0.4
	y = 0.6
	icon = "medhud"

	required_technologies = list(/datum/technology/adv_med_machines)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/item/medical/mass_spectrometer, /datum/design/research/item/medical/reagent_scanner,
					/datum/design/research/item/scalpel_laser, /datum/design/research/item/hud/health, /datum/design/research/item/hud/security)

/datum/technology/improved_biotech
	name = "Improved Biotech"
	desc = "Improved Biotech"
	tech_type = RESEARCH_BIOTECH

	x = 0.55
	y = 0.6
	icon = "handheldmonitor"

	required_technologies = list(/datum/technology/basic_medical_tools)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/item/implant/chemical, /datum/design/research/item/part/adv_sensor,
						/datum/design/research/item/part/nano_mani)
/*
/datum/technology/med_teleportation
	name = "Medical Teleportation"
	desc = "Medical Teleportation"
	tech_type = RESEARCH_BIOTECH

	x = 0.7
	y = 0.5
	icon = "medbeacon"

	required_technologies = list(/datum/technology/improved_biotech)
	required_tech_levels = list()
	cost = 1200

	unlocks_designs = list("beacon_warp", "body_warp")
*/
/datum/technology/advanced_biotech
	name = "Advanced Biotech"
	desc = "Advanced Biotech"
	tech_type = RESEARCH_BIOTECH

	x = 0.7
	y = 0.7
	icon = "rapidsyringegun"

	required_technologies = list(/datum/technology/improved_biotech)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/item/part/phasic_sensor, /datum/design/research/item/part/pico_mani,
						/datum/design/research/item/medical/adv_mass_spectrometer, /datum/design/research/item/medical/adv_reagent_scanner,
						/datum/design/research/item/weapon/chemsprayer, /datum/design/research/item/weapon/rapidsyringe)

/datum/technology/portable_chemistry
	name = "Portable Chemistry"
	desc = "Portable Chemistry"
	tech_type = RESEARCH_BIOTECH

	x = 0.7
	y = 0.9
	icon = "chemdisp"

	required_technologies = list(/datum/technology/advanced_biotech)
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/circuit/chemmaster,
						/datum/design/research/circuit/chem_heater)

/datum/technology/top_biotech
	name = "Top-tier Biotech"
	desc = "Top-tier Biotech"
	tech_type = RESEARCH_BIOTECH

	x = 0.85
	y = 0.7
	icon = "scalpelmanager"

	required_technologies = list(/datum/technology/advanced_biotech)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/weapon/flora_gun,
						/datum/design/research/item/mechfab/modules/armor, /datum/design/research/item/mechfab/modules/armblade,
						/datum/design/research/item/mechfab/modules/runner, /datum/design/research/item/mechfab/modules/multitool/surgical,
						/datum/design/research/item/mechfab/modules/multitool/engineer, /datum/design/research/item/mechfab/modules/multitool/miner)
