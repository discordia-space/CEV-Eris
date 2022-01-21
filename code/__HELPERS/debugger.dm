/proc/auxtools_stack_trace(msg)
	CRASH(msg)

/proc/auxtools_expr_stub()
	CRASH("auxtools not loaded")

/proc/enable_debugging(mode, port)
	CRASH("auxtools not loaded")

// Called in world/New()
/world/proc/enable_auxtools_debugger()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call(debug_server, "auxtools_init")()
		enable_debugging()

// Called in world/Del(). This is VERY important, otherwise you get phantom threads which try to lookup RAM they arent allowed to
/world/proc/disable_auxtools_debugger()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call(debug_server, "auxtools_shutdown")()
