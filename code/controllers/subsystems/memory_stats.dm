#ifndef OPENDREAM
// byond-memorystats does not work on OpenDream, as it relies on functions exported from byondcore.dll / libbyond.so
SUBSYSTEM_DEF(memory_stats)
	name = "Memory Statistics"
	wait = 5 MINUTES
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

/datum/controller/subsystem/memory_stats/Initialize()
	if(!rustg_file_exists(MEMORYSTATS_DLL_PATH))
		flags |= SS_NO_FIRE
		return ..()
	fire()
	return ..()

// TODO: Figure out why this still being fired even if it doesnt exist. onlinx
/datum/controller/subsystem/memory_stats/fire(resumed)
	var/memory_summary = get_memory_stats()
	if(memory_summary)
		var/timestamp = time2text(world.timeofday, "YYYY-MM-DD_hh-mm-ss")
		rustg_file_write(memory_summary, "[GLOB.log_directory]/profiler/memstat-[timestamp].txt")

/datum/controller/subsystem/memory_stats/proc/get_memory_stats()
	var/result = trimtext(call_ext(MEMORYSTATS_DLL_PATH, "memory_stats")())
	if(!findtext(result, "Server mem usage:"))
		CRASH("byond-memorystats call errored: [result || "(null)"]")
	return result
#endif

/client/proc/server_memory_stats()
	set name = "Server Memory Stats"
	set category = "Debug"
	set desc = "Print various statistics about the server's current memory usage (does not work on OpenDream)"

	if(!check_rights(R_DEBUG))
		return
	var/box_color = "red"
#ifndef OPENDREAM
	var/result = SSmemory_stats?.initialized ? span_danger("Error fetching memory statistics!") : span_warning("SSmemory_stats hasn't been initialized yet!")
	var/memory_stats = trimtext(replacetext(SSmemory_stats.get_memory_stats(), "Server mem usage:", ""))
	if(length(memory_stats))
		result = memory_stats
		box_color = "purple"
#else
	var/result = span_danger("Memory statistics not supported on OpenDream, sorry!")
#endif
	to_chat(src, fieldset_block("Memory Statistics", result, "boxed_message [box_color]_box") /*avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE*/)
