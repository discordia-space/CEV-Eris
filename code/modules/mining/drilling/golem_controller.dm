#define RANDOM_WALK 10

/datum/golem_controller

	var/turf/loc  // Location of the golem_controller
	var/list/obj/structure/golem_burrow/burrows = list()  // List of golem burrows tied to the controller
	var/list/mob/living/carbon/superior_animal/roach/golems = list()  // List of golems tied to the controller
	var/processing = TRUE

/datum/golem_controller/New(var/turf/location, var/richness, var/seismic)
	testing("Creating controller with [richness] - [seismic] - ([location.x], [location.y], [location.z]")
	loc = location
	if(seismic)
		for(var/i in 1 to seismic)
			spawn_golem_burrow()

	START_PROCESSING(SSobj, src)

/datum/golem_controller/Destroy()
	testing("Destroying controller")
	processing = FALSE  // Stop processing
	for(var/obj/structure/golem_burrow/GB in burrows)  // Unlink burrows and controller
		GB.controller = null
	. = ..()

/datum/golem_controller/Process()
	// Currently, STOP_PROCESSING does NOT instantly remove the object from processing queue
	// This is a quick and dirty fix for runtime error spam caused by this
	testing("Processing")
	if(!processing)
		return

	if(!burrows.len)
		qdel(src)

	if(prob(20))
		testing("Spawning golem")
		spawn_golem()

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

/datum/golem_controller/proc/spawn_golem()

	var/obj/structure/golem_burrow/GB = pick(burrows)  // Pick a burrow in the pool
	golems += new /mob/living/carbon/superior_animal/roach(GB.loc)  // Spawn golem at that burrow

#undef RANDOM_WALK
