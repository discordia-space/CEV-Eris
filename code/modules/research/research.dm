/*
General Explanation:
The research datum is the "folder" where all the research information is stored in a R&D console. It's also a holder for all the
various procs used to manipulate it.

Variables:
- known_designs: A list of instantiated design datums known by this research datum.
- design_categories_protolathe: Same as above, but filtered by build_type.
- design_categories_imprinter: Ditto.
- researched_tech: An associative list of instantiated tech trees (/datum/tech), with a value of a list containing known instantiated technology nodes (/datum/technology)
- researched_nodes: All the known researched technology nodes.
- experiments: experiments datum.
- research_points: a number value representing points. Only meaningful for the rd console currently.

Procs:
- IsResearched(datum/technology/T): Is T in researched_nodes?
- CanResearch(datum/technology/T): Can T be researched (checks T cost, if T's associated tree is shown and if we have the required tech levels/nodes).
- UnlockTechology(datum/technology/T, force = FALSE): Unlocks a technology node T for src. Safe (uses the procs above). Adds T to the needed lists, and adds its designs too.
														Setting force to true ignores T's cost. 
- download_from(datum/research/O): Downloads data from O. The result is the union of src and O. 
- forget_techology(datum/technology/T): Removes T from src. 
- forget_all(tech_type): Forget all the technology nodes associated to a tree with type tech_type. 
- AddDesign2Known(datum/design/D): Add design to known_designs. 
- check_item_for_tech(obj/item/I): Unlocks a hidden tech tree if the item has the tree's item_tech_req in its origin_tech.

*/
/***************************************************************
**						Master Types						  **
**	Includes all the helper procs and basic tech processing.  **
***************************************************************/

/datum/research								//Holder for all the existing, archived, and known tech. Individual to console.
	var/list/known_designs = list()			//List of available designs (at base reliability).
	var/list/design_categories_protolathe = list()
	var/list/design_categories_imprinter = list()

	var/list/researched_tech = list() // Tree = list(of_researched_tech)
	var/list/researched_nodes = list() // All research nodes

	var/datum/experiment_data/experiments

	var/research_points = 0

/datum/research/New()
	..()
	SSresearch.initialize_research_datum(src)
	experiments = new /datum/experiment_data()

/datum/research/proc/IsResearched(datum/technology/T)
	return (T in researched_nodes)

/datum/research/proc/CanResearch(datum/technology/T)
	if(T.cost > research_points)
		return FALSE
	var/datum/tech/mytree = locate(T.tech_type) in researched_tech
	if(!mytree || !mytree.shown) // invalid tech_type or hidden tree, no bypassing safeties!
		return

	for(var/tree in T.required_tech_levels)
		var/datum/tech/tech_tree = locate(tree) in researched_tech
		var/level = T.required_tech_levels[tree]

		if(tech_tree.level < level)
			return FALSE

	for(var/tech in T.required_technologies)
		var/datum/technology/tech_node = locate(tech) in SSresearch.all_tech_nodes
		if(!IsResearched(tech_node))
			return FALSE

	return TRUE

/datum/research/proc/UnlockTechology(datum/technology/T, force = FALSE)
	if(IsResearched(T))
		return FALSE
	if(!CanResearch(T) && !force)
		return FALSE
	researched_nodes += T
	var/datum/tech/tree = locate(T.tech_type) in researched_tech
	researched_tech[tree] += T
	if(!force)
		research_points -= T.cost
	tree.level += 1

	for(var/D in T.unlocks_designs)
		var/datum/design/design = locate(D) in SSresearch.all_designs
		if(design)
			AddDesign2Known(design)
	return TRUE

/datum/research/proc/download_from(datum/research/O)
	for(var/t in O.researched_tech)
		var/datum/tech/tree = t
		var/datum/tech/our_tree = locate(tree.type) in researched_tech

		if(tree.shown && !our_tree.shown)
			our_tree.shown = tree.shown
			. = TRUE // we actually updated something

		for(var/tech in O.researched_tech[t])
			var/datum/technology/T = tech
			if(UnlockTechology(T, force = TRUE))
				. = TRUE // we actually updated something
	experiments.merge_with(O.experiments)

/datum/research/proc/forget_techology(datum/technology/T)
	if(!IsResearched(T))
		return
	var/datum/tech/tree = locate(T.tech_type) in researched_tech
	if(!tree)
		return
	tree.level -= 1
	researched_tech[tree] -= T
	researched_nodes -= T

	for(var/D in T.unlocks_designs)
		known_designs -= D

