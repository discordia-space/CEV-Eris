/datum/unit_test/loadout_has_cost_and_name/Run()
	for(var/geartype in subtypesof(/datum/gear))
		var/datum/gear/G = geartype
		Check(G)

// because test assert returns, and we dont want that.
/datum/unit_test/loadout_has_cost_and_name/proc/Check(datum/gear/G)
	if(G == /datum/gear/gloves)
		return
	TEST_ASSERT(initial(G.display_name), "Loadout ([G]) has no display name.")
	TEST_ASSERT(initial(G.cost), "Loadout ([G]) has no cost.")
	TEST_ASSERT(initial(G.path), "Loadout ([G]) has no path definition.")
