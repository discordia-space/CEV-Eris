/*
	Research subsystem. Manages the static part of R&D, aka designs, technology nodes and such.
	Does NOT handle tech trees since they're supposed to be instantiated per console, to track user's progress.
	It holds instantiated designs, instantiated technologies (nodes) and tech tree types.
	It sets research datums' designs and creates a new tree for each datum.
*/

SUBSYSTEM_DEF(research)
	name = "Research"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DEFAULT

	var/list/all_designs = list()	// All design datums
	var/list/starting_designs = list() // List of designs starts_unlocked = TRUE
	var/list/all_tech_trees = list() // All tech tree typepaths (keys) associated to a list of their tech node instances (list(values))
	var/list/all_tech_nodes = list() // All tech nodes

	var/research_initialized = FALSE

	// If a research holder or a design file is created before SS is initialized, put it here and initialize it later.
	var/list/design_files_to_init = list()
	var/list/research_files_to_init = list()

/datum/controller/subsystem/research/Initialize()
	for(var/R in subtypesof(/datum/design))
		var/datum/design/design = new R
		design.AssembleDesignInfo()
		if(!design.build_path)
			continue

		all_designs += design
		if(design.starts_unlocked)
			starting_designs += design

		var/datum/computer_file/binary/design/design_file = new
		design_file.design = design
		design_file.on_design_set()
		design.file = design_file

	for(var/T in subtypesof(/datum/tech))
		all_tech_trees[T] = list()

	for(var/T in subtypesof(/datum/technology))
		var/datum/technology/tech = new T
		all_tech_nodes += tech
		if(tech.tech_type in all_tech_trees)
			all_tech_trees[tech.tech_type] += tech
		else
			WARNING("Unknown tech_type '[tech.tech_type]' in technology '[tech.name]'")

	generate_integrated_circuit_designs()

	research_initialized = TRUE
	for(var/i in research_files_to_init)
		initialize_research_datum(i)
	// Initialize design files that were created before
	for(var/file in design_files_to_init)
		initialize_design_file(file)
	design_files_to_init = list()

	return ..()


/datum/controller/subsystem/research/proc/generate_integrated_circuit_designs()
	for(var/obj/item/integrated_circuit/IC in all_integrated_circuits)
		if(!(IC.spawn_flags & IC_SPAWN_RESEARCH))
			continue
		var/datum/design/design = new /datum/design/research/circuit(src)
		design.name = "Custom circuitry \[[IC.category_text]\] ([IC.name])"
		design.id = "ic-[lowertext(IC.name)]"
		design.build_path = IC.type

		design.AssembleDesignInfo()


		all_designs += design

/datum/controller/subsystem/research/proc/initialize_design_file(datum/computer_file/binary/design/design_file)
	// If designs are already generated, initialized right away.
	// If not, add them to the list to be initialized later.
	if(research_initialized)
		var/datum/design/design = locate(design_file.design) in all_designs
		if(design)
			design_file.design = design
			design_file.on_design_set()
		else
			error("Incorrect design ID or path: [design_file.design]")

	else
		design_files_to_init += design_file

/datum/controller/subsystem/research/proc/initialize_research_datum(datum/research/R)
	if(!research_initialized)
		research_files_to_init += R
		return
	for(var/i in all_tech_trees)
		var/datum/tech/T = new i
		T.max_level = all_tech_trees[i].len
		R.researched_tech[T] = list()
	for(var/i in starting_designs)
		R.known_designs += i
	
