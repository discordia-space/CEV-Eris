// TO ADD: vendor design
/datum/technology/basic_engineering
	name = "Basic Engineering"
	desc = "Basic enginering designs and circuits."
	tech_type = RESEARCH_ENGINEERING

	x = 0.1
	y = 0.5
	icon = "wrench"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list(	/datum/design/research/item/science_tool,
							/datum/design/research/item/part/basic_micro_laser,
							/datum/design/research/item/part/basic_matter_bin,
							/datum/design/research/circuit/arcade_battle,
							/datum/design/research/circuit/arcade_orion_trail,
							/datum/design/research/circuit/autolathe,
							/datum/design/research/item/light_replacer,
							/datum/design/autolathe/tool/weldermask,
							/datum/design/research/item/mesons
						)

/datum/technology/monitoring
	name = "Monitoring"
	desc = "Connection to vesel atmos system."
	tech_type = RESEARCH_ENGINEERING

	x = 0.2
	y = 0.7
	icon = "monitoring"

	required_technologies = list(/datum/technology/basic_engineering)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/atmosalerts, /datum/design/research/circuit/air_management)

// TO ADD: space_heater
/datum/technology/ice_and_fire
	name = "Ice And Fire"
	desc = "Basic designs of gas heaters and coolers."
	tech_type = RESEARCH_ENGINEERING

	x = 0.2
	y = 0.8
	icon = "spaceheater"

	required_technologies = list(/datum/technology/monitoring)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/gas_heater, /datum/design/research/circuit/gas_cooler)

// TO ADD: idcardconsole
/datum/technology/adv_replication
	name = "Advanced Replication"
	desc = "RnD machines and consoles."
	tech_type = RESEARCH_ENGINEERING

	x = 0.3
	y = 0.7
	icon = "rd"

	required_technologies = list(/datum/technology/monitoring)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(	/datum/design/research/circuit/rdconsole,
							/datum/design/research/circuit/rdservercontrol,
							/datum/design/research/circuit/rdserver,
							/datum/design/research/circuit/destructive_analyzer,
							/datum/design/research/circuit/protolathe,
							/datum/design/research/circuit/circuit_imprinter
						)

// Make this its own tech tree?
/datum/technology/modular_components
	name = "Modular Components"
	desc = "Components for modular computers."
	tech_type = RESEARCH_ENGINEERING

	x = 0.3
	y = 0.8
	icon = "pda"

	required_technologies = list(/datum/technology/adv_replication)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(
							/datum/design/research/item/modularcomponent/portabledrive/basic,
							/datum/design/research/item/modularcomponent/portabledrive/normal,
							/datum/design/research/item/modularcomponent/portabledrive/advanced,
							/datum/design/research/item/modularcomponent/disk/normal,
							/datum/design/research/item/modularcomponent/disk/advanced,
							/datum/design/research/item/modularcomponent/disk/super,
							/datum/design/research/item/modularcomponent/disk/cluster,
							/datum/design/research/item/modularcomponent/disk/small,
							/datum/design/research/item/modularcomponent/disk/micro,
							/datum/design/research/item/modularcomponent/netcard/basic,
							/datum/design/research/item/modularcomponent/netcard/advanced,
							/datum/design/research/item/modularcomponent/netcard/wired,
							/datum/design/research/item/modularcomponent/cardslot,
							/datum/design/research/item/modularcomponent/nanoprinter,
							/datum/design/research/item/modularcomponent/teslalink,
							/datum/design/research/item/modularcomponent/cpu,
							/datum/design/research/item/modularcomponent/cpu/small,
							/datum/design/research/item/modularcomponent/cpu/photonic,
							/datum/design/research/item/modularcomponent/cpu/photonic/small
						)

// Make this its own tech tree?
/datum/technology/custom_circuits
	name = "Custom Circuits"
	desc = "Integral Ciruits"
	tech_type = RESEARCH_ENGINEERING

	x = 0.4
	y = 0.8
	icon = "tesla"

	required_technologies = list(/datum/technology/adv_replication)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(
							/datum/design/research/item/wirer,
							/datum/design/research/item/debugger,
							/datum/design/research/item/custom_circuit_assembly,
							/datum/design/research/item/custom_circuit_assembly/medium,
							/datum/design/research/item/custom_circuit_assembly/drone,
							/datum/design/research/item/custom_circuit_assembly/large,
							/datum/design/research/item/custom_circuit_assembly/implant
							)
/* No tesla engine?
/datum/technology/tesla
	name = "Tesla"
	desc = "Tesla"
	tech_type = RESEARCH_ENGINEERING

	x = 0.3
	y = 0.2
	icon = "tesla"

	required_technologies = list(/datum/technology/basic_engineering)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list("tesla_coil", "grounding_rod")
*/

