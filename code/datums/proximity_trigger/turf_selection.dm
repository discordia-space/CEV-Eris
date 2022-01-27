/decl/turf_selection/proc/get_turfs(var/atom/origin,69ar/range)
	return list()

/decl/turf_selection/square/get_turfs(var/atom/origin,69ar/range)
	. = list()
	var/turf/center = get_turf(origin)
	if(!center)
		return
	for(var/turf/T in RANGE_TURFS(range, center))
		. += T
