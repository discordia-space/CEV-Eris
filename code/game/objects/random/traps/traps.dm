/obj/spawner/traps
	name = "random trap"
	icon_state = "trap-red"
	alpha = 128
	tags_to_spawn = list(SPAWN_TRAP_ARMED)
	biome_type = /obj/landmark/loot_biomes/trap

/obj/spawner/traps/valid_candidates()
	var/list/possible_traps = ..()
	//Check that its possible to spawn the chosen trap at this location
	for(var/trap in possible_traps)
		if(biome_spawner && biome && biome.use_loc)
			if(can_spawn_trap_in_range(get_turf(biome), trap, biome.range))
				continue
		else if(can_spawn_trap(loc, trap))
			continue
		possible_traps -= trap
	return possible_traps

/obj/spawner/traps/biome_spawner_trap
	name = "biome trap spawner"
	biome_spawner = TRUE
	latejoin = TRUE

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
	if(ispath(trap, /obj/item/weapon/beartrap))
		if(locate(/obj/structure/multiz/ladder) in T)
			return FALSE
	else if(ispath(trap, /obj/structure/wire_splicing))
		if(locate(/obj/structure/cable) in dview(3, T))
			return TRUE
		return FALSE

/proc/can_spawn_trap_in_range(turf/T, trap, nrange)
	. = FALSE
	var/list/points = list()
	if(T.is_wall && T.is_hole)
		return FALSE
	for(var/turf/target in trange(nrange, T))
		if(can_spawn_trap(target, trap))
			points += target
	if(points.len)
		return points

/obj/spawner/traps/find_smart_point(trap)
	if(!biome || !biome.use_loc)
		return FALSE
	return can_spawn_trap_in_range(get_turf(biome), trap, biome.range)
