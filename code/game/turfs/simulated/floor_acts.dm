//EX act uses new damage type blast, which allows it to get burn AND damage overlays simultaneously
/turf/simulated/floor/ex_act(severity)
	//set src in oview(1)
	var/obj/effect/shield/turf_shield = getEffectShield()

	if (turf_shield)
		var/temp = turf_shield.ignoreExAct
		turf_shield.ignoreExAct = FALSE
		turf_shield.ex_act(severity)
		turf_shield.ignoreExAct = temp

		if (!turf_shield.isInactive())
			return
		else
			severity++

	switch(severity)
		if(1.0)
			take_damage(rand(300, 600), BLAST) //Breaks through 3 - 4 layers
		if(2.0)
			take_damage(rand(115, 430), BLAST) //Breaks through 2 - 3 layers
		if(3.0)
			take_damage(rand(20, 120), BLAST) //Breaks 1-2 layers


/turf/simulated/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)

	var/temp_destroy = get_damage_temperature()
	if(!burnt && prob(5))
		burn_tile(exposed_temperature)
	else if(temp_destroy && exposed_temperature >= (temp_destroy + 100) && prob(1) && !is_plating())
		make_plating() //destroy the tile, exposing plating
		burn_tile(exposed_temperature)


//should be a little bit lower than the temperature required to destroy the material
/turf/simulated/floor/proc/get_damage_temperature()
	return flooring ? flooring.damage_temperature : null

/turf/simulated/floor/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)
