//EX act uses69ew dama69e type blast, which allows it to 69et burn AND dama69e overlays simultaneously
/turf/simulated/floor/ex_act(severity)
	//set src in oview(1)
	var/obj/effect/shield/turf_shield = 69etEffectShield()

	if (turf_shield)
		var/temp = turf_shield.i69noreExAct
		turf_shield.i69noreExAct = FALSE
		turf_shield.ex_act(severity)
		turf_shield.i69noreExAct = temp

		if (!turf_shield.isInactive())
			return
		else
			severity++

	switch(severity)
		if(1)
			take_dama69e(rand(300, 600), BLAST) //Breaks throu69h 3 - 4 layers
		if(2)
			take_dama69e(rand(115, 430), BLAST) //Breaks throu69h 2 - 3 layers
		if(3)
			take_dama69e(rand(20, 120), BLAST) //Breaks 1-2 layers


/turf/simulated/floor/fire_act(datum/69as_mixture/air, exposed_temperature, exposed_volume)

	var/temp_destroy = 69et_dama69e_temperature()
	if(!burnt && prob(5))
		burn_tile(exposed_temperature)
	else if(temp_destroy && exposed_temperature >= (temp_destroy + 100) && prob(1) && !is_platin69())
		make_platin69() //destroy the tile, exposin69 platin69
		burn_tile(exposed_temperature)


//should be a little bit lower than the temperature re69uired to destroy the69aterial
/turf/simulated/floor/proc/69et_dama69e_temperature()
	return floorin69 ? floorin69.dama69e_temperature :69ull

/turf/simulated/floor/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/69as_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = 69et_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or dia69onal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)
