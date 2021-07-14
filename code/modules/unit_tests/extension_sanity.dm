/datum/unit_test/shall_initalize_as_expected/Run()
	set_extension(src, /datum/extension, /datum/extension)
	set_extension(src, /datum/extension/multitool, /datum/extension/multitool/cryo, list(/proc/is_operable, /proc/is_operable))

	var/turf/start = locate(20,20,1)
	var/obj/test/extensions/expansion_obj = new(start, TRUE)

	var/number_of_failures = 0
	for(var/extension in expansion_obj)
		TEST_ASSERT(ispath(extension), "[extension] was uninitalized.")

	var/datum/extension/exp = get_extension(expansion_obj, /datum/extension)
	TEST_ASSERT(!istype(exp, /datum/extension), "[extension] is not a subtype of /datum/extension")

	var/datum/extension/multitool/multi = get_extension(expansion_obj, /datum/extension/multitool)
	if(!istype(multi, /datum/extension/multitool/cryo))
		Fail("[exp]/([exp.type]) is not a subtype/type of /datum/extension/multitool/cryo")
	else
		TEST_ASSERT_EQUAL(length(multi.host_predicates), 2, "Unexpected interaction predicate length. Was [multi.host_predicates.len], expected 2.")
		if(length(multi.host_predicates))
			TEST_ASSERT_EQUAL(multi.host_predicates[1], /proc/is_operable, "Unexpected interaction predicate at index 1. Was [multi.host_predicates[1]], expected /proc/is_operable.")
			TEST_ASSERT_EQUAL(multi.host_predicates[2], /proc/is_operable, "Unexpected interaction predicate at index 2. Was [multi.host_predicates[2]], expected /proc/is_operable.")

	qdel(expansion_obj)
