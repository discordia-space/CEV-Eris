/datum/golem_controller

	var/turf/loc  // Location of the golem_controller
	var/list/obj/structure/golem_burrow/burrows = list()  // List of golem burrows tied to the controller
	var/processing = TRUE
	var/obj/machinery/mining/deep_drill/DD
	
	// Wave related69ariables
	var/datum/golem_wave/GW  // Golem wave datum
	var/count = 0  //69umber of burrows created since the start
	var/time_burrow = 0  // Timestamp of last created burrow
	var/time_spawn = 0  // Timestamp of last spawn wave

/datum/golem_controller/New(turf/location, seismic, drill)
	loc = location
	var/path = GLOB.golem_waves69seismic69  // Retrieve which kind of wave it is depending on seismic activity
	GW =69ew path()
	if(drill)
		DD = drill

	START_PROCESSING(SSobj, src)

/datum/golem_controller/Destroy()
	processing = FALSE  // Stop processing
	qdel(GW)  // Destroy wave object
	GW =69ull
	DD =69ull
	for(var/obj/structure/golem_burrow/GB in burrows)  // Unlink burrows and controller
		GB.stop()
	..()

/datum/golem_controller/Process()
	// Currently, STOP_PROCESSING does69OT instantly remove the object from processing queue
	// This is a quick and dirty fix for runtime error spam caused by this
	if(!processing)
		return

	// Check if a69ew burrow should be created
	if(count < GW.burrow_count && (world.time - time_burrow) > GW.burrow_interval)
		time_burrow = world.time
		count++
		spawn_golem_burrow()

	// Check if a69ew spawn wave should occur
	if((world.time - time_spawn) > GW.spawn_interval)
		time_spawn = world.time
		spawn_golems()

/datum/golem_controller/proc/spawn_golem_burrow()
	// Spawn burrow randomly in a donut around the drill
	var/turf/T = pick(getcircle(loc, 7))
	while(loc && check_density_no_mobs(T) && T != loc)
		T = get_step(T, get_dir(T, loc))
	// If we end up on top of the drill, just spawn69ext to it
	if(T == loc)
		T = get_step(loc, pick(cardinal))

	burrows +=69ew /obj/structure/golem_burrow(T)  // Spawn burrow at final location

/datum/golem_controller/proc/spawn_golems()
	// Spawn golems at all burrows
	for(var/obj/structure/golem_burrow/GB in burrows)
		var/list/possible_directions = cardinal.Copy()
		var/i = 0
		// Spawn golems around the burrow on free turfs
		while(i < GW.golem_spawn && possible_directions.len)
			var/turf/possible_T = get_step(GB.loc, pick_n_take(possible_directions))
			if(!check_density_no_mobs(possible_T))
				i++
				var/golemtype = pick(subtypesof(/mob/living/carbon/superior_animal/golem))
				new golemtype(possible_T, drill=DD)  // Spawn golem at free location
		// Spawn remaining golems on top of burrow
		if(i < GW.golem_spawn)
			for(var/j in i to GW.golem_spawn)
				var/golemtype = pick(subtypesof(/mob/living/carbon/superior_animal/golem))
				new golemtype(GB.loc, drill=DD)  // Spawn golem at that burrow

/datum/golem_controller/proc/stop()
	// Disable wave
	processing = FALSE

	// Delete controller
	qdel(src)

/datum/golem_controller/proc/check_density_no_mobs(turf/F)
	if(F.density)
		return TRUE
	for(var/atom/A in F)
		if(A.density && !(A.flags & ON_BORDER) && !ismob(A))
			return TRUE
	return FALSE
