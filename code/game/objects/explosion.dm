//TODO: Flash range does nothing currently

proc/explosion(turf/epicenter, power, falloff, explosion_flags, adminlog = TRUE)
	if(falloff == 0)
		falloff = power / 10
	var/max_range = round(power / falloff)
	var/far_dist = max_range * 10
	var/frequency = get_rand_frequency()
	new /obj/effect/explosion(epicenter)
	SSexplosions.start_explosion(epicenter, power, falloff, explosion_flags)
	for(var/mob/M in GLOB.player_list)
		// Double check for client
		if(M && M.client)
			var/turf/M_turf = get_turf(M)
			if(M_turf && M_turf.z == epicenter.z)
				var/dist = get_dist(M_turf, epicenter)
				// If inside the blast radius + world.view - 2
				if(dist <= round(max_range + world.view - 2, 1))
					M.playsound_local(epicenter, get_sfx("explosion"), 100, 1, frequency, falloff = 5) // get_sfx() is so that everyone gets the same sound
					//You hear a far explosion if you're outside the blast radius. Small bombs shouldn't be heard all over the station.
				else if(dist <= far_dist)
					var/far_volume = CLAMP(far_dist, 30, 50) // Volume is based on explosion size and dist
					far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
					M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', far_volume, 1, frequency, falloff = 5)
	var/close = range(world.view+round(power/100,1), epicenter)
	// to all distanced mobs play a different sound
	for(var/mob/M in world) if(M.z == epicenter.z) if(!(M in close))
		// check if the mob can hear
		if(M.ear_deaf <= 0 || !M.ear_deaf) if(!istype(M.loc,/turf/space))
			M << 'sound/effects/explosionfar.ogg'
	if(adminlog)
		message_admins("Explosion with power:[power] and falloff:[falloff] in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
		log_game("Explosion with size power:[power] and falloff:[falloff] in area [epicenter.loc.name] ")

	/*
	spawn(0)
		if(config.use_recursive_explosions)
			var/power = devastation_range * 2 + heavy_impact_range + light_impact_range //The ranges add up, ie light 14 includes both heavy 7 and devestation 3. So this calculation means devestation counts for 4, heavy for 2 and light for 1 power, giving us a cap of 27 power.
			explosion_rec(epicenter, power)
			return

		if(light_impact_range > 2 && isnull(singe_impact_range))
			singe_impact_range = light_impact_range + 1
			light_impact_range--

		var/start = world.timeofday
		epicenter = get_turf(epicenter)
		if(!epicenter) return

		// Handles recursive propagation of explosions.
		if(devastation_range > 2 || heavy_impact_range > 2)
			if(HasAbove(epicenter.z) && z_transfer & UP)
				explosion(GetAbove(epicenter), max(0, devastation_range - 2), max(0, heavy_impact_range - 2), max(0, light_impact_range - 2), max(0, flash_range - 2), 0, UP, max(0, singe_impact_range - 2))
			if(HasBelow(epicenter.z) && z_transfer & DOWN)
				explosion(GetBelow(epicenter), max(0, devastation_range - 2), max(0, heavy_impact_range - 2), max(0, light_impact_range - 2), max(0, flash_range - 2), 0, DOWN, max(0, singe_impact_range - 2))

		var/max_range = max(devastation_range, heavy_impact_range, light_impact_range, flash_range, singe_impact_range)

		// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.
		// Stereo users will also hear the direction of the explosion!
		// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.
		// 3/7/14 will calculate to 80 + 35
		var/far_dist = 0
		far_dist += heavy_impact_range * 5
		far_dist += devastation_range * 20
		var/frequency = get_rand_frequency()
		for(var/mob/M in GLOB.player_list)
			// Double check for client
			if(M && M.client)
				var/turf/M_turf = get_turf(M)
				if(M_turf && M_turf.z == epicenter.z)
					var/dist = get_dist(M_turf, epicenter)
					// If inside the blast radius + world.view - 2
					if(dist <= round(max_range + world.view - 2, 1))
						M.playsound_local(epicenter, get_sfx("explosion"), 100, 1, frequency, falloff = 5) // get_sfx() is so that everyone gets the same sound

						//You hear a far explosion if you're outside the blast radius. Small bombs shouldn't be heard all over the station.

					else if(dist <= far_dist)
						var/far_volume = CLAMP(far_dist, 30, 50) // Volume is based on explosion size and dist
						far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
						M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', far_volume, 1, frequency, falloff = 5)

		var/close = range(world.view+round(devastation_range,1), epicenter)
		// to all distanced mobs play a different sound
		for(var/mob/M in world) if(M.z == epicenter.z) if(!(M in close))
			// check if the mob can hear
			if(M.ear_deaf <= 0 || !M.ear_deaf) if(!istype(M.loc,/turf/space))
				M << 'sound/effects/explosionfar.ogg'
		if(adminlog)
			message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range], [singe_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
			log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range], [singe_impact_range]) in area [epicenter.loc.name] ")

		var/approximate_intensity = (devastation_range * 3) + (heavy_impact_range * 2) + light_impact_range + round(singe_impact_range / 2)
		var/powernet_rebuild_was_deferred_already = defer_powernet_rebuild
		// Large enough explosion. For performance reasons, powernets will be rebuilt manually
		if(!defer_powernet_rebuild && (approximate_intensity > 25))
			defer_powernet_rebuild = 1

		if(heavy_impact_range > 1)
			var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
			E.set_up(epicenter)
			E.start()

		var/x0 = epicenter.x
		var/y0 = epicenter.y
		var/z0 = epicenter.z

		activate_mobs_in_range(epicenter, max_range)
		for(var/turf/T in RANGE_TURFS(max_range, epicenter))
			var/dist = sqrt((T.x - x0)**2 + (T.y - y0)**2)

			if(dist < devastation_range)		dist = 1
			else if(dist < heavy_impact_range)	dist = 2
			else if(dist < light_impact_range)	dist = 3
			else if(dist < singe_impact_range)	dist = 4
			else								continue

			T.ex_act(dist)
			if(T)
				for(var/atom_movable in T.contents)	//bypass type checking since only atom/movable can be contained by turfs anyway
					var/atom/movable/AM = atom_movable
					if(AM && AM.simulated)	AM.ex_act(dist, epicenter)

		var/took = (world.timeofday-start)/10
		//You need to press the DebugGame verb to see these now....they were getting annoying and we've collected a fair bit of data. Just -test- changes  to explosion code using this please so we can compare
		if(Debug2)	log_world("## DEBUG: Explosion([x0],[y0],[z0])(d[devastation_range],h[heavy_impact_range],l[light_impact_range]): Took [took] seconds.")

		//Machines which report explosions.
		for(var/i,i<=doppler_arrays.len,i++)
			var/obj/machinery/doppler_array/Array = doppler_arrays[i]
			if(Array)
				Array.sense_explosion(x0,y0,z0,devastation_range,heavy_impact_range,light_impact_range,singe_impact_range,took)

		sleep(8)

		if(!powernet_rebuild_was_deferred_already && defer_powernet_rebuild)
			SSmachines.makepowernets()
			defer_powernet_rebuild = 0

	return 1
	*/



proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		tile.explosion_act(500, null)

proc/fragment_explosion(var/turf/epicenter, var/range, var/f_type, var/f_amount = 100, var/f_damage = null, var/f_step = 2, var/same_turf_hit_chance = 20)
	if(!isturf(epicenter))
		epicenter = get_turf(epicenter)

	if(!epicenter || !f_type)
		return

	var/list/target_turfs = getcircle(epicenter, range)
	var/fragments_per_projectile = f_amount/target_turfs.len //This is rounded but only later
	for(var/turf/T in target_turfs)
		//sleep(0)
		var/obj/item/projectile/bullet/pellet/fragment/P = new f_type(epicenter)

		if (!isnull(f_damage))
			P.damage_types[BRUTE] = f_damage
		P.pellets = fragments_per_projectile
		P.range_step = f_step

		P.shot_from = epicenter

		P.launch(T)

		//Some of the fragments will hit mobs in the same turf
		if (prob(same_turf_hit_chance))
			for(var/mob/living/M in epicenter)
				P.attack_mob(M, 0, 100)


// This is made to mimic the explosion that would happen when something gets pierced by a bullet ( a tank by a anti-armor shell , a armoured car by an .60 AMR,  etc, creates flying shrapnel on the other side!)
proc/fragment_explosion_angled(atom/epicenter, turf/origin , projectile_type, projectile_amount)
	var/turf/turf_t = get_turf_away_from_target_complex(get_turf(epicenter), origin, 3)
	var/list/hittable_turfs  = RANGE_TURFS(1, turf_t)
	var/proj_amount = projectile_amount
	while(proj_amount)
		proj_amount--
		var/obj/item/projectile/pew_thingie = new projectile_type(epicenter)
		pew_thingie.firer = epicenter
		pew_thingie.launch(pick(hittable_turfs))

//Generic proc for spread of any projectile type.
proc/projectile_explosion(turf/epicenter, range, p_type, p_amount = 10, list/p_damage = list())
    if(!istype(epicenter))
        epicenter = get_turf(epicenter)

    if(!epicenter || !p_type)
        return

    var/list/target_turfs = getcircle(epicenter, range)
    while(p_amount)
        sleep(0)
        var/obj/item/projectile/P = new p_type(epicenter)

        if(length(p_damage))
            P.damage_types = p_damage

        P.shot_from = epicenter

        P.launch(pick(target_turfs))
        p_amount--
