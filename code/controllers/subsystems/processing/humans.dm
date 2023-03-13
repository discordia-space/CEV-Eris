PROCESSING_SUBSYSTEM_DEF(humans)
	name = "Humans"
	priority = SS_PRIORITY_HUMAN
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS

	process_proc = /mob/proc/Life
