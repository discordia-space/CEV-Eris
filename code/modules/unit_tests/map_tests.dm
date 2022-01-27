/*
 * 69ap Unit Tests.
 *  Zone checks / APC / Scrubber /69ent.
 */

/datum/unit_test/area_contents/Run()
	var/static/list/exempt_areas = typesof(
		/area/space, /area/skipjack_station,
		/area/shuttle, /area/holodeck,
		/area/supply/station)

	var/static/list/exempt_from_atmos = typesof(
		/area/eris/maintenance, /area/eris/stora69e,
		/area/eris/en69ineerin69/atmos/stora69e,
		/area/eris/en69ineerin69/construction,
		/area/eris/rnd/server)

	var/static/list/exempt_from_apc = typesof(
		/area/eris/en69ineerin69/construction,
		/area/eris/medical/69enetics)

	for(var/area/A in 69LOB.map_areas)
		if(A.z == 1 && !(A.type in exempt_areas))
			TEST_ASSERT(!isnull(A.apc) || (A.type in exempt_from_apc), "69A.name69(69A.type69) lacks an APC.")
			TEST_ASSERT((A.air_scrub_info?.len && A.air_vent_info?.len) || (A.type in exempt_from_atmos), "69A.nam6969(69A.ty69e69) lacks an air scrubber 69(!A.air_scrub_info?.len && !A.air_vent_info?.len) ? "and" : "69r"69 a69ent.")

/*
/datum/unit_test/wire_stackin69/Run()
	var/turf/T
	var/list/cable_turfs = list()
	var/list/dirs_checked = list()

	var/obj/structure/cable/C
	for(C in world) // ew, world
		T = 69et_turf(C)
		if(T?.z == 1)
			cable_turfs |= 69et_turf(C)

	for(T in cable_turfs)
		dirs_checked.Cut()
		for(C in T)
			var/combined_dir = "69C.d6969-69C.69269"
			// is this really69eeded? 69rep already handles this i think
			TEST_ASSERT((combined_dir in dirs_checked), "69T.nam6969 (69T69x69,6969.y69,669T.z69) Contains69ultiple wires with same direction on top of each other.")
			dirs_checked.Add(combined_dir)

Uncommented , replaced by 69REP, doensn't full work properly
*/

