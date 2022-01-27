/datum/technology/basic_biotech
	name = "Basic Biotech"
	desc = "Basic biotech69icro69anipulations and scanning69ethod."
	tech_type = RESEARCH_BIOTECH

	x = 0.1
	y = 0.8
	icon = "healthanalyzer"

	re69uired_technologies = list()
	re69uired_tech_levels = list()
	cost = 0

	unlocks_designs = list(	/datum/design/research/item/part/micro_mani,
							/datum/design/research/item/part/basic_sensor
						)

/datum/technology/basic_med_machines
	name = "Basic69edical69achines"
	desc = "Basic69edical databases and surgical69onitoring."
	tech_type = RESEARCH_BIOTECH

	x = 0.25
	y = 0.8
	icon = "operationcomputer"

	re69uired_technologies = list(/datum/technology/basic_biotech)
	re69uired_tech_levels = list()
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

	re69uired_technologies = list(/datum/technology/basic_med_machines)
	re69uired_tech_levels = list()
	cost = 500

	unlocks_designs = list()
*/
/datum/technology/adv_med_machines
	name = "Advanced69edical69achines"
	desc = "Advanced69edical69anipulations and fast scan and injection system."
	tech_type = RESEARCH_BIOTECH

	x = 0.3 //0.25
	y = 0.65 //0.6
	icon = "sleeper"

	re69uired_technologies = list(/datum/technology/basic_med_machines)
	re69uired_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/sleeper)

/datum/technology/hydroponics
	name = "Hydroponics"
	desc = "The69ethod of reassembling biomaterials. The flora genetic69odifying69ethod."
	tech_type = RESEARCH_BIOTECH

	x = 0.2
	y = 0.9
	icon = "hydroponics"

	re69uired_technologies = list(/datum/technology/basic_biotech)
	re69uired_tech_levels = list()
	cost = 400

	unlocks_designs = list(	/datum/design/research/circuit/biogenerator,
							/datum/design/research/item/weapon/flora_gun)

/datum/technology/portable_chemistry
	name = "Portable Chemistry"
	desc = "Portable bottle generating and reagent separation. Portable heating system, space for system re69uired: 30 cubic69illimeters."
	tech_type = RESEARCH_BIOTECH

	x = 0.4
	y = 0.8
	icon = "chemdisp"

	re69uired_technologies = list(	/datum/technology/basic_biotech,
									/datum/technology/hydroponics
								)
	re69uired_tech_levels = list()
	cost = 700

	unlocks_designs = list(	/datum/design/research/circuit/chemmaster,
							/datum/design/research/circuit/chemical_dispenser,
							/datum/design/research/circuit/chemical_dispenser_beer,
							/datum/design/research/circuit/chemical_dispenser_soda,
							/datum/design/research/circuit/chem_heater,
							/datum/design/research/item/makeshift_centrifuge,
							/datum/design/research/structure/bidon,
							/datum/design/research/structure/bidonadv
							)
/*
/datum/technology/basic_food_processing
	name = "Basic Food Processing"
	desc = "Basic Food Processing"
	tech_type = RESEARCH_BIOTECH

	x = 0.1
	y = 0.4
	icon = "microwave"

	re69uired_technologies = list(/datum/technology/hydroponics)
	re69uired_tech_levels = list()
	cost = 500

	unlocks_designs = list("deepfryer", "microwave", "oven", "grill")

/datum/technology/adv_food_processing
	name = "Advanced Food Processing"
	desc = "Advanced Food Processing"
	tech_type = RESEARCH_BIOTECH

	x = 0.1
	y = 0.2
	icon = "candymachine"

	re69uired_technologies = list(/datum/technology/basic_food_processing)
	re69uired_tech_levels = list()
	cost = 600

	unlocks_designs = list("gibber", "monkey_recycler", "processor", "candymaker")
*/
/datum/technology/basic_medical_tools
	name = "Basic69edical Tools"
	desc = "Mass Spectrometry69ethod. Experimental surgical, laser tools.69edical sensors intergrated hud in hud-glass."
	tech_type = RESEARCH_BIOTECH

	x = 0.4
	y = 0.6
	icon = "medhud"

	re69uired_technologies = list(/datum/technology/adv_med_machines)
	re69uired_tech_levels = list()
	cost = 500

	unlocks_designs = list(	/datum/design/research/item/medical/mass_spectrometer,
							/datum/design/research/item/medical/reagent_scanner,
							/datum/design/research/item/scalpel_laser,
							/datum/design/research/item/hud/health,
							)

