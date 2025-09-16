/client/proc/tracy_next_round()
	set name = "Toggle Tracy Next Round"
	set desc = "Toggle running the byond-tracy profiler next round"
	set category = "Debug"
	if(!check_rights(R_DEBUG))
		return
#ifndef OPENDREAM_REAL
	if(!fexists(TRACY_DLL_PATH))
		to_chat(src, span_danger("byond-tracy library ([TRACY_DLL_PATH]) not present!"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	else if (!CONFIG_GET(flag/allow_tracy_queue))
		to_chat(src, span_danger("byond-tracy is not allowed in the config!"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	if(fexists(TRACY_ENABLE_PATH))
		fdel(TRACY_ENABLE_PATH)
	else
		rustg_file_write("[ckey]", TRACY_ENABLE_PATH)
	message_admins(span_adminnotice("[key_name_admin(src)] [fexists(TRACY_ENABLE_PATH) ? "enabled" : "disabled"] the byond-tracy profiler for next round."))
	log_admin("[key_name(src)] [fexists(TRACY_ENABLE_PATH) ? "enabled" : "disabled"] the byond-tracy profiler for next round.")
#else
	to_chat(src, span_danger("byond-tracy is not supported on OpenDream, sorry!"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
#endif

/client/proc/start_tracy()
	set name = "Run Tracy Now"
	set desc = "Start running the byond-tracy profiler immediately."
	set category = "Debug"
	if(!check_rights(R_DEBUG))
		return
#ifndef OPENDREAM_REAL
	if(Tracy.enabled)
		to_chat(src, span_warning("byond-tracy is already running!"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	else if(Tracy.error)
		to_chat(src, span_danger("byond-tracy failed to initialize during an earlier attempt: [Tracy.error]"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	else if(!fexists(TRACY_DLL_PATH))
		to_chat(src, span_danger("byond-tracy library ([TRACY_DLL_PATH]) not present!"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	else if (!CONFIG_GET(flag/allow_tracy_start))
		to_chat(src, span_danger("byond-tracy is not allowed in the config!"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return

	message_admins(span_adminnotice("[key_name_admin(src)] is trying to start the byond-tracy profiler."))
	log_admin("[key_name(src)] is trying to start the byond-tracy profiler.")
	if(!Tracy.enable("[ckey]"))
		to_chat(src, span_danger("byond-tracy failed to initialize: [Tracy.error]"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		message_admins(span_adminnotice("[key_name_admin(src)] tried to start the byond-tracy profiler, but it failed to initialize ([Tracy.error])"))
		log_admin("[key_name(src)] tried to start the byond-tracy profiler, but it failed to initialize ([Tracy.error])")
		return
	to_chat(src, span_notice("byond-tracy successfully started!"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
	message_admins(span_adminnotice("[key_name_admin(src)] started the byond-tracy profiler."))
	log_admin("[key_name(src)] started the byond-tracy profiler.")
	if(Tracy.trace_path)
		rustg_file_write("[Tracy.trace_path]", "[GLOB.log_directory]/tracy.loc")
#else
	to_chat(src, span_danger("byond-tracy is not supported on OpenDream, sorry!"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
#endif
