// Returns the atom sitting on the turf.
// For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
/proc/get_atom_on_turf(var/atom/movable/M)
	var/atom/mloc = M
	while(mloc && mloc.loc && !istype(mloc.loc, /turf/))
		mloc = mloc.loc
	return mloc

/proc/iswall(turf/T)
	return (istype(T, /turf/simulated/wall) || istype(T, /turf/unsimulated/wall) || istype(T, /turf/simulated/shuttle/wall))

/proc/isfloor(turf/T)
	return (istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor) || istype(T, /turf/simulated/shuttle/floor))

//Edit by Nanako
//This proc is used in only two places, ive changed it to make more sense
//The old behaviour returned zero if there were any simulated atoms at all, even pipes and wires
//Now it just finds if the tile is blocked by anything solid.
/proc/turf_clear(turf/T)
	if (T.density)
		return 0
	for(var/atom/A in T)
		if(A.density)
			return 0
	return 1

/proc/clear_interior(var/turf/T)
	if (turf_clear(T))
		if (!turf_is_external(T))
			return TRUE

// Picks a turf without a mob from the given list of turfs, if one exists.
// If no such turf exists, picks any random turf from the given list of turfs.
/proc/pick_mobless_turf_if_exists(var/list/start_turfs)
	if(!start_turfs.len)
		return null

	var/list/available_turfs = list()
	for(var/start_turf in start_turfs)
		var/mob/M = locate() in start_turf
		if(!M)
			available_turfs += start_turf
	if(!available_turfs.len)
		available_turfs = start_turfs
	return pick(available_turfs)

/proc/turf_contains_dense_objects(var/turf/T)
	return T.contains_dense_objects()

/proc/not_turf_contains_dense_objects(var/turf/T)
	return !turf_contains_dense_objects(T)

/proc/is_station_turf(var/turf/T)
	return T && isStationLevel(T.z)

/*
	Turf manipulation
*/

//Returns an assoc list that describes how turfs would be changed if the
//turfs in turfs_src were translated by shifting the src_origin to the dst_origin
/proc/get_turf_translation(turf/src_origin, turf/dst_origin, list/turfs_src)
	var/list/turf_map = list()
	for(var/turf/source in turfs_src)
		var/x_pos = (source.x - src_origin.x)
		var/y_pos = (source.y - src_origin.y)
		var/z_pos = (source.z - src_origin.z)

		var/turf/target = locate(dst_origin.x + x_pos, dst_origin.y + y_pos, dst_origin.z + z_pos)
		if(!target)
			error("Null turf in translation @ ([dst_origin.x + x_pos], [dst_origin.y + y_pos], [dst_origin.z + z_pos])")
		turf_map[source] = target //if target is null, preserve that information in the turf map

	return turf_map


/proc/translate_turfs(var/list/translation, var/area/base_area = null, var/turf/base_turf)
	for(var/turf/source in translation)

		var/turf/target = translation[source]

		if(target)
			//update area first so that area/Entered() will be called with the correct area when atoms are moved
			if(base_area)
				source.loc.contents.Add(target)
				base_area.contents.Add(source)
			transport_turf_contents(source, target)

	//change the old turfs
	for(var/turf/source in translation)
		source.ChangeTurf(base_turf ? base_turf : get_base_turf_by_area(source), 1, 1)

//Transports a turf from a source turf to a target turf, moving all of the turf's contents and making the target a copy of the source.
/proc/transport_turf_contents(turf/source, turf/target)

	var/turf/new_turf = target.ChangeTurf(source.type, 1, 1)
	new_turf.transport_properties_from(source)

	for(var/obj/O in source)
		if(O.simulated)
			O.forceMove(new_turf)

	for(var/mob/M in source)
		if(isEye(M)) continue // If we need to check for more mobs, I'll add a variable
		M.forceMove(new_turf)

	return new_turf


