//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all turfs in areas of that type in the world.
/proc/get_area_turfs(var/areatype, var/list/predicates)
	if(!areatype) return null
	if(istext(areatype)) areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	var/list/turfs = new/list()
	for(var/areapath in typesof(areatype))
		var/area/A = locate(areapath)
		for(var/turf/T in A.contents)
			if(!predicates || all_predicates_true(list(T), predicates))
				turfs += T
	return turfs

//Returns everything in an area based on type, searching recursively
/proc/get_area_contents(var/areatype)
	var/list/turf/LT = get_area_turfs(areatype)
	var/list/contents = list()
	for (var/turf/T in LT)
		contents |= T.get_recursive_contents()

	return contents


/proc/pick_area_turf(var/areatype, var/list/predicates)
	var/list/turfs = get_area_turfs(areatype, predicates)
	if(turfs && turfs.len)
		return pick(turfs)

/proc/is_matching_vessel(var/atom/A, var/atom/B)
	var/area/area1 = get_area(A)
	var/area/area2 = get_area(B)
	if (!area1 || !area2)
		return FALSE

	if (area1.vessel == area2.vessel)
		return TRUE
	return FALSE

/atom/proc/get_vessel()
	var/area/A = get_area(src)
	return A.vessel


//A useful proc for events.
//This returns a random area of the station which is meaningful. Ie, a room somewhere
//If filter_players is true, it will only pick an area that has no human players in it
	//This is useful for spawning, you dont want people to see things pop into existence
//If filter_maintenance is true, maintenance areas won't be chosen
	//Since eris maintenance is a labyrinth and people dont hang around there, this defaults true
/proc/random_ship_area(var/filter_players = FALSE, var/filter_maintenance = TRUE, var/filter_critical = FALSE)
	var/list/possible = list()
	for(var/Y in ship_areas)
		var/area/A = Y
		if (istype(A, /area/shuttle))
			continue

		if (filter_maintenance && A.is_maintenance)
			continue

		if (filter_critical && (A.flags & AREA_FLAG_CRITICAL))
			continue

		//Although hostile mobs instadying to turrets is fun
		//If there's no AI they'll just be hit with stunbeams all day and spam the attack logs.
		if (istype(A, /area/turret_protected))
			continue

		if(filter_players)
			var/should_continue = FALSE
			for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
				if(!H.client)
					continue
				if(A == get_area(H))
					should_continue = TRUE
					break

			if(should_continue)
				continue

		possible += A

	return pick(possible)

/area/proc/random_space()
	var/list/turfs = list()
	for(var/turf/simulated/floor/F in src.contents)
		if(turf_clear(F))
			turfs += F
	if (turfs.len)
		return pick(turfs)
	else return null


/area/proc/random_hideable_turf()
	var/list/turfs = list()
	for(var/turf/simulated/floor/F in src.contents)
		if(turf_clear(F))
			if (F.flooring && (F.flooring.flags & TURF_HIDES_THINGS))
				turfs += F
	if (turfs.len)
		return pick(turfs)
	else return null

