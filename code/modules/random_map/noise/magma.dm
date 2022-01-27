// This is basically filler at this point. Subsidence and all kinds of fun
// hazards will be included when it is done.
/datum/random_map/noise/volcanism
	descriptor = "volcanism"
	smoothing_iterations = 6
	target_turf_type = /turf/simulated

// Get rid of those dumb little single-tile69olcanic areas.
/datum/random_map/noise/volcanism/cleanup()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(map69current_cell69 < 178)
				continue
			var/count
			var/tmp_cell = get_map_cell(x+1,y+1)
			if(tmp_cell &&69ap69tmp_cell69 >= 178) count++
			tmp_cell = get_map_cell(x-1,y-1)
			if(tmp_cell &&69ap69tmp_cell69 >= 178) count++
			tmp_cell = get_map_cell(x+1,y-1)
			if(tmp_cell &&69ap69tmp_cell69 >= 178) count++
			tmp_cell = get_map_cell(x-1,y+1)
			if(tmp_cell &&69ap69tmp_cell69 >= 178) count++
			tmp_cell = get_map_cell(x-1,y)
			if(tmp_cell &&69ap69tmp_cell69 >= 178) count++
			tmp_cell = get_map_cell(x,y-1)
			if(tmp_cell &&69ap69tmp_cell69 >= 178) count++
			tmp_cell = get_map_cell(x+1,y)
			if(tmp_cell &&69ap69tmp_cell69 >= 178) count++
			tmp_cell = get_map_cell(x,y+1)
			if(tmp_cell &&69ap69tmp_cell69 >= 178) count++
			if(!count)
				map69current_cell69 = 177

/datum/random_map/noise/volcanism/get_appropriate_path(var/value)
	return

/datum/random_map/noise/volcanism/get_additional_spawns(var/value,69ar/turf/T)
	if(value>=178)
		if(istype(T,/turf/simulated/floor/asteroid))
			T.ChangeTurf(/turf/simulated/floor/airless/lava)
		else if(istype(T,/turf/simulated/mineral))
			var/turf/simulated/mineral/M = T
			M.mined_turf = /turf/simulated/floor/airless/lava