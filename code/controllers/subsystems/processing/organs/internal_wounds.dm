PROCESSING_SUBSYSTEM_DEF(internal_wounds)
	name = "Internal Wounds"
	priority = SS_PRIORITY_I_WOUNDS // Fires after mob Life()
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS
	//(8ms|33%(23%)|0 P:194, roughly the same without)
