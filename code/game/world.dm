
/*
	The initialization of the game happens roughly like this:

	1. All global variables are initialized (including the global_init and tgstation's master controller instances including subsystems).
	2. The map is initialized, and map objects are created.
	3. world/New() runs.
	4. tgstation's MC runs initialization for various subsystems (refer to its own defines for the load order).

*/

#define RESTART_COUNTER_PATH "data/round_counter.txt"
/// Load byond-tracy. If USE_BYOND_TRACY is defined, then this is ignored and byond-tracy is always loaded.
#define USE_TRACY_PARAMETER "tracy"
/// Force the log directory to be something specific in the data/logs folder
#define OVERRIDE_LOG_DIRECTORY_PARAMETER "log-directory"
/// Prevent the master controller from starting automatically
#define NO_INIT_PARAMETER "no-init"

GLOBAL_VAR(restart_counter)

/**
 * THIS !!!SINGLE!!! PROC IS WHERE ANY FORM OF INIITIALIZATION THAT CAN'T BE PERFORMED IN SUBSYSTEMS OR WORLD/NEW IS DONE
 * NOWHERE THE FUCK ELSE
 * I DON'T CARE HOW MANY LAYERS OF DEBUG/PROFILE/TRACE WE HAVE, YOU JUST HAVE TO DEAL WITH THIS PROC EXISTING
 * I'M NOT EVEN GOING TO TELL YOU WHERE IT'S CALLED FROM BECAUSE I'M DECLARING THAT FORBIDDEN KNOWLEDGE
 * SO HELP ME GOD IF I FIND ABSTRACTION LAYERS OVER THIS!
 */
/world/proc/Genesis(tracy_initialized = FALSE)
	RETURN_TYPE(/datum/controller/master)

	if(!tracy_initialized)
		Tracy = new
#ifdef USE_BYOND_TRACY
		if(Tracy.enable("USE_BYOND_TRACY defined"))
			Genesis(tracy_initialized = TRUE)
			return
#else
		var/tracy_enable_reason
		if(USE_TRACY_PARAMETER in params)
			tracy_enable_reason = "world.params"
		if(fexists(TRACY_ENABLE_PATH))
			tracy_enable_reason ||= "enabled for round"
			SEND_TEXT(world.log, "[TRACY_ENABLE_PATH] exists, initializing byond-tracy!")
			fdel(TRACY_ENABLE_PATH)
		if(!isnull(tracy_enable_reason) && Tracy.enable(tracy_enable_reason))
			Genesis(tracy_initialized = TRUE)
			return
#endif

	Profile(PROFILE_RESTART)
	Profile(PROFILE_RESTART, type = "sendmaps")

	// Write everything to this log file until we get to SetupLogs() later
	_initialize_log_files("data/logs/config_error.[GUID()].log")

	// Init the debugger first so we can debug Master
	Debugger = new

	// Create the logger
	logger = new

	// THAT'S IT, WE'RE DONE, THE. FUCKING. END.
	Master = new

// /*
// 	Pre-map initialization stuff should go here.
// */



// something something port genesis
// something something long ass rant about initialization

/**
 * World creation
 *
 * Here is where a round itself is actually begun and setup.
 * * db connection setup
 * * config loaded from files
 * * loads admins
 * * and most importantly, calls initialize on the master subsystem, starting the game loop that causes the rest of the game to begin processing and setting up
 *
 *
 * Nothing happens until something moves. ~Albert Einstein
 *
 * For clarity, this proc gets triggered later in the initialization pipeline, it is not the first thing to happen, as it might seem.
 *
 * Initialization Pipeline:
 * Global vars are new()'ed, (including config, glob, and the master controller will also new and preinit all subsystems when it gets new()ed)
 * Compiled in maps are loaded (mainly centcom). all areas/turfs/objs/mobs(ATOMs) in these maps will be new()ed
 * world/New() (You are here)
 * Once world/New() returns, client's can connect.
 * 1 second sleep
 * Master Controller initialization.
 * Subsystem initialization.
 * Non-compiled-in maps are maploaded, all atoms are new()ed
 * All atoms in both compiled and uncompiled maps are initialized()
 */