/proc/is_turf_near_space(var/turf/T)
	var/area/A = get_area(T)
	if (A.flags & AREA_FLAG_EXTERNAL)
		return TRUE

	for (var/a in trange(1, T))
		var/turf/U = a //This is a speed hack.
		//Manual casting when the type is known skips an istype check in the loop
		if (A.flags & AREA_FLAG_EXTERNAL)
			return TRUE

		else if (istype(U, /turf/space) || istype(U, /turf/simulated/floor/hull))
			return TRUE

	return FALSE


/proc/cardinal_turfs(var/atom/A)
	var/list/turf/turfs = list()
	var/turf/origin = get_turf(A)
	for (var/a in cardinal)
		var/turf/T = get_step(origin, a)
		if (T)
			turfs.Add(T)
	return turfs


//This fuzzy proc attempts to determine whether or not this tile is outside the ship
/proc/turf_is_external(var/turf/T)
	if (istype(T, /turf/space))
		return TRUE

	var/area/A = get_area(T)
	if (A.flags & AREA_FLAG_EXTERNAL)
		return TRUE

	var/datum/gas_mixture/environment = T.return_air()
	if (!environment || !environment.total_moles)
		return TRUE

	return FALSE


//Returns true if this tile is an upper hull tile of the ship. IE, a roof
/proc/turf_is_upper_hull(var/turf/T)
	var/turf/B = GetBelow(T)
	if (!B)
		//Gotta be something below us if we're a roof
		return FALSE

	if (!turf_is_external(T))
		//We must be outdoors. if there's something above us we're not the roof
		return FALSE

	if (turf_is_external(B))
		//Got to be containing something underneath us
		return FALSE

	return TRUE

//Returns true if this is a lower hull of the ship. IE,a floor that has space underneath
/proc/turf_is_lower_hull(var/turf/T)
	if (turf_is_external(T))
		//We must be indoors
		return FALSE

	var/turf/B = GetBelow(T)
	if (!B)
		//If we're on the lowest zlevel, return true
		return TRUE

	if (turf_is_external(B))
		//We must be outdoors. if there's something above us we're not the roof
		return TRUE



	return FALSE



/proc/isOnShipLevel(var/atom/A)
	if (A && istype(A))
		if (A.z in maps_data.station_levels)
			return TRUE
	return FALSE


//This is used when you want to check a turf which is a Z transition. For example, an openspace or stairs
//If this turf conencts to another in that manner, it will return the destination. If not, it will return the input
/proc/get_connecting_turf(var/turf/T, var/turf/from = null)
	if (T.is_hole)
		var/turf/U = GetBelow(T)
		if (U)
			return U

	var/obj/effect/portal/P = (locate(/obj/effect/portal) in T)
	if (P && P.target)
		return P.get_destination(from)

	var/obj/structure/multiz/stairs/active/SA = (locate(/obj/structure/multiz/stairs/active) in T)
	if (SA && SA.target)
		return get_turf(SA.target)
	return T

/turf/proc/has_gravity()
	var/area/A = loc
	if (A)
		return A.has_gravity()

	return FALSE

/proc/is_turf_atmos_unsafe(var/turf/T)
	if(istype(T, /turf/space)) // Space tiles
		return "Spawn location is open to space."
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return "Spawn location lacks atmosphere."
	return get_atmosphere_issues(air, 1)


//Used for border objects. This returns true if this atom is on the border between the two specified turfs
//This assumes that the atom is located inside the target turf
/atom/proc/is_between_turfs(var/turf/origin, var/turf/target)
	if (flags & ON_BORDER)
		var/testdir = get_dir(target, origin)
		return (dir & testdir)
	return TRUE


//Ported from bay, the supplied text is usually from click parameters.
//Gets the turf under the screen coords where someone clicked
//Used for clicks on blackspace
/proc/screen_loc2turf(text, turf/origin)
	if(!origin)
		return null
	var/tZ = splittext(text, ",")
	var/tX = splittext(tZ[1], "-")
	var/tY = text2num(tX[2])
	tX = splittext(tZ[2], "-")
	tX = text2num(tX[2])
	tZ = origin.z
	tX = max(1, min(origin.x + 7 - tX, world.maxx))
	tY = max(1, min(origin.y + 7 - tY, world.maxy))
	return locate(tX, tY, tZ)
