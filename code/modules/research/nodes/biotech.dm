/datum/technology/basic_biotech
	name = "Basic Biotech"
	desc = "Basic biotech micro manipulations and scanning method."
	tech_type = RESEARCH_BIOTECH

	x = 0.1
	y = 0.8
	icon = "healthanalyzer"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list(	/datum/design/research/item/part/micro_mani,
							/datum/design/research/item/part/basic_sensor
						)

/datum/technology/basic_med_machines
	name = "Basic Medical Machines"
	desc = "Basic medical databases and surgical monitoring."
	tech_type = RESEARCH_BIOTECH

	x = 0.25
	y = 0.8
	icon = "operationcomputer"

	required_technologies = list(/datum/technology/basic_biotech)
	required_tech_levels = list()
	cost = 200

	unlocks_designs = list(	/datum/design/research/circuit/med_data,
							/datum/design/research/circuit/operating
						)
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
	desc = "Advanced Medical manipulations and fast scan and injection system."
	tech_type = RESEARCH_BIOTECH

	x = 0.3 //0.25
	y = 0.65 //0.6
	icon = "sleeper"

	required_technologies = list(/datum/technology/basic_med_machines)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/sleeper)

/datum/technology/hydroponics
	name = "Hydroponics"
	desc = "The method of reassembling biomaterials. The flora genetic modifying method."
	tech_type = RESEARCH_BIOTECH

	x = 0.2
	y = 0.9
	icon = "hydroponics"

	required_technologies = list(/datum/technology/basic_biotech)
	required_tech_levels = list()
	cost = 400

	unlocks_designs = list(	/datum/design/research/circuit/biogenerator,
							/datum/design/research/item/weapon/flora_gun)

/datum/technology/portable_chemistry
	name = "Portable Chemistry"
	desc = "Portable bottle generating and reagent separation. Portable heating system, space for system required: 30 cubic millimeters."
	tech_type = RESEARCH_BIOTECH

	x = 0.4
	y = 0.8
	icon = "chemdisp"

	required_technologies = list(	/datum/technology/basic_biotech,
									/datum/technology/hydroponics
								)
	required_tech_levels = list()
	cost = 700

	unlocks_designs = list(	/datum/design/research/circuit/chemmaster,
							/datum/design/research/circuit/chem_heater,
							/datum/design/research/item/makeshift_centrifuge,
							/datum/design/research/structure/bidon
							)
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
	desc = "Mass Spectrometry method. Experimental surgical, laser tools. Medical sensors intergrated hud in hud-glass."
	tech_type = RESEARCH_BIOTECH

	x = 0.4
	y = 0.6
	icon = "medhud"

	required_technologies = list(/datum/technology/adv_med_machines)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(	/datum/design/research/item/medical/mass_spectrometer,
							/datum/design/research/item/medical/reagent_scanner,
							/datum/design/research/item/scalpel_laser,
							/datum/design/research/item/hud/health,
							)

/datum/technology/improved_biotech
	name = "Improved Biotech"
	desc = "Improved micro manipulations, advaced scanning method. Chemical implant, be careful."
	tech_type = RESEARCH_BIOTECH

	x = 0.55
	y = 0.6
	icon = "handheldmonitor"

	required_technologies = list(/datum/technology/basic_medical_tools)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(	/datum/design/research/item/implant/chemical,
							/datum/design/research/item/part/adv_sensor,
							/datum/design/research/item/part/nano_mani
							)

/datum/technology/portable_biotech
	name = "Portable Biotech"
	desc = "Portable injection and scan method, capitalists' and not capitalists portable sleeper. Integrated medical sensors hud with hardsuits' systems."
	tech_type = RESEARCH_BIOTECH

	x = 0.65
	y = 0.8
	icon = "rignuclearreactor"

	required_technologies = list(/datum/technology/improved_biotech,
								/datum/technology/portable_chemistry
								)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(	/datum/design/research/item/autodoc,
							/datum/design/research/item/autodoc_comercial,
							/datum/design/research/item/chem_dispenser,
							/datum/design/research/item/medhud,
							/datum/design/research/structure/bidonadv
							)

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
	desc = "Top-tier micro manipulations systems. Top-tier scan method. Upgraded mass spectrometry. Advaced sprayer. Machinegunlike syringe-gun."
	tech_type = RESEARCH_BIOTECH

	x = 0.7
	y = 0.7
	icon = "rapidsyringegun"

	required_technologies = list(/datum/technology/improved_biotech)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(	/datum/design/research/item/part/phasic_sensor,
							/datum/design/research/item/part/pico_mani,
							/datum/design/research/item/medical/adv_mass_spectrometer,
							/datum/design/research/item/medical/adv_reagent_scanner,
							/datum/design/research/item/weapon/chemsprayer,
							/datum/design/research/item/weapon/rapidsyringe
							)

/datum/technology/top_biotech
	name = "Augmentations' Biotech"
	desc = "Augmentations for body, this tech using almost all previous technologies."
	tech_type = RESEARCH_BIOTECH

	x = 0.85
	y = 0.7
	icon = "scalpelmanager"

	required_technologies = list(	/datum/technology/advanced_biotech,
									/datum/technology/portable_biotech
								)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(	/datum/design/research/item/mechfab/modules/armor,
							/datum/design/research/item/mechfab/modules/armblade,
							/datum/design/research/item/mechfab/modules/runner,
							/datum/design/research/item/mechfab/modules/multitool/surgical,
							/datum/design/research/item/mechfab/modules/multitool/engineer,
							/datum/design/research/item/mechfab/modules/multitool/miner
							)
