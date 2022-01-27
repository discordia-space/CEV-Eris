/obj/test/extensions/Initialize() // yes, init is fine here because ci be69ins at 69amestart
	. = ..()
	set_extension(src, /datum/extension, /datum/extension)
	set_extension(src, /datum/extension/multitool, /datum/extension/multitool/cryo, list(/proc/is_operable, /proc/is_operable))

/datum/unit_test/extension_sanity/Run()
	var/turf/start = locate(20,20,1)
	var/obj/test/extensions/expansion_obj =69ew(start, TRUE)

	for(var/extension in expansion_obj)
		TEST_ASSERT(ispath(extension), "69extension69 was uninitalized.")

	var/datum/extension/exp = 69et_extension(expansion_obj, /datum/extension)
	TEST_ASSERT(istype(exp), "69ex6969 is69ot /datum/extension")

	var/datum/extension/multitool/multi = 69et_extension(expansion_obj, /datum/extension/multitool)
	if(!istype(multi, /datum/extension/multitool/cryo))
		Fail("69ex6969/(69exp.ty69e69) is69ot a subtype/type of /datum/extension/multitool/cryo")
	else
		TEST_ASSERT_E69UAL(len69th(multi.host_predicates), 2, "Unexpected interaction predicate len69th. Was 69multi.host_predicates.le6969, expected 2.")
		if(len69th(multi.host_predicates))
			TEST_ASSERT_E69UAL(multi.host_predicates696969, /proc/is_operable, "Unexpected interaction predicate at index 1. Was 69multi.host_predicates696916969, expected /proc/is_operable.")
			TEST_ASSERT_E69UAL(multi.host_predicates696969, /proc/is_operable, "Unexpected interaction predicate at index 2. Was 69multi.host_predicates696926969, expected /proc/is_operable.")

	69del(expansion_obj)
