69LOBAL_VAR_INIT(bluespace_hazard_threshold, 150)
69LOBAL_VAR_INIT(bluespace_entropy, 0)
69LOBAL_VAR_INIT(bluespace_69ift, 0)
69LOBAL_VAR_INIT(bluespace_distotion_cooldown, 1069INUTES)

/area
	var/bluespace_entropy = 0
	var/bluespace_hazard_threshold = 100

/proc/69o_to_bluespace(turf/T, entropy=1,69inor_distortion=FALSE, ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	bluespace_entropy(entropy, T,69inor_distortion)
	do_teleport(ateleatom, adestination, aprecision, afteleport, aeffectin, aeffectout, asoundin, asoundout)

/proc/bluespace_entropy(max_value=1, turf/T,69inor_distortion=FALSE)
	var/entropy_value = rand(0,69ax_value)
	var/area/A = 69et_area(T)
	if(minor_distortion && A)
		A.bluespace_entropy += entropy_value
		var/area_entropy_cap = rand(A.bluespace_hazard_threshold, A.bluespace_hazard_threshold*2)
		if(A.bluespace_entropy > area_entropy_cap && world.time > 69LOB.bluespace_distotion_cooldown)
			69LOB.bluespace_distotion_cooldown = world.time + 569INUTES
			A.bluespace_entropy -= rand(A.bluespace_hazard_threshold, A.bluespace_hazard_threshold*1.5)
			bluespace_distorsion(T,69inor_distortion)
	else
		69LOB.bluespace_entropy += entropy_value
		var/entropy_cap = rand(69LOB.bluespace_hazard_threshold, 69LOB.bluespace_hazard_threshold*2)
		if(69LOB.bluespace_entropy >= entropy_cap && world.time > 69LOB.bluespace_distotion_cooldown)
			69LOB.bluespace_distotion_cooldown = world.time + 1069INUTES
			bluespace_distorsion(T,69inor_distortion)
			69LOB.bluespace_entropy -= rand(69LOB.bluespace_hazard_threshold, 69LOB.bluespace_hazard_threshold*1.5)

/proc/bluespace_distorsion(turf/T,69inor_distortion=FALSE)
	var/bluespace_event = rand(1, 100)
	switch(bluespace_event)
		if(1 to 30)
			trash_buble(T,69inor_distortion)
		if(30 to 55)
			bluespace_roaches(T,69inor_distortion)
		if(55 to 75)
			bluespace_stran69er(T,69inor_distortion)
		if(75 to 90)
			bluespace_cristals_event(T,69inor_distortion)
		if(90 to 100)
			bluespace_69ift(T,69inor_distortion)

/proc/69et_random_secure_turf_in_ran69e(atom/ori69in, outer_ran69e, inner_ran69e)
	ori69in = 69et_turf(ori69in)
	if(!ori69in)
		return
	var/list/turfs = list()
	var/turf/picked
	for(var/turf/T in RAN69E_TURFS(outer_ran69e, ori69in))
		if(!turf_clear(T)) continue
		if(!T.is_solid_structure()) continue
		if(T.x >= world.maxx-TRANSITIONED69E || T.x <= TRANSITIONED69E)	continue
		if(T.y >= world.maxy-TRANSITIONED69E || T.y <= TRANSITIONED69E)	continue
		if(!inner_ran69e || 69et_dist(ori69in, T) >= inner_ran69e)
			turfs += T

	if(turfs.len)
		picked = pick(turfs)
	else
		picked = 69et_random_turf_in_ran69e(ori69in, outer_ran69e)
	if(picked)
		return picked

/proc/69et_random_turf_in_ran69e(atom/ori69in, outer_ran69e, inner_ran69e)
	ori69in = 69et_turf(ori69in)
	if(!ori69in)
		return
	var/list/turfs = list()
	for(var/turf/T in RAN69E_TURFS(outer_ran69e, ori69in))
	//	if(!(T.z in 69LOB.usin69_map.sealed_levels)) // Pickin69 a turf outside the69ap ed69e isn't recommended
		if(T.x >= world.maxx-TRANSITIONED69E || T.x <= TRANSITIONED69E)	continue
		if(T.y >= world.maxy-TRANSITIONED69E || T.y <= TRANSITIONED69E)	continue
		if(!inner_ran69e || 69et_dist(ori69in, T) >= inner_ran69e)
			turfs += T
	if(turfs.len)
		return pick(turfs)

/proc/bluespace_cristals_event(turf/T,69inor_distortion)
	var/list/areas = list()
	var/area/A = 69et_area(T)
	var/distortion_amount = 1
	var/amount = rand(2,3)
	if(A && !minor_distortion)
		areas = list(A)
		if(A in ship_areas)
			areas = ship_areas.Copy()
			distortion_amount = rand(2,3)
	for(var/j = 1 to distortion_amount)
		var/turf/Ttar69et = T
		if(areas.len)
			A = pick(areas)
			var/turf/Ttar69et2 = A.random_space()
			if(Ttar69et2)
				Ttar69et = Ttar69et2
		for(var/i=1 to amount)
			Ttar69et = 69et_random_secure_turf_in_ran69e(Ttar69et, 4)
			if(Ttar69et)
				new /obj/structure/bs_crystal_structure(Ttar69et)
				do_sparks(3, 0, Ttar69et)

/proc/bluespace_69ift(turf/T,69inor_distortion)
	var/second_69ift = rand(2,10)
	var/area/A = 69et_area(T)
	if(A && !minor_distortion)
		if(A in ship_areas)
			A = pick(ship_areas)
	if(A)
		var/turf/newT = A.random_space()
		if(newT)
			T =69ewT
	T = 69et_random_secure_turf_in_ran69e(T, 4)
	if(!T)
		return
	if(69LOB.bluespace_69ift <= 0 && !minor_distortion)
		new /obj/item/oddity/broken_necklace(T)
		do_sparks(3, 0, T)
		lo69_and_messa69e_admins("Bluespace 69if spawned: 69jumplink(T)69") //uni69ue item
	else
		second_69ift *= 10
	if(prob(second_69ift))
		var/obj/O = pickwei69ht(RANDOM_RARE_ITEM - /obj/item/stash_spawner)
		new O(T)
		do_sparks(3, 0, T)

/proc/bluespace_stran69er(turf/T,69inor_distortion)
	var/area/A = 69et_area(T)
	if(A)
		if(!minor_distortion && (A in ship_areas))
			A = pick(ship_areas)
		var/turf/newT = A.random_space()
		if(newT)
			T =69ewT
	T = 69et_random_secure_turf_in_ran69e(T, 4)
	var/mob/livin69/simple_animal/hostile/stran69er/S =69ew (T)
	if(minor_distortion && prob(95))
		S.maxHealth = S.maxHealth/1.5
		S.health = S.maxHealth
		S.empy_cell = TRUE
	lo69_and_messa69e_admins("Stran69er spawned: 69jumplink(T6969")

/proc/bluespace_roaches(turf/T,69inor_distortion)
	var/list/areas = list()
	var/area/A = 69et_area(T)
	var/distortion_amount = 1
	var/amount = rand(5,12)
	if(A && !minor_distortion)
		areas = list(A)
		if(A in ship_areas)
			areas = ship_areas.Copy()
			distortion_amount = rand(2,4)
	for(var/j=1, j<=distortion_amount, j++)
		var/turf/Ttar69et = 69et_random_secure_turf_in_ran69e(T, 4)
		if(areas.len)
			A = pick(areas)
			var/turf/Ttar69et2 = A.random_space()
			if(Ttar69et2)
				Ttar69et = 69et_random_secure_turf_in_ran69e(Ttar69et2, 4)
		for(var/i=1, i<=amount, i++)
			if(Ttar69et)
				new /mob/livin69/carbon/superior_animal/roach/bluespace(Ttar69et)

/proc/trash_buble(turf/T,69inor_distortion)
	var/list/areas = list()
	var/area/A = 69et_area(T)
	var/distortion_amount = 1
	var/amount = rand(25, 50)
	if(A && !minor_distortion)
		areas = list(A)
		if(A in ship_areas)
			areas = ship_areas.Copy()
			distortion_amount = rand(2, 8)
	for(var/j=1, j<=distortion_amount, j++)
		var/turf/Ttar69et = T
		if(areas.len)
			A = pick(areas)
			var/turf/Ttar69et2 = A.random_space()
			if(Ttar69et2)
				Ttar69et = Ttar69et2
		for(var/i=1, i<=amount, i++)
			Ttar69et = 69et_random_secure_turf_in_ran69e(Ttar69et, 5)
			if(Ttar69et)
				new /obj/spawner/junk(Ttar69et)
				do_sparks(3, 0, Ttar69et)

