//wrapper macros for easier grepping
#define DIRECT_OUTPUT(A, B) A << B
#define DIRECT_INPUT(A, B) A >> B
#define SEND_IMAGE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)
#define READ_FILE(file, text) DIRECT_INPUT(file, text)
//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end= world.system_type == UNIX ? ascii2text(13) : ""

//print a warning message to world.log
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [UNLINT(src)] usr: [usr].")
/proc/warning(msg)
	msg = "## WARNING: [msg]"
	log_world(msg)

//not an error or a warning, but worth to mention on the world log, just in case.
#define NOTICE(MSG) notice(MSG)
/proc/notice(msg)
	msg = "## NOTICE: [msg]"
	log_world(msg)

//print a testing-mode debug message to world.log and world
#ifdef TESTING
#define testing(msg) log_world("## TESTING: [msg]"); to_chat(world, "## TESTING: [msg]")
#define testing_variable(variable, value) var variable = value
#else
#define testing(msg)
#define testing_variable(variable, value)
#endif

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
/proc/log_test(text)
	// WRITE_LOG(GLOB.test_log, text)
	log_world("## CI: [text]")
	SEND_TEXT(world.log, text)
#endif

#if defined(REFERENCE_DOING_IT_LIVE)
#define log_reftracker(msg) log_harddel("## REF SEARCH [msg]")

/proc/log_harddel(text)
	log_world("## HARDDEL: [text]")

#elif defined(REFERENCE_TRACKING) // Doing it locally
#define log_reftracker(msg) log_world("## REF SEARCH [msg]")

#else //Not tracking at all
#define log_reftracker(msg)
#endif

/proc/error(msg)
	log_world("## ERROR: [msg][log_end]")

/proc/game_log(category, text)
	diary << "\[[time_stamp()]] [game_id] [category]: [text][log_end]"

/proc/log_admin(text)
	admin_log.Add(text)
	lobby_message(message = text, color = "#FFA500")
	if (config.log_admin)
		game_log("ADMIN", text)

/proc/log_debug(text)
	if (config.log_debug)
		game_log("DEBUG", text)

	for(var/client/C in admins)
		if(C.get_preference_value(/datum/client_preference/staff/show_debug_logs) == GLOB.PREF_SHOW)
			to_chat(C, "DEBUG: [text]")

/proc/log_game(text)
	if (config.log_game)
		game_log("GAME", text)

/proc/log_vote(text)
	if (config.log_vote)
		game_log("VOTE", text)

/proc/log_access(text)
	if (config.log_access)
		game_log("ACCESS", text)

/proc/log_say(text)
	if (config.log_say)
		game_log("SAY", text)

/proc/log_ooc(text)
	if (config.log_ooc)
		game_log("OOC", text)

/proc/log_whisper(text)
	if (config.log_whisper)
		game_log("WHISPER", text)

/proc/log_emote(text)
	if (config.log_emote)
		game_log("EMOTE", text)

/proc/log_attack(text)
	if (config.log_attack)
		game_log("ATTACK", text)

/proc/log_adminsay(text)
	if (config.log_adminchat)
		game_log("ADMINSAY", text)

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		game_log("ADMINWARN", text)


/**
 * Appends a tgui-related log entry. All arguments are optional.
 */
/proc/log_tgui(user, message, context,
		datum/tgui_window/window,
		datum/src_object)
	var/entry = ""
	// Insert user info
	if(!user)
		entry += "<nobody>"
	else if(istype(user, /mob))
		var/mob/mob = user
		entry += "[mob.ckey] (as [mob] at [mob.x],[mob.y],[mob.z])"
	else if(istype(user, /client))
		var/client/client = user
		entry += "[client.ckey]"
	// Insert context
	if(context)
		entry += " in [context]"
	else if(window)
		entry += " in [window.id]"
	// Resolve src_object
	if(!src_object && window?.locked_by)
		src_object = window.locked_by.src_object
	// Insert src_object info
	if(src_object)
		entry += "\nUsing: [src_object.type] [REF(src_object)]"
	// Insert message
	if(message)
		entry += "\n[message]"
	game_log("TGUI", entry)
	// WRITE_LOG(GLOB.tgui_log, entry)


/proc/log_to_dd(text)
	log_world(text)
	if(config.log_world_output)
		game_log("DD_OUTPUT", text)

/proc/log_misc(text)
	game_log("MISC", text)

/proc/log_unit_test(text)
	log_world("## UNIT_TEST ##: [text]")
	log_debug(text)

/proc/log_qdel(text)
	world_qdel_log << "\[[time_stamp()]] [game_id] QDEL: [text][log_end]"

/proc/log_asset(text)
	game_log("ASSET", text)