/datum/research/proc/forget_random_technology()
	if(researched_nodes.len > 0)
		var/datum/technology/T = pick(researched_nodes)
		forget_techology(T)

/datum/research/proc/forget_all(tech_type)
	var/datum/tech/tree = locate(tech_type) in researched_tech
	if(!tree)
		return
	tree.level = 1
	researched_nodes -= researched_tech[tree] // Remove all the nodes of the tree from the general researched nodes list
	for(var/tech in researched_tech[tree])
		var/datum/technology/T = tech
		for(var/D in T.unlocks_designs)
			known_designs -= D

/datum/research/proc/AddDesign2Known(datum/design/D)
	if(D in known_designs)
		return

	known_designs += D
	var/cat = D.category ? D.category : "Unspecified"
	if(D.build_type & PROTOLATHE)
		design_categories_protolathe |= cat
	else if(D.build_type & IMPRINTER)
		design_categories_imprinter |= cat


// Unlocks hidden tech trees
/datum/research/proc/check_item_for_tech(obj/item/I)
	var/list/temp_tech = I.origin_tech
	if(!temp_tech.len)
		return

	for(var/tree in researched_tech)
		var/datum/tech/T = tree
		if(T.shown || !T.item_tech_req)
			continue

		for(var/item_tech in temp_tech)
			if(item_tech == T.item_tech_req)
				T.shown = TRUE
				return

/***************************************************************
**						Technology Trees					  **
***************************************************************/

/datum/tech	//Datum of individual technologies.
	var/name = "name"          //Name of the technology.
	var/shortname = "name"
	var/desc = "description"   //General description of what it does and what it makes.
	var/level = 0              //A simple number scale of the research level.
	var/rare = 1               //How much CentCom wants to get that tech. Used in supply shuttle tech cost calculation.
	var/max_level              //Calculated based on the ammount of technologies
	var/shown = TRUE           //Used to hide tech that is not supposed to be shown from the start
	var/item_tech_req          //Deconstructing items with this tech will unlock this tech tree

//Trunk Technologies (don't require any other techs and you start knowning them).

/datum/tech/engineering
	name = "Engineering Research"
	shortname = "Engineering"
	desc = "Development of new and improved engineering parts."

/datum/tech/biotech
	name = "Biological Technology"
	shortname = "Biological"
	desc = "Research into the deeper mysteries of life and organic substances."

/datum/tech/combat
	name = "Combat Systems Research"
	shortname = "Combat Systems"
	desc = "The development of offensive and defensive systems."

/datum/tech/powerstorage
	name = "Power Manipulation Technology"
	shortname = "Power Manipulation"
	desc = "The various technologies behind the storage and generation of electicity."

/datum/tech/bluespace
	name = "'Blue-space' Research"
	shortname = "Blue-space"
	desc = "Research into the sub-reality known as 'blue-space'."
	rare = 2

/datum/tech/robotics
	name = "Robotics Research"
	shortname = "Robotics"
	desc = "Research into the exosuits"

/datum/tech/illegal
	name = "Illegal Technologies Research"
	shortname = "Illegal Tech"
	desc = "The study of technologies that violate standard Nanotrasen regulations."
	rare = 3
	shown = FALSE
	item_tech_req = TECH_ILLEGAL // research any traitor item and this tech will show up

/datum/technology
	var/name = "name"
	var/desc = "description"                // Not used because lazy
	var/tech_type                           // Which tech tree does this techology belongs to (path/define)

	var/x = 0.5                             // Position on the tech tree map, 0 - left, 1 - right
	var/y = 0.5                             // 0 - down, 1 - top
	var/icon = "gun"                        // css class of techology icon, defined in shared.css

	var/list/required_technologies = list() // Paths of techologies that are required to be unlocked before this one. Should have same tech_type
	var/list/required_tech_levels = list()  // list(/datum/tech/biotech = 5, ...) Paths and required levels of tech
	var/cost = 100                          // How much research points required to unlock this techology

	var/list/unlocks_designs = list()       // Paths of designs that this technology unlocks

/datum/technology/proc/getCost()
	// Calculates tech disk's supply points sell cost
	var/datum/tech/tree = locate(tech_type) in SSresearch.all_tech_trees
	if(tree)
		return (cost/100)*initial(tree.rare)
	else
		return cost/100

