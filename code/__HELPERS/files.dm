GLOBAL_VAR_INIT(fileaccess_timer, 0)

//checks if a file exists and contains text
//returns text as a string if these conditions are met
/proc/return_file_text(filename)
	if(fexists(filename) == 0)
		stack_trace("File not found ([filename])")
		return

	var/text = file2text(filename)
	if(!text)
		stack_trace("File empty ([filename])")
		return

	return text

/client/proc/browse_files(root_type = BROWSE_ROOT_ALL_LOGS, max_iterations = 10, list/valid_extensions = list("txt", "log", "htm", "html", "gz", "json", "log.json"), list/whitelist = null, allow_folder = TRUE)
	var/regex/valid_ext_regex = new("\\.(?:[regex_quote_list(valid_extensions)])$", "i")
	var/regex/whitelist_regex
	if(whitelist)
		// try not to look at it too hard. yes i wrote this by hand.
		whitelist_regex = new("(?:\[\\/\\\\\]$|(?:^|\\\\|\\/)(?:[regex_quote_list(whitelist)]|(?:profiler|sendmaps|memstat)-(?:init|\[0-9_\\-\]+))\\.(?:[regex_quote_list(valid_extensions)])$)", "i")

	// wow why was this ever a parameter
	var/root = "data/logs/"
	switch(root_type)
		if(BROWSE_ROOT_ALL_LOGS)
			root = "data/logs/"
		if(BROWSE_ROOT_CURRENT_LOGS)
			root = "[GLOB.log_directory]/"
	var/path = root

	for(var/i in 1 to max_iterations)
		var/list/choices = flist(path)
		if(whitelist_regex)
			for(var/listed_path in choices)
				if(!whitelist_regex.Find(listed_path))
					choices -= listed_path
		choices = sortList(choices)
		if(path != root)
			choices.Insert(1, "/")
		if(allow_folder)
			choices.Insert(1, "Download Folder")
		if(root_type == BROWSE_ROOT_ALL_LOGS && SSdbcore.IsConnected())
			choices.Insert(1, "Choose Round ID")

		var/choice = tgui_input_list(src, "Choose a file to access", "Download", choices)
		if(!choice)
			return
		switch(choice)
			if("/")
				path = root
				continue
			if("Choose Round ID")
				var/current_round_id = text2num(GLOB.round_id)
				var/target_round = tgui_input_number(
					src,
					message = "Choose which round ID you wish to go to",
					title = "Download",
					default = current_round_id,
					max_value = current_round_id,
					min_value = 1
				)
				if(!target_round)
					to_chat(src, span_warning("No round ID chosen."), type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
					return
				var/round_folder = get_log_directory_by_round_id(target_round)
				if(!round_folder)
					to_chat(src, span_warning("Could not find log directory for round [target_round]!"), type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
					return
				path = "[round_folder]/"
				continue
			if("Download Folder")
				if(!allow_folder)
					return
				var/list/comp_flist = flist(path)
				var/confirmation = tgui_input_list(
					user = src,
					message = "Are you SURE you want to download all the files in this folder? (This will open [length(comp_flist)] prompt[length(comp_flist) == 1 ? "" : "s"])",
					title = "Confirmation",
					items = list("Yes", "No")
				)
				if(confirmation != "Yes")
					continue
				for(var/file in comp_flist)
					src << ftp(path + file)
				return
		path += choice

		if(copytext_char(path, -1) != "/") //didn't choose a directory, no need to iterate again
			break
	if(!rustg_file_exists(path) || !valid_ext_regex.Find(path))
		to_chat(src, "<font color='red'>Error: browse_files(): File not found/Invalid file([path]).</font>")
		return

	return path

/proc/regex_quote_list(list/input) as text
	var/list/sanitized = list()
	for(var/thingy in input)
		sanitized += REGEX_QUOTE(thingy)
	return jointext(sanitized, "|")

#define FTPDELAY 200 //200 tick delay to discourage spam
#define ADMIN_FTPDELAY_MODIFIER 0.5 //Admins get to spam files faster since we ~trust~ them!
/* This proc is a failsafe to prevent spamming of file requests.
	It is just a timer that only permits a download every [FTPDELAY] ticks.
	This can be changed by modifying FTPDELAY's value above.

	PLEASE USE RESPONSIBLY, Some log files can reach sizes of 4MB! */
/client/proc/file_spam_check()
	var/time_to_wait = GLOB.fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: file_spam_check(): Spam. Please wait [DisplayTimeText(time_to_wait)].</font>")
		return TRUE
	var/delay = FTPDELAY
	if(holder)
		delay *= ADMIN_FTPDELAY_MODIFIER
	GLOB.fileaccess_timer = world.time + delay
	return FALSE
#undef FTPDELAY
#undef ADMIN_FTPDELAY_MODIFIER

/// Save file as an external file then md5 it.
/// Used because md5ing files stored in the rsc sometimes gives incorrect md5 results.
/proc/md5asfile(file)
	var/static/notch = 0
	// its importaint this code can handle md5filepath sleeping instead of hard blocking, if it's converted to use rust_g.
	var/filename = "tmp/md5asfile.[world.realtime].[world.timeofday].[world.time].[world.tick_usage].[notch]"
	notch = WRAP(notch+1, 0, 2**15)
	fcopy(file, filename)
	. = rustg_hash_file(RUSTG_HASH_MD5, filename)
	fdel(filename)
