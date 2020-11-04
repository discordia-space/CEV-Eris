GLOBAL_VAR_INIT(bluespace_entropy, 0)
GLOBAL_VAR_INIT(bluespace_gift, 0)
GLOBAL_VAR_INIT(bluespace_distotion_cooldown, 10 MINUTES)

/area
	var/local_bluespace_entropy = 0

/proc/go_to_bluespace(turf/T, entropy=1, minor_distortion=FALSE, ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	bluespace_entropy(entropy, T, minor_distortion)
	do_teleport(ateleatom, adestination, aprecision, afteleport, aeffectin, aeffectout, asoundin, asoundout)

/proc/bluespace_entropy(max_value=1, turf/T, minor_distortion=FALSE)
	var/entropy_value = rand(0, max_value)
	var/area/A = get_area(T)
	if(minor_distortion && A)
		A.local_bluespace_entropy += entropy_value
		var/area_entropy_cap = rand(100, 200)
		if(A.local_bluespace_entropy > area_entropy_cap && world.time > GLOB.bluespace_distotion_cooldown)
			GLOB.bluespace_distotion_cooldown = world.time + 5 MINUTES
			A.local_bluespace_entropy -= rand(100, 150)
			bluespace_distorsion(T, minor_distortion)
	else
		GLOB.bluespace_entropy += entropy_value
		var/entropy_cap = rand(150, 300)
		if(GLOB.bluespace_entropy >= entropy_cap && world.time > GLOB.bluespace_distotion_cooldown)
			GLOB.bluespace_distotion_cooldown = world.time + 10 MINUTES
			bluespace_distorsion(T, minor_distortion)
			GLOB.bluespace_entropy -= rand(150, 225)

/proc/bluespace_distorsion(turf/T, minor_distortion=FALSE)
	var/bluespace_event = rand(1, 100)
	switch(bluespace_event)
		if(1 to 30)
			trash_buble(T, minor_distortion)
		if(30 to 55)
			bluespace_roaches(T, minor_distortion)
		if(55 to 75)
			bluespace_stranger(T, minor_distortion)
		if(75 to 90)
			bluespace_cristals_event(T, minor_distortion)
		if(90 to 100)
			bluespace_gift(T, minor_distortion)

/proc/get_random_secure_turf_in_range(atom/origin, outer_range, inner_range)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	var/turf/picked
	for(var/turf/T in trange(outer_range, origin))
		if(!turf_clear(T)) continue
		if(!T.is_solid_structure()) continue
		if(T.x >= world.maxx-TRANSITIONEDGE || T.x <= TRANSITIONEDGE)	continue
		if(T.y >= world.maxy-TRANSITIONEDGE || T.y <= TRANSITIONEDGE)	continue
		if(!inner_range || get_dist(origin, T) >= inner_range)
			turfs += T

	if(turfs.len)
		picked = pick(turfs)
	else
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
	var/amount = rand(2,3)
	if(A && !minor_distortion)
		areas = list(A)
		if(A in ship_areas)
			areas = ship_areas.Copy()
			distortion_amount = rand(2,3)
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
	var/second_gift = rand(2,10)
	var/area/A = get_area(T)
	if(A && !minor_distortion)
		if(A in ship_areas)
			A = pick(ship_areas)
	if(A)
		var/turf/newT = A.random_space()
		if(newT)
			T = newT
	T = get_random_secure_turf_in_range(T, 4)
	if(!T)
		return
	if(GLOB.bluespace_gift <= 0 && !minor_distortion)
		new /obj/item/weapon/oddity/broken_necklace(T)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, T)
		sparks.start()
		log_and_message_admins("Bluespace gif spawned: [jumplink(T)]") //unique item
	else
		second_gift *= 10
	if(prob(second_gift))
		var/obj/O = pickweight(RANDOM_RARE_ITEM - /obj/item/stash_spawner)
		new O(T)
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, T)
		sparks.start()

/proc/bluespace_stranger(turf/T, minor_distortion)
	var/area/A = get_area(T)
	if(A)
		if(!minor_distortion && (A in ship_areas))
			A = pick(ship_areas)
		var/turf/newT = A.random_space()
		if(newT)
			T = newT
	T = get_random_secure_turf_in_range(T, 4)
	var/mob/living/simple_animal/hostile/stranger/S = new /mob/living/simple_animal/hostile/stranger(T)
	if(minor_distortion && prob(95))
		S.maxHealth = S.maxHealth/2
		S.health = S.health/2
		S.prob_tele = S.prob_tele/2
		S.empy_cell = TRUE

/proc/bluespace_roaches(turf/T, minor_distortion)
	var/list/areas = list()
	var/area/A = get_area(T)
	var/distortion_amount = 1
	var/amount = rand(5,12)
	if(A && !minor_distortion)
		areas = list(A)
		if(A in ship_areas)
			areas = ship_areas.Copy()
			distortion_amount = rand(2,4)
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
	var/amount = rand(25, 50)
	if(A && !minor_distortion)
		areas = list(A)
		if(A in ship_areas)
			areas = ship_areas.Copy()
			distortion_amount = rand(2, 8)
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
				new /obj/spawner/junk(Ttarget)
				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, Ttarget)
				sparks.start()