// Engineering

// TO ADD: vendor design
/datum/technology/basic_engineering
	name = "Basic Engineering"
	desc = "Basic"
	tech_type = RESEARCH_ENGINEERING

	x = 0.1
	y = 0.4
	icon = "wrench"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list(/datum/design/research/item/science_tool, /datum/design/research/item/part/basic_micro_laser,
						 /datum/design/research/item/part/basic_matter_bin, /datum/design/research/circuit/arcade_battle,
						 /datum/design/research/circuit/arcade_orion_trail, /datum/design/research/circuit/autolathe,
						 /datum/design/research/item/light_replacer, /datum/design/autolathe/tool/weldermask, /datum/design/research/item/mesons)

/datum/technology/monitoring
	name = "Monitoring"
	desc = "Monitoring"
	tech_type = RESEARCH_ENGINEERING

	x = 0.2
	y = 0.4
	icon = "monitoring"

	required_technologies = list(/datum/technology/basic_engineering)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/atmosalerts, /datum/design/research/circuit/air_management)

// TO ADD: space_heater
/datum/technology/ice_and_fire
	name = "Ice And Fire"
	desc = "Ice And Fire"
	tech_type = RESEARCH_ENGINEERING

	x = 0.2
	y = 0.6
	icon = "spaceheater"

	required_technologies = list(/datum/technology/monitoring)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/gas_heater, /datum/design/research/circuit/gas_cooler)

// TO ADD: idcardconsole
/datum/technology/adv_engineering
	name = "Advanced Engineering"
	desc = "Advanced Engineering"
	tech_type = RESEARCH_ENGINEERING

	x = 0.3
	y = 0.4
	icon = "rd"

	required_technologies = list(/datum/technology/monitoring)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/circuit/rdconsole, /datum/design/research/circuit/rdservercontrol, /datum/design/research/circuit/rdserver,
					 /datum/design/research/circuit/destructive_analyzer, /datum/design/research/circuit/protolathe, /datum/design/research/circuit/circuit_imprinter)

// Make this its own tech tree?
/datum/technology/modular_components
	name = "Modular Components"
	desc = "Modular Components"
	tech_type = RESEARCH_ENGINEERING

	x = 0.3
	y = 0.2
	icon = "pda"

	required_technologies = list(/datum/technology/adv_engineering)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/item/modularcomponent/portabledrive/basic, /datum/design/research/item/modularcomponent/portabledrive/normal,
						/datum/design/research/item/modularcomponent/portabledrive/advanced, /datum/design/research/item/modularcomponent/disk/normal,
						/datum/design/research/item/modularcomponent/disk/advanced, /datum/design/research/item/modularcomponent/disk/super,
						/datum/design/research/item/modularcomponent/disk/cluster, /datum/design/research/item/modularcomponent/disk/small,
						/datum/design/research/item/modularcomponent/disk/micro, /datum/design/research/item/modularcomponent/netcard/basic,
						/datum/design/research/item/modularcomponent/netcard/advanced, /datum/design/research/item/modularcomponent/netcard/wired,
						/datum/design/research/item/modularcomponent/cardslot, /datum/design/research/item/modularcomponent/nanoprinter,
						/datum/design/research/item/modularcomponent/teslalink, /datum/design/research/item/modularcomponent/cpu,
						/datum/design/research/item/modularcomponent/cpu/small, /datum/design/research/item/modularcomponent/cpu/photonic,
						/datum/design/research/item/modularcomponent/cpu/photonic/small
	)

// Make this its own tech tree?
/datum/technology/custom_circuits
	name = "Custom Circuits"
	desc = "Custom Circuits"
	tech_type = RESEARCH_ENGINEERING

	x = 0.3
	y = 0.6
	icon = "tesla" // TODO: Get a better icon

	required_technologies = list(/datum/technology/adv_engineering)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/item/wirer, /datum/design/research/item/debugger,
						/datum/design/research/item/custom_circuit_assembly, /datum/design/research/item/custom_circuit_assembly/medium,
						/datum/design/research/item/custom_circuit_assembly/drone, /datum/design/research/item/custom_circuit_assembly/large,
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

	required_technologies = list(/datum/technology/adv_engineering)
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
	y = 0.4
	icon = "advmop"

	required_technologies = list(/datum/technology/adv_engineering)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/ordercomp, /datum/design/research/circuit/supplycomp)

