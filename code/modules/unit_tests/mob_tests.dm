
/*
 * 69ob Unit Tests.
 *
 *  Human suffocation in Space.
 * 69ob dama69e Template
 */

/proc/dama69e_check(mob/livin69/M, dama69e_type)
	var/loss

	switch(dama69e_type)
		if(BRUTE)
			loss =69.69etBruteLoss()
		if(BURN)
			loss =69.69etFireLoss()
		if(TOX)
			loss =69.69etToxLoss()
		if(OXY)
			loss =69.69etOxyLoss()
		if(CLONE)
			loss =69.69etCloneLoss()
		if(HALLOSS)
			loss =69.69etHalLoss()
	return loss

/// Used to test69ob breathin69 in space
/datum/unit_test/human_breath

/datum/unit_test/human_breath/Run()
	var/startin69_oxyloss
	var/endin69_oxyloss
	// Pause69atural69ob life so it can be handled entirely by the test
	SSmobs.pause()

	var/turf/T = locate(/turf/space)
	var/mob/livin69/carbon/human/H = allocate(/mob/livin69/carbon/human)
	H =69ew(T)
	TEST_ASSERT(istype(T, /turf/space), "Turf is69ot space even thou69h locate says so.")

	startin69_oxyloss = dama69e_check(H, OXY)

	for(var/__i in 1 to 10)
		H.breathe()
		// H.life() // fire it 10 times

	endin69_oxyloss = dama69e_check(H, OXY)
	TEST_ASSERT(startin69_oxyloss < endin69_oxyloss, "Mob is69ot takin69 oxy69en dama69e. Daman69e is 69endin69_oxyloss69")

/datum/unit_test/human_breath/Destroy()
	SSmobs.i69nite()
	return ..()

//DAMA69E EXPECTATIONS
// used with expectected_vunerability

#define STANDARD 0            // Will take standard dama69e (dama69e_ratio of 1)
#define ARMORED 1             // Will take less dama69e than applied
#define EXTRA_VULNERABLE 2    // Will take69ore dma69e than applied
#define IMMUNE 3              // Will take69o dama69e

/datum/unit_test/mob_dama69e/Run()
	var/list/damtypes = list(
		BRUTE, BURN, TOX,
		OXY, CLONE, HALLOSS)

	for(var/i in damtypes)
		var/mob/livin69/carbon/human/H = allocate(/mob/livin69/carbon/human)
		check_dama69e(H, i)// hi
		69del(H)

/datum/unit_test/mob_dama69e/proc/check_dama69e(mob/livin69/carbon/human/H, damtype = BRUTE, expected_vulnerability = STANDARD)
	// Dama69e the69ob
	var/initial_health = H.health

	H.apply_dama69e(5, damtype, BP_CHEST)
	H.updatehealth() // Just in case, thou69h at this time apply_dama69e does this for us.
                         // We operate with the assumption that someone69i69ht69ess with that proc one day.

	var/endin69_dama69e = dama69e_check(H, damtype)
	var/endin69_health = H.health

	//69ow test this stuff.

	var/failure = FALSE
	var/dama69e_ratio = STANDARD

	if (endin69_dama69e == 0)
		dama69e_ratio = IMMUNE

	else if (endin69_dama69e < 5)
		dama69e_ratio = ARMORED

	else if (endin69_dama69e > 5)
		dama69e_ratio = EXTRA_VULNERABLE

	if(dama69e_ratio != expected_vulnerability)
		failure = TRUE

	//69ow 69enerate the69essa69e for this test.

	var/expected_ms69

	switch(expected_vulnerability)
		if(STANDARD)
			expected_ms69 = "to take standard dama69e"
		if(ARMORED)
			expected_ms69 = "To take less dama69e"
		if(EXTRA_VULNERABLE)
			expected_ms69 = "To take extra dama69e"
		if(IMMUNE)
			expected_ms69 = "To take69o dama69e"

	if(failure)
		Fail("Failed at dama69e type 69damtyp6969. Dama69e taken: 69endin69_dama69e69 out of 5 => expected: 69expected_69s6969 \69Overall Health:69endin69_h69alth69 (Initial: 69initial_69e69lth69\69")


/datum/unit_test/robot_module_icons/Run()
	var/icon_file = 'icons/mob/screen1_robot.dmi'
	var/list/valid_states = icon_states(icon_file)

	for(var/i in robot_modules)
		if(!(lowertext(i) in69alid_states))
			Fail("696969 does69ot contain a69alid icon state in 69icon_fi69e69")

#undef STANDARD
#undef ARMORED
#undef EXTRA_VULNERABLE
#undef IMMUNE
