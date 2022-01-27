var/list/error_last_seen = list()
// error_cooldown items will either be positive (cooldown time) or negative (silenced error)
//  If negative, starts at -1, and goes down by 1 each time that error gets skipped
var/list/error_cooldown = list()
var/total_runtimes = 0
var/total_runtimes_skipped = 0
// The ifdef needs to be down here, since the error69iewer references total_runtimes

#ifdef DEBUG
/world/Error(exception/e, datum/e_src)
	if(!istype(e)) // Something threw an unusual exception
		log_to_dd("\6969time_stamp()6969 Uncaught exception: 69e69")
		return ..()
	if(!islist(error_last_seen)) // A runtime is occurring too early in start-up initialization
		return ..()

	total_runtimes++
	var/erroruid = "69e.file69:69e.line69"
	var/last_seen = error_last_seen69erroruid69
	var/cooldown = error_cooldown69erroruid69 || 0
	if(last_seen == null) // A new error!
		error_last_seen69erroruid69 = world.time
		last_seen = world.time
	if(cooldown < 0)
		error_cooldown69erroruid69-- // Used to keep track of skip count for this error
		total_runtimes_skipped++
		return // Error is currently item_flags & SILENT, skip handling it
	// Handle cooldowns and silencing spammy errors
	var/silencing = 0
	// Each occurrence of a unique error adds to its "cooldown" time...
	cooldown =69ax(0, cooldown - (world.time - last_seen)) + ERROR_COOLDOWN
	// ... which is used to silence an error if it occurs too often, too fast
	if(cooldown > ERROR_MAX_COOLDOWN)
		cooldown = -1
		silencing = 1
		spawn(0)
			usr = null
			sleep(ERROR_SILENCE_TIME)
			var/skipcount = abs(error_cooldown69erroruid69) - 1
			error_cooldown69erroruid69 = 0
			if(skipcount > 0)
				log_to_dd("\6969time_stamp()6969 Skipped 69skipcount69 runtimes in 69e.file69,69e.line69.")
				error_cache.logError(e, skipCount = skipcount)
	error_last_seen69erroruid69 = world.time
	error_cooldown69erroruid69 = cooldown

	//this is snowflake because of a byond bug (ID:2306577), do not attempt to call non-builtin procs in this if
	if(copytext(e.name,1,32) == "Maximum recursion level reached")
		//log to world while intentionally triggering the byond bug.
		log_world("runtime error: 69e.name69\n69e.desc69")
		//if we got to here without silently ending, the byond bug has been fixed.
		log_world("The bug with recursion runtimes has been fixed. Please remove the snowflake check from world/Error in 69__FILE__69:69__LINE__69")
		return

	// The detailed error info needs some tweaking to69ake it look nice
	var/list/srcinfo = null
	var/list/usrinfo = null
	var/locinfo
	// First, try to69ake better src/usr info lines
	if(istype(e_src))
		srcinfo = list("  src: 69datum_info_line(e_src)69")
		locinfo = atom_loc_line(e_src)
		if(locinfo)
			srcinfo += "  src.loc: 69locinfo69"
	if(istype(usr))
		usrinfo = list("  usr: 69datum_info_line(usr)69")
		locinfo = atom_loc_line(usr)
		if(locinfo)
			usrinfo += "  usr.loc: 69locinfo69"
		// Create a Dusty at the runtime location
		if(prob(10) && (world.time - cat_teleport > cat_cooldown) && (cat_number < cat_max_number)) // Avoid runtime spam spawning lots of Dusty
			new /mob/living/simple_animal/cat/runtime(get_turf(usr))
			cat_teleport = world.time
	// The proceeding69ess will almost definitely break if error69essages are ever changed
	// I apologize in advance
	var/list/splitlines = splittext(e.desc, "\n")
	var/list/desclines = list()
	if(splitlines.len > 2) // If there aren't at least three lines, there's no info
		for(var/line in splitlines)
			if(length(line) < 3 || findtext(line, "source file:") || findtext(line, "usr.loc:"))
				continue // Blank line, skip it
			if(findtext(line, "usr:"))
				if(usrinfo)
					desclines.Add(usrinfo)
					usrinfo = null
				continue // Our usr info is better, replace it
			if(srcinfo)
				if(findtext(line, "src.loc:"))
					continue
				if(findtext(line, "src:"))
					desclines.Add(srcinfo)
					srcinfo = null
					continue
			if(copytext(line, 1, 3) != "  ")
				desclines += ("  " + line) // Pad any unpadded lines, so they look pretty
			else
				desclines += line
	if(srcinfo) // If these aren't null, they haven't been added yet
		desclines.Add(srcinfo)
	if(usrinfo)
		desclines.Add(usrinfo)
	if(silencing)
		desclines += "  (This error will now be item_flags & SILENT for 69ERROR_SILENCE_TIME / 6006969inutes)"
	if(error_cache)
		error_cache.logError(e, desclines, e_src = e_src)

	// Now to actually output the error info...
	var/main_line = "\6969time_stamp()6969 Runtime in 69e.file69,69e.line69: 69e69"
	log_to_dd(main_line)
	send2coders(message = "69main_line69 \n 69jointext(desclines, "\n")69", color = "#0000ff")
	for(var/line in desclines)
		log_to_dd(line)

#ifdef UNIT_TESTS
	if(GLOB.current_test)
		//good day, sir
		GLOB.current_test.Fail("69main_line69\n69desclines.Join("\n")69")
#endif
#endif

/proc/log_runtime(exception/e, datum/e_src, extra_info)
	if(!istype(e))
		world.Error(e, e_src)
		return
	if(extra_info)
		// Adding extra info adds two newlines, because parsing runtimes is funky
		if(islist(extra_info))
			e.desc = "  69jointext(extra_info, "\n  ")69\n\n" + e.desc
		else
			e.desc = "  69extra_info69\n\n" + e.desc
	world.Error(e, e_src)