// TO ADD: ore_redemption, mining_equipment_vendor, mining_fabricator?
/datum/technology/basic_mining
	name = "Basic Mining"
	desc = "Basic Mining"
	tech_type = RESEARCH_ENGINEERING

	x = 0.5
	y = 0.4
	icon = "drill"

	required_technologies = list(/datum/technology/supplyanddemand)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/item/weapon/mining/drill)

/datum/technology/advanced_mining
	name = "Advanced Mining"
	desc = "Advanced Mining"
	tech_type = RESEARCH_ENGINEERING

	x = 0.6
	y = 0.4
	icon = "jackhammer"

	required_technologies = list(/datum/technology/basic_mining)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/circuit/miningdrill, /datum/design/research/circuit/miningdrillbrace,
						/datum/design/research/item/weapon/mining/drill_diamond, /datum/design/research/item/weapon/mining/jackhammer)
/*
/datum/technology/basic_handheld
	name = "Basic Handheld"
	desc = "Basic Handheld"
	tech_type = RESEARCH_ENGINEERING

	x = 0.3
	y = 0.6
	icon = "pda"

	required_technologies = list(/datum/technology/adv_engineering)
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

	x = 0.7
	y = 0.5
	icon = "advmatterbin"

	required_technologies = list(/datum/technology/advanced_mining)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/item/part/high_micro_laser, /datum/design/research/item/part/adv_matter_bin)

/datum/technology/ultra_parts
	name = "Ultra Parts"
	desc = "Ultra Parts"
	tech_type = RESEARCH_ENGINEERING

	x = 0.8
	y = 0.5
	icon = "supermatterbin"

	required_technologies = list(/datum/technology/adv_parts)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/part/ultra_micro_laser, /datum/design/research/item/part/super_matter_bin, /datum/design/research/item/medical/nanopaste)
/*
/datum/technology/telescience
	name = "Telescience"
	desc = "telescience"
	tech_type = RESEARCH_ENGINEERING

	x = 0.8
	y = 0.3
	icon = "telescience"

	required_technologies = list(/datum/technology/ultra_parts)
	required_tech_levels = list()
	cost = 3000

	unlocks_designs = list("telepad_concole", "telepad")

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
/datum/technology/super_adv_engineering
	name = "Super Advanced Engineering"
	desc = "Super Advanced Engineering"
	tech_type = RESEARCH_ENGINEERING

	x = 0.8
	y = 0.7
	icon = "rped"

	required_technologies = list(/datum/technology/ultra_parts)
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/item/part/RPED, /datum/design/research/circuit/secure_airlock)

/datum/technology/adv_tools
	name = "Advanced Tools"
	desc = "Advanced Tools"
	tech_type = RESEARCH_ENGINEERING

	x = 0.8
	y = 0.9
	icon = "jawsoflife"

	required_technologies = list(/datum/technology/super_adv_engineering)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/autolathe/tool/pneumatic_crowbar, /datum/design/autolathe/tool/rcd,
						/datum/design/autolathe/tool/rcd_ammo)

// Biotech

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

// Combat

/datum/technology/basic_combat
	name = "Basic Combat Systems"
	desc = "Basic Combat Systems"
	tech_type = RESEARCH_COMBAT

	x = 0.1
	y = 0.5
	icon = "stunbaton"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list()

// TO ADD: synth flashes?
/datum/technology/basic_nonlethal
	name = "Basic Non-Lethal"
	desc = "Basic Non-Lethal"
	tech_type = RESEARCH_COMBAT

	x = 0.3
	y = 0.5
	icon = "flash"

	required_technologies = list(/datum/technology/basic_combat)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/item/flash)

/datum/technology/advanced_nonlethal
	name = "Advanced Non-Lethal"
	desc = "Advanced Non-Lethal"
	tech_type = RESEARCH_COMBAT

	x = 0.3
	y = 0.3
	icon = "stunrevolver"

	required_technologies = list(/datum/technology/basic_nonlethal)
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/item/weapon/stunrevolver, /datum/design/research/item/ammo/shotgun_stun)

/datum/technology/weapon_recharging
	name = "Weapon Recharging"
	desc = "Weapon Recharging"
	tech_type = RESEARCH_COMBAT

	x = 0.5
	y = 0.5
	icon = "recharger"

	required_technologies = list(/datum/technology/advanced_nonlethal)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/sec_computers
	name = "Security Computers"
	desc = "Security Computers"
	tech_type = RESEARCH_COMBAT

	x = 0.1
	y = 0.7
	icon = "seccomputer"

	required_technologies = list(/datum/technology/basic_combat)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/secdata, /datum/design/research/circuit/prisonmanage)

/datum/technology/basic_lethal
	name = "Basic Lethal Weapons"
	desc = "Basic Lethal Weapons"
	tech_type = RESEARCH_COMBAT

	x = 0.7
	y = 0.5
	icon = "ammobox"

	required_technologies = list(/datum/technology/weapon_recharging)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/weapon/large_grenade)

/datum/technology/exotic_weaponry
	name = "Exotic Weaponry"
	desc = "Exotic Weaponry"
	tech_type = RESEARCH_COMBAT

	x = 0.7
	y = 0.3
	icon = "tempgun"

	required_technologies = list(/datum/technology/basic_lethal)
	required_tech_levels = list()
	cost = 3000

	unlocks_designs = list(/datum/design/research/item/weapon/temp_gun)

/datum/technology/adv_exotic_weaponry
	name = "Advanced Exotic Weaponry"
	desc = "Advanced Exotic Weaponry"
	tech_type = RESEARCH_COMBAT

	x = 0.9
	y = 0.3
	icon = "teslagun"

	required_technologies = list(/datum/technology/exotic_weaponry)
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list(/datum/design/research/item/weapon/decloner, /datum/design/research/item/weapon/plasmapistol)

/datum/technology/adv_lethal
	name = "Advanced Lethal Weapons"
	desc = "Advanced Lethal Weapons"
	tech_type = RESEARCH_COMBAT

	x = 0.7
	y = 0.7
	icon = "submachinegun"

	required_technologies = list(/datum/technology/basic_lethal)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list("smg")

/datum/technology/laser_weaponry
	name = "Laser Weaponry"
	desc = "Laser Weaponry"
	tech_type = RESEARCH_COMBAT

	x = 0.9
	y = 0.7
	icon = "gun"

	required_technologies = list(/datum/technology/adv_lethal, /datum/technology/adv_exotic_weaponry)
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list(/datum/design/research/item/weapon/nuclear_gun, /datum/design/research/item/weapon/lasercannon)

// Powerstorage

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

// Bluespace

/datum/technology/basic_bluespace
	name = "Basic 'Blue-space'"
	desc = "Basic 'Blue-space'"
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.2
	icon = "gps"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list(/datum/design/research/item/beacon)

/datum/technology/radio_transmission
	name = "Radio Transmission"
	desc = "Radio Transmission"
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.4
	icon = "headset"

	required_technologies = list(/datum/technology/basic_bluespace)
	required_tech_levels = list()
	cost = 200

	unlocks_designs = list()

/datum/technology/telecommunications
	name = "Telecommunications"
	desc = "Telecommunications"
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.6
	icon = "communications"

	required_technologies = list(/datum/technology/radio_transmission)
	required_tech_levels = list()
	cost = 600

	unlocks_designs = list(/datum/design/research/circuit/comconsole)

/datum/technology/bluespace_telecommunications
	name = "Bluespace Telecommunications"
	desc = "Bluespace Telecommunications"
	tech_type = RESEARCH_BLUESPACE

	x = 0.4
	y = 0.6
	icon = "bluespacething"

	required_technologies = list(/datum/technology/telecommunications)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/circuit/comm_monitor, /datum/design/research/circuit/comm_server,
						/datum/design/research/circuit/message_monitor, /datum/design/research/circuit/tcom/receiver,
						/datum/design/research/circuit/tcom/bus, /datum/design/research/circuit/tcom/hub,
						/datum/design/research/circuit/tcom/relay, /datum/design/research/circuit/tcom/processor,
						/datum/design/research/circuit/tcom/server, /datum/design/research/circuit/tcom/broadcaster,
						/datum/design/research/circuit/ntnet_relay,
						/datum/design/research/item/part/subspace_ansible, /datum/design/research/item/part/hyperwave_filter, 
						/datum/design/research/item/part/subspace_amplifier, /datum/design/research/item/part/subspace_treatment, 
						/datum/design/research/item/part/subspace_analyzer, /datum/design/research/item/part/subspace_crystal,
						/datum/design/research/item/part/subspace_transmitter)

/datum/technology/bluespace_shield
	name = "Bluespace Shields"
	desc = "Bluespace Shields"
	tech_type = RESEARCH_BLUESPACE

	x = 0.4
	y = 0.4
	icon = "shield"

	required_technologies = list(/datum/technology/bluespace_telecommunications)
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/circuit/shield/hull)
/*
/datum/technology/transmission_encryption
	name = "Transmission Encryption"
	desc = "Transmission Encryption"
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.8
	icon = "radiogrid"

	required_technologies = list(/datum/technology/telecommunications)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()
*/
/datum/technology/teleportation
	name = "Teleportation"
	desc = "Teleportation"
	tech_type = RESEARCH_BLUESPACE

	x = 0.6
	y = 0.6
	icon = "teleporter"

	required_technologies = list(/datum/technology/bluespace_telecommunications)
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/circuit/teleconsole)

