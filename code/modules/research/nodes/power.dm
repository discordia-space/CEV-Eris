/datum/technology/basic_power
	name = "Basic Power"
	desc = "Basic Power"
	tech_type = RESEARCH_POWERSTORAGE

	x = 0.5
	y = 0.8
	icon = "cell"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list(/datum/design/research/circuit/powermonitor, /datum/design/research/circuit/pacman, /datum/design/research/item/part/basic_capacitor,
						/datum/design/research/item/powercell/large/basic, /datum/design/research/item/powercell/large/high,
						/datum/design/research/item/powercell/medium/basic, /datum/design/research/item/powercell/medium/high,
						/datum/design/research/item/powercell/small/basic, /datum/design/research/item/powercell/small/high,
						/datum/design/research/circuit/batteryrack)

/datum/technology/advanced_power
	name = "Advanced Power"
	desc = "Advanced Power"
	tech_type = RESEARCH_POWERSTORAGE

	x = 0.5
	y = 0.6
	icon = "supercell"

	required_technologies = list(/datum/technology/basic_power)
	required_tech_levels = list()
	cost = 200

	unlocks_designs = list(/datum/design/research/item/part/adv_capacitor, /datum/design/research/item/powercell/large/super,
						/datum/design/research/item/powercell/medium/super, /datum/design/research/item/powercell/small/super)

/datum/technology/improved_power_generation
	name = "Improved Power Generation"
	desc = "Improved Power Generation"
	tech_type = RESEARCH_POWERSTORAGE

	x = 0.3
	y = 0.6
	icon = "generator"

	required_technologies = list(/datum/technology/advanced_power)
	required_tech_levels = list()
	cost = 400

	unlocks_designs = list(/datum/design/research/circuit/superpacman)

/datum/technology/advanced_power_storage
	name = "Advanced Power Storage"
	desc = "Advanced Power Storage"
	tech_type = RESEARCH_POWERSTORAGE

	x = 0.1
	y = 0.6
	icon = "smes"

	required_technologies = list(/datum/technology/improved_power_generation)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/circuit/smes_cell, /datum/design/research/item/part/smes_coil/weak)

/datum/technology/solar_power
	name = "Solar Power"
	desc = "Solar Power"
	tech_type = RESEARCH_POWERSTORAGE

	x = 0.7
	y = 0.6
	icon = "solarcontrol"

	required_technologies = list(/datum/technology/advanced_power)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/solarcontrol)

/datum/technology/super_power
	name = "Super Power"
	desc = "Super Power"
	tech_type = RESEARCH_POWERSTORAGE

	x = 0.5
	y = 0.4
	icon = "hypercell"

	required_technologies = list(/datum/technology/advanced_power)
	required_tech_levels = list()
	cost = 1200

	unlocks_designs = list(/datum/design/research/item/part/super_capacitor, /datum/design/research/item/powercell/large/hyper,
						/datum/design/research/item/powercell/medium/hyper, /datum/design/research/item/powercell/small/hyper,
						/datum/design/research/item/part/smes_coil/super_io, /datum/design/research/item/part/smes_coil/super_capacity)

/datum/technology/advanced_power_generation
	name = "Advanced Power Generation"
	desc = "Advanced Power Generation"
	tech_type = RESEARCH_POWERSTORAGE

	x = 0.3
	y = 0.4
	icon = "supergenerator"

	required_technologies = list(/datum/technology/super_power, /datum/technology/improved_power_generation)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/circuit/mrspacman)
/*
/datum/technology/fusion_power_generation
	name = "R-UST Mk. 8 Tokamak Generator"
	desc = "R-UST Mk. 8 Tokamak Generator"
	tech_type = RESEARCH_POWERSTORAGE

	x = 0.1
	y = 0.4
	icon = "fusion"

	required_technologies = list(/datum/technology/advanced_power_generation)
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list("fusion_core_control", "fusion_fuel_compressor", "fusion_fuel_control", "gyrotron_control", "fusion_core", "fusion_injector", "gyrotron")
*/
/datum/technology/bluespace_power
	name = "Fusion Based Power"
	desc = "Fusion Based Power"
	tech_type = RESEARCH_POWERSTORAGE

	x = 0.5
	y = 0.2
	icon = "bluespacecell"

	required_technologies = list(/datum/technology/super_power)
	required_tech_levels = list()
	cost = 3000

	unlocks_designs = list(/datum/design/research/item/powercell/large/nuclear,
						/datum/design/research/item/powercell/medium/nuclear, /datum/design/research/item/powercell/small/nuclear)
