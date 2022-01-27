/datum/random_map/noise/ore
	descriptor = "ore distribution69ap"
	var/deep_val = 0.8              // Threshold for deep69etals, set in69ew as percentage of cell_range.
	var/rare_val = 0.7              // Threshold for rare69etal, set in69ew as percentage of cell_range.
	var/chunk_size = 4              // Size each cell represents on69ap

/datum/random_map/noise/ore/New()
	rare_val = cell_range * rare_val
	deep_val = cell_range * deep_val
	..()

/datum/random_map/noise/ore/check_map_sanity()

	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	// Increment69ap sanity counters.
	for(var/value in69ap)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++
	// Sanity check.
	if(surface_count <69IN_SURFACE_COUNT)
		admin_notice(SPAN_DANGER("Insufficient surface69inerals. Rerolling..."), R_DEBUG)
		return 0
	else if(rare_count <69IN_RARE_COUNT)
		admin_notice(SPAN_DANGER("Insufficient rare69inerals. Rerolling..."), R_DEBUG)
		return 0
	else if(deep_count <69IN_DEEP_COUNT)
		admin_notice(SPAN_DANGER("Insufficient deep69inerals. Rerolling..."), R_DEBUG)
		return 0
	else
		return 1

/datum/random_map/noise/ore/apply_to_turf(var/x,var/y)

	var/tx = ((origin_x-1)+x)*chunk_size
	var/ty = ((origin_y-1)+y)*chunk_size

	for(var/i=0,i<chunk_size,i++)
		for(var/j=0,j<chunk_size,j++)
			var/turf/simulated/T = locate(tx+j, ty+i, origin_z)
			if(!istype(T) || !T.has_resources)
				continue
			if(!priority_process) sleep(-1)
			T.resources = list()
			T.resources69MATERIAL_GLASS69 = rand(7,12)
			T.resources69MATERIAL_PLASTIC69 = rand(7,12)

			T.seismic_activity = rand(SEISMIC_MIN, SEISMIC_MAX)

			var/current_cell =69ap69get_map_cell(x,y)69
			if(current_cell < rare_val)      // Surface69etals.
				T.resources69MATERIAL_IRON69 =     rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources69MATERIAL_GOLD69 =     rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources69MATERIAL_SILVER69 =   rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources69MATERIAL_URANIUM69 =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources69MATERIAL_DIAMOND69 =  0
				T.resources69MATERIAL_PLASMA69 =   0
				T.resources69MATERIAL_OSMIUM69 =   0
				T.resources69MATERIAL_TRITIUM69 =  0
			else if(current_cell < deep_val) // Rare69etals.
				T.resources69MATERIAL_GOLD69 =     rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources69MATERIAL_SILVER69 =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources69MATERIAL_URANIUM69 =  rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources69MATERIAL_PLASMA69 =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources69MATERIAL_OSMIUM69 =   rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources69MATERIAL_TRITIUM69 =  0
				T.resources69MATERIAL_DIAMOND69 =  0
				T.resources69MATERIAL_IRON69 =     0
			else                             // Deep69etals.
				T.resources69MATERIAL_URANIUM69 =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources69MATERIAL_DIAMOND69 =  rand(RESOURCE_LOW_MIN,  RESOURCE_LOW_MAX)
				T.resources69MATERIAL_PLASMA69 =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources69MATERIAL_OSMIUM69 =   rand(RESOURCE_HIGH_MIN, RESOURCE_HIGH_MAX)
				T.resources69MATERIAL_TRITIUM69 =  rand(RESOURCE_MID_MIN,  RESOURCE_MID_MAX)
				T.resources69MATERIAL_IRON69 =     0
				T.resources69MATERIAL_GOLD69 =     0
				T.resources69MATERIAL_SILVER69 =   0
			CHECK_TICK
	return

/datum/random_map/noise/ore/get_map_char(var/value)
	if(value < rare_val)
		return "S"
	else if(value < deep_val)
		return "R"
	else
		return "D"

/datum/random_map/noise/ore/filthy_rich
	deep_val = 0.6
	rare_val = 0.4

/datum/random_map/noise/ore/rich
	deep_val = 0.7
	rare_val = 0.5

/datum/random_map/noise/ore/poor
	deep_val = 0.8
	rare_val = 0.7
	chunk_size = 3
