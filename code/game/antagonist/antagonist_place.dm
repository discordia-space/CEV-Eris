/datum/antagonist/proc/get_starting_locations()
	if(landmark_id)
		starting_locations = list()
		for(var/obj/effect/landmark/L in landmarks_list)
			if(L.name == landmark_id)
				starting_locations |= get_turf(L)

/datum/antagonist/proc/place_mob(var/mob/living/mob)
	if(!starting_locations || !starting_locations.len)
		return
	var/turf/T = pick_mobless_turf_if_exists(starting_locations)
	mob.forceMove(T)