/datum/technology/bluespace_tools
	name = "Bluespace Tools"
	desc = "Bluespace Tools"
	tech_type = RESEARCH_BLUESPACE

	x = 0.8
	y = 0.8
	icon = "bagofholding"

	required_technologies = list(/datum/technology/teleportation)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/beaker/bluespace, /datum/design/research/item/beaker/noreact,
						/datum/design/research/item/bag_holding, )
/*
/datum/technology/bluespace_rped
	name = "Bluespace RPED"
	desc = "Bluespace RPED"
	tech_type = RESEARCH_BLUESPACE

	x = 0.8
	y = 0.4
	icon = "bluespacerped"

	required_technologies = list(/datum/technology/teleportation)
	required_tech_levels = list()
	cost = 3000

	unlocks_designs = list()
*/
// Robotics

/datum/technology/basic_robotics
	name = "Basic Robotics"
	desc = "Basic Robotics"
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.2
	icon = "cyborganalyzer"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list(/datum/design/research/circuit/mech_recharger, /datum/design/research/circuit/recharge_station,
						/datum/design/research/item/medical/robot_scanner, /datum/design/research/item/mmi)

/datum/technology/mech_ripley
	name = "Ripley"
	desc = "Ripley"
	tech_type = RESEARCH_ROBOTICS

	x = 0.4
	y = 0.3
	icon = "ripley"

	required_technologies = list(/datum/technology/basic_robotics)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/mecha/ripley_main, /datum/design/research/circuit/mecha/ripley_peri)

