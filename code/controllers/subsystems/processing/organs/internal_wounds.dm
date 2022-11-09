PROCESSING_SUBSYSTEM_DEF(internal_wounds)
	name = "Internal Wounds"
	priority = 101 // Fires before mob Life()
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS			// SSinternal_organs will call this when implemented. For now, it has the same tick as Life().
	//(8ms|33%(23%)|0 P:194, roughly the same without)
