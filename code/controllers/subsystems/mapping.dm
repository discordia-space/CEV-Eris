SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

/datum/controller/subsystem/mapping/Initialize(start_timeofday)

	if(config.generate_asteroid)
		// These values determine the specific area that the map is applied to.
		// Because we do not use Bay's default map, we check the config file to see if custom parameters are needed, so we need to avoid hardcoding.
		if(maps_data.asteroid_leves)
			for(var/z_level in maps_data.asteroid_leves)
				if(!isnum(z_level))
					// If it's still not a number, we probably got fed some nonsense string.
					admin_notice("<span class='danger'>Error: ASTEROID_Z_LEVELS config wasn't given a number.</span>")
				// Now for the actual map generating.  This occurs for every z-level defined in the config.
				new /datum/random_map/automata/cave_system(null, 1, 1, z_level, 300, 300)
				// Let's add ore too.
				new /datum/random_map/noise/ore(null, 1, 1, z_level, 64, 64)
		else
			admin_notice("<span class='danger'>Error: No asteroid z-levels defined in config!</span>")

	if(config.use_overmap)
		if(!maps_data.overmap_z)
			build_overmap()
		else
			testing("Overmap already exist in maps_data for [maps_data.overmap_z].")
	else
		testing("Overmap generation disabled in config.")

	return ..()

/datum/controller/subsystem/mapping/proc/build_overmap()
	testing("Building overmap...")
	world.maxz++
	maps_data.overmap_z = world.maxz
	var/list/turfs = list()
	for (var/square in block(locate(1,1,maps_data.overmap_z), locate(maps_data.overmap_size, maps_data.overmap_size, maps_data.overmap_z)))
		var/turf/T = square
		if(T.x == maps_data.overmap_size || T.y == maps_data.overmap_size)
			T = T.ChangeTurf(/turf/unsimulated/map/edge)
		else
			T = T.ChangeTurf(/turf/unsimulated/map/)
		turfs += T
		CHECK_TICK

	var/area/overmap/A = new
	A.contents.Add(turfs)

	maps_data.sealed_levels |= maps_data.overmap_z
	overmap_event_handler.create_events(maps_data.overmap_z, maps_data.overmap_size, maps_data.overmap_event_areas)
	testing("Overmap build complete.")

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
