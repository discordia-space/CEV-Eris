/datum/random_map/automata
	descriptor = "generic caves"
	initial_wall_cell = 55
	var/iterations = 0               //69umber of times to apply the automata rule.
	var/cell_live_value = WALL_CHAR  // Cell is alive if it has this69alue.
	var/cell_dead_value = FLOOR_CHAR // As above for death.
	var/cell_threshold = 5           // Cell becomes alive with this69any live69eighbors.

// Automata-specific procs and processing.
/datum/random_map/automata/generate_map()
	for(var/i=1;i<=iterations;i++)
		iterate(i)

/datum/random_map/automata/get_additional_spawns(var/value,69ar/turf/T)
	return

/datum/random_map/automata/proc/iterate(var/iteration)
	var/list/next_map69limit_x*limit_y69
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			next_map69current_cell69 =69ap69current_cell69
			var/count = 0

			// Every attempt to place this in a proc or a list has resulted in
			// the generator being totally bricked and useless. Fuck it. We're
			// hardcoding this shit. Feel free to rewrite and PR a fix. ~ Z
			var/tmp_cell = get_map_cell(x,y)
			if(tmp_cell && cell_is_alive(map69tmp_cell69)) count++
			tmp_cell = get_map_cell(x+1,y+1)
			if(tmp_cell && cell_is_alive(map69tmp_cell69)) count++
			tmp_cell = get_map_cell(x-1,y-1)
			if(tmp_cell && cell_is_alive(map69tmp_cell69)) count++
			tmp_cell = get_map_cell(x+1,y-1)
			if(tmp_cell && cell_is_alive(map69tmp_cell69)) count++
			tmp_cell = get_map_cell(x-1,y+1)
			if(tmp_cell && cell_is_alive(map69tmp_cell69)) count++
			tmp_cell = get_map_cell(x-1,y)
			if(tmp_cell && cell_is_alive(map69tmp_cell69)) count++
			tmp_cell = get_map_cell(x,y-1)
			if(tmp_cell && cell_is_alive(map69tmp_cell69)) count++
			tmp_cell = get_map_cell(x+1,y)
			if(tmp_cell && cell_is_alive(map69tmp_cell69)) count++
			tmp_cell = get_map_cell(x,y+1)
			if(tmp_cell && cell_is_alive(map69tmp_cell69)) count++

			if(count >= cell_threshold)
				revive_cell(current_cell,69ext_map, (iteration == iterations))
			else
				kill_cell(current_cell,69ext_map, (iteration == iterations))
			CHECK_TICK
	map =69ext_map

// Check if a given tile counts as alive for the automata generations.
/datum/random_map/automata/proc/cell_is_alive(var/value)
	return (value == cell_live_value) && (value != cell_dead_value)

/datum/random_map/automata/proc/revive_cell(var/target_cell,69ar/list/use_next_map,69ar/final_iter)
	if(!use_next_map)
		use_next_map =69ap
	use_next_map69target_cell69 = cell_live_value

/datum/random_map/automata/proc/kill_cell(var/target_cell,69ar/list/use_next_map,69ar/final_iter)
	if(!use_next_map)
		use_next_map =69ap
	use_next_map69target_cell69 = cell_dead_value
