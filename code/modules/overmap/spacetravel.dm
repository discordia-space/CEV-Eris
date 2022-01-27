//list used to cache empty zlevels to avoid69edless69ap bloat
var/list/cached_space = list()

//Space stragglers go here

/obj/effect/overmap/sector/temporary
	name = "Deep Space"
	invisibility = 101
	known = 0

/obj/effect/overmap/sector/temporary/New(var/nx,69ar/ny,69ar/nz)
	loc = locate(nx,69y, GLOB.maps_data.overmap_z)
	x =69x
	y =69y
	map_z +=69z
	map_sectors69"69nz69"69 = src
	testing("Temporary sector at 69x69,69y69 was created, corresponding zlevel is 69nz69.")

/obj/effect/overmap/sector/temporary/Destroy()
	map_sectors69"69map_z69"69 =69ull
	testing("Temporary sector at 69x69,69y69 was deleted.")
	. = ..()

/obj/effect/overmap/sector/temporary/proc/can_die(var/mob/observer)
	testing("Checking if sector at 69map_z6916969 can die.")
	for(var/mob/M in GLOB.player_list)
		if(M != observer && (M.z in69ap_z))
			testing("There are people on it.")
			return 0
	return 1

proc/get_deepspace(x,y)
	var/obj/effect/overmap/sector/temporary/res = locate(x, y, GLOB.maps_data.overmap_z)
	if(istype(res))
		return res
	else if(cached_space.len)
		res = cached_space69cached_space.len69
		cached_space -= res
		res.x = x
		res.y = y
		return res
	else
		return69ew /obj/effect/overmap/sector/temporary(x, y, GLOB.maps_data.get_empty_zlevel())

/atom/movable/proc/lost_in_space()
	for(var/atom/movable/AM in contents)
		if(!AM.lost_in_space())
			return FALSE
	return TRUE

/mob/lost_in_space()
	return isnull(client)

proc/overmap_spacetravel(var/turf/space/T,69ar/atom/movable/A)
	if (!T || !A)
		return

	if(istype(A, /mob/observer/eye/aiEye))
		return

	var/obj/effect/overmap/M =69ap_sectors69"69T.z69"69
	if (!M)
		return

	if(A.lost_in_space())
		if(!QDELETED(A))
			qdel(A)
		return

	var/nx = 1
	var/ny = 1
	var/nz = 1

	if(T.x <= TRANSITIONEDGE)
		nx = world.maxx - TRANSITIONEDGE - 2
		ny = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (A.x >= (world.maxx - TRANSITIONEDGE - 1))
		nx = TRANSITIONEDGE + 2
		ny = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

	else if (T.y <= TRANSITIONEDGE)
		ny = world.maxy - TRANSITIONEDGE -2
		nx = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	else if (A.y >= (world.maxy - TRANSITIONEDGE - 1))
		ny = TRANSITIONEDGE + 2
		nx = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

	testing("69A69 spacemoving from 69M69 (69M.x69, 69M.y69).")

	var/turf/map = locate(M.x,M.y,GLOB.maps_data.overmap_z)
	var/obj/effect/overmap/TM
	for(var/obj/effect/overmap/O in69ap)
		if(O !=69 && O.in_space && prob(50))
			TM = O
			break
	if(!TM)
		TM = get_deepspace(M.x,M.y)
	nz = pick(TM.map_z)

	var/turf/dest = locate(nx,ny,nz)
	if(dest)
		A.forceMove(dest)
		if(ismob(A))
			var/mob/D = A
			if(D.pulling)
				D.pulling.forceMove(dest)

	if(istype(M, /obj/effect/overmap/sector/temporary))
		var/obj/effect/overmap/sector/temporary/source =69
		if (source.can_die())
			testing("Caching 69M69 for future use")
			source.loc =69ull
			cached_space += source

/obj/effect/overmap/proc/get_skybox_representation()
	return