/datum/map_template
	var/name = "Default Template Name"
	var/desc = "Some text should go here. Maybe."
	var/id = null
	var/template_group = null // If this is set, no more than one template in the same group will be spawned, per submap seeding.
	var/width = 0
	var/height = 0
	var/mappath = null
	var/loaded = 0 // Times loaded this round
	var/annihilate = FALSE // If true, all (movable) atoms at the location where the map is loaded will be deleted before the map is loaded in.

	var/cost = null // The map generator has a set 'budget' it spends to place down different submaps. It will pick available submaps randomly until
					// it runs out. The cost of a submap should roughly corrispond with several factors such as size, loot, difficulty, desired scarcity, etc.
					// Set to -1 to force the submap to always be made.
	var/allow_duplicates = FALSE // If false, only one map template will be spawned by the game. Doesn't affect admins spawning then manually.
	var/discard_prob = 0 // If non-zero, there is a chance that the map seeding algorithm will skip this template when selecting potential templates to use.

	var/template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

	///if true, creates a list of all atoms created by this template loading, defaults to FALSE
	var/returns_created_atoms = FALSE

	///the list of atoms created by this template being loaded, only populated if returns_created_atoms is TRUE
	var/list/created_atoms = list()
	//make sure this list is accounted for/cleared if you request it from ssatoms!

/datum/map_template/New(path = null, rename = null)
	if(path)
		mappath = path
	if(mappath)
		spawn(1)
			preload_size(mappath)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path, orientation = SOUTH)
	var/bounds = SSmapping.load_map(file(path), 1, 1, 1, cropMap = FALSE, measureOnly = TRUE, orientation = orientation, delayed_loading = TRUE)
	if(bounds)
		if(orientation & (90 | 270))
			width = bounds[MAP_MAXY]
			height = bounds[MAP_MAXX]
		else
			width = bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
			height = bounds[MAP_MAXY]
	return bounds

/datum/map_template/proc/initTemplateBounds(list/bounds)
	if(!bounds) //something went wrong
		stack_trace("[name] template failed to initialize correctly!")
		return


	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/structure/cable/cables = list()
	var/list/atom/movable/movables = list()
	var/list/area/areas = list()

	var/list/turfs = block(
		locate(
			bounds[MAP_MINX],
			bounds[MAP_MINY],
			bounds[MAP_MINZ]
			),
		locate(
			bounds[MAP_MAXX],
			bounds[MAP_MAXY],
			bounds[MAP_MAXZ]
			)
		)

	for(var/turf/current_turf as anything in turfs)
		var/area/current_turfs_area = current_turf.loc
		areas |= current_turfs_area
		if(!SSatoms.initialized)
			continue

		for(var/movable_in_turf in current_turf)
			movables += movable_in_turf
			if(istype(movable_in_turf, /obj/structure/cable))
				cables += movable_in_turf
				continue
			if(istype(movable_in_turf, /obj/machinery/atmospherics))
				atmos_machines += movable_in_turf

	if(!SSatoms.initialized)
		return

	SSatoms.InitializeAtoms(areas + turfs + movables, returns_created_atoms ? created_atoms : null)

	// NOTE, now that Initialize and LateInitialize run correctly, do we really
	// need these two below?
	SSmachines.setup_template_powernets(cables)
	SSair.setup_template_machinery(atmos_machines)

	// Ensure all machines in loaded areas get notified of power status
	for(var/I in areas)
		var/area/A = I
		A.power_change()

	//admin_notice("<span class='danger'>Submap initializations finished.</span>", R_DEBUG)

/datum/map_template/proc/load(turf/T, centered = FALSE, orientation = SOUTH, var/post_init = 0)
	var/old_T = T
	if(centered)
		T = locate(T.x - round(((orientation & NORTH|SOUTH) ? width : height)/2) , T.y - round(((orientation & NORTH|SOUTH) ? height : width)/2) , T.z)
	if(!T)
		return
	if(T.x+width > world.maxx)
		return
	if(T.y+height > world.maxy)
		return

	if(annihilate)
		annihilate_bounds(old_T, centered, orientation)

	var/list/bounds = SSmapping.load_map(file(mappath), T.x, T.y, T.z, cropMap = TRUE, orientation = orientation, delayed_loading = TRUE)
	if(!bounds)
		return

//	if(!SSmapping.loading_ruins) //Will be done manually during mapping ss init
//		repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	if(!post_init)
		initTemplateBounds(bounds)

	log_game("[name] loaded at at [T.x],[T.y],[T.z]")
	loaded++
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE, orientation = SOUTH)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(((orientation & NORTH|SOUTH) ? width : height)/2), placement.y - round(((orientation & NORTH|SOUTH) ? height : width)/2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x+((orientation & NORTH|SOUTH) ? width : height)-1, placement.y+((orientation & NORTH|SOUTH) ? height : width)-1, placement.z))

/datum/map_template/proc/annihilate_bounds(turf/origin, centered = FALSE, orientation = SOUTH)
	//var/deleted_atoms = 0
	//admin_notice("<span class='danger'>Annihilating objects in submap loading locatation.</span>", R_DEBUG)
	var/list/turfs_to_clean = get_affected_turfs(origin, centered, orientation)
	if(turfs_to_clean.len)
		for(var/turf/T in turfs_to_clean)
			for(var/atom/movable/AM in T)
			//	++deleted_atoms
				qdel(AM)
	//admin_notice("<span class='danger'>Annihilated [deleted_atoms] objects.</span>", R_DEBUG)
