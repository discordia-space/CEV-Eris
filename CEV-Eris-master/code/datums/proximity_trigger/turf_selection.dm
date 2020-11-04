/decl/turf_selection/proc/get_turfs(var/atom/origin, var/range)
	return list()

/decl/turf_selection/square/get_turfs(var/atom/origin, var/range)
	. = list()
	var/turf/center = get_turf(origin)
	if(!center)
		return
	for(var/turf/T in trange(range, center))
		. += T