/world/New()
	log_world("Genesis over, loading world...")
	//logs
	href_logfile = file("[GLOB.log_directory]/hrefs.htm")

	// DO NOT MOVE config.Load() HERE BY ANY MEANS! Turfs require on configurations which is loaded in the Master controller that loads global_vars
	InitTgs()

	var/latest_changelog = file("[global.config.directory]/../html/changelogs/archive/" + time2text(world.timeofday, "YYYY-MM") + ".yml")
	GLOB.changelog_hash = fexists(latest_changelog) ? md5(latest_changelog) : 0 //for telling if the changelog has changed recently

	if(byond_version < MIN_COMPILER_VERSION)
		log_world("Your server's byond version does not meet the recommended requirements for this server. Please update BYOND")

	ConfigLoaded()

	if(NO_INIT_PARAMETER in params)
		return

	Master.Initialize(10, FALSE, TRUE)

	#ifdef UNIT_TESTS
	HandleTestRun()
	#endif

	if(CONFIG_GET(flag/tor_ban))
		SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ToRban_autoupdate)))

	call_restart_webhook()
	TgsInitializationComplete()

/**
 * Everything in here is prioritized in a very specific way.
 * If you need to add to it, ask yourself hard if what your adding is in the right spot
 * (i.e. basically nothing should be added before load_admins() in here)
 */
/world/proc/ConfigLoaded()

	//apply a default value to CONFIG_GET(string/python_path), if needed
	if (!CONFIG_GET(string/python_path))
		if(world.system_type == UNIX)
			CONFIG_SET(string/python_path, "/usr/bin/env python2")
		else //probably windows, if not this should work anyway
			CONFIG_SET(string/python_path, "python")

	SSdbcore.InitializeRound()

	SetupLogs()

	world.name = station_name()

	if(config && CONFIG_GET(string/servername) != null && CONFIG_GET(string/server_suffix) && world.port > 0)
		// dumb and hardcoded but I don't care~
		CONFIG_SET(string/servername, CONFIG_GET(string/servername) + " #[(world.port % 1000) / 100]")

	load_admins()

	callHook("startup")

	generate_body_modification_lists()

	update_status()

	LoadVerbs(/datum/verbs/menu)

	// This is kinda important. Set up details of what the hell things are made of.
	populate_material_list()


	if(fexists(RESTART_COUNTER_PATH))
		GLOB.restart_counter = text2num(trim(file2text(RESTART_COUNTER_PATH)))
		fdel(RESTART_COUNTER_PATH)

/world/proc/InitTgs()
	TgsNew(new /datum/tgs_event_handler/impl, TGS_SECURITY_TRUSTED)
	GLOB.revdata.load_tgs_info()

/world/proc/HandleTestRun()
	//trigger things to run the whole process
	Master.sleep_offline_after_initializations = FALSE
	SSticker.start_immediately = TRUE
	// config hacks
	CONFIG_SET(number/empty_server_restart_time, 0)
	CONFIG_SET(number/vote_autogamemode_timeleft, 0)
	// CONFIG_SET(number/round_end_countdown, 0)
	var/datum/callback/cb
#ifdef UNIT_TESTS
	cb = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(RunUnitTests))
#else
	cb = VARSET_CALLBACK(global, universe_has_ended, TRUE)
#endif
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_addtimer), cb, 10 SECONDS))

/world/proc/SetupLogs()
	var/override_dir = params[OVERRIDE_LOG_DIRECTORY_PARAMETER]
	if(!override_dir)
		var/realtime = world.realtime
		var/texttime = time2text(realtime, "YYYY/MM/DD", TIMEZONE_UTC)
		GLOB.log_directory = "data/logs/[texttime]/round-"
		// GLOB.picture_logging_prefix = "L_[time2text(realtime, "YYYYMMDD", TIMEZONE_UTC)]_"
		// GLOB.picture_log_directory = "data/picture_logs/[texttime]/round-"
		if(GLOB.round_id)
			GLOB.log_directory += "[GLOB.round_id]"
			// GLOB.picture_logging_prefix += "R_[GLOB.round_id]_"
			// GLOB.picture_log_directory += "[GLOB.round_id]"
		else
			var/timestamp = replacetext(time_stamp(), ":", ".")
			GLOB.log_directory += "[timestamp]"
			// GLOB.picture_log_directory += "[timestamp]"
			// GLOB.picture_logging_prefix += "T_[timestamp]_"
	else
		GLOB.log_directory = "data/logs/[override_dir]"
		// GLOB.picture_logging_prefix = "O_[override_dir]_"
		// GLOB.picture_log_directory = "data/picture_logs/[override_dir]"

	logger.init_logging()

	if(Tracy.trace_path)
		rustg_file_write("[Tracy.trace_path]", "[GLOB.log_directory]/tracy.loc")

	var/latest_changelog = file("[global.config.directory]/../html/changelogs/archive/" + time2text(world.timeofday, "YYYY-MM", TIMEZONE_UTC) + ".yml")
	GLOB.changelog_hash = fexists(latest_changelog) ? md5(latest_changelog) : 0 //for telling if the changelog has changed recently

	if(GLOB.round_id)
		log_game("Round ID: [GLOB.round_id]")

	// This was printed early in startup to the world log and config_error.log,
	// but those are both private, so let's put the commit info in the runtime
	// log which is ultimately public.
	log_runtime(GLOB.revdata.get_log_message())

	#ifndef USE_CUSTOM_ERROR_HANDLER
	world.log = file("[GLOB.log_directory]/dd.log")