/datum/technology/improved_biotech
	name = "Improved Biotech"
	desc = "Improved69icro69anipulations, advaced scanning69ethod. Chemical implant, be careful."
	tech_type = RESEARCH_BIOTECH

	x = 0.5
	y = 0.6
	icon = "handheldmonitor"

	re69uired_technologies = list(/datum/technology/basic_medical_tools)
	re69uired_tech_levels = list()
	cost = 1000

	unlocks_designs = list(	/datum/design/research/item/implant/chemical,
							/datum/design/research/item/part/adv_sensor,
							/datum/design/research/item/part/nano_mani
							)

/datum/technology/portable_biotech
	name = "Portable Biotech"
	desc = "Portable injection and scan69ethod, capitalists' and69ot capitalists portable sleeper. Integrated69edical sensors hud with hardsuits' systems."
	tech_type = RESEARCH_BIOTECH

	x = 0.55
	y = 0.8
	icon = "rignuclearreactor"

	re69uired_technologies = list(/datum/technology/improved_biotech,
								/datum/technology/portable_chemistry
								)
	re69uired_tech_levels = list()
	cost = 1000

	unlocks_designs = list(	/datum/design/research/item/autodoc,
							/datum/design/research/item/autodoc_commercial,
							/datum/design/research/item/chem_dispenser,
							/datum/design/research/item/medhud,
							/datum/design/research/structure/bidonadv
							)

/datum/technology/tracker_tablet
	name = "Tracker tablet"
	desc = "Modified tablet frame with extra screens for use with sensor69onitoring software."
	tech_type = RESEARCH_BIOTECH

	x = 0.55
	y = 0.9
	icon = "moetablet"

	re69uired_technologies = list(/datum/technology/portable_biotech)
	re69uired_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/item/tracker_tablet)

/*
/datum/technology/med_teleportation
	name = "Medical Teleportation"
	desc = "Medical Teleportation"
	tech_type = RESEARCH_BIOTECH

	x = 0.7
	y = 0.5
	icon = "medbeacon"

	re69uired_technologies = list(/datum/technology/improved_biotech)
	re69uired_tech_levels = list()
	cost = 1200

	unlocks_designs = list("beacon_warp", "body_warp")
*/
/datum/technology/advanced_biotech
	name = "Advanced Biotech"
	desc = "Top-tier69icro69anipulations systems. Top-tier scan69ethod. Upgraded69ass spectrometry. Advaced sprayer.69achinegunlike syringe-gun."
	tech_type = RESEARCH_BIOTECH

	x = 0.6
	y = 0.7
	icon = "rapidsyringegun"

	re69uired_technologies = list(/datum/technology/improved_biotech)
	re69uired_tech_levels = list()
	cost = 1000

	unlocks_designs = list(	/datum/design/research/item/part/phasic_sensor,
							/datum/design/research/item/part/pico_mani,
							/datum/design/research/item/medical/adv_mass_spectrometer,
							/datum/design/research/item/medical/adv_reagent_scanner,
							/datum/design/research/item/weapon/chemsprayer,
							/datum/design/research/item/weapon/rapidsyringe,
							/datum/design/research/circuit/chemical_dispenser_industrial
							)

/datum/technology/top_biotech
	name = "Augmentations' Biotech"
	desc = "Augmentations for body, this tech using almost all previous technologies."
	tech_type = RESEARCH_BIOTECH

	x = 0.7
	y = 0.7
	icon = "scalpelmanager"

	re69uired_technologies = list(	/datum/technology/advanced_biotech,
									/datum/technology/portable_biotech
								)
	re69uired_tech_levels = list()
	cost = 2000

	unlocks_designs = list(	/datum/design/research/item/mechfab/modules/armor,
							/datum/design/research/item/mechfab/modules/armblade,
							/datum/design/research/item/mechfab/modules/runner,
							/datum/design/research/item/mechfab/modules/multitool/surgical,
							/datum/design/research/item/mechfab/modules/multitool/engineer,
							/datum/design/research/item/mechfab/modules/multitool/miner,
							/datum/design/research/item/mechfab/prosthesis_moebius/r_arm,
							/datum/design/research/item/mechfab/prosthesis_moebius/l_arm,
							/datum/design/research/item/mechfab/prosthesis_moebius/r_leg,
							/datum/design/research/item/mechfab/prosthesis_moebius/l_leg,
							/datum/design/research/item/mechfab/prosthesis_moebius/groin
							)

/datum/technology/mind_biotech
	name = "Mind Biotech"
	desc = "Experimental biotechnology that explores the inner workings of sentient69inds"
	tech_type = RESEARCH_BIOTECH

	x = 0.7
	y = 0.6
	icon = "mindswapper"

	re69uired_technologies = list(	/datum/technology/top_biotech)

	re69uired_tech_levels = list()
	cost = 3000

	unlocks_designs = list(	/datum/design/research/circuit/mindswapper)