// TO ADD: advmop?, holosign, spraycan, spacesuit & helmet?, glowsticks_adv, stimpack
/datum/technology/supplyanddemand
	name = "Supply And Demand"
	desc = "Supply And Demand"
	tech_type = RESEARCH_ENGINEERING

	x = 0.4
	y = 0.6
	icon = "advmop"

	required_technologies = list(/datum/technology/basic_engineering)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/ordercomp, /datum/design/research/circuit/supplycomp)

//TOOLS BRANCH
// TO ADD: ore_redemption, mining_equipment_vendor, mining_fabricator?
/datum/technology/basic_mining
	name = "Basic Mining"
	desc = "Mining handdrill technology."
	tech_type = RESEARCH_ENGINEERING

	x = 0.3
	y = 0.4
	icon = "drill"

	required_technologies = list(/datum/technology/basic_engineering)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/item/weapon/mining/drill)


/datum/technology/advanced_mining
	name = "Advanced Mining"
	desc = "Static drill, improved handrill."
	tech_type = RESEARCH_ENGINEERING

	x = 0.4
	y = 0.4
	icon = "jackhammer"

	required_technologies = list(/datum/technology/basic_mining)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(	/datum/design/research/circuit/miningdrill,
							/datum/design/research/circuit/miningdrillbrace,
							/datum/design/research/item/weapon/mining/drill_diamond,
							/datum/design/research/item/weapon/mining/jackhammer
							)

/datum/technology/adv_tools
	name = "Advanced Tools"
	desc = "Matter replication technology. Pneumatics integration in crowbar."
	tech_type = RESEARCH_ENGINEERING

	x = 0.6
	y = 0.4
	icon = "jawsoflife"

	required_technologies = list(	/datum/technology/super_adv_engineering,
									/datum/technology/advanced_mining
								)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(	/datum/design/autolathe/tool/pneumatic_crowbar,
							/datum/design/autolathe/tool/rcd,
							/datum/design/autolathe/tool/rcd_ammo
							)

/datum/technology/improved_tools
	name = "Improved-Advanced Tools"
	desc = "Fast matter deconstruction technology."
	tech_type = RESEARCH_ENGINEERING

	x = 0.7
	y = 0.5
	icon = "jawsoflife"

	required_technologies = list(/datum/technology/adv_tools)
	required_tech_levels = list()
	cost = 1200

	unlocks_designs = list(	/datum/design/research/item/weapon/hatton,
							/datum/design/research/item/ammo/hatton
							)

/*
/datum/technology/basic_handheld
	name = "Basic Handheld"
	desc = "Basic Handheld"
	tech_type = RESEARCH_ENGINEERING

	x = 0.3
	y = 0.6
	icon = "pda"

	required_technologies = list(/datum/technology/basic_engineering)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list("pda", "cart_basic", "cart_engineering", "cart_atmos", "cart_medical", "cart_chemistry", "cart_security", "cart_janitor", "cart_science", "cart_quartermaster")

/datum/technology/adv_handheld
	name = "Advanced Handheld"
	desc = "Advanced Handheld"
	tech_type = RESEARCH_ENGINEERING

	x = 0.6
	y = 0.6
	icon = "goldpda"

	required_technologies = list(/datum/technology/basic_handheld)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list("cart_hop", "cart_hos", "cart_ce", "cart_cmo", "cart_rd", "cart_captain")
*/
/datum/technology/adv_parts
	name = "Advanced Parts"
	desc = "Advanced Parts"
	tech_type = RESEARCH_ENGINEERING

	x = 0.2
	y = 0.2
	icon = "advmatterbin"

	required_technologies = list(/datum/technology/basic_engineering)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/item/part/high_micro_laser, /datum/design/research/item/part/adv_matter_bin)

/datum/technology/ultra_parts
	name = "Super Parts"
	desc = "Super Parts"
	tech_type = RESEARCH_ENGINEERING

	x = 0.4
	y = 0.2
	icon = "supermatterbin"

	required_technologies = list(/datum/technology/adv_parts)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/part/ultra_micro_laser, /datum/design/research/item/part/super_matter_bin, /datum/design/research/item/medical/nanopaste)

/datum/technology/super_adv_engineering
	name = "Progressive Engineering"
	desc = "Rapid Part Exchange technology and secure airlocks electronics."
	tech_type = RESEARCH_ENGINEERING

	x = 0.5
	y = 0.3
	icon = "rped"

	required_technologies = list(/datum/technology/ultra_parts)
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/item/part/RPED, /datum/design/research/circuit/secure_airlock)

/*
/datum/technology/bluespace_parts
	name = "Bluespace Parts"
	desc = "Bluespace Parts"
	tech_type = RESEARCH_ENGINEERING

	x = 0.9
	y = 0.5
	icon = "bluespacematterbin"

	required_technologies = list(/datum/technology/ultra_parts)
	required_tech_levels = list()
	cost = 2500

	unlocks_designs = list("quadultra_micro_laser", "bluespace_matter_bin")
*/


