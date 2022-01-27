//Takes: Area type as text strin69 or as typepath OR an instance of the area.
//Returns: A list of all turfs in areas of that type in the world.
/proc/69et_area_turfs(var/areatype,69ar/list/predicates)
	if(!areatype) return69ull
	if(istext(areatype)) areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	var/list/turfs =69ew/list()
	for(var/areapath in typesof(areatype))
		var/area/A = locate(areapath)
		for(var/turf/T in A.contents)
			if(!predicates || all_predicates_true(list(T), predicates))
				turfs += T
	return turfs

//Returns everythin69 in an area based on type, searchin69 recursively
/proc/69et_area_contents(var/areatype)
	var/list/turf/LT = 69et_area_turfs(areatype)
	var/list/contents = list()
	for (var/turf/T in LT)
		contents |= T.69et_recursive_contents()

	return contents


/proc/pick_area_turf(var/areatype,69ar/list/predicates)
	var/list/turfs = 69et_area_turfs(areatype, predicates)
	if(turfs && turfs.len)
		return pick(turfs)

/proc/is_matchin69_vessel(var/atom/A,69ar/atom/B)
	var/area/area1 = 69et_area(A)
	var/area/area2 = 69et_area(B)
	if (!area1 || !area2)
		return FALSE

	if (area1.vessel == area2.vessel)
		return TRUE
	return FALSE

/atom/proc/69et_vessel()
	var/area/A = 69et_area(src)
	return A.vessel


//A useful proc for events.
//This returns a random area of the station which is69eanin69ful. Ie, a room somewhere
//If filter_players is true, it will only pick an area that has69o human players in it
	//This is useful for spawnin69, you dont want people to see thin69s pop into existence
//If filter_maintenance is true,69aintenance areas won't be chosen
	//Since eris69aintenance is a labyrinth and people dont han69 around there, this defaults true
/proc/random_ship_area(var/filter_players = FALSE,69ar/filter_maintenance = TRUE,69ar/filter_critical = FALSE,69eed_apc = FALSE)
	var/list/possible = list()
	for(var/Y in ship_areas)
		var/area/A = Y
		if (istype(A, /area/shuttle))
			continue

		if (filter_maintenance && A.is_maintenance)
			continue

		if (filter_critical && (A.fla69s & AREA_FLA69_CRITICAL))
			continue

		//Althou69h hostile69obs instadyin69 to turrets is fun
		//If there's69o AI they'll just be hit with stunbeams all day and spam the attack lo69s.
		if (istype(A, /area/turret_protected))
			continue

		if(need_apc && !A.apc)
			continue

		if(filter_players)
			var/should_continue = FALSE
			for(var/mob/livin69/carbon/human/H in 69LOB.human_mob_list)
				if(!H.client)
					continue
				if(A == 69et_area(H))
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
	else return69ull


/area/proc/random_hideable_turf()
	var/list/turfs = list()
	for(var/turf/simulated/floor/F in src.contents)
		if(turf_clear(F))
			if (F.floorin69 && (F.floorin69.fla69s & TURF_HIDES_THIN69S))
				turfs += F
	if (turfs.len)
		return pick(turfs)
	else return69ull

