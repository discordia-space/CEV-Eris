/*
 *  Map Unit Tests.
 *  Zone checks / APC / Scrubber / Vent.
 */

/datum/unit_test/area_contents/Run()
	var/static/list/exempt_areas = typesof(
		/area/space, /area/skipjack_station,
		/area/shuttle, /area/holodeck, /area/outpost/pulsar)

	var/static/list/exempt_from_atmos = typesof(
		/area/eris/maintenance, /area/eris/storage,
		/area/eris/engineering/atmos/storage,
		/area/eris/engineering/construction,
		/area/eris/engineering/post,
		/area/eris/rnd/server)

	var/static/list/exempt_from_apc = typesof(
		/area/eris/engineering/construction,
		/area/eris/medical/genetics)

	for(var/area/A in GLOB.map_areas)
		if((A.z in GLOB.maps_data.station_levels) && !(A.type in exempt_areas))
			if (isnull(A.apc) && !(A.type in exempt_from_apc))
				TEST_FAIL("[A.name]([A.type]) lacks an APC Z: [A.z].")
			if (!((LAZYLEN(A.air_scrub_info) && LAZYLEN(A.air_vent_info)) || (A.type in exempt_from_atmos)))
				TEST_FAIL("[A.name]([A.type]) lacks an air scrubber [(!A.air_scrub_info?.len && !A.air_vent_info?.len) ? "and" : "or"] a vent Z: [A.z].")

/*
/datum/unit_test/wire_stacking/Run()
	var/turf/T
	var/list/cable_turfs = list()
	var/list/dirs_checked = list()

	var/obj/structure/cable/C
	for(C in world) // ew, world
		T = get_turf(C)
		if(T?.z == 1)
			cable_turfs |= get_turf(C)

	for(T in cable_turfs)
		dirs_checked.Cut()
		for(C in T)
			var/combined_dir = "[C.d1]-[C.d2]"
			// is this really needed? grep already handles this i think
			TEST_ASSERT((combined_dir in dirs_checked), "[T.name] ([T.x],[T.y],[T.z]) Contains multiple wires with same direction on top of each other.")
			dirs_checked.Add(combined_dir)

Uncommented , replaced by GREP, doensn't full work properly
*/

/// Conveys all log_mapping messages as unit test failures, as they all indicate mapping problems.
/datum/unit_test/log_mapping
	// Happen before all other tests, to make sure we only capture normal mapping logs.
	priority = TEST_PRE

/datum/unit_test/log_mapping/Run()
	var/static/regex/test_areacoord_regex = regex(@"\(-?\d+,-?\d+,(-?\d+)\)")

	for(var/log_entry in GLOB.unit_test_mapping_logs)
		// Only fail if AREACOORD was conveyed, and it's a station or mining z-level.
		// This is due to mapping errors don't have coords being impossible to diagnose as a unit test,
		// and various ruins frequently intentionally doing non-standard things.
		if(!test_areacoord_regex.Find(log_entry))
			continue
		var/z = text2num(test_areacoord_regex.group[1])
		if(!(z in GLOB.maps_data.station_levels)) // station only
			continue

		TEST_FAIL(log_entry)

