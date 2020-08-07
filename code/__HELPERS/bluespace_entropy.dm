GLOBAL_VAR_INIT(bluespace_entropy, 0)

/proc/go_to_bluespace(turf/T, entropy=1, minor_dristortion=FALSE, ateleatom, adestination, aprecision=0, afteleport=1, aeffectin=null, aeffectout=null, asoundin=null, asoundout=null)
	bluespace_entropy(entropy, T, minor_dristortion)
	do_teleport(ateleatom, adestination, aprecision, afteleport, aeffectin, aeffectout, asoundin, asoundout)

/proc/bluespace_entropy(max_value=1, turf/T, minor_dristortion=FALSE)
	if(minor_dristortion && prob(1))
		GLOB.bluespace_entropy -= 20
		bluespace_distorsion(T, minor_dristortion)
	else
		GLOB.bluespace_entropy += rand(0, max_value)
		if(GLOB.bluespace_entropy >= 150)
			bluespace_distorsion(T, minor_dristortion)
			GLOB.bluespace_entropy -= 150

/proc/bluespace_distorsion(turf/T, minor_dristortion=FALSE)
	var/distortion_value = rand(1, 100)
	switch(distortion_value)
		if(1 to 30)
			trash_buble(T, minor_dristortion)
		if(30 to 60)
			bluespace_roaches(T, minor_dristortion)
		if(60 to 90)
			bluespace_stranger(T, minor_dristortion)
		if(90 to 100)
			bluespace_gift(T, minor_dristortion)

/proc/get_random_secure_turf_in_range(atom/origin, outer_range, inner_range)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	for(var/turf/T in trange(outer_range, origin))
		if(istype(T,/turf/space)) continue
		if(T.density) continue
		if(T.x >= world.maxx-TRANSITIONEDGE || T.x <= TRANSITIONEDGE)	continue
		if(T.y >= world.maxy-TRANSITIONEDGE || T.y <= TRANSITIONEDGE)	continue
		if(!inner_range || get_dist(origin, T) >= inner_range)
			turfs += T
	if(turfs.len)
		return pick(turfs)

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

/proc/bluespace_gift(turf/T, minor_dristortion)
	var/obj/item/weapon/oddity/O = pick(subtypesof(/obj/item/weapon/oddity))
	new O(T)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, T)
	sparks.start()

/proc/bluespace_stranger(turf/T, minor_dristortion)
	var/mob/living/simple_animal/hostile/stranger/S = new /mob/living/simple_animal/hostile/stranger(T)
	if(minor_dristortion)
		S.rapid = FALSE
		S.empy_cell = TRUE

/proc/bluespace_roaches(turf/T, minor_dristortion)
	if(!minor_dristortion)
		new /mob/living/carbon/superior_animal/roach/bluespace(T)
		new /mob/living/carbon/superior_animal/roach/bluespace(T)
		new /mob/living/carbon/superior_animal/roach/bluespace(T)
		new /mob/living/carbon/superior_animal/roach/bluespace(T)
	else
		new /mob/living/carbon/superior_animal/roach/bluespace(T)
		new /mob/living/carbon/superior_animal/roach/bluespace(T)

/proc/trash_buble(turf/T, minor_dristortion)
	var/amount = 10
	if(minor_dristortion)
		amount = 5
	for(var/i = 1 to amount)
		var/turf/Ttarget = get_random_secure_turf_in_range(T, 4)
		if(Ttarget)
			new /obj/random/junk(Ttarget)
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(3, 0, T)
			sparks.start()

