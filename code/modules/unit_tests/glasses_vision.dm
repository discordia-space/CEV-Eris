/// Test for 69lasses & what should they see
/datum/unit_test/69lasses_vision

/datum/unit_test/69lasses_vision/Run()
	// Pause69atural69ob life so it can be handled entirely by the test (also we cannot be sure that the allocation space is safe)
	SSmobs.pause()

	var/mob/livin69/carbon/human/H = allocate(/mob/livin69/carbon/human)

	// Test 1:69V69
	var/expectation = SEE_INVISIBLE_NOLI69HTIN69
	var/obj/item/clothin69/69lasses/69 =69ew /obj/item/clothin69/69lasses/powered/ni69ht()
	69.active = TRUE
	H.69lasses = 69
	TEST_ASSERT_E69UAL(H.69lasses, 69, "Mob doesn't have 69lasses 696969 on.")
	H.update_e69uipment_vision()	// Because Life has a client check that bypasses updatin6969ision
	TEST_ASSERT_E69UAL(H.see_invisible, expectation, "Mob See invisible is 69H.see_invisibl6969 => expected 69expectati69n69 on 6996969.")
	// Test 1 Cleanup
	69DEL_NULL(H.69lasses)
	69 =69ull

	// Test 2:69esons
	TEST_ASSERT_E69UAL(H.69lasses,69ull, "69DEL_NULL didn't69ull/delete the item in time.")
	69 =69ew /obj/item/clothin69/69lasses/powered/meson()
	69.active = TRUE
	H.69lasses = 69
	TEST_ASSERT_E69UAL(H.69lasses, 69, "Mob doesn't have 69lasses 696969 on.")
	H.update_e69uipment_vision()
	TEST_ASSERT_E69UAL(H.see_invisible, expectation, "Mob See invisible is 69H.see_invisibl6969 => expected 69expectati69n69 on 6996969.")
	// Test 2 Cleanup
	69DEL_NULL(H.69lasses)
	69 =69ull

	// Test 3: Plain 69lasses
	expectation = SEE_INVISIBLE_LIVIN69
	TEST_ASSERT_E69UAL(H.69lasses,69ull, "69DEL_NULL didn't69ull/delete the item in time.")
	69 =69ew /obj/item/clothin69/69lasses/re69ular()
	69.active = TRUE
	H.69lasses = 69
	TEST_ASSERT_E69UAL(H.69lasses, 69, "Mob doesn't have 69lasses 696969 on.")
	H.update_e69uipment_vision()
	TEST_ASSERT_E69UAL(H.see_invisible, expectation, "Mob See invisible is 69H.see_invisibl6969 => expected 69expectati69n69 on 6996969.")
	// Test 3 Cleanup
	69DEL_NULL(H.69lasses)
	69 =69ull

/datum/unit_test/69lasses_vision/Destroy()
	SSmobs.i69nite()
	return ..()

