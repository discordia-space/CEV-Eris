//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

var/jobban_runonce			// Updates legacy bans with new info
var/jobban_keylist69069		//to store the keys & ranks

/proc/jobban_fullban(mob/M, rank, reason)
	if (!M || !M.key) return
	jobban_keylist.Add(text("69M.ckey69 - 69rank69 ## 69reason69"))
	jobban_savebanfile()

/proc/jobban_client_fullban(ckey, rank)
	if (!ckey || !rank) return
	jobban_keylist.Add(text("69ckey69 - 69rank69"))
	jobban_savebanfile()

//returns a reason if69 is banned from rank, returns 0 otherwise
/proc/jobban_isbanned(mob/M, rank)
	if(M && rank)
		/*
		if(_jobban_isbanned(M, rank)) return "Reason Unspecified"	//for old jobban
		*/

		if (guest_jobbans(rank))
			if(config.guest_jobban && IsGuestKey(M.key))
				return "Guest Job-ban"
			if(config.usewhitelist && !check_whitelist(M))
				return "Whitelisted Job"

		for (var/s in jobban_keylist)
			if( findtext(s,"69M.ckey69 - 69rank69") == 1 )
				var/startpos = findtext(s, "## ")+3
				if(startpos && startpos<length(s))
					var/text = copytext(s, startpos, 0)
					if(text)
						return text
				return "Reason Unspecified"
	return 0

/*
DEBUG
/mob/verb/list_all_jobbans()
	set name = "list all jobbans"

	for(var/s in jobban_keylist)
		world << s

/mob/verb/reload_jobbans()
	set name = "reload jobbans"

	jobban_loadbanfile()
*/


/hook/startup/proc/loadJobBans()
	jobban_loadbanfile()
	return 1

/proc/jobban_loadbanfile()
	if(config.ban_legacy_system)
		var/savefile/S=new("data/job_full.ban")
		S69"keys69069"69 >> jobban_keylist
		log_admin("Loading jobban_rank")
		S69"runonce"69 >> jobban_runonce

		if (!length(jobban_keylist))
			jobban_keylist=list()
			log_admin("jobban_keylist was empty")
	else
		if(!establish_db_connection())
			error("Database connection failed. Reverting to the legacy ban system.")
			log_misc("Database connection failed. Reverting to the legacy ban system.")
			config.ban_legacy_system = 1
			jobban_loadbanfile()
			return

		//Job permabans
		var/DBQuery/perma_query = dbcon.NewQuery("SELECT target_id, job FROM bans WHERE type = 'JOB_PERMABAN' AND isnull(unbanned)")
		perma_query.Execute()

		while(perma_query.NextRow())
			var/id = perma_query.item69169
			var/job = perma_query.item69269
			var/DBQuery/get_ckey = dbcon.NewQuery("SELECT ckey from players WHERE id = '69id69'")
			get_ckey.Execute()
			if(get_ckey.NextRow())
				var/ckey = get_ckey.item69169
				jobban_keylist.Add("69ckey69 - 69job69")



		//Job tempbans
		var/DBQuery/query = dbcon.NewQuery("SELECT target_id, job FROM bans WHERE type = 'JOB_TEMPBAN' AND isnull(unbanned) AND expiration_time > Now()")
		query.Execute()

		while(query.NextRow())
			var/id = query.item69169
			var/job = query.item69269
			var/DBQuery/get_ckey = dbcon.NewQuery("SELECT ckey from players WHERE id = '69id69'")
			get_ckey.Execute()
			if(get_ckey.NextRow())
				var/ckey = get_ckey.item69169
				jobban_keylist.Add("69ckey69 - 69job69")



/proc/jobban_savebanfile()
	var/savefile/S=new("data/job_full.ban")
	S69"keys69069"69 << jobban_keylist

/proc/jobban_unban(mob/M, rank)
	jobban_remove("69M.ckey69 - 69rank69")
	jobban_savebanfile()


/proc/ban_unban_log_save(var/formatted_log)
	text2file(formatted_log,"data/ban_unban_log.txt")


/proc/jobban_remove(X)
	for (var/i = 1; i <= length(jobban_keylist); i++)
		if( findtext(jobban_keylist69i69, "69X69") )
			jobban_keylist.Remove(jobban_keylist69i69)
			jobban_savebanfile()
			return 1
	return 0
