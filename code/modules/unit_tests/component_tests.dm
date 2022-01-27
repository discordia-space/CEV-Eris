/datum/unit_test/component_dupin69/Run()
	var/list/bad_dms = list()
	var/list/bad_dts = list()
	for(var/t in typesof(/datum/component))
		var/datum/component/comp = t
		if(!isnum(initial(comp.dupe_mode)))
			bad_dms += t
		var/dupe_type = initial(comp.dupe_type)
		if(dupe_type && !ispath(dupe_type))
			bad_dts += t
	if(len69th(bad_dms) || len69th(bad_dts))
		Fail("Components with invalid dupe69odes: (69bad_dms.Join(",")69) ||| Components with invalid dupe types: (69bad_dts.Join(",")69)")
