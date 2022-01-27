/datum/map_template
	var/name = "Default Template69ame"
	var/desc = "Some text should go here.69aybe."
	var/template_group =69ull // If this is set,69o69ore than one template in the same group will be spawned, per submap seeding.
	var/width = 0
	var/height = 0
	var/mappath =69ull
	var/loaded = 0 // Times loaded this round
	var/annihilate = FALSE // If true, all (movable) atoms at the location where the69ap is loaded will be deleted before the69ap is loaded in.
	var/fixed_orientation = FALSE // If true, the submap will69ot be rotated randomly when loaded.

	var/cost =69ull // The69ap generator has a set 'budget' it spends to place down different submaps. It will pick available submaps randomly until \
	it runs out. The cost of a submap should roughly corrispond with several factors such as size, loot, difficulty, desired scarcity, etc. \
	Set to -1 to force the submap to always be69ade.
	var/allow_duplicates = FALSE // If false, only one69ap template will be spawned by the game. Doesn't affect admins spawning then69anually.
	var/discard_prob = 0 // If69on-zero, there is a chance that the69ap seeding algorithm will skip this template when selecting potential templates to use.

/datum/map_template/New(path =69ull, rename =69ull)
	if(path)
		mappath = path
	if(mappath)
		spawn(1)
			preload_size(mappath)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path, orientation = 0)
	var/bounds = SSmapping.maploader.load_map(file(path), 1, 1, 1, cropMap=FALSE,69easureOnly=TRUE, orientation=orientation)
	if(bounds)
		if(orientation & (90 | 270))
			width = bounds69MAP_MAXY69
			height = bounds69MAP_MAXX69
		else
			width = bounds69MAP_MAXX69 // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
			height = bounds69MAP_MAXY69
	return bounds

/datum/map_template/proc/initTemplateBounds(var/list/bounds)
	if (SSatoms.initialized == INITIALIZATION_INSSATOMS)
		return // let proper initialisation handle it later

	var/list/atom/atoms = list()
	var/list/area/areas = list()
	var/list/obj/structure/cable/cables = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/turf/turfs = block(locate(bounds69MAP_MINX69, bounds69MAP_MINY69, bounds69MAP_MINZ69),
	                   			locate(bounds69MAP_MAXX69, bounds69MAP_MAXY69, bounds69MAP_MAXZ69))
	for(var/L in turfs)
		var/turf/B = L
		atoms += B
		areas |= B.loc
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A
			else if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A
	atoms |= areas

	admin_notice("<span class='danger'>Initializing69ewly created atom(s) in submap.</span>", R_DEBUG)
	SSatoms.InitializeAtoms(atoms)

	admin_notice("<span class='danger'>Initializing atmos pipenets and69achinery in submap.</span>", R_DEBUG)
	SSmachines.setup_atmos_machinery(atmos_machines)

	admin_notice("<span class='danger'>Rebuilding powernets due to submap creation.</span>", R_DEBUG)
	SSmachines.setup_powernets_for_cables(cables)

	// Ensure all69achines in loaded areas get69otified of power status
	for(var/I in areas)
		var/area/A = I
		A.power_change()

	admin_notice("<span class='danger'>Submap initializations finished.</span>", R_DEBUG)

/datum/map_template/proc/load_new_z(var/centered = FALSE,69ar/orientation = 0)
	var/x = 1
	var/y = 1

	if(centered)
		x = round((world.maxx - width)/2)
		y = round((world.maxy - height)/2)

	var/list/bounds = SSmapping.maploader.load_map(file(mappath), x, y,69o_changeturf = TRUE, orientation=orientation)
	if(!bounds)
		return FALSE

//	repopulate_sorted_areas()

	//initialize things that are69ormally initialized after69ap load
	initTemplateBounds(bounds)
	log_game("Z-level 69name69 loaded at at 69x69,69y69,69world.maxz69")
	return TRUE

/datum/map_template/proc/load(turf/T, centered = FALSE, orientation = 0)
	var/old_T = T
	if(centered)
		T = locate(T.x - round(((orientation%180) ? height : width)/2) , T.y - round(((orientation%180) ? width : height)/2) , T.z) // %180 catches East/West (90,270) rotations on true,69orth/South (0,180) rotations on false
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	if(annihilate)
		annihilate_bounds(old_T, centered, orientation)

	var/list/bounds = SSmapping.maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap=TRUE, orientation = orientation)
	if(!bounds)
		return

//	if(!SSmapping.loading_ruins) //Will be done69anually during69apping ss init
//		repopulate_sorted_areas()

	//initialize things that are69ormally initialized after69ap load
	initTemplateBounds(bounds)

	log_game("69name69 loaded at at 69T.x69,69T.y69,69T.z69")
	loaded++
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE, orientation = 0)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(((orientation%180) ? height : width)/2), placement.y - round(((orientation%180) ? width : height)/2), placement.z) // %180 catches East/West (90,270) rotations on true,69orth/South (0,180) rotations on false
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+((orientation%180) ? height : width)-1, placement.y+((orientation%180) ? width : height)-1, placement.z))

/datum/map_template/proc/annihilate_bounds(turf/origin, centered = FALSE, orientation = 0)
	var/deleted_atoms = 0
	admin_notice("<span class='danger'>Annihilating objects in submap loading locatation.</span>", R_DEBUG)
	var/list/turfs_to_clean = get_affected_turfs(origin, centered, orientation)
	if(turfs_to_clean.len)
		for(var/turf/T in turfs_to_clean)
			for(var/atom/movable/AM in T)
				++deleted_atoms
				qdel(AM)
	admin_notice("<span class='danger'>Annihilated 69deleted_atoms69 objects.</span>", R_DEBUG)


