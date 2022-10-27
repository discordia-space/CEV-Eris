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

/datum/research/proc/adjust_research_points(value)
	if(value > 0)
		GLOB.research_point_gained += value
	research_points += value

/datum/research								//Holder for all the existing, archived, and known tech. Individual to console.
	var/list/known_designs = list()			//List of available designs (at base reliability).
	var/list/design_categories_protolathe = list()
	var/list/design_categories_imprinter = list()
	var/list/design_categories_mechfab = list()
	var/list/design_categories_organfab = list()

	var/list/researched_tech = list() // Tree = list(of_researched_tech)
	var/list/researched_nodes = list() // All research nodes

	var/datum/experiment_data/experiments

	var/known_research_file_ids = list()

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

/datum/research/proc/UnlockTechology(datum/technology/T, force = FALSE, initial = FALSE)
	if(IsResearched(T))
		return FALSE
	if(!CanResearch(T) && !force)
		return FALSE
	researched_nodes += T
	var/datum/tech/tree = locate(T.tech_type) in researched_tech
	researched_tech[tree] += T
	if(!force)
		adjust_research_points(-T.cost)

	if(initial) // Initial technologies don't add levels
		tree.max_level -= 1
	else
		tree.level += 1

	for(var/id in T.unlocks_designs)
		AddDesign2Known(SSresearch.get_design(id))

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
	known_research_file_ids |= O.known_research_file_ids
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
	if(D.build_type & IMPRINTER)
		design_categories_imprinter |= cat
	if(D.build_type & MECHFAB)
		design_categories_mechfab |= cat
	if(D.build_type & ORGAN_GROWER)
		design_categories_organfab |= cat


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

/datum/research/proc/is_research_file_type(datum/computer_file/file)
	if(istype(file, /datum/computer_file/binary/research_points))
		return TRUE

	return FALSE

/datum/research/proc/can_load_file(datum/computer_file/file)
	if(istype(file, /datum/computer_file/binary/research_points))
		var/datum/computer_file/binary/research_points/research_points_file = file
		return !(research_points_file.research_id in known_research_file_ids)

	return FALSE

/datum/research/proc/load_file(datum/computer_file/file)
	if(!can_load_file(file))
		return FALSE

	if(istype(file, /datum/computer_file/binary/research_points))
		var/datum/computer_file/binary/research_points/research_points_file = file
		known_research_file_ids += research_points_file.research_id
		adjust_research_points(research_points_file.size * 1000)
		return TRUE

	return FALSE


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

/datum/tech/covert
	name = "Covert Technologies Research"
	shortname = "Covert Tech"
	desc = "The study of technologies that violate standard regulations."
	rare = 3
	shown = FALSE
	item_tech_req = TECH_COVERT // research any contractor item and this tech will show up

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
