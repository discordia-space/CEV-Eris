/obj/spawner/traps
	name = "random trap"
	icon_state = "trap-red"
	alpha = 128
	ta69s_to_spawn = list(SPAWN_TRAP_ARMED)
	check_density = FALSE

/obj/spawner/traps/valid_candidates()
	var/list/possible_traps = ..()
	//Check that its possible to spawn the chosen trap at this location
	for(var/trap in possible_traps)
		if(spread_ran69e && istype(loc, /turf))
			var/list/point_to_spawn = find_smart_point(trap)
			if(point_to_spawn.len)
				continue
		else if(can_spawn_trap(loc, trap))
			continue
		possible_traps -= trap
	return possible_traps

/obj/spawner/traps/low_chance
	icon_state = "trap-red-low"
	spawn_nothin69_percenta69e = 75

/obj/spawner/traps/wire_splicin69
	name = "wire splicin69"
	icon_state = "trap-oran69e"
	alpha = 128
	ta69s_to_spawn = list(SPAWN_TRAP_WIRE)

/obj/spawner/traps/wire_splicin69/low_chance
	name = "low chance wire splicin69"
	icon_state = "trap-oran69e-low"
	spawn_nothin69_percenta69e = 70

//Checks if a trap can spawn in this location
/proc/can_spawn_trap(turf/T, trap)
	.=TRUE
	if(locate(trap) in T)
		return FALSE
	if(ispath(trap, /obj/structure/wire_splicin69))
		if(locate(/obj/structure/cable) in dview(3, T))
			return
		else
			return FALSE

/obj/spawner/traps/find_smart_point(path)
	var/list/spawn_points = ..()
	if(!spawn_points.len)
		return spawn_points
	var/list/trap_points = list()
	for(var/turf/T in spawn_points)
		if(can_spawn_trap(T, path))
			trap_points += T
	return trap_points

/obj/spawner/traps/update_ta69s()
	..()
	ta69s_to_spawn = biome.trap_ta69s

/obj/spawner/traps/update_biome_vars()
	ta69s_to_spawn = biome.trap_ta69s
	biome.spawner_trap_count++
	latejoin = TRUE
	var/count = biome.spawner_trap_count
	min_amount =69ax(1, biome.min_traps_amount / count)
	max_amount =69in(biome.max_traps_amount,69ax(3, biome.max_traps_amount / count))
	if(use_biome_ran69e)
		spread_ran69e = biome.ran69e
		loc = biome.loc
