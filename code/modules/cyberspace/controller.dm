PROCESSING_SUBSYSTEM_DEF(CyberAvatarsAI)
	name = "CyberAvatarsAI"
	priority = SS_PRIORITY_CYBERAVATAR
	flags = SS_KEEP_TIMING|SS_NO_INIT|SS_BACKGROUND
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS

	process_proc = /datum/CyberSpaceAvatar/proc/Proccess
