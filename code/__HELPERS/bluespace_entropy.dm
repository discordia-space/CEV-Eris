GLOBAL_VAR_INIT(bluespace_entropy, 0)
GLOBAL_VAR_INIT(bluespace_gift, FALSE)

/proc/go_to_bluespace(turf/T, entropy=1, minor_distortion=FALSE, ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	bluespace_entropy(entropy, T, minor_distortion)
	do_teleport(ateleatom, adestination, aprecision, afteleport, aeffectin, aeffectout, asoundin, asoundout)

/proc/bluespace_entropy(max_value=1, turf/T, minor_distortion=FALSE)
	if(minor_distortion)
		if(prob(rand(1, max_value)))
			GLOB.bluespace_entropy -= rand(30, 60)
			bluespace_distorsion(T, minor_distortion)
		else
			GLOB.bluespace_entropy += rand(0, max_value)
	else
		GLOB.bluespace_entropy += rand(0, max_value)
		var/entropy_cap = rand(100, 300)
		if(GLOB.bluespace_entropy >= entropy_cap)
			bluespace_distorsion(T, minor_distortion)
			GLOB.bluespace_entropy -= rand(100, 200)

/proc/bluespace_distorsion(turf/T, minor_distortion=FALSE)
	var/bluespace_event = rand(1, 105)
	switch(bluespace_event)
		if(1 to 33)
			trash_buble(T, minor_distortion)
		if(33 to 66)
			bluespace_roaches(T, minor_distortion)
		if(66 to 99)
			bluespace_stranger(T, minor_distortion)
		if(99 to 102)
			bluespace_cristals_event(T, minor_distortion)
		if(102 to 105)
			bluespace_gift(T, minor_distortion)


/proc/get_random_secure_turf_in_range(atom/origin, outer_range, inner_range)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	var/turf/picked
	for(var/turf/T in trange(outer_range, origin))
		if(istype(T,/turf/space)) continue
		if(istype(T,/turf/simulated/open)) continue
		if(!turf_clear(T)) continue
		if(T.x >= world.maxx-TRANSITIONEDGE || T.x <= TRANSITIONEDGE)	continue
		if(T.y >= world.maxy-TRANSITIONEDGE || T.y <= TRANSITIONEDGE)	continue
		if(!inner_range || get_dist(origin, T) >= inner_range)
			turfs += T

	if(turfs.len)
		picked = pick(turfs)
	else if(inner_range >=2)
		picked = get_random_secure_turf_in_range(origin, outer_range, 1)
	if(!picked)
		picked = get_random_turf_in_range(origin, outer_range)
	if(picked)
		return picked

/proc/get_random_turf_in_range(atom/origin, outer_range, inner_range)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	for(var/turf/T in trange(outer_range, origin))
	//	if(!(T.z in GLOB.using_map.sealed_levels)) // Picking a turf outside the map edge isn't recommended
		if(T.x >= world.maxx-TRANSITIONEDGE || T.x <= TRANSITIONEDGE)	continue
		if(T.y >= world.maxy-TRANSITIONEDGE || T.y <= TRANSITIONEDGE)	continue
		if(!inner_range || get_dist(origin, T) >= inner_range)
			turfs += T
	if(turfs.len)
		return pick(turfs)

/proc/bluespace_cristals_event(turf/T, minor_distortion)
	var/list/areas = list()
	var/area/A = get_area(T)
	var/distortion_amount = 1
	var/amount = rand(2,4)
	if(A && !minor_distortion)
		areas = list(A)
		if(A in ship_areas)
			areas = ship_areas.Copy()
		distortion_amount = rand(2, 5)
	for(var/j = 1 to distortion_amount)
		var/turf/Ttarget = T
		if(areas.len)
			A = pick(areas)
			var/turf/Ttarget2 = A.random_space()
			if(Ttarget2)
				Ttarget = Ttarget2
		for(var/i=1 to amount)
			Ttarget = get_random_secure_turf_in_range(Ttarget, 4)
			if(Ttarget)
				new /obj/structure/bs_crystal_structure(Ttarget)
				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, Ttarget)
				sparks.start()

/proc/bluespace_gift(turf/T, minor_distortion)
	var/second_gift = rand(2,8)
	var/area/A = get_area(T)
	if(A && !minor_distortion)
		if(A in ship_areas)
			A = pick(ship_areas)
	if(A)
		var/turf/newT = A.random_space()
		if(newT)
			T = newT
	T = get_random_secure_turf_in_range(T, 4)
	if(minor_distortion)
		second_gift = round(second_gift/2)
	if(!GLOB.bluespace_gift && T)
		new /obj/item/weapon/oddity/broken_necklace(T)
		GLOB.bluespace_gift = TRUE
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, T)
		sparks.start()
	else
		second_gift *= 10
	if(prob(second_gift) && T)
		var/obj/O = pickweight(RANDOM_RARE_ITEM - /obj/item/stash_spawner)
		new O(T)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, T)
		sparks.start()

/proc/bluespace_stranger(turf/T, minor_distortion)
	var/area/A = get_area(T)
	if(A && !minor_distortion)
		if(A in ship_areas)
			A = pick(ship_areas)
	if(A)
		var/turf/newT = A.random_space()
		if(newT)
			T = newT
	T = get_random_secure_turf_in_range(T, 4)
	var/mob/living/simple_animal/hostile/stranger/S = new /mob/living/simple_animal/hostile/stranger(T)
	if(minor_distortion && prob(95))
		S.maxHealth = S.maxHealth/2
		S.health = health/2
		S.prob_tele = S.prob_tele/2
		S.empy_cell = TRUE

/proc/bluespace_roaches(turf/T, minor_distortion)
	var/list/areas = list()
	var/area/A = get_area(T)
	var/distortion_amount = 1
	var/amount = rand(4,16)
	if(A && !minor_distortion)
		areas = list(A)
		if(A in ship_areas)
			areas = ship_areas.Copy()
		distortion_amount = rand(2, 6)
	for(var/j=1, j<=distortion_amount, j++)
		var/turf/Ttarget = get_random_secure_turf_in_range(T, 4)
		if(areas.len)
			A = pick(areas)
			var/turf/Ttarget2 = A.random_space()
			if(Ttarget2)
				Ttarget = get_random_secure_turf_in_range(Ttarget2, 4)
		for(var/i=1, i<=amount, i++)
			if(Ttarget)
				new /mob/living/carbon/superior_animal/roach/bluespace(Ttarget)

/proc/trash_buble(turf/T, minor_distortion)
	var/list/areas = list()
	var/area/A = get_area(T)
	var/distortion_amount = 1
	var/amount = rand(30, 60)
	if(A && !minor_distortion)
		areas = list(A)
		if(A in ship_areas)
			areas = ship_areas.Copy()
		distortion_amount = rand(4, 10)
	for(var/j=1, j<=distortion_amount, j++)
		var/turf/Ttarget = T
		if(areas.len)
			A = pick(areas)
			var/turf/Ttarget2 = A.random_space()
			if(Ttarget2)
				Ttarget = Ttarget2
		for(var/i=1, i<=amount, i++)
			Ttarget = get_random_secure_turf_in_range(Ttarget, 5)
			if(Ttarget)
				new /obj/random/junk(Ttarget)
				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, Ttarget)
				sparks.start()

