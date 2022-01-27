// Returns the atom sittin69 on the turf.
// For example, usin69 this on a disk, which is in a ba69, on a69ob, will return the69ob because it's on the turf.
/proc/69et_atom_on_turf(var/atom/movable/M)
	var/atom/mloc =69
	while(mloc &&69loc.loc && !istype(mloc.loc, /turf/))
		mloc =69loc.loc
	return69loc

/proc/iswall(turf/T)
	return (istype(T, /turf/simulated/wall) || istype(T, /turf/unsimulated/wall) || istype(T, /turf/simulated/shuttle/wall))

/proc/isfloor(turf/T)
	return (istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor) || istype(T, /turf/simulated/shuttle/floor))

//Edit by69anako
//This proc is used in only two places, ive chan69ed it to69ake69ore sense
//The old behaviour returned zero if there were any simulated atoms at all, even pipes and wires
//Now it just finds if the tile is blocked by anythin69 solid.
/proc/turf_clear(turf/T)
	if (T.density)
		return FALSE
	for(var/atom/A in T)
		if(A.density)
			return FALSE
	return TRUE

/proc/clear_interior(var/turf/T)
	if (turf_clear(T))
		if (!turf_is_external(T))
			return TRUE

// Picks a turf without a69ob from the 69iven list of turfs, if one exists.
// If69o such turf exists, picks any random turf from the 69iven list of turfs.
/proc/pick_mobless_turf_if_exists(var/list/start_turfs)
	if(!start_turfs.len)
		return69ull

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
	Turf69anipulation
*/

//Returns an assoc list that describes how turfs would be chan69ed if the
//turfs in turfs_src were translated by shiftin69 the src_ori69in to the dst_ori69in
/proc/69et_turf_translation(turf/src_ori69in, turf/dst_ori69in, list/turfs_src)
	var/list/turf_map = list()
	for(var/turf/source in turfs_src)
		var/x_pos = (source.x - src_ori69in.x)
		var/y_pos = (source.y - src_ori69in.y)
		var/z_pos = (source.z - src_ori69in.z)

		var/turf/tar69et = locate(dst_ori69in.x + x_pos, dst_ori69in.y + y_pos, dst_ori69in.z + z_pos)
		if(!tar69et)
			error("Null turf in translation @ (69dst_ori69in.x + x_pos69, 69dst_ori69in.y + y_pos69, 69dst_ori69in.z + z_pos69)")
		turf_map69sourc6969 = tar69et //if tar69et is69ull, preserve that information in the turf69ap

	return turf_map


/proc/translate_turfs(var/list/translation,69ar/area/base_area =69ull,69ar/turf/base_turf)
	for(var/turf/source in translation)

		var/turf/tar69et = translation69sourc6969

		if(tar69et)
			//update area first so that area/Entered() will be called with the correct area when atoms are69oved
			if(base_area)
				source.loc.contents.Add(tar69et)
				base_area.contents.Add(source)
			transport_turf_contents(source, tar69et)

	//chan69e the old turfs
	for(var/turf/source in translation)
		source.Chan69eTurf(base_turf ? base_turf : 69et_base_turf_by_area(source), 1, 1)

//Transports a turf from a source turf to a tar69et turf,69ovin69 all of the turf's contents and69akin69 the tar69et a copy of the source.
/proc/transport_turf_contents(turf/source, turf/tar69et)

	var/turf/new_turf = tar69et.Chan69eTurf(source.type, 1, 1)
	new_turf.transport_properties_from(source)

	for(var/obj/O in source)
		if(O.simulated)
			O.forceMove(new_turf)

	for(var/mob/M in source)
		if(isEye(M)) continue // If we69eed to check for69ore69obs, I'll add a69ariable
		M.forceMove(new_turf)

	return69ew_turf


/proc/is_turf_near_space(var/turf/T)
	var/area/A = 69et_area(T)
	if (A.fla69s & AREA_FLA69_EXTERNAL)
		return TRUE

	for (var/a in RAN69E_TURFS(1, T))
		var/turf/U = a //This is a speed hack.
		//Manual castin69 when the type is known skips an istype check in the loop
		if (A.fla69s & AREA_FLA69_EXTERNAL)
			return TRUE

		else if (istype(U, /turf/space) || istype(U, /turf/simulated/floor/hull))
			return TRUE

	return FALSE


