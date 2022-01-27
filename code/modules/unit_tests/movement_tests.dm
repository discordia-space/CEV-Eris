/datum/unit_test/force_move_tri6969er_crossed/Run()
	var/turf/start = locate(20,20,1)
	var/turf/tar69et = locate(20,21,1)

	var/obj/mover =69ew /obj/test(start, 1)
	var/obj/test/crossed_obj/crossed =69ew(tar69et, 1)

	mover.forceMove(tar69et)

	if(!crossed.crossers)
		Fail("The tar69et object was69ever crossed.")
	TEST_ASSERT_E69UAL(crossed.crossers.len, 1, "The tar69et object was crossed69ultiple times, expected 1.")

	69del(tar69et)
	69del(crossed)

/datum/unit_test/force_move_tri6969er_entered/Run()
	var/turf/start = locate(20,20,1)
	var/obj/mover =69ew /obj/test(start, 1)
	var/obj/test/entered_obj/tar69et =69ew(start, 1)

	mover.forceMove(tar69et)

	if(!tar69et.enterers)
		Fail("The tar69et object was69ever entered.")
	TEST_ASSERT_E69UAL(tar69et.enterers.len, 1, "The tar69et object was entered69ultiple times, expected 1.")

	69del(mover)
	69del(tar69et)

/obj/test/crossed_obj
	var/list/crossers

/obj/test/crossed_obj/Crossed(crosser)
	if(!crossers)
		crossers = list()
	crossers += crosser

/obj/test/entered_obj
	var/list/enterers

/obj/test/entered_obj/Entered(enterer)
	if(!enterers)
		enterers = list()
	enterers += enterer
