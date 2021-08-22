/// Test for glasses & what should they see
/datum/unit_test/glasses_vision

/datum/unit_test/glasses_vision/Run()
	// Pause natural mob life so it can be handled entirely by the test (also we cannot be sure that the allocation space is safe)
	SSmobs.pause()

	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human)

	// Test 1: NVG
	var/expectation = SEE_INVISIBLE_NOLIGHTING
	var/obj/item/clothing/glasses/G = new /obj/item/clothing/glasses/powered/night()
	G.active = TRUE
	H.glasses = G
	TEST_ASSERT_EQUAL(H.glasses, G, "Mob doesn't have glasses [G] on.")
	H.update_equipment_vision()	// Because Life has a client check that bypasses updating vision
	TEST_ASSERT_EQUAL(H.see_invisible, expectation, "Mob See invisible is [H.see_invisible] => expected [expectation] on [G].")
	// Test 1 Cleanup
	QDEL_NULL(H.glasses)
	G = null

	// Test 2: Mesons
	TEST_ASSERT_EQUAL(H.glasses, null, "QDEL_NULL didn't null/delete the item in time.")
	G = new /obj/item/clothing/glasses/powered/meson()
	G.active = TRUE
	H.glasses = G
	TEST_ASSERT_EQUAL(H.glasses, G, "Mob doesn't have glasses [G] on.")
	H.update_equipment_vision()
	TEST_ASSERT_EQUAL(H.see_invisible, expectation, "Mob See invisible is [H.see_invisible] => expected [expectation] on [G].")
	// Test 2 Cleanup
	QDEL_NULL(H.glasses)
	G = null

	// Test 3: Plain Glasses
	expectation = SEE_INVISIBLE_LIVING
	TEST_ASSERT_EQUAL(H.glasses, null, "QDEL_NULL didn't null/delete the item in time.")
	G = new /obj/item/clothing/glasses/regular()
	G.active = TRUE
	H.glasses = G
	TEST_ASSERT_EQUAL(H.glasses, G, "Mob doesn't have glasses [G] on.")
	H.update_equipment_vision()
	TEST_ASSERT_EQUAL(H.see_invisible, expectation, "Mob See invisible is [H.see_invisible] => expected [expectation] on [G].")
	// Test 3 Cleanup
	QDEL_NULL(H.glasses)
	G = null

/datum/unit_test/glasses_vision/Destroy()
	SSmobs.ignite()
	return ..()