/datum/technology/mech_odysseus
	name = "Odyssey"
	desc = "Odyssey"
	tech_type = RESEARCH_ROBOTICS

	x = 0.6
	y = 0.3
	icon = "odyssey"

	required_technologies = list(/datum/technology/basic_robotics)
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list(/datum/design/research/circuit/mecha/odysseus_main, /datum/design/research/circuit/mecha/odysseus_peri)

/datum/technology/advanced_robotics
	name = "Advanced Robotics"
	desc = "Advanced Robotics"
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.5
	icon = "posbrain"

	required_technologies = list(/datum/technology/mech_ripley, /datum/technology/mech_odysseus)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/circuit/mechacontrol, /datum/design/research/item/posibrain,
						/datum/design/research/circuit/mechfab, /datum/design/research/circuit/robocontrol,
						/datum/design/research/circuit/dronecontrol, /datum/design/research/item/mmi_radio,
						/datum/design/research/item/intellicard, /datum/design/research/item/paicard)

/datum/technology/artificial_intelligence
	name = "Artificial intelligence"
	desc = "Artificial intelligence"
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.65
	icon = "aicard"

	required_technologies = list(/datum/technology/advanced_robotics)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/circuit/aifixer, /datum/design/research/aimodule/safeguard,
						/datum/design/research/aimodule/onehuman, /datum/design/research/aimodule/protectstation,
						/datum/design/research/aimodule/notele, /datum/design/research/aimodule/quarantine,
						/datum/design/research/aimodule/oxygen, /datum/design/research/aimodule/freeform,
						/datum/design/research/aimodule/reset, /datum/design/research/aimodule/purge,
						/datum/design/research/aimodule/core/freeformcore, /datum/design/research/aimodule/core/asimov,
						/datum/design/research/aimodule/core/paladin, /datum/design/research/circuit/aicore,
						/datum/design/research/circuit/aiupload, /datum/design/research/circuit/borgupload)

