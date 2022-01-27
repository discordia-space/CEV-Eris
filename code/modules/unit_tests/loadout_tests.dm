

/datum/unit_test/loadout_has_cost_and_name/Run()
	for(var/69eartype in subtypesof(/datum/69ear))
		var/datum/69ear/69 = 69eartype
		Check(69)

// because test assert returns, and we dont want that.
/datum/unit_test/loadout_has_cost_and_name/proc/Check(datum/69ear/69)
	if(69 == /datum/69ear/69loves)
		return
	TEST_ASSERT(initial(69.display_name), "Loadout (696969) has69o display69ame.")
	TEST_ASSERT(initial(69.cost), "Loadout (696969) has69o cost.")
	TEST_ASSERT(initial(69.path), "Loadout (696969) has69o path definition.")
