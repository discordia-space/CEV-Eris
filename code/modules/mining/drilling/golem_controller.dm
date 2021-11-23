/datum/golem_controller

	var/turf/loc  // Location of the golem_controller
	var/list/obj/structure/golem_burrow/burrows = list()  // List of golem burrows tied to the controller
	var/processing = TRUE
	var/obj/machinery/mining/deep_drill/DD
	
	// Wave related variables
	var/datum/golem_wave/GW  // Golem wave datum
	var/count = 0  // Number of burrows created since the start
	var/time_burrow = 0  // Timestamp of last created burrow
	var/time_spawn = 0  // Timestamp of last spawn wave

/datum/golem_controller/New(var/turf/location, var/seismic, var/drill)
	loc = location
	var/path = GLOB.golem_waves[seismic]  // Retrieve which kind of wave it is depending on seismic activity
	GW = new path()
	if(drill)
		DD = drill

	START_PROCESSING(SSobj, src)

/datum/golem_controller/Destroy()
	processing = FALSE  // Stop processing
	qdel(GW)  // Destroy wave object
	GW = null
	DD = null
	for(var/obj/structure/golem_burrow/GB in burrows)  // Unlink burrows and controller
		GB.stop()
	. = ..()

/datum/golem_controller/Process()
	// Currently, STOP_PROCESSING does NOT instantly remove the object from processing queue
	// This is a quick and dirty fix for runtime error spam caused by this
	if(!processing)
		return

	// Check if a new burrow should be created
	if(count < GW.burrow_count && (world.time - time_burrow) > GW.burrow_interval)
		time_burrow = world.time
		count++
		spawn_golem_burrow()

	// Check if a new spawn wave should occur
	if((world.time - time_spawn) > GW.spawn_interval)
		time_spawn = world.time
		spawn_golems()

/datum/golem_controller/proc/spawn_golem_burrow()
	// Spawn burrow randomly in a donut around the drill
	var/turf/T = pick(circlerangeturfs(loc, 7))
	//while(T.contains_dense_objects(TRUE) && T != loc)
	while(T != loc)
		T = get_step(T, get_dir(T, DD))
	// If we end up on top of the drill, just spawn next to it
	if(T == loc)
		T = get_step(loc, pick(cardinal))

	burrows += new /obj/structure/golem_burrow(T)  // Spawn burrow at final location

/datum/golem_controller/proc/spawn_golems()
	// Spawn golems at all burrows
	for(var/obj/structure/golem_burrow/GB in burrows)
		var/list/possible_directions = cardinal.Copy()
		var/i = 0
		// Spawn golems around the burrow on free turfs
		while(i < GW.golem_spawn && possible_directions.len)
			var/turf/possible_T = get_step(GB.loc, pick_n_take(possible_directions))
			if(!possible_T.contains_dense_objects(TRUE))
				i++
				new /mob/living/carbon/superior_animal/golem/iron(possible_T, drill=DD)  // Spawn golem at free location
		// Spawn remaining golems on top of burrow
		if(i < GW.golem_spawn)
			for(var/j in i to GW.golem_spawn)
				new /mob/living/carbon/superior_animal/golem/iron(GB.loc, drill=DD)  // Spawn golem at that burrow

/datum/golem_controller/proc/stop()
	// Disable wave
	processing = FALSE

	// Delete controller
	qdel(src)