/datum/technology/robot_modules
	name = "Cyborg Components"
	desc = "Cyborg Components"
	tech_type = RESEARCH_ROBOTICS

	x = 0.7
	y = 0.35
	icon = "aicard" // TODO better icon

	required_technologies = list(/datum/technology/advanced_robotics)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/mechfab/robot/component/jetpack, /datum/design/research/item/robot_upgrade/vtec,
						/datum/design/research/item/robot_upgrade/tasercooler, /datum/design/research/item/robot_upgrade/rcd)

/datum/technology/mech_gygax
	name = "Gygax"
	desc = "Gygax"
	tech_type = RESEARCH_ROBOTICS

	x = 0.4
	y = 0.7
	icon = "gygax"

	required_technologies = list(/datum/technology/advanced_robotics)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/circuit/mecha/gygax_main, /datum/design/research/circuit/mecha/gygax_peri, /datum/design/research/circuit/mecha/gygax_targ)

/* ??
/datum/technology/mech_gyrax_ultra
	name = "Gygax Ultra"
	desc = "Gygax Ultra"
	tech_type = RESEARCH_ROBOTICS

	x = 0.4
	y = 0.9
	icon = "gygaxultra"

	required_technologies = list(/datum/technology/mech_gygax)
	required_tech_levels = list()
	cost = 4000

	unlocks_designs = list("ultra_main", "ultra_peri", "ultra_targ")
*/
/datum/technology/mech_durand
	name = "Durand"
	desc = "Durand"
	tech_type = RESEARCH_ROBOTICS

	x = 0.6
	y = 0.7
	icon = "durand"

	required_technologies = list(/datum/technology/advanced_robotics)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/circuit/mecha/durand_main, /datum/design/research/circuit/mecha/durand_peri, /datum/design/research/circuit/mecha/durand_targ)


/datum/technology/mech_phazon
	name = "Phazon"
	desc = "Phazon"
	tech_type = RESEARCH_ROBOTICS

	x = 0.6
	y = 0.9
	icon = "vindicator" // TODO change icon

	required_technologies = list(/datum/technology/mech_durand)
	required_tech_levels = list() // Add some bluespace requirement?
	cost = 4000

	unlocks_designs = list(/datum/design/research/circuit/mecha/phazon_main, /datum/design/research/circuit/mecha/phazon_peri, /datum/design/research/circuit/mecha/phazon_targ)

/datum/technology/mech_utility_modules
	name = "Exosuit Utility Modules"
	desc = "Exosuit Utility Modules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.25
	y = 0.5
	icon = "mechrcd"

	required_technologies = list(/datum/technology/advanced_robotics)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/item/mecha/jetpack, /datum/design/research/item/mecha/ai_holder,
						/datum/design/research/item/mecha/wormhole_gen, /datum/design/research/item/mecha/rcd,
						/datum/design/research/item/mecha/gravcatapult, /datum/design/research/item/mecha/repair_droid,
						/datum/design/research/item/mecha/plasma_generator, /datum/design/research/item/mecha/energy_relay,
						/datum/design/research/item/mecha/syringe_gun, /datum/design/research/item/mecha/diamond_drill,
						/datum/design/research/item/mecha/generator_nuclear)

/datum/technology/mech_teleporter_modules
	name = "Exosuit Teleporter Module"
	desc = "Exosuit Teleporter Module"
	tech_type = RESEARCH_ROBOTICS

	x = 0.1
	y = 0.5
	icon = "mechteleporter"

	required_technologies = list(/datum/technology/mech_utility_modules)
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list(/datum/design/research/item/mecha/teleporter)

/datum/technology/mech_armor_modules
	name = "Exosuit Armor Modules"
	desc = "Exosuit Armor Modules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.25
	y = 0.8
	icon = "mecharmor"

	required_technologies = list(/datum/technology/mech_utility_modules)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/mecha/ccw_armor, /datum/design/research/item/mecha/proj_armor)

/datum/technology/mech_weaponry_modules
	name = "Exosuit Weaponry"
	desc = "Exosuit Weaponry"
	tech_type = RESEARCH_ROBOTICS

	x = 0.75
	y = 0.5
	icon = "mechgrenadelauncher"

	required_technologies = list(/datum/technology/advanced_robotics)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/mecha/weapon/scattershot, /datum/design/research/item/mecha/weapon/laser,
						/datum/design/research/item/mecha/weapon/grenade_launcher)

