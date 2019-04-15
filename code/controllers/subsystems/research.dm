SUBSYSTEM_DEF(research)
	name = "Research"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DEFAULT

	// Design datums:
	var/list/design_ids = list()	// id = datum
	var/list/all_designs = list()	// just datums

	// If a research holder is created before SS is initialized, put it here and
	var/list/research_holders_to_init = list()

/datum/controller/subsystem/research/Initialize()
	for(var/R in subtypesof(/datum/design))
		var/datum/design/design = new R
		design.AssembleDesignInfo()
		if(!design.build_path)
			continue

		all_designs += design

		// Design ID is string or path.
		// If path, make it accessible in both path and text form.
		design_ids[design.id] = design
		design_ids["[design.id]"] = design

	generate_integrated_circuit_designs()

	// Initialize research holders that were created before
	for(var/R in research_holders_to_init)
		var/datum/research/research = R
		initialize_designs(research)

	research_holders_to_init = list()

	return ..()


/datum/controller/subsystem/research/proc/generate_integrated_circuit_designs()
	for(var/obj/item/integrated_circuit/IC in all_integrated_circuits)
		if(!(IC.spawn_flags & IC_SPAWN_RESEARCH))
			continue
		var/datum/design/design = new /datum/design/research/circuit(src)
		design.name = "Custom circuitry \[[IC.category_text]\] ([IC.name])"
		design.id = "ic-[lowertext(IC.name)]"
		design.build_path = IC.type

		if(length(IC.origin_tech))
			design.req_tech = IC.origin_tech.Copy()
		else
			design.req_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2)

		design.AssembleDesignInfo()


		all_designs += design

		// Design ID is string or path.
		// If path, make it accessible in both path and text form.
		design_ids[design.id] = design
		design_ids["[design.id]"] = design


/datum/controller/subsystem/research/proc/initialize_designs(datum/research/research)
	// If designs are already generated, initialized right away.
	// If not, add them to the list to be initialized later.
	if(length(all_designs))
		for(var/datum/design/D in all_designs)
			if(!D.req_tech)
				continue

			research.possible_designs += D
			research.possible_design_ids[D.id] = D
			research.possible_design_ids["[D.id]"] = D
		research.RefreshResearch()
	else
		research_holders_to_init += research
