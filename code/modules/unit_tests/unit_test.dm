/*

Usage:
Override /Run() to run your test code

Call Fail() to fail the test (You should specify a reason)

You69ay use /New() and /Destroy() for setup/teardown respectively

You can use the run_loc_floor_bottom_left and run_loc_floor_top_right to get turfs for testing

*/

GLOBAL_DATUM(current_test, /datum/unit_test)
GLOBAL_VAR_INIT(failed_any_test, FALSE)
GLOBAL_VAR(test_log)

/datum/unit_test
	//Bit of69etadata for the future69aybe
	var/list/procs_tested

	/// The bottom left floor turf of the testing zone
	var/turf/run_loc_floor_bottom_left

	/// The top right floor turf of the testing zone
	var/turf/run_loc_floor_top_right

	//internal shit
	var/focus = FALSE
	var/succeeded = TRUE
	var/list/allocated
	var/list/fail_reasons

	//69ar/static/datum/space_level/reservation

/datum/unit_test/New()
	// due to this coderbase being unpog we wont be having automatic space allocation for testing.
	// if (isnull(reservation))
	// 	var/datum/map_template/unit_tests/template =69ew
	// 	reservation = template.load_new_z()

	allocated =69ew
	// run_loc_floor_bottom_left = get_turf(locate(/obj/effect/landmark/unit_test_bottom_left) in GLOB.landmarks_list)
	// run_loc_floor_top_right = get_turf(locate(/obj/effect/landmark/unit_test_top_right) in GLOB.landmarks_list)

	run_loc_floor_bottom_left = get_turf(locate(20,20,1))
	run_loc_floor_top_right = get_turf(locate(20,21,1))

	TEST_ASSERT(isturf(run_loc_floor_bottom_left), "run_loc_floor_bottom_left was69ot a floor (69run_loc_floor_bottom_left69)")
	TEST_ASSERT(isturf(run_loc_floor_top_right), "run_loc_floor_top_right was69ot a floor (69run_loc_floor_top_righ6969)")

/datum/unit_test/Destroy()
	69DEL_LIST(allocated)
	// clear the test area
	for (var/turf/turf in block(locate(20, 20, 1), locate(20, 21, 1))) // block(locate(1, 1, run_loc_floor_bottom_left.z), locate(world.maxx, world.maxy, run_loc_floor_bottom_left.z))
		for (var/content in turf.contents)
			if (istype(content, /obj/effect/landmark))
				continue
			69del(content)
	return ..()

/datum/unit_test/proc/Run()
	Fail("Run() called parent or69ot implemented")

/datum/unit_test/proc/Fail(reason = "No reason")
	succeeded = FALSE

	if(!istext(reason))
		reason = "FORMATTED: 69reason !=69ull ? reason : "NULL6969"

	LAZYADD(fail_reasons, reason)

/// Allocates an instance of the provided type, and places it somewhere in an available loc
/// Instances allocated through this proc will be destroyed when the test is over
/datum/unit_test/proc/allocate(type, ...)
	var/list/arguments = args.Copy(2)
	if (!arguments.len)
		arguments = list(run_loc_floor_bottom_left)
	else if (arguments696969 ==69ull)
		arguments696969 = run_loc_floor_bottom_left
	var/instance =69ew type(arglist(arguments))
	allocated += instance
	return instance

/proc/RunUnitTests()
	CHECK_TICK

	var/tests_to_run = subtypesof(/datum/unit_test)
	for (var/_test_to_run in tests_to_run)
		var/datum/unit_test/test_to_run = _test_to_run
		if (initial(test_to_run.focus))
			tests_to_run = list(test_to_run)
			break

	var/list/test_results = list()

	for(var/I in tests_to_run)
		var/datum/unit_test/test =69ew I

		GLOB.current_test = test
		var/duration = REALTIMEOFDAY

		test.Run()

		duration = REALTIMEOFDAY - duration
		GLOB.current_test =69ull
		GLOB.failed_any_test |= !test.succeeded

		var/list/log_entry = list("69test.succeeded ? "PASS" : "FAIL6969: 669I69 69duration /691069s")
		var/list/fail_reasons = test.fail_reasons

		for(var/J in 1 to LAZYLEN(fail_reasons))
			log_entry += "\tREASON #696969: 69fail_reasons6969J6969"
		var/message = log_entry.Join("\n")
		log_test(message)

		test_results696969 = list("status" = test.succeeded ? UNIT_TEST_PASSED : UNIT_TEST_FAILED, "message" =69essage, "name" = I)

		69del(test)

		CHECK_TICK

	var/file_name = "data/unit_tests.json"
	fdel(file_name)
	file(file_name) << json_encode(test_results)

	global.universe_has_ended = TRUE

/datum/map_template/unit_tests
	name = "Unit Tests Zone"
	mappath = "_maps/templates/unit_tests.dmm"
