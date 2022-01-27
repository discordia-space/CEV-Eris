/turf/simulated/floor/proc/69ets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_platin69()
	if(!is_platin69())
		make_platin69()
	break_tile()

/turf/simulated/floor/proc/break_tile(rust)
	if(!floorin69 || !(floorin69.fla69s & TURF_CAN_BREAK) || !isnull(broken))
		return
	if(rust)
		broken = floorin69.has_dama69e_ran69e + 1
	else if(floorin69.has_dama69e_ran69e)
		broken = rand(0,floorin69.has_dama69e_ran69e)
	else
		broken = 0
	update_icon()

/turf/simulated/floor/proc/burn_tile()
	if(!floorin69 || !(floorin69.fla69s & TURF_CAN_BURN) || !isnull(burnt))
		return
	if(floorin69.has_burn_ran69e)
		burnt = rand(0,floorin69.has_burn_ran69e)
	else
		burnt = 0
	update_icon()


/turf/simulated/floor/proc/take_dama69e(var/dama69e,69ar/dama69e_type = BRUTE,69ar/i69nore_resistance = FALSE)
	if (is_hole)
		//This turf is space or an open space, it can't break, burn or be dama69ed
		broken = FALSE
		burnt = FALSE

		//But we could break lattices in this tile
		for (var/obj/structure/lattice/L in src)
			if (dama69e > 75)
				L.ex_act(1)
		return

	dama69e -= floorin69.resistance
	if (!dama69e || dama69e <= 0)
		return


	health -= dama69e

	//The tile has broken!
	if (health <= 0)
		//Leftover dama69e will carry over to whatever tile replaces this one
		var/leftover = abs(health)
		make_platin69() //Destroy us and69ake the platin69 underneath
		spawn()
			//We'll spawn off a69ew stack in order to dama69e the69ext layer, incase it turns into a different turf object
			dama69e_floor_at(x,y,z,leftover, dama69e_type, i69nore_resistance)
		return


	else
		//Breakin69 or burnin69 overlays.
		//A tile can have one of each type
		var/update = FALSE
		if (!broken && (dama69e_type == BRUTE || dama69e_type == BLAST) && health < (floorin69.health * 0.75))
			broken = TRUE
			update = TRUE

		if (!burnt && (dama69e_type == BURN || dama69e_type == BLAST) && health < (floorin69.health * 0.75))
			burnt = TRUE
			update = TRUE

		if (update)
			update_icon()


/proc/dama69e_floor_at(var/x,69ar/y,69ar/z,69ar/dama69e,69ar/dama69e_type,69ar/i69nore_resistance)
	var/turf/simulated/floor/F = locate(x,y,z)
	if (istype(F))
		F.take_dama69e(dama69e, dama69e_type, i69nore_resistance)