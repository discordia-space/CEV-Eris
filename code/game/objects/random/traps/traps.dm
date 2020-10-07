/obj/spawner/traps
	name = "random trap"
	icon_state = "trap-red"
	alpha = 128
	tags_to_spawn = list(SPAWN_TRAP_ARMED)
	biome_type = /obj/landmark/loot_biomes/trap
	check_density = FALSE

/obj/spawner/traps/valid_candidates()
	var/list/possible_traps = ..()
	//Check that its possible to spawn the chosen trap at this location
	for(var/trap in possible_traps)
		if(biome_spawner && biome && biome.use_loc)
			if(find_smart_point(trap))
				continue
		else if(can_spawn_trap(loc, trap))
			continue
		possible_traps -= trap
	return possible_traps

/obj/spawner/traps/low_chance
	icon_state = "trap-red-low"
	spawn_nothing_percentage = 75

/obj/spawner/traps/wire_splicing
	name = "wire splicing"
	icon_state = "trap-orange"
	alpha = 128
	tags_to_spawn = list(SPAWN_WIRE_TRAP)

/obj/spawner/traps/wire_splicing/low_chance
	name = "low chance wire splicing"
	icon_state = "trap-orange-low"
	spawn_nothing_percentage = 70

//Checks if a trap can spawn in this location
/proc/can_spawn_trap(turf/T, trap)
	.=TRUE
	if(ispath(trap, /obj/structure/wire_splicing))
		if(locate(/obj/structure/cable) in dview(3, T))
			return TRUE
	if(locate(trap) in T)
		return FALSE
	if(T.is_wall || (T.is_hole && !T.is_solid_structure()) || T.density)
		return FALSE

/obj/spawner/traps/find_smart_point(path)
	.=..()
	if(!.)
		return FALSE
	var/list/spawn_points = .
	var/list/trap_points = list()
	for(var/turf/T in spawn_points)
		if(can_spawn_trap(T, path))
			trap_points += T
	return trap_points
