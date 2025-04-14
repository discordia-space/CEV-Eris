PROCESSING_SUBSYSTEM_DEF(reagents)
	name = "Reagents"
	priority = FIRE_PRIORITY_OBJECTS
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_REAGENTS

/datum/controller/subsystem/processing/reagents/Initialize(timeofday)
	initialize_chemical_reactions()
	..()

//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
// It is filtered into multiple lists within a list.
// For example:
// chemical_reaction_list["plasma"] is a list of all reactions relating to plasma
// Note that entries in the list are NOT duplicated. So if a reaction pertains to
// more than one chemical it will still only appear in only one of the sublists.
/datum/controller/subsystem/processing/reagents/proc/initialize_chemical_reactions()
	var/paths = typesof(/datum/chemical_reaction) - /datum/chemical_reaction
	INIT_EMPTY_GLOBLIST(chemical_reactions_list)
	INIT_EMPTY_GLOBLIST(chemical_reactions_list_by_result)

	for(var/path in paths)
		var/datum/chemical_reaction/D = new path()
		for(var/id in D.required_reagents)
			if(!is_reagent_with_id_exist(id))
				error("recipe [D.type] created incorectly,\[required_reagents\] reagent with id \"[id]\" does not exist.")
		for(var/id in D.catalysts)
			if(!is_reagent_with_id_exist(id))
				error("recipe [D.type] created incorectly,\[catalysts\] reagent with id [id] does not exist.")
		for(var/id in D.inhibitors)
			if(!is_reagent_with_id_exist(id))
				error("recipe [D.type] created incorectly,\[inhibitors\] reagent with id [id] does not exist.")
		for(var/id in D.byproducts)
			if(!is_reagent_with_id_exist(id))
				error("recipe [D.type] created incorectly,\[byproducts\] reagent with id [id] does not exist.")
		if(D.required_reagents && D.required_reagents.len)
			if(D.result)
				if(!GLOB.chemical_reactions_list_by_result[D.result])
					GLOB.chemical_reactions_list_by_result[D.result] = list()
				GLOB.chemical_reactions_list_by_result[D.result] += D
			var/reagent_id = D.required_reagents[1]
			if(!GLOB.chemical_reactions_list[reagent_id])
				GLOB.chemical_reactions_list[reagent_id] = list()
			GLOB.chemical_reactions_list[reagent_id] += D
