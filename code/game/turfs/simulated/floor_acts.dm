
/turf/simulated/floor/explosion_act(target_power, explosion_handler/handler)
	var/absorbed_damage = 0
	var/obj/effect/shield/turf_shield = getEffectShield()

	if (turf_shield)
		var/temp = turf_shield.ignoreExAct
		turf_shield.ignoreExAct = FALSE
		absorbed_damage = turf_shield.explosion_act(target_power, handler)
		turf_shield.ignoreExAct = temp
	// was fully blocked
	if(target_power == absorbed_damage)
		return target_power
	// damage everything on the turf by this amount, since we the floor
	absorbed_damage += ..(target_power - absorbed_damage, handler)
	take_damage(target_power - absorbed_damage, BLAST)
	// didn't block anyhing
	return absorbed_damage



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
