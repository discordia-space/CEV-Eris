/*

Usage:
Override /Run() to run your test code

Call TEST_FAIL() to fail the test (You should specify a reason)

You may use /New() and /Destroy() for setup/teardown respectively

You can use the run_loc_floor_bottom_left and run_loc_floor_top_right to get turfs for testing

*/

GLOBAL_DATUM(current_test, /datum/unit_test)
GLOBAL_VAR_INIT(failed_any_test, FALSE)
GLOBAL_VAR(test_log)
/// When unit testing, all logs sent to log_mapping are stored here and retrieved in log_mapping unit test.
GLOBAL_LIST_EMPTY(unit_test_mapping_logs)

/datum/unit_test
	//Bit of metadata for the future maybe
	var/list/procs_tested

	/// The bottom left floor turf of the testing zone
	var/turf/run_loc_floor_bottom_left

	/// The top right floor turf of the testing zone
	var/turf/run_loc_floor_top_right

	///The priority of the test, the larger it is the later it fires
	var/priority = TEST_DEFAULT
	//internal shit
	var/focus = FALSE
	var/succeeded = TRUE
	var/list/allocated
	var/list/fail_reasons


/proc/cmp_unit_test_priority(datum/unit_test/a, datum/unit_test/b)
	return initial(a.priority) - initial(b.priority)

/datum/unit_test/New()
	// due to this coderbase being unpog we wont be having automatic space allocation for testing.
	// if (isnull(reservation))
	// 	var/datum/map_template/unit_tests/template = new
	// 	reservation = template.load_new_z()

	allocated = new
	// run_loc_floor_bottom_left = get_turf(locate(/obj/effect/landmark/unit_test_bottom_left) in GLOB.landmarks_list)
	// run_loc_floor_top_right = get_turf(locate(/obj/effect/landmark/unit_test_top_right) in GLOB.landmarks_list)

	run_loc_floor_bottom_left = get_turf(locate(20,20,1))
	run_loc_floor_top_right = get_turf(locate(20,21,1))

	TEST_ASSERT(isturf(run_loc_floor_bottom_left), "run_loc_floor_bottom_left was not a floor ([run_loc_floor_bottom_left])")
	TEST_ASSERT(isturf(run_loc_floor_top_right), "run_loc_floor_top_right was not a floor ([run_loc_floor_top_right])")

/datum/unit_test/Destroy()
	QDEL_LIST(allocated)
	// clear the test area
	for (var/turf/turf in block(locate(1, 1, run_loc_floor_bottom_left.z), locate(world.maxx, world.maxy, run_loc_floor_bottom_left.z)))
		for (var/content in turf.contents)
			qdel(content)
	return ..()

/datum/unit_test/proc/Run()
	TEST_FAIL("Run() called parent or not implemented")

/datum/unit_test/proc/Fail(reason = "No reason", file = "OUTDATED_TEST", line = 1)
	succeeded = FALSE

	if(!istext(reason))
		reason = "FORMATTED: [reason != null ? reason : "NULL"]"

	LAZYADD(fail_reasons, list(list(reason, file, line)))

/// Allocates an instance of the provided type, and places it somewhere in an available loc
/// Instances allocated through this proc will be destroyed when the test is over
/datum/unit_test/proc/allocate(type, ...)
	var/list/arguments = args.Copy(2)
	if (!arguments.len)
		arguments = list(run_loc_floor_bottom_left)
	else if (arguments[1] == null)
		arguments[1] = run_loc_floor_bottom_left
	var/instance = new type(arglist(arguments))
	allocated += instance
	return instance

/datum/unit_test/proc/test_screenshot(name, icon/icon)
	if (!istype(icon))
		TEST_FAIL("[icon] is not an icon.")
		return

	var/path_prefix = replacetext(replacetext("[type]", "/datum/unit_test/", ""), "/", "_")
	name = replacetext(name, "/", "_")

	var/filename = "code/modules/unit_tests/screenshots/[path_prefix]_[name].png"

	if (fexists(filename))
		var/data_filename = "data/screenshots/[path_prefix]_[name].png"
		fcopy(icon, data_filename)
		log_test("[path_prefix]_[name] was found, putting in data/screenshots")
	else if (fexists("code"))
		// We are probably running in a local build
		fcopy(icon, filename)
		TEST_FAIL("Screenshot for [name] did not exist. One has been created.")
	else
		// We are probably running in real CI, so just pretend it worked and move on
		fcopy(icon, "data/screenshots_new/[path_prefix]_[name].png")

		log_test("[path_prefix]_[name] was put in data/screenshots_new")

/proc/RunUnitTest(test_path, list/test_results)
	var/datum/unit_test/test = new test_path

	GLOB.current_test = test
	var/duration = REALTIMEOFDAY

	test.Run()

	duration = REALTIMEOFDAY - duration
	GLOB.current_test = null
	GLOB.failed_any_test |= !test.succeeded

	var/list/log_entry = list(
		"[test.succeeded ? TEST_OUTPUT_GREEN("PASS") : TEST_OUTPUT_RED("FAIL")]: [test_path] [duration / 10]s",
	)
	var/list/fail_reasons = test.fail_reasons
	// var/map_name = SSmapping.config.map_name

	for(var/reasonID in 1 to LAZYLEN(fail_reasons))
		var/text = fail_reasons[reasonID][1]
		var/file = fail_reasons[reasonID][2]
		var/line = fail_reasons[reasonID][3]

		// Github action annotation.
		// See https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions

		// Need to escape the text to properly support newlines.
		var/annotation_text = replacetext(text, "%", "%25")
		annotation_text = replacetext(annotation_text, "\n", "%0A")

		log_world("::error file=[file],line=[line],title=[station_name]: [test_path]::[annotation_text]")

		// Normal log message
		log_entry += "\tREASON #[reasonID]: [text] at [file]:[line]"

	var/message = log_entry.Join("\n")
	log_test(message)

	test_results[test_path] = list("status" = test.succeeded ? UNIT_TEST_PASSED : UNIT_TEST_FAILED, "message" = message, "name" = test_path)

	qdel(test)

/proc/RunUnitTests()
	CHECK_TICK

	var/list/tests_to_run = subtypesof(/datum/unit_test)
	var/list/focused_tests = list()
	for (var/_test_to_run in tests_to_run)
		var/datum/unit_test/test_to_run = _test_to_run
		if (initial(test_to_run.focus))
			focused_tests += test_to_run
	if(length(focused_tests))
		tests_to_run = focused_tests

	tests_to_run = sortTim(tests_to_run, /proc/cmp_unit_test_priority)

	var/list/test_results = list()

	for(var/unit_path in tests_to_run)
		CHECK_TICK //We check tick first because the unit test we run last may be so expensive that checking tick will lock up this loop forever
		RunUnitTest(unit_path, test_results)

	var/file_name = "data/unit_tests.json"
	fdel(file_name)
	file(file_name) << json_encode(test_results)

	global.universe_has_ended = TRUE

/datum/map_template/unit_tests
	name = "Unit Tests Zone"
	mappath = "_maps/templates/unit_tests.dmm"
