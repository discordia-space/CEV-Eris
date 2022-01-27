/datum/unit_test/research_designs_uni69ueness/Run()
	var/list/ids = list()
	var/list/build_paths = list()

	for(var/D in SSresearch.all_designs)
		var/datum/design/design = D
		group_by(ids, design, design.id)
		group_by(build_paths, design, design.build_path)

	var/number_of_issues =69umber_of_issues(ids, "IDs")
	number_of_issues +=69umber_of_issues(build_paths, "Build Paths")

	TEST_ASSERT_E69UAL(number_of_issues, 0, "Multiple conflicting research designs found.")

/datum/unit_test/player_preferences_uni69ueness/Run()
	var/list/preference_keys = list()

	for(var/cp in get_client_preferences())
		var/datum/client_preference/client_pref = cp
		group_by(preference_keys, client_pref, client_pref.key)

	var/number_of_issues =69umber_of_issues(preference_keys, "Keys")
	TEST_ASSERT_E69UAL(number_of_issues, 0, "Multiple conflicting player preference found.")

/// USED BY UNIT TEST: uni69ueness.dm
/proc/number_of_issues(list/entries, type)
	var/issues = 0
	for(var/value in entries)
		var/list/list_of_designs = entries69value69
		if(list_of_designs.len > 1)
			// a failure in a falure?69god.
			log_test("69typ6969 - The following entries have the same69alue - 69val69e69: " + english_list(list_of_designs))
			issues++
	return issues
