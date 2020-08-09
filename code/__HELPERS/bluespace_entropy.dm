GLOBAL_VAR_INIT(bluespace_entropy, 0)

/proc/go_to_bluespace(turf/T, entropy=1, minor_distortion=FALSE, ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	bluespace_entropy(entropy, T, minor_distortion)
	do_teleport(ateleatom, adestination, aprecision, afteleport, aeffectin, aeffectout, asoundin, asoundout)

/proc/bluespace_entropy(max_value=1, turf/T, minor_distortion=FALSE)
	if(minor_distortion && prob(1))
		GLOB.bluespace_entropy -= rand(25, 100)
		bluespace_distorsion(T, minor_distortion)
	else
		GLOB.bluespace_entropy += rand(0, max_value)
		var/entropy_cap = rand(100, 300)
		if(GLOB.bluespace_entropy >= entropy_cap)
			bluespace_distorsion(T, minor_distortion)
			GLOB.bluespace_entropy -= rand(100, 150)

/proc/bluespace_distorsion(turf/T, minor_distortion=FALSE)
	var/bluespace_event = rand(1, 11)
	switch(bluespace_event)
		if(1 to 3)
			trash_buble(T, minor_distortion)
		if(3 to 6)
			bluespace_roaches(T, minor_distortion)
		if(6 to 9)
			bluespace_stranger(T, minor_distortion)
		if(9 to 10)
			bluespace_cristals_event(T, minor_distortion)
		if(10 to 11)
			bluespace_gift(T, minor_distortion)


/proc/get_random_secure_turf_in_range(atom/origin, outer_range, inner_range)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	var/turf/picked
	for(var/turf/T in trange(outer_range, origin))
		if(istype(T,/turf/space)) continue
		if(T.density) continue
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
	var/amount = rand(2,4)
	if(minor_distortion)
		amount = round(amount/2)
	for(var/i=1 to amount)
		var/turf/Ttarget = get_random_secure_turf_in_range(T, 3)
		if(Ttarget)
			new /obj/structure/bs_crystal_structure(Ttarget)
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(3, 0, Ttarget)
			sparks.start()

/proc/bluespace_gift(turf/T, minor_distortion)
	var/second_gift = rand(2,8)
	if(minor_distortion)
		second_gift = round(second_gift/2)
	new /obj/item/weapon/oddity/broken_necklace(T)
	if(prob(second_gift))
		var/obj/O = pickweight(RANDOM_RARE_ITEM - /obj/item/stash_spawner)
		new O(T)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, T)
	sparks.start()

/proc/bluespace_stranger(turf/T, minor_distortion)
	var/mob/living/simple_animal/hostile/stranger/S = new /mob/living/simple_animal/hostile/stranger(T)
	if(minor_distortion && prob(90))
		S.rapid = FALSE
		S.empy_cell = TRUE

/proc/bluespace_roaches(turf/T, minor_distortion)
	var/base_amount = rand(3,10)
	var/prob_extra = rand(0, 15)
	var/extra_amount = rand(0,2)
	if(minor_distortion)
		base_amount = round(base_amount/2)
	if(prob(prob_extra) && extra_amount)
		base_amount += extra_amount
	for(var/i=1 to base_amount)
		new /mob/living/carbon/superior_animal/roach/bluespace(T)

/proc/trash_buble(turf/T, minor_distortion)
	var/amount = rand(10, 16)
	if(minor_distortion)
		amount = round(amount/2)
	for(var/i = 1 to amount)
		var/turf/Ttarget = get_random_turf_in_range(T, 5)
		if(Ttarget)
			new /obj/random/junk(Ttarget)
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(3, 0, Ttarget)
			sparks.start()