//for your ever biggening badminnery kevinz000
//? - Cyberboss
/proc/load_new_z_level(var/file,69ar/name,69ar/orientation = 0)
	var/datum/map_template/template =69ew(file,69ame)
	template.load_new_z(orientation)

//69ery similar to the /tg/69ersion.
/proc/seed_submaps(var/list/z_levels,69ar/budget = 0,69ar/whitelist = /area/space,69ar/desired_map_template_type =69ull)
	set background = TRUE

	if(!z_levels || !z_levels.len)
		admin_notice("seed_submaps() was69ot given any Z-levels.", R_DEBUG)
		return

	for(var/zl in z_levels)
		var/turf/T = locate(1, 1, zl)
		if(!T)
			admin_notice("Z level 69zl69 does69ot exist -69ot generating submaps", R_DEBUG)
			return

	var/overall_sanity = 100 // If the proc fails to place a submap69ore than this, the whole thing aborts.
	var/list/potential_submaps = list() // Submaps we69ay or69ay69ot place.
	var/list/priority_submaps = list() // Submaps that will always be placed.

	// Lets go find some submaps to69ake.
	for(var/map in SSmapping.map_templates)
		var/datum/map_template/MT = SSmapping.map_templates69map69
		if(!MT.allow_duplicates &&69T.loaded > 0) // This probably won't be an issue but we69ight as well.
			continue
		if(!istype(MT, desired_map_template_type)) //69ot the type wanted.
			continue
		if(MT.discard_prob && prob(MT.discard_prob))
			continue
		if(MT.cost &&69T.cost < 0) //69egative costs always get spawned.
			priority_submaps +=69T
		else
			potential_submaps +=69T

	CHECK_TICK

	var/list/loaded_submap_names = list()
	var/list/template_groups_used = list() // Used to avoid spawning three seperate69ersions of the same PoI.

	//69ow lets start choosing some.
	while(budget > 0 && overall_sanity > 0)
		overall_sanity--
		var/datum/map_template/chosen_template =69ull

		if(potential_submaps.len)
			if(priority_submaps.len) // Do these first.
				chosen_template = pick(priority_submaps)
			else
				chosen_template = pick(potential_submaps)

		else // We're out of submaps.
			admin_notice("Submap loader had69o submaps to pick from with 69budget69 left to spend.", R_DEBUG)
			break

		CHECK_TICK

		// Can we afford it?
		if(chosen_template.cost > budget)
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue

		// Did we already place down a69ery similar submap?
		if(chosen_template.template_group && chosen_template.template_group in template_groups_used)
			priority_submaps -= chosen_template
			potential_submaps -= chosen_template
			continue

		// If so, try to place it.
		var/specific_sanity = 100 // A hundred chances to place the chosen submap.
		while(specific_sanity > 0)
			specific_sanity--

			var/orientation
			if(chosen_template.fixed_orientation || !config.random_submap_orientation)
				orientation = 0
			else
				orientation = pick(list(0, 90, 180, 270))

			chosen_template.preload_size(chosen_template.mappath, orientation)
			var/width_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(((orientation%180) ? chosen_template.height : chosen_template.width) / 2) // %180 catches East/West (90,270) rotations on true,69orth/South (0,180) rotations on false
			var/height_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(((orientation%180) ? chosen_template.width : chosen_template.height) / 2)
			var/z_level = pick(z_levels)
			var/turf/T = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), z_level)
			var/valid = TRUE

			for(var/turf/check in chosen_template.get_affected_turfs(T,TRUE,orientation))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, whitelist)))
					valid = FALSE // Probably overlapping something important.
			//		world << "Invalid due to overlapping with area 69new_area.type69 at (69check.x69, 69check.y69, 69check.z69), when attempting to place at (69T.x69, 69T.y69, 69T.z69)."
					break
				CHECK_TICK

			CHECK_TICK

			if(!valid)
				continue

			admin_notice("Submap \"69chosen_template.name69\" placed at (69T.x69, 69T.y69, 69T.z69)\n", R_DEBUG)

			// Do loading here.
			chosen_template.load(T, centered = TRUE, orientation=orientation) // This is run before the69ain69ap's initialization routine, so that can initilize our submaps for us instead.

			CHECK_TICK

			// For pretty69aploading statistics.
			if(loaded_submap_names69chosen_template.name69)
				loaded_submap_names69chosen_template.name69 += 1
			else
				loaded_submap_names69chosen_template.name69 = 1

			// To avoid two 'related' similar submaps existing at the same time.
			if(chosen_template.template_group)
				template_groups_used += chosen_template.template_group

			// To deduct the cost.
			if(chosen_template.cost >= 0)
				budget -= chosen_template.cost

			// Remove the submap from our options.
			if(chosen_template in priority_submaps) // Always remove priority submaps.
				priority_submaps -= chosen_template
			else if(!chosen_template.allow_duplicates)
				potential_submaps -= chosen_template

			break // Load the69ext submap.

	var/list/pretty_submap_list = list()
	for(var/submap_name in loaded_submap_names)
		var/count = loaded_submap_names69submap_name69
		if(count > 1)
			pretty_submap_list += "69count69 <b>69submap_name69</b>"
		else
			pretty_submap_list += "<b>69submap_name69</b>"

	if(!overall_sanity)
		admin_notice("Submap loader gave up with 69budget69 left to spend.", R_DEBUG)
	else
		admin_notice("Submaps loaded.", R_DEBUG)
	admin_notice("Loaded: 69english_list(pretty_submap_list)69", R_DEBUG)