/// Logging for mapping errors
/proc/log_mapping(text, skip_world_log)
#ifdef UNIT_TESTS
	GLOB.unit_test_mapping_logs += text
#endif
	log_world("## MAPPING: [text]")
	if(skip_world_log)
		return
	log_world(text)

//pretty print a direction bitflag, can be useful for debugging.
/proc/print_dir(var/dir)
	var/list/comps = list()
	if(dir & NORTH) comps += "NORTH"
	if(dir & SOUTH) comps += "SOUTH"
	if(dir & EAST) comps += "EAST"
	if(dir & WEST) comps += "WEST"
	if(dir & UP) comps += "UP"
	if(dir & DOWN) comps += "DOWN"

	return english_list(comps, nothing_text="0", and_text="|", comma_text="|")

/* Helper procs for building detailed log lines */
/proc/key_name(whom, include_link = null, include_name = TRUE, highlight_special_characters = TRUE)
	var/mob/M
	var/client/C
	var/key
	var/ckey
	var/fallback_name

	if(!whom)
		return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
		ckey = C.ckey
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
		ckey = M.ckey
	else if(istext(whom))
		key = whom
		ckey = ckey(whom)
		// C = GLOB.directory[ckey]
		// if(C)
		// 	M = C.mob
	else if(istype(whom, /datum/mind))
		var/datum/mind/mind = whom
		key = mind.key
		ckey = ckey(key)
		if(mind.current)
			M = mind.current
			if(M.client)
				C = M.client
		else
			fallback_name = mind.name
	else // Catch-all cases if none of the types above match
		var/swhom = null

		if(istype(whom, /atom))
			var/atom/A = whom
			swhom = "[A.name]"
		else if(istype(whom, /datum))
			swhom = "[whom]"

		if(!swhom)
			swhom = "*invalid*"

		return "\[[swhom]\]"

	. = ""

	if(!ckey)
		include_link = FALSE

	if(key)
		if(C?.holder && C.holder.fakekey && !include_name)
			if(include_link)
				. += "<a href='?priv_msg=[REF(C)]'>"
			. += "Administrator"
		else
			if(include_link)
				. += "<a href='?priv_msg=[REF(ckey)]'>"
			. += key
		if(!C)
			. += "\[DC\]"

		if(include_link)
			. += "</a>"
	else
		. += "*no key*"

	if(include_name)
		var/name
		if(M)
			if(M.real_name)
				name += "/([M.real_name])"
			else if(M.name)
				name += "/([M.name])"
		else if(fallback_name)
			name += "/([fallback_name])"

		if(include_link && is_special_character(M) && highlight_special_characters)
			. += "/(<font color='#FFA500'>[name]</font>)" //Orange
		else
			. += "/([name])"

	return .

/proc/key_name_admin(whom, include_name = TRUE)
	return key_name(whom, TRUE, include_name)

// Helper procs for building detailed log lines
/datum/proc/get_log_info_line()
	return "[src] ([type]) ([any2ref(src)])"

/area/get_log_info_line()
	return "[..()] ([isnum(z) ? "[x],[y],[z]" : "0,0,0"])"

/turf/get_log_info_line()
	return "[..()] ([x],[y],[z]) ([loc ? loc.type : "NULL"])"

/atom/movable/get_log_info_line()
	var/turf/t = get_turf(src)
	return "[..()] ([t ? t : "NULL"]) ([t ? "[t.x],[t.y],[t.z]" : "0,0,0"]) ([t ? t.type : "NULL"])"

/mob/get_log_info_line()
	return ckey ? "[..()] ([ckey])" : ..()

/proc/log_info_line(var/datum/d)
	if(isnull(d))
		return "*null*"
	if(islist(d))
		var/list/L = list()
		for(var/e in d)
			L += log_info_line(e)
		return "\[[jointext(L, ", ")]\]" // We format the string ourselves, rather than use json_encode(), because it becomes difficult to read recursively escaped "
	if(!istype(d))
		return json_encode(d)
	return d.get_log_info_line()

/proc/log_world(text) //general logging; displayed both in DD and in the text file
	if(config && config.log_runtime)
		runtime_diary << text	//save to it
	world.log << text	//do that


// Helper proc for building detailed log lines
/proc/datum_info_line(datum/d)
	if(!istype(d))
		return
	if(!ismob(d))
		return "[d] ([d.type])"
	var/mob/m = d
	return "[m] ([m.ckey]) ([m.type])"

/proc/atom_loc_line(var/atom/a)
	if(!istype(a))
		return
	var/turf/t = get_turf(a)
	if(istype(t))
		return "[a.loc] ([t.x],[t.y],[t.z]) ([a.loc.type])"
	else if(a.loc)
		return "[a.loc] (0,0,0) ([a.loc.type])"
