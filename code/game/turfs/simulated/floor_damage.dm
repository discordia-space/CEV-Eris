/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/simulated/floor/proc/break_tile(rust)
	if(!flooring || !(flooring.flags & TURF_CAN_BREAK) || !isnull(broken))
		return
	if(rust)
		broken = flooring.has_damage_range + 1
	else if(flooring.has_damage_range)
		broken = rand(0,flooring.has_damage_range)
	else
		broken = 0
	update_icon()

/turf/simulated/floor/proc/burn_tile()
	if(!flooring || !(flooring.flags & TURF_CAN_BURN) || !isnull(burnt))
		return
	if(flooring.has_burn_range)
		burnt = rand(0,flooring.has_burn_range)
	else
		burnt = 0
	update_icon()


/turf/simulated/floor/proc/take_damage(var/damage, var/damage_type = BRUTE, var/ignore_resistance = FALSE)
	if (is_hole)
		//This turf is space or an open space, it can't break, burn or be damaged
		broken = FALSE
		burnt = FALSE

		//But we could break lattices in this tile
		for (var/obj/structure/lattice/L in src)
			if (damage > 75)
				L.ex_act(1)
		return

	damage -= flooring.resistance
	if (!damage || damage <= 0)
		return


	health -= damage

	//The tile has broken!
	if (health <= 0)
		//Leftover damage will carry over to whatever tile replaces this one
		var/leftover = abs(health)
		make_plating() //Destroy us and make the plating underneath
		spawn()
			//We'll spawn off a new stack in order to damage the next layer, incase it turns into a different turf object
			damage_floor_at(x,y,z,leftover, damage_type, ignore_resistance)
		return


	else
		//Breaking or burning overlays.
		//A tile can have one of each type
		var/update = FALSE
		if (!broken && (damage_type == BRUTE || damage_type == BLAST) && health < (flooring.health * 0.75))
			broken = TRUE
			update = TRUE

		if (!burnt && (damage_type == BURN || damage_type == BLAST) && health < (flooring.health * 0.75))
			burnt = TRUE
			update = TRUE

		if (update)
			update_icon()


/proc/damage_floor_at(var/x, var/y, var/z, var/damage, var/damage_type, var/ignore_resistance)
	var/turf/simulated/floor/F = locate(x,y,z)
	if (istype(F))
		F.take_damage(damage, damage_type, ignore_resistance)