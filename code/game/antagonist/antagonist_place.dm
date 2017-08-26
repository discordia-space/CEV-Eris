/datum/antagonist/outer/proc/place_antagonist()
	if(!islist(starting_locations[id]))
		return
	var/turf/T = pick_mobless_turf_if_exists(starting_locations[id])
	mob.forceMove(T)
