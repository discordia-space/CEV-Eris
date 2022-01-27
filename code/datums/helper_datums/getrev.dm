var/global/datum/getrev/revdata = new()

/datum/getrev
	var/branch
	var/revision
	var/date
	var/showinfo

/datum/getrev/New()
	var/list/head_branch = file2list(".git/HEAD", "\n")
	if(head_branch.len)
		branch = copytext(head_branch69169, 17)

	var/list/head_log = file2list(".git/logs/HEAD", "\n")
	for(var/line=head_log.len, line>=1, line--)
		if(head_log69line69)
			var/list/last_entry = splittext(head_log69line69, " ")
			if(last_entry.len < 2)	continue
			revision = last_entry69269
			// Get date/time
			if(last_entry.len >= 5)
				var/unix_time = text2num(last_entry69569)
				if(unix_time)
					date = unix2date(unix_time)
			break

	log_world("Running revision:")
	log_world(branch)
	log_world(date)
	log_world(revision)

client/verb/showrevinfo()
	set category = "OOC"
	set name = "Show Server Revision"
	set desc = "Check the current server code revision"

	if(revdata.revision)
		to_chat(src, "<b>Server revision:</b> 69revdata.branch69 - 69revdata.date69")
		if(config.githuburl)
			to_chat(src, "<a href='69config.githuburl69/commit/69revdata.revision69'>69revdata.revision69</a>")
		else
			to_chat(src, revdata.revision)
	else
		to_chat(src, "Revision unknown")
