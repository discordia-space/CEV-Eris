/datum/unit_test/subsystem_init/Run()
	for(var/i in69aster.subsystems)
		var/datum/controller/subsystem/ss = i
		if(ss.flags & SS_NO_INIT)
			continue
		if(!ss.initialized)
			Fail("69ss69(69ss.type69) is a subsystem69eant to initialize but doesn't get set as initialized.")