#else
	if (TgsAvailable()) // why
		world.log = file("[GLOB.log_directory]/dd.log") //not all runtimes trigger world/Error, so this is the only way to ensure we can see all of them.
#endif
	set_db_log_directory()

/proc/set_db_log_directory()
	set waitfor = FALSE
	if(!GLOB.round_id || !SSdbcore.IsConnected())
		return
	var/datum/db_query/set_log_directory = SSdbcore.NewQuery({"
		UPDATE [format_table_name("round")]
		SET
			`log_directory` = :log_directory
		WHERE
			`id` = :round_id
	"}, list("log_directory" = GLOB.log_directory, "round_id" = GLOB.round_id))
	set_log_directory.Execute()
	QDEL_NULL(set_log_directory)

/proc/get_log_directory_by_round_id(round_id)
	if(!isnum(round_id) || round_id <= 0 || !SSdbcore.IsConnected())
		return
	var/datum/db_query/query_log_directory = SSdbcore.NewQuery({"
		SELECT `log_directory`
		FROM
			[format_table_name("round")]
		WHERE
			`id` = :round_id
	"}, list("round_id" = round_id))
	if(!query_log_directory.warn_execute())
		qdel(query_log_directory)
		return
	if(!query_log_directory.NextRow())
		qdel(query_log_directory)
		CRASH("Failed to get log directory for round [round_id]")
	var/log_directory = query_log_directory.item[1]
	QDEL_NULL(query_log_directory)
	if(!rustg_file_exists(log_directory))
		CRASH("Log directory '[log_directory]' for round ID [round_id] doesn't exist!")
	return log_directory



/// Returns a list of data about the world state, don't clutter
/world/proc/get_world_state_for_logging()
	var/data = list()
	data["tick_usage"] = world.tick_usage
	data["tick_lag"] = world.tick_lag
	data["time"] = world.time
	data["timestamp"] = logger.unix_timestamp_string()
	return data

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/world/Topic(T, addr, master, key)
	TGS_TOPIC //redirect to server tools if necessary
	var/list/topic_handlers = WorldTopicHandlers()

	var/list/input = params2list(T)
	var/datum/world_topic/handler
	for(var/I in topic_handlers)
		if(I in input)
			handler = topic_handlers[I]
			break

	if((!handler || initial(handler.log)) && config && CONFIG_GET(flag/log_world_topic))
		log_topic("\"[T]\", from:[addr], master:[master], key:[key]")

	if(!handler)
		return

	handler = new handler()
	return handler.TryRun(input)

/world/proc/FinishTestRun()
	set waitfor = FALSE
	var/list/fail_reasons
	if(GLOB)
		if(GLOB.total_runtimes != 0)
			fail_reasons = list("Total runtimes: [GLOB.total_runtimes]")
#ifdef UNIT_TESTS
		if(GLOB.failed_any_test)
			LAZYADD(fail_reasons, "Unit Tests failed!")
#endif
		// if(!GLOB.log_directory)
		// 	LAZYADD(fail_reasons, "Missing GLOB.log_directory!")
	else
		fail_reasons = list("Missing GLOB!")
	if(!fail_reasons)
		text2file("Success!", "data/logs/ci/clean_run.lk") // [GLOB.log_directory]
	else
		log_world("Test run failed!\n[fail_reasons.Join("\n")]")
	sleep(0) //yes, 0, this'll let Reboot finish and prevent byond memes
	qdel(src) //shut it down

/// Returns TRUE if the world should do a TGS hard reboot.
/world/proc/check_hard_reboot()
	if(!TgsAvailable())
		return FALSE
	// byond-tracy can't clean up itself, and thus we should always hard reboot if its enabled, to avoid an infinitely growing trace.
	if(Tracy?.enabled)
		return TRUE
	var/ruhr = CONFIG_GET(number/rounds_until_hard_restart)
	switch(ruhr)
		if(-1)
			return FALSE
		if(0)
			return TRUE
		else
			if(GLOB.restart_counter >= ruhr)
				return TRUE
			else
				text2file("[++GLOB.restart_counter]", RESTART_COUNTER_PATH)
				return FALSE

/world/Reboot(reason = 0, fast_track = FALSE)
	if(!CONFIG_GET(flag/tts_cache))
		for(var/i in GLOB.tts_death_row)
			fdel(i)

	if(reason || fast_track) //special reboot, do none of the normal stuff
		if(usr)
			log_admin("[key_name(usr)] Has requested an immediate world restart via client side debugging tools")
			message_admins("[key_name_admin(usr)] Has requested an immediate world restart via client side debugging tools")
		to_chat(world, span_boldannounce("Rebooting World immediately due to host request."))
	else
		to_chat(world, span_boldannounce("Rebooting world..."))
		Master.Shutdown() //run SS shutdowns

	for(var/client/C in GLOB.clients)
		if(CONFIG_GET(string/server))	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[CONFIG_GET(string/server)]")


	#ifdef UNIT_TESTS
	FinishTestRun()
	#else
	..()
	#endif

	if(check_hard_reboot())
		log_world("World hard rebooted at [time_stamp()]")
		// shutdown_logging() // See comment below.
		QDEL_NULL(Tracy)
		QDEL_NULL(Debugger)
		TgsEndProcess()
		return ..()

	log_world("World rebooted at [time_stamp()]")

	// shutdown_logging() // Past this point, no logging procs can be used, at risk of data loss.
	QDEL_NULL(Tracy)
	QDEL_NULL(Debugger)

	TgsReboot()



/hook/startup/proc/loadMode()
	world.load_storyteller()
	return 1

/world/proc/load_storyteller()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_storyteller = Lines[1]
			log_game("Saved storyteller is '[master_storyteller]'")

/world/proc/save_storyteller(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_mentors()
	if(CONFIG_GET(flag/admin_legacy_system))
		var/text = file2text("config/mentors.txt")
		if (!text)
			error("Failed to load config/mentors.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue
				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Mentor"
				var/rights = GLOB.admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(GLOB.directory[ckey])

/world/proc/update_status()
	var/s = ""

	if (config && CONFIG_GET(string/servername))
		s += "<b>[CONFIG_GET(string/servername)]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
//	s += "[GLOB.game_version]"
	s += "Default"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(SSticker)
		if(master_storyteller)
			features += master_storyteller
	else
		features += "<b>STARTING</b>"

	if (!GLOB.enter_allowed)
		features += "closed"

	features += CONFIG_GET(flag/abandon_allowed) ? "respawn" : "no respawn"

	if (config && CONFIG_GET(flag/allow_vote_mode))
		features += "vote"

	if (config && CONFIG_GET(flag/allow_ai))
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in GLOB.player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"


	if (config && CONFIG_GET(string/hostedby))
		features += "hosted by <b>[CONFIG_GET(string/hostedby)]</b>"

	if (features)
		s += ": [jointext(features, ", ")]"

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

/world/proc/update_hub_visibility(new_visibility)
	if(new_visibility == GLOB.hub_visibility)
		return
	GLOB.hub_visibility = new_visibility
	if(GLOB.hub_visibility)
		hub_password = "kMZy3U5jJHSiBQjr"
	else
		hub_password = "SORRYNOPASSWORD"

/world/proc/incrementMaxZ()
	SEND_SIGNAL(SSdcs, COMSIG_WORLD_MAXZ_INCREMENTING)
	maxz++
	SSmobs.MaxZChanged()

/world/proc/change_fps(new_value = 30)
	if(new_value <= 0)
		CRASH("change_fps() called with [new_value] new_value.")
	if(fps == new_value)
		return //No change required.

	fps = new_value


/world/Profile(command, type, format)
	if((command & PROFILE_STOP) || !global.config?.loaded || !CONFIG_GET(flag/forbid_all_profiling))
		. = ..()

#undef USE_TRACY_PARAMETER
#undef NO_INIT_PARAMETER
#undef OVERRIDE_LOG_DIRECTORY_PARAMETER
#undef RESTART_COUNTER_PATH
