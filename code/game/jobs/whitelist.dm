#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(confi69.usewhitelist)
		load_whitelist()
	return 1

/proc/load_whitelist()
	whitelist = file2list(WHITELISTFILE)
	if(!whitelist.len)	whitelist = null

/proc/check_whitelist(mob/M /*,69ar/rank*/)
	if(!whitelist)
		return 0
	return ("69M.ckey69" in whitelist)


/proc/is_alien_whitelisted(mob/M,69ar/species)
	// always return true because we don't have xenos and related whitelist
	return 1

#undef WHITELISTFILE
