/obj/spawner/traps
	name = "random trap"
	icon_state = "trap-red"
	alpha = 128
	tags_to_spawn = list(SPAWN_TRAP_ARMED)

/obj/spawner/traps/item_to_spawn()
	.=..()
	var/list/possible_traps = valid_candidates()
	//Check that its possible to spawn the chosen trap at this location
	while (possible_traps.len)
		var/trap = pick_spawn(possible_traps)
		if (can_spawn_trap(loc, trap))
			return trap
		else
			possible_traps -= trap

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
		if (locate(/obj/structure/cable) in dview(3, T))
			return TRUE
		return FALSE
