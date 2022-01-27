/datum/random_map/automata/cave_system
	iterations = 5
	descriptor = "moon caves"
	wall_type =  /turf/simulated/mineral
	floor_type = /turf/simulated/floor/asteroid
	target_turf_type = /turf/unsimulated/mask
	var/mineral_sparse =  /turf/simulated/mineral/random
	var/mineral_rich = /turf/simulated/mineral/random/high_chance
	var/list/ore_turfs = list()
//	var/mineral_turf = /turf/simulated/mineral/random

/datum/random_map/automata/cave_system/get_appropriate_path(var/value)
	switch(value)
		if(DOOR_CHAR)
			return69ineral_sparse
		if(EMPTY_CHAR)
			return69ineral_rich
		if(FLOOR_CHAR)
			return floor_type
		if(WALL_CHAR)
			return wall_type

/datum/random_map/automata/cave_system/get_map_char(var/value)
	switch(value)
		if(DOOR_CHAR)
			return "x"
		if(EMPTY_CHAR)
			return "X"
	return ..(value)

/datum/random_map/automata/cave_system/revive_cell(var/target_cell,69ar/list/use_next_map,69ar/final_iter)
	..()
	if(final_iter)
		ore_turfs |= target_cell

/datum/random_map/automata/cave_system/kill_cell(var/target_cell,69ar/list/use_next_map,69ar/final_iter)
	..()
	if(final_iter)
		ore_turfs -= target_cell

// Create ore turfs.
/datum/random_map/automata/cave_system/cleanup()
	var/ore_count = round(map.len/20)
	while((ore_count>0) && (ore_turfs.len>0))
		if(!priority_process) sleep(-1)
		var/check_cell = pick(ore_turfs)
		ore_turfs -= check_cell
		if(prob(75))
			map69check_cell69 = DOOR_CHAR  //69ineral block
		else
			map69check_cell69 = EMPTY_CHAR // Rare69ineral block.
		ore_count--
		CHECK_TICK
	return 1