/datum/technology/mech_heavy_weaponry_modules
	name = "Exosuit Heavy Weaponry"
	desc = "Exosuit Heavy Weaponry"
	tech_type = RESEARCH_ROBOTICS

	x = 0.75
	y = 0.8
	icon = "mechlaser"

	required_technologies = list(/datum/technology/mech_weaponry_modules)
	required_tech_levels = list()
	cost = 4000

	unlocks_designs = list(/datum/design/research/item/mecha/weapon/laser_heavy, /datum/design/research/item/mecha/weapon/ion)
/*
/datum/technology/basic_hardsuit_modules
	name = "Basic Hardsuit Modules"
	desc = "Basic Hardsuit Modules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.35
	y = 0.1
	icon = "rigscanner"

	required_technologies = list()
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list("rigsimpleai", "rigflash", "righealthscanner", "riganomalyscanner", "rigorescanner", "rigextinguisher", "rigmetalfoamspray", "rigcoolingunit")

/datum/technology/advanced_hardsuit_modules
	name = "Advanced Hardsuit Modules"
	desc = "Basic Hardsuit Modules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.5
	y = 0.1
	icon = "rigtaser"

	required_technologies = list(/datum/technology/basic_hardsuit_modules)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list("rigadvancedai", "riggrenadelauncherflashbang", "rigdrill", "rigselfrepair", "rigmountedtaser", "rigcombatinjector", "rigmedicalinjector")

/datum/technology/toptier_hardsuit_modules
	name = "Top-Tier Hardsuit Modules"
	desc = "Top-Tier Hardsuit Modules"
	tech_type = RESEARCH_ROBOTICS

	x = 0.65
	y = 0.1
	icon = "rignuclearreactor"

	required_technologies = list(/datum/technology/advanced_hardsuit_modules)
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list("rigmountedlaserrifle", "rigrcd", "rigmedteleport", "rignuclearreactor")
*/
// Illegal

/datum/technology/binary_encryption_key
	name = "Binary Encrpytion Key"
	desc = "Binary Encrpytion Key"
	tech_type = RESEARCH_ILLEGAL

	x = 0.1
	y = 0.5
	icon = "binarykey"

	required_technologies = list()
	required_tech_levels = list(RESEARCH_BLUESPACE = 5)
	cost = 2000

	unlocks_designs = list(/datum/design/research/item/binaryencrypt)

/datum/technology/chameleon_kit
	name = "Chameleon Kit"
	desc = "Chameleon Kit"
	tech_type = RESEARCH_ILLEGAL

	x = 0.3
	y = 0.5
	icon = "chamelion"

	required_technologies = list(/datum/technology/binary_encryption_key)
	required_tech_levels = list(RESEARCH_ENGINEERING = 10)
	cost = 3000

	unlocks_designs = list(/datum/design/research/item/chameleon_kit)

/datum/technology/freedom_implant
	name = "Glass Case- 'Freedom'"
	desc = "Glass Case- 'Freedom'"
	tech_type = RESEARCH_ILLEGAL

	x = 0.5
	y = 0.5
	icon = "freedom"

	required_technologies = list(/datum/technology/chameleon_kit)
	required_tech_levels = list(RESEARCH_BIOTECH = 5)
	cost = 3000

	unlocks_designs = list(/datum/design/research/item/implant/freedom)

/datum/technology/tyrant_aimodule
	name = "AI Core Module (T.Y.R.A.N.T.)"
	desc = "AI Core Module (T.Y.R.A.N.T.)"
	tech_type = RESEARCH_ILLEGAL

	x = 0.7
	y = 0.5
	icon = "module"

	required_technologies = list(/datum/technology/freedom_implant)
	required_tech_levels = list(RESEARCH_ROBOTICS = 5)
	cost = 3000

	unlocks_designs = list(/datum/design/research/aimodule/core/tyrant)

/datum/technology/borg_syndicate_module
	name = "Borg Illegal Weapons Upgrade"
	desc = "Borg Illegal Weapons Upgrade"
	tech_type = RESEARCH_ILLEGAL

	x = 0.9
	y = 0.5
	icon = "borgmodule"

	required_technologies = list(/datum/technology/tyrant_aimodule)
	required_tech_levels = list(RESEARCH_ROBOTICS = 10)
	cost = 5000

	unlocks_designs = list(/datum/design/research/item/robot_upgrade/syndicate)
