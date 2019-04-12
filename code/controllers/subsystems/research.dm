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

	// Initialize research holders that were created before
	for(var/R in research_holders_to_init)
		var/datum/research/research = R
		initialize_designs(research)

	research_holders_to_init = list()

	return ..()


/datum/controller/subsystem/research/proc/initialize_designs(datum/research/research)
	if(length(all_designs))
		for(var/datum/design/research/D in all_designs)
			research.possible_designs += D
			research.possible_design_ids[D.id] = D
			research.possible_design_ids["[D.id]"] = D
		research.RefreshResearch()
	else
		research_holders_to_init += research
