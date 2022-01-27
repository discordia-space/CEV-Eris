/*
General Explanation:
The research datum is the "folder" where all the research information is stored in a R&D console. It's also a holder for all the
various procs used to69anipulate it.

Variables:
- known_designs: A list of instantiated design datums known by this research datum.
- design_categories_protolathe: Same as above, but filtered by build_type.
- design_categories_imprinter: Ditto.
- researched_tech: An associative list of instantiated tech trees (/datum/tech), with a69alue of a list containing known instantiated technology69odes (/datum/technology)
- researched_nodes: All the known researched technology69odes.
- experiments: experiments datum.
- research_points: a69umber69alue representing points. Only69eaningful for the rd console currently.

Procs:
- IsResearched(datum/technology/T): Is T in researched_nodes?
- CanResearch(datum/technology/T): Can T be researched (checks T cost, if T's associated tree is shown and if we have the re69uired tech levels/nodes).
- UnlockTechology(datum/technology/T, force = FALSE): Unlocks a technology69ode T for src. Safe (uses the procs above). Adds T to the69eeded lists, and adds its designs too.
														Setting force to true ignores T's cost.
- download_from(datum/research/O): Downloads data from O. The result is the union of src and O.
- forget_techology(datum/technology/T): Removes T from src.
- forget_all(tech_type): Forget all the technology69odes associated to a tree with type tech_type.
- AddDesign2Known(datum/design/D): Add design to known_designs.
- check_item_for_tech(obj/item/I): Unlocks a hidden tech tree if the item has the tree's item_tech_re69 in its origin_tech.

*/
/***************************************************************
**						Master Types						  **
**	Includes all the helper procs and basic tech processing.  **
***************************************************************/

/datum/research/proc/adjust_research_points(value)
	if(value > 0)
		GLOB.research_point_gained +=69alue
	research_points +=69alue

/datum/research								//Holder for all the existing, archived, and known tech. Individual to console.
	var/list/known_designs = list()			//List of available designs (at base reliability).
	var/list/design_categories_protolathe = list()
	var/list/design_categories_imprinter = list()
	var/list/design_categories_mechfab = list()

	var/list/researched_tech = list() // Tree = list(of_researched_tech)
	var/list/researched_nodes = list() // All research69odes

	var/datum/experiment_data/experiments

	var/known_research_file_ids = list()

	var/research_points = 0

/datum/research/New()
	..()
	SSresearch.initialize_research_datum(src)
	experiments =69ew /datum/experiment_data()

/datum/research/proc/IsResearched(datum/technology/T)
	return (T in researched_nodes)

/datum/research/proc/CanResearch(datum/technology/T)
	if(T.cost > research_points)
		return FALSE
	var/datum/tech/mytree = locate(T.tech_type) in researched_tech
	if(!mytree || !mytree.shown) // invalid tech_type or hidden tree,69o bypassing safeties!
		return

	for(var/tree in T.re69uired_tech_levels)
		var/datum/tech/tech_tree = locate(tree) in researched_tech
		var/level = T.re69uired_tech_levels69tree69

		if(tech_tree.level < level)
			return FALSE

	for(var/tech in T.re69uired_technologies)
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
	researched_tech69tree69 += T
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

		for(var/tech in O.researched_tech69t69)
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
	researched_tech69tree69 -= T
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
	researched_nodes -= researched_tech69tree69 // Remove all the69odes of the tree from the general researched69odes list
	for(var/tech in researched_tech69tree69)
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
	if(D.build_type &69ECHFAB)
		design_categories_mechfab |= cat


// Unlocks hidden tech trees
/datum/research/proc/check_item_for_tech(obj/item/I)
	var/list/temp_tech = I.origin_tech
	if(!temp_tech.len)
		return

	for(var/tree in researched_tech)
		var/datum/tech/T = tree
		if(T.shown || !T.item_tech_re69)
			continue

		for(var/item_tech in temp_tech)
			if(item_tech == T.item_tech_re69)
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
	var/desc = "description"   //General description of what it does and what it69akes.
	var/level = 0              //A simple69umber scale of the research level.
	var/rare = 1               //How69uch CentCom wants to get that tech. Used in supply shuttle tech cost calculation.
	var/max_level              //Calculated based on the ammount of technologies
	var/shown = TRUE           //Used to hide tech that is69ot supposed to be shown from the start
	var/item_tech_re69          //Deconstructing items with this tech will unlock this tech tree

//Trunk Technologies (don't re69uire any other techs and you start knowning them).

/datum/tech/engineering
	name = "Engineering Research"
	shortname = "Engineering"
	desc = "Development of69ew and improved engineering parts."

/datum/tech/biotech
	name = "Biological Technology"
	shortname = "Biological"
	desc = "Research into the deeper69ysteries of life and organic substances."

/datum/tech/combat
	name = "Combat Systems Research"
	shortname = "Combat Systems"
	desc = "The development of offensive and defensive systems."

/datum/tech/powerstorage
	name = "Power69anipulation Technology"
	shortname = "Power69anipulation"
	desc = "The69arious technologies behind the storage and generation of electicity."

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
	desc = "The study of technologies that69iolate standard regulations."
	rare = 3
	shown = FALSE
	item_tech_re69 = TECH_COVERT // research any contractor item and this tech will show up

/datum/technology
	var/name = "name"
	var/desc = "description"                //69ot used because lazy
	var/tech_type                           // Which tech tree does this techology belongs to (path/define)

	var/x = 0.5                             // Position on the tech tree69ap, 0 - left, 1 - right
	var/y = 0.5                             // 0 - down, 1 - top
	var/icon = "gun"                        // css class of techology icon, defined in shared.css

	var/list/re69uired_technologies = list() // Paths of techologies that are re69uired to be unlocked before this one. Should have same tech_type
	var/list/re69uired_tech_levels = list()  // list(/datum/tech/biotech = 5, ...) Paths and re69uired levels of tech
	var/cost = 100                          // How69uch research points re69uired to unlock this techology

	var/list/unlocks_designs = list()       // Paths of designs that this technology unlocks

/datum/technology/proc/getCost()
	// Calculates tech disk's supply points sell cost
	var/datum/tech/tree = locate(tech_type) in SSresearch.all_tech_trees
	if(tree)
		return (cost/100)*initial(tree.rare)
	else
		return cost/100
