/client/proc/tracy_next_round()
	set name = "Toggle Tracy Next Round"
	set desc = "Toggle running the byond-tracy profiler next round"
	set category = "Debug"
	if(!check_rights_for(src, R_DEBUG))
		return
#ifndef OPENDREAM
	if(!fexists(TRACY_DLL_PATH))
		to_chat(src, span_danger("byond-tracy library ([TRACY_DLL_PATH]) not present!"))
		return
	if(fexists(TRACY_ENABLE_PATH))
		fdel(TRACY_ENABLE_PATH)
	else
		rustg_file_write("[ckey]", TRACY_ENABLE_PATH)
	message_admins(span_adminnotice("[key_name_admin(src)] [fexists(TRACY_ENABLE_PATH) ? "enabled" : "disabled"] the byond-tracy profiler for next round."))
	log_admin("[key_name(src)] [fexists(TRACY_ENABLE_PATH) ? "enabled" : "disabled"] the byond-tracy profiler for next round.")
#else
	to_chat(src, span_danger("byond-tracy is not supported on OpenDream, sorry!"))
#endif

/client/proc/start_tracy()
	set name = "Run Tracy Now"
	set desc = "Start running the byond-tracy profiler immediately."
	set category = "Debug"
	if(!check_rights_for(src, R_DEBUG))
		return
#ifndef OPENDREAM
	if(GLOB.tracy_initialized)
		to_chat(src, span_warning("byond-tracy is already running!"))
		return
	else if(GLOB.tracy_init_error)
		to_chat(src, span_danger("byond-tracy failed to initialize during an earlier attempt: [GLOB.tracy_init_error]"))
		return
	else if(!fexists(TRACY_DLL_PATH))
		to_chat(src, span_danger("byond-tracy library ([TRACY_DLL_PATH]) not present!"))
		return
	message_admins(span_adminnotice("[key_name_admin(src)] is trying to start the byond-tracy profiler."))
	log_admin("[key_name(src)] is trying to start the byond-tracy profiler.")
	GLOB.tracy_initialized = FALSE
	GLOB.tracy_init_reason = "[ckey]"
	world.init_byond_tracy()
	if(GLOB.tracy_init_error)
		to_chat(src, span_danger("byond-tracy failed to initialize: [GLOB.tracy_init_error]"))
		message_admins(span_adminnotice("[key_name_admin(src)] tried to start the byond-tracy profiler, but it failed to initialize ([GLOB.tracy_init_error])"))
		log_admin("[key_name(src)] tried to start the byond-tracy profiler, but it failed to initialize ([GLOB.tracy_init_error])")
		return
	to_chat(src, span_notice("byond-tracy successfully started!"))
	message_admins(span_adminnotice("[key_name_admin(src)] started the byond-tracy profiler."))
	log_admin("[key_name(src)] started the byond-tracy profiler.")
	if(GLOB.tracy_log)
		rustg_file_write("[GLOB.tracy_log]", "[GLOB.log_directory]/tracy.loc")
#else
	to_chat(src, span_danger("byond-tracy is not supported on OpenDream, sorry!"))
#endif
