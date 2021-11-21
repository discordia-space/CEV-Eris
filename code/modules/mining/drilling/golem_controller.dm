#define RANDOM_WALK 10

/datum/golem_controller

	var/turf/loc  // Location of the golem_controller
	var/list/obj/structure/golem_burrow/burrows = list()  // List of golem burrows tied to the controller
	var/list/mob/living/simple_animal/hostile/hivebot/range/golems = list()  // List of golems tied to the controller
	var/processing = TRUE
	
	// Wave related variables
	var/datum/golem_wave/GW  // Golem wave datum
	var/count = 0  // Number of burrows created since the start
	var/time_burrow = 0  // Timestamp of last created burrow
	var/time_spawn = 0  // Timestamp of last spawn wave

/datum/golem_controller/New(var/turf/location, var/seismic)
	testing("Creating controller with [seismic] - ([location.x], [location.y], [location.z]")
	loc = location
	var/path = GLOB.golem_waves[seismic]  // Retrieve which kind of wave it is depending on seismic activity
	GW = new path()

	START_PROCESSING(SSobj, src)

/datum/golem_controller/Destroy()
	testing("Destroying controller")
	processing = FALSE  // Stop processing
	qdel(GW)  // Destroy wave object
	GW = null
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
		testing("Spawning burrow")
		spawn_golem_burrow()

	// Check if a new spawn wave should occur
	if((world.time - time_spawn) > GW.spawn_interval)
		time_spawn = world.time
		testing("Spawning golems")
		spawn_golems()


/datum/golem_controller/proc/spawn_golem_burrow()
	// Random walk starting from drill location without crossing any dense turf
	// That way we are sure there will always be a path to the drill
	var/turf/T = loc
	var/turf/next_T = loc
	for(var/i in 1 to RANDOM_WALK)
		next_T = get_step(T, pick(GLOB.cardinal))
		if(next_T != loc && !next_T.contains_dense_objects(TRUE))
			T = next_T

	testing("Spawning burrow on [T] at [T.x] [T.y] [T.z]")
	burrows += new /obj/structure/golem_burrow(T)  // Spawn burrow at final location

/datum/golem_controller/proc/spawn_golems()
	// Spawn golems at all burrows
	for(var/obj/structure/golem_burrow/GB in burrows)
		for(var/i in 1 to GW.golem_spawn)
			golems += new /mob/living/simple_animal/hostile/hivebot/range(GB.loc)  // Spawn golem at that burrow

/datum/golem_controller/proc/stop()
	// Disable wave
	processing = FALSE

	// Delete controller
	qdel(src)

#undef RANDOM_WALK
