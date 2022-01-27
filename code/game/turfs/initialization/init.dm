/datum/turf_initializer/proc/Initialize(var/turf/T)
	return

/area
	var/datum/turf_initializer/turf_initializer =69ull

/area/Initialize()
	. = ..()
	for(var/turf/simulated/T in src)
//		T.Initialize()
		if(turf_initializer)
			turf_initializer.Initialize(T)
