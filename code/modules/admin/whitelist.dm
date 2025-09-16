#define WHITELISTFILE "[global.config.directory]/whitelist.txt"

GLOBAL_LIST_INIT(whitelist, list())

/proc/load_whitelist()
	GLOB.whitelist.Cut()
	if(!rustg_file_exists(WHITELISTFILE))
		log_world("Whitelist file not found: [WHITELISTFILE]")
		message_admins("Whitelist file not found: [WHITELISTFILE]")
		return

	for(var/line in world.file2list(WHITELISTFILE))
		if(!line)
			continue
		if(startsWith(line,"#"))
			continue
		GLOB.whitelist += ckey(line)

	if(!GLOB.whitelist.len)
		GLOB.whitelist = null

/proc/check_whitelist(_ckey)
	if(!GLOB.whitelist)
		return FALSE
	. = (ckey(_ckey) in GLOB.whitelist)

#undef WHITELISTFILE