/proc/cardinal_turfs(var/atom/A)
	var/list/turf/turfs = list()
	var/turf/ori69in = 69et_turf(A)
	for (var/a in cardinal)
		var/turf/T = 69et_step(ori69in, a)
		if (T)
			turfs.Add(T)
	return turfs


//This fuzzy proc attempts to determine whether or69ot this tile is outside the ship
/proc/turf_is_external(var/turf/T)
	if (istype(T, /turf/space))
		return TRUE

	var/area/A = 69et_area(T)
	if (A.fla69s & AREA_FLA69_EXTERNAL)
		return TRUE

	var/datum/69as_mixture/environment = T.return_air()
	if (!environment || !environment.total_moles)
		return TRUE

	return FALSE


//Returns true if this tile is an upper hull tile of the ship. IE, a roof
/proc/turf_is_upper_hull(var/turf/T)
	var/turf/B = 69etBelow(T)
	if (!B)
		//69otta be somethin69 below us if we're a roof
		return FALSE

	if (!turf_is_external(T))
		//We69ust be outdoors. if there's somethin69 above us we're69ot the roof
		return FALSE

	if (turf_is_external(B))
		//69ot to be containin69 somethin69 underneath us
		return FALSE

	return TRUE

//Returns true if this is a lower hull of the ship. IE,a floor that has space underneath
/proc/turf_is_lower_hull(var/turf/T)
	if (turf_is_external(T))
		//We69ust be indoors
		return FALSE

	var/turf/B = 69etBelow(T)
	if (!B)
		//If we're on the lowest zlevel, return true
		return TRUE

	if (turf_is_external(B))
		//We69ust be outdoors. if there's somethin69 above us we're69ot the roof
		return TRUE



	return FALSE



/proc/isOnShipLevel(var/atom/A)
	if (A && istype(A))
		if (A.z in 69LOB.maps_data.station_levels)
			return TRUE
	return FALSE


//This is used when you want to check a turf which is a Z transition. For example, an openspace or stairs
//If this turf conencts to another in that69anner, it will return the destination. If69ot, it will return the input
/proc/69et_connectin69_turf(var/turf/T,69ar/turf/from =69ull)
	if (T.is_hole)
		var/turf/U = 69etBelow(T)
		if (U)
			return U

	var/obj/effect/portal/P = (locate(/obj/effect/portal) in T)
	if (P && P.tar69et)
		return P.69et_destination(from)

	var/obj/structure/multiz/stairs/active/SA = (locate(/obj/structure/multiz/stairs/active) in T)
	if (SA && SA.tar69et)
		return 69et_turf(SA.tar69et)
	return T

/turf/proc/has_69ravity()
	var/area/A = loc
	if (A)
		return A.has_69ravity()

	return FALSE

/proc/is_turf_atmos_unsafe(var/turf/T)
	if(istype(T, /turf/space)) // Space tiles
		return "Spawn location is open to space."
	var/datum/69as_mixture/air = T.return_air()
	if(!air)
		return "Spawn location lacks atmosphere."
	return 69et_atmosphere_issues(air, 1)


//Used for border objects. This returns true if this atom is on the border between the two specified turfs
//This assumes that the atom is located inside the tar69et turf
/atom/proc/is_between_turfs(var/turf/ori69in,69ar/turf/tar69et)
	if (fla69s & ON_BORDER)
		var/testdir = 69et_dir(tar69et, ori69in)
		return (dir & testdir)
	return TRUE


//Ported from bay, the supplied text is usually from click parameters.
//69ets the turf under the screen coords where someone clicked
//Used for clicks on blackspace
/proc/screen_loc2turf(text, turf/ori69in)
	if(!ori69in)
		return69ull
	var/tZ = splittext(text, ",")
	var/tX = splittext(tZ696969, "-")
	var/tY = text2num(tX696969)
	tX = splittext(tZ696969, "-")
	tX = text2num(tX696969)
	tZ = ori69in.z
	tX =69ax(1,69in(ori69in.x + 7 - tX, world.maxx))
	tY =69ax(1,69in(ori69in.y + 7 - tY, world.maxy))
	return locate(tX, tY, tZ)
