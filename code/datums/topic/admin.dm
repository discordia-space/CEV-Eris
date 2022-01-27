/datum/admin_topic
	var/keyword
	var/list/require_perms = list()
	var/datum/admins/source
	//The permissions needed to run the topic.
	//If you want the user to need69ultiple perms, have each perm be an entry into the list, like this: list(R_ADMIN, R_MOD)
	//If you want the user to need just one of69ultiple perms, have the perms be the same entry in the list using OR, like this: list(R_ADMIN|R_MOD)
	//These can be combined, for example with: list(R_MOD|R_MENTOR, R_ADMIN) which would require you to have either R_MOD or R_MENTOR, as well as R_ADMIN

/datum/admin_topic/proc/TryRun(list/input, datum/admins/owner)
	if(require_perms.len)
		for(var/i in require_perms)
			if(!check_rights(i, TRUE))
				return FALSE
	source = owner
	. = Run(input)
	qdel(src)

/datum/admin_topic/proc/Run(list/input) //use the source arg to access the admin datum.
	CRASH("Run() not implemented for 69type69!")


/datum/admin_topic/dbsearchckey
	keyword = "dbsearchckey"

/datum/admin_topic/dbsearchckey/dbsearchadmin //inherits the behaviour of dbsearchckey, but with a different keyword.
	keyword = "dbsearchadmin"

/datum/admin_topic/dbsearchckey/Run(list/input)
	var/adminckey = input69"dbsearchadmin"69
	var/playerckey = input69"dbsearchckey"69
	var/playerip = input69"dbsearchip"69
	var/playercid = input69"dbsearchcid"69
	var/dbbantype = text2num(input69"dbsearchbantype"69)
	var/match = FALSE

	if("dbmatch" in input)
		match = TRUE

	source.DB_ban_panel(playerckey, adminckey, playerip, playercid, dbbantype,69atch)


/datum/admin_topic/dbbanedit
	keyword = "dbbanedit"

/datum/admin_topic/dbbanedit/Run(list/input)
	var/banedit = input69"dbbanedit"69
	var/banid = text2num(input69"dbbanid"69)
	if(!banedit || !banid)
		return

	source.DB_ban_edit(banid, banedit)


/datum/admin_topic/dbbanaddtype
	keyword = "dbbanaddtype"

/datum/admin_topic/dbbanaddtype/Run(list/input)
	var/bantype = text2num(input69"dbbanaddtype"69)
	var/banckey = input69"dbbanaddckey"69
	var/banip = input69"dbbanaddip"69
	var/bancid = input69"dbbanaddcid"69
	var/banduration = text2num(input69"dbbaddduration"69)
	var/banjob = input69"dbbanaddjob"69
	var/banreason = input69"dbbanreason"69

	banckey = ckey(banckey)

	switch(bantype)
		if(BANTYPE_PERMA)
			if(!banckey || !banreason)
				to_chat(usr, "Not enough parameters (Requires ckey and reason)")
				return
			banduration = null
			banjob = null
		if(BANTYPE_TEMP)
			if(!banckey || !banreason || !banduration)
				to_chat(usr, "Not enough parameters (Requires ckey, reason and duration)")
				return
			banjob = null
		if(BANTYPE_JOB_PERMA)
			if(!banckey || !banreason || !banjob)
				to_chat(usr, "Not enough parameters (Requires ckey, reason and job)")
				return
			banduration = null
		if(BANTYPE_JOB_TEMP)
			if(!banckey || !banreason || !banjob || !banduration)
				to_chat(usr, "Not enough parameters (Requires ckey, reason and job)")
				return

	var/mob/playermob

	for(var/mob/M in GLOB.player_list)
		if(M.ckey == banckey)
			playermob =69
			break


	banreason = "(MANUAL BAN) "+banreason

	if(!playermob)
		if(banip)
			banreason = "69banreason69 (CUSTOM IP)"
		if(bancid)
			banreason = "69banreason69 (CUSTOM CID)"
	else
		message_admins("Ban process: A69ob69atching 69playermob.ckey69 was found at location 69playermob.x69, 69playermob.y69, 69playermob.z69. Custom ip and computer id fields replaced with the ip and computer id from the located69ob")

	source.DB_ban_record(bantype, playermob, banduration, banreason, banjob, banckey, banip, bancid )


/datum/admin_topic/editrights
	keyword = "editrights"
	require_perms = list(R_PERMISSIONS)

/datum/admin_topic/editrights/Run(list/input)

	var/adm_ckey

	var/task = input69"editrights"69
	if(task == "add")
		var/new_ckey = ckey(input(usr,"New admin's ckey","Admin ckey", null) as text|null)
		if(!new_ckey)
			return
		if(new_ckey in admin_datums)
			to_chat(usr, "<font color='red'>Error: Topic 'editrights': 69new_ckey69 is already an admin</font>")
			return
		adm_ckey = new_ckey
		task = "rank"
	else if(task != "show")
		adm_ckey = ckey(input69"ckey"69)
		if(!adm_ckey)
			to_chat(usr, "<font color='red'>Error: Topic 'editrights': No69alid ckey</font>")
			return

	var/datum/admins/D = admin_datums69adm_ckey69

	if(task == "remove")
		if(alert("Are you sure you want to remove 69adm_ckey69?","Message","Yes","Cancel") == "Yes")
			if(!D)
				return
			admin_datums -= adm_ckey
			D.disassociate()

			message_admins("69key_name_admin(usr)69 removed 69adm_ckey69 from the admins list")
			log_admin("69key_name(usr)69 removed 69adm_ckey69 from the admins list")
			source.log_admin_rank_modification(adm_ckey, "player")

	else if(task == "rank")
		var/new_rank
		if(admin_ranks.len)
			new_rank = input("Please select a rank", "New rank", null, null) as null|anything in (admin_ranks|"*New Rank*")
		else
			new_rank = input("Please select a rank", "New rank", null, null) as null|anything in list("Game69aster","Game Admin", "Trial Admin", "Admin Observer","*New Rank*")

		var/rights = 0
		if(D)
			rights = D.rights
		switch(new_rank)
			if(null,"")
				return
			if("*New Rank*")
				new_rank = input("Please input a new rank", "New custom rank", null, null) as null|text
				if(config.admin_legacy_system)
					new_rank = ckeyEx(new_rank)
				if(!new_rank)
					to_chat(usr, "<font color='red'>Error: Topic 'editrights': Invalid rank</font>")
					return
				if(config.admin_legacy_system)
					if(admin_ranks.len)
						if(new_rank in admin_ranks)
							rights = admin_ranks69new_rank69		//we typed a rank which already exists, use its rights
						else
							admin_ranks69new_rank69 = 0			//add the new rank to admin_ranks
			else
				if(config.admin_legacy_system)
					new_rank = ckeyEx(new_rank)
					rights = admin_ranks69new_rank69				//we input an existing rank, use its rights

		if(D)
			D.disassociate()								//remove adminverbs and unlink from client
			D.rank = new_rank								//update the rank
			D.rights = rights								//update the rights based on admin_ranks (default: 0)
		else
			D = new /datum/admins(new_rank, rights, adm_ckey)

		var/client/C = directory69adm_ckey69						//find the client with the specified ckey (if they are logged in)
		D.associate(C)											//link up with the client and add69erbs

		to_chat(C, "69key_name_admin(usr)69 has set your admin rank to: 69new_rank69.")
		message_admins("69key_name_admin(usr)69 edited the admin rank of 69adm_ckey69 to 69new_rank69")
		log_admin("69key_name(usr)69 edited the admin rank of 69adm_ckey69 to 69new_rank69")
		source.log_admin_rank_modification(adm_ckey, new_rank)

	else if(task == "permissions")
		if(!D)
			return
		var/list/permissionlist = list()
		for(var/i=1, i<=R_MAXPERMISSION, i<<=1)		//that <<= is shorthand for i = i << 1. Which is a left bitshift
			permissionlist69rights2text(i)69 = i
		var/new_permission = input("Select a permission to turn on/off", "Permission toggle", null, null) as null|anything in permissionlist
		if(!new_permission)
			return
		D.rights ^= permissionlist69new_permission69

		var/client/C = directory69adm_ckey69
		to_chat(C, "69key_name_admin(usr)69 has toggled your permission: 69new_permission69.")
		message_admins("69key_name_admin(usr)69 toggled the 69new_permission69 permission of 69adm_ckey69")
		log_admin("69key_name(usr)69 toggled the 69new_permission69 permission of 69adm_ckey69")
		source.log_admin_permission_modification(adm_ckey, permissionlist69new_permission69, new_permission)

	source.edit_admin_permissions()


/datum/admin_topic/simplemake
	keyword = "simplemake"
	require_perms = list(R_FUN)

/datum/admin_topic/simplemake/Run(list/input)
	var/mob/M = locate(input69"mob"69)
	if(!ismob(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return

	var/delmob = FALSE
	switch(alert("Delete old69ob?","Message","Yes","No","Cancel"))
		if("Cancel")
			return
		if("Yes")
			delmob = TRUE

	log_admin("69key_name(usr)69 has used rudimentary transformation on 69key_name(M)69. Transforming to 69input69"simplemake"6969; deletemob=69delmob69")
	message_admins("\blue 69key_name_admin(usr)69 has used rudimentary transformation on 69key_name_admin(M)69. Transforming to 69input69"simplemake"6969; deletemob=69delmob69", 1)

	switch(input69"simplemake"69)
		if("observer")
			M.change_mob_type( /mob/observer/ghost , null, null, delmob )
		if("angel")
			M.change_mob_type( /mob/observer/eye/angel , null, null, delmob )
		if("human")
			M.change_mob_type( /mob/living/carbon/human , null, null, delmob, input69"species"69)
		if("slime")
			M.change_mob_type( /mob/living/carbon/slime , null, null, delmob )
		if("monkey")
			M.change_mob_type( /mob/living/carbon/human/monkey , null, null, delmob )
		if("robot")
			M.change_mob_type( /mob/living/silicon/robot , null, null, delmob )
		if("cat")
			M.change_mob_type( /mob/living/simple_animal/cat , null, null, delmob )
		if("runtime")
			M.change_mob_type( /mob/living/simple_animal/cat/fluff/Runtime , null, null, delmob )
		if("corgi")
			M.change_mob_type( /mob/living/simple_animal/corgi , null, null, delmob )
		if("ian")
			M.change_mob_type( /mob/living/simple_animal/corgi/Ian , null, null, delmob )
		if("crab")
			M.change_mob_type( /mob/living/simple_animal/crab , null, null, delmob )
		if("coffee")
			M.change_mob_type( /mob/living/simple_animal/crab/Coffee , null, null, delmob )
		if("parrot")
			M.change_mob_type( /mob/living/simple_animal/parrot , null, null, delmob )
		if("polyparrot")
			M.change_mob_type( /mob/living/simple_animal/parrot/Poly , null, null, delmob )


/datum/admin_topic/unbanf
	keyword = "unbanf"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/unbanf/Run(list/input)
	var/banfolder = input69"unbanf"69
	Banlist.cd = "/base/69banfolder69"
	var/key = Banlist69"key"69
	if(alert(usr, "Are you sure you want to unban 69key69?", "Confirmation", "Yes", "No") == "Yes")
		if(RemoveBan(banfolder))
			source.unbanpanel()
		else
			alert(usr, "This ban has already been lifted / does not exist.", "Error", "Ok")
			source.unbanpanel()


/datum/admin_topic/warn
	keyword = "warn"

/datum/admin_topic/warn/Run(list/input)
	usr.client.warn(input69"warn"69)


/datum/admin_topic/unbane
	keyword = "unbane"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/unbane/Run(list/input)

	UpdateTime()
	var/reason

	var/banfolder = input69"unbane"69
	Banlist.cd = "/base/69banfolder69"
	var/reason2 = Banlist69"reason"69
	var/temp = Banlist69"temp"69

	var/minutes = Banlist69"minutes"69

	var/banned_key = Banlist69"key"69
	Banlist.cd = "/base"

	var/duration

	switch(alert("Temporary Ban?",,"Yes","No"))
		if("Yes")
			temp = TRUE
			var/mins = 0
			if(minutes > CMinutes)
				mins =69inutes - CMinutes
			mins = input(usr,"How long (in69inutes)? (Default: 1440)","Ban time",mins ?69ins : 1440) as num|null
			if(!mins)
				return
			mins =69in(525599,mins)
			minutes = CMinutes +69ins
			duration = GetExp(minutes)
			reason = sanitize(input(usr,"Reason?","reason",reason2) as text|null)
			if(!reason)
				return
		if("No")
			temp = FALSE
			duration = "Perma"
			reason = sanitize(input(usr,"Reason?","reason",reason2) as text|null)
			if(!reason)
				return

	log_admin("69key_name(usr)69 edited 69banned_key69's ban. Reason: 69reason69 Duration: 69duration69")
	ban_unban_log_save("69key_name(usr)69 edited 69banned_key69's ban. Reason: 69reason69 Duration: 69duration69")
	message_admins("\blue 69key_name_admin(usr)69 edited 69banned_key69's ban. Reason: 69reason69 Duration: 69duration69", 1)
	Banlist.cd = "/base/69banfolder69"
	Banlist69"reason"69 << reason
	Banlist69"temp"69 << temp
	Banlist69"minutes"69 <<69inutes
	Banlist69"bannedby"69 << usr.ckey
	Banlist.cd = "/base"

	source.unbanpanel()


/datum/admin_topic/jobban2
	keyword = "jobban2"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/jobban2/Run(list/input)

	var/mob/M = locate(input69"jobban2"69)
	if(!ismob(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return

	if(!M.ckey)	//sanity
		to_chat(usr, "This69ob has no ckey")
		return

	var/dat = ""
	var/header = {"
		<title>Job-Ban Panel: 69M.name69</title>
		<style>
			a{
				word-spacing: normal;
			}
			.jobs{
				text-align:center;
				word-spacing: 30px;
			}
		</style>
	"}
	var/list/body = list()

	//Regular jobs
	//Command (Blue)
	body += source.formatJobGroup(M, "Command Positions", "ccccff", "commanddept", command_positions)
	//Security (Red)
	body += source.formatJobGroup(M, "Security Positions", "ffddf0", "securitydept", security_positions)
	//Engineering (Yellow)
	body += source.formatJobGroup(M, "Engineering Positions", "d5c88f", "engineeringdept", engineering_positions)
	//Medical (White)
	body += source.formatJobGroup(M, "Medical Positions", "ffeef0", "medicaldept",69edical_positions)
	//Science (Purple)
	body += source.formatJobGroup(M, "Science Positions", "e79fff", "sciencedept", science_positions)
	//Church (Gold)
	body += source.formatJobGroup(M, "Church Positions", "ecd37d", "churchdept", church_positions)
	//Civilian (Grey)
	body += source.formatJobGroup(M, "Civilian Positions", "dddddd", "civiliandept", civilian_positions)
	//Non-Human (Green)
	body += source.formatJobGroup(M, "Non-human Positions", "ccffcc", "nonhumandept", nonhuman_positions + "Antag HUD")
	//Antagonist (Orange)

	var/jobban_list = list()
	for(var/a_id in GLOB.antag_bantypes)
		var/a_ban = GLOB.antag_bantypes69a_id69
		var/datum/antagonist/antag = get_antag_data(a_id)
		jobban_list69antag.role_text69 = a_ban
	body += source.formatJobGroup(M, "Antagonist Positions", "ffeeaa", "Syndicate", jobban_list)

	dat = "<head>69header69</head><body><tt><table width='100%'>69body.Join(null)69</table></tt></body>"
	usr << browse(dat, "window=jobban2;size=800x490")


/datum/admin_topic/jobban3
	keyword = "jobban3"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/jobban3/Run(list/input)
	if(check_rights(R_MOD, FALSE) && !check_rights(R_ADMIN, FALSE) && !config.mods_can_job_tempban) // If69od and tempban disabled
		to_chat(usr, SPAN_WARNING("Mod jobbanning is disabled!"))
		return

	var/mob/M = locate(input69"jobban4"69)
	if(!ismob(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return

	if(M != usr)																//we can jobban ourselves
		if(M.client &&69.client.holder && (M.client.holder.rights & R_ADMIN ||69.client.holder.rights & R_MOD))		//they can ban too. So we can't ban them
			alert("You cannot perform this action. You69ust be of a higher administrative rank!")
			return

	//get jobs for department if specified, otherwise just returnt he one job in a list.
	var/list/joblist = list()
	switch(input69"jobban3"69)
		if("commanddept")
			for(var/jobPos in command_positions)
				var/datum/job/temp = SSjob.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("securitydept")
			for(var/jobPos in security_positions)
				var/datum/job/temp = SSjob.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("engineeringdept")
			for(var/jobPos in engineering_positions)
				var/datum/job/temp = SSjob.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("medicaldept")
			for(var/jobPos in69edical_positions)
				var/datum/job/temp = SSjob.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("sciencedept")
			for(var/jobPos in science_positions)
				var/datum/job/temp = SSjob.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("churchdept")
			for(var/jobPos in church_positions)
				var/datum/job/temp = SSjob.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("civiliandept")
			for(var/jobPos in civilian_positions)
				var/datum/job/temp = SSjob.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		if("nonhumandept")
			joblist += "pAI"
			for(var/jobPos in nonhuman_positions)
				if(!jobPos)	continue
				var/datum/job/temp = SSjob.GetJob(jobPos)
				if(!temp) continue
				joblist += temp.title
		else
			joblist += input69"jobban3"69

	//Create a list of unbanned jobs within joblist
	var/list/notbannedlist = list()
	for(var/job in joblist)
		if(!jobban_isbanned(M, job))
			notbannedlist += job

	//Banning comes first
	if(notbannedlist.len) //at least 1 unbanned job exists in joblist so we have stuff to ban.
		switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
			if("Yes")

				if(config.ban_legacy_system)
					to_chat(usr, "\red Your server is using the legacy banning system, which does not support temporary job bans. Consider upgrading. Aborting ban.")
					return
				var/mins = input(usr,"How long (in69inutes)?","Ban time",1440) as num|null
				if(!mins)
					return
				if(check_rights(R_MOD, FALSE) && !check_rights(R_ADMIN, FALSE) &&69ins > config.mod_job_tempban_max)
					to_chat(usr, SPAN_WARNING("Moderators can only job tempban up to 69config.mod_job_tempban_max6969inutes!"))
					return
				var/reason = sanitize(input(usr,"Reason?","Please State Reason","") as text|null)
				if(!reason)
					return

				var/msg
				for(var/job in notbannedlist)
					ban_unban_log_save("69key_name(usr)69 temp-jobbanned 69key_name(M)69 from 69job69 for 69mins6969inutes. reason: 69reason69")
					log_admin("69key_name(usr)69 temp-jobbanned 69key_name(M)69 from 69job69 for 69mins6969inutes")

					source.DB_ban_record(BANTYPE_JOB_TEMP,69,69ins, reason, job)

					jobban_fullban(M, job, "69reason69; By 69usr.ckey69 on 69time2text(world.realtime)69") //Legacy banning does not support temporary jobbans.
					if(!msg)
						msg = job
					else
						msg += ", 69job69"
				message_admins("\blue 69key_name_admin(usr)69 banned 69key_name_admin(M)69 from 69msg69 for 69mins6969inutes", 1)
				to_chat(M, "\red<BIG><B>You have been jobbanned by 69usr.client.ckey69 from: 69msg69.</B></BIG>")
				to_chat(M, "\red <B>The reason is: 69reason69</B>")
				to_chat(M, "\red This jobban will be lifted in 69mins6969inutes.")
				input69"jobban2"69 = TRUE // lets it fall through and refresh
				return TRUE
			if("No")
				var/reason = sanitize(input(usr,"Reason?","Please State Reason","") as text|null)
				if(reason)
					var/msg
					for(var/job in notbannedlist)
						ban_unban_log_save("69key_name(usr)69 perma-jobbanned 69key_name(M)69 from 69job69. reason: 69reason69")
						log_admin("69key_name(usr)69 perma-banned 69key_name(M)69 from 69job69")

						source.DB_ban_record(BANTYPE_JOB_PERMA,69, -1, reason, job)

						jobban_fullban(M, job, "69reason69; By 69usr.ckey69 on 69time2text(world.realtime)69")
						if(!msg)	msg = job
						else		msg += ", 69job69"
					message_admins("\blue 69key_name_admin(usr)69 banned 69key_name_admin(M)69 from 69msg69", 1)
					to_chat(M, "\red<BIG><B>You have been jobbanned by 69usr.client.ckey69 from: 69msg69.</B></BIG>")
					to_chat(M, "\red <B>The reason is: 69reason69</B>")
					to_chat(M, "\red Jobban can be lifted only upon request.")
					input69"jobban2"69 = TRUE // lets it fall through and refresh
					return TRUE
			if("Cancel")
				return

	//Unbanning joblist
	//all jobs in joblist are banned already OR we didn't give a reason (implying they shouldn't be banned)
	if(joblist.len) //at least 1 banned job exists in joblist so we have stuff to unban.
		if(!config.ban_legacy_system)
			to_chat(usr, "Unfortunately, database based unbanning cannot be done through this panel")
			source.DB_ban_panel(M.ckey)
			return
		var/msg
		for(var/job in joblist)
			var/reason = jobban_isbanned(M, job)
			if(!reason) continue //skip if it isn't jobbanned anyway
			switch(alert("Job: '69job69' Reason: '69reason69' Un-jobban?","Please Confirm","Yes","No"))
				if("Yes")
					ban_unban_log_save("69key_name(usr)69 unjobbanned 69key_name(M)69 from 69job69")
					log_admin("69key_name(usr)69 unbanned 69key_name(M)69 from 69job69")
					source.DB_ban_unban(M.ckey, BANTYPE_JOB_PERMA, job)


					jobban_unban(M, job)
					if(!msg)	msg = job
					else		msg += ", 69job69"
				else
					continue
		if(msg)
			message_admins("\blue 69key_name_admin(usr)69 unbanned 69key_name_admin(M)69 from 69msg69", 1)
			to_chat(M, "\red<BIG><B>You have been un-jobbanned by 69usr.client.ckey69 from 69msg69.</B></BIG>")
			input69"jobban2"69 = TRUE // lets it fall through and refresh
		return TRUE
	return FALSE //we didn't do anything!


/datum/admin_topic/boot2
	keyword = "boot2"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/boot2/Run(list/input)
	var/mob/M = locate(input69"boot2"69)
	if (ismob(M))
		if(!check_if_greater_rights_than(M.client))
			return
		var/reason = sanitize(input("Please enter reason"))
		if(!reason)
			to_chat(M, "\red You have been kicked from the server")
		else
			to_chat(M, "\red You have been kicked from the server: 69reason69")
		log_admin("69key_name(usr)69 booted 69key_name(M)69.")
		message_admins("\blue 69key_name_admin(usr)69 booted 69key_name_admin(M)69.", 1)
		del(M.client)


/datum/admin_topic/removejobban
	keyword = "removejobban"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/removejobban/Run(list/input)
	var/t = input69"removejobban"69
	if(t)
		if((alert("Do you want to unjobban 69t69?","Unjobban confirmation", "Yes", "No") == "Yes") && t) //No69ore69isclicks! Unless you do it twice.
			log_admin("69key_name(usr)69 removed 69t69")
			message_admins("\blue 69key_name_admin(usr)69 removed 69t69", 1)
			jobban_remove(t)
			input69"ban"69 = TRUE // lets it fall through and refresh
			var/t_split = splittext(t, " - ")
			var/key = t_split69169
			var/job = t_split69269
			source.DB_ban_unban(ckey(key), BANTYPE_JOB_PERMA, job)


/datum/admin_topic/newban
	keyword = "newban"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/newban/Run(list/input)
	if(check_rights(R_MOD, FALSE) && !check_rights(R_ADMIN, FALSE) && !config.mods_can_job_tempban) // If69od and tempban disabled
		to_chat(usr, SPAN_WARNING("Mod jobbanning is disabled!"))
		return

	var/mob/M = locate(input69"newban"69)
	if(!ismob(M)) return

	if(M.client &&69.client.holder)
		return	//admins cannot be banned. Even if they could, the ban doesn't affect them anyway
	var/delayed = 0
	if(alert("Delayed Ban?", "Ban after roundend. Work with DB only.", "Yes", "No") == "Yes")
		delayed = 1

	switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
		if("Yes")
			var/mins = input(usr,"How long (in69inutes)?","Ban time",1440) as num|null
			if(!mins)
				return

			if(check_rights(R_MOD, FALSE) && !check_rights(R_ADMIN, FALSE) &&69ins > config.mod_tempban_max)
				to_chat(usr, SPAN_WARNING("Moderators can only job tempban up to 69config.mod_tempban_max6969inutes!"))
				return
			if(mins >= 525600)69ins = 525599
			var/reason = sanitize(input(usr,"Reason?","reason","Griefer") as text|null)
			if(!reason)
				return
			AddBan(M.ckey,69.computer_id, reason, usr.ckey, 1,69ins, delayed_ban = delayed)
			ban_unban_log_save("69usr.client.ckey69 has banned 69M.ckey69. - Reason: 69reason69 - This will be removed in 69mins6969inutes.")
			to_chat(M, "\red<BIG><B>You have been banned by 69usr.client.ckey69.\nReason: 69reason69.</B></BIG>")
			to_chat(M, "\red This is a temporary ban, it will be removed in 69mins6969inutes.")

			source.DB_ban_record(BANTYPE_TEMP,69,69ins, reason, delayed_ban = delayed)

			if(config.banappeals)
				to_chat(M, "\red To try to resolve this69atter head to 69config.banappeals69")
			else
				to_chat(M, "\red No ban appeals URL has been set.")
			log_admin("69usr.client.ckey69 has banned 69M.ckey69.\nReason: 69reason69\nThis will be removed in 69mins6969inutes.")
			message_admins("\blue69usr.client.ckey69 has banned 69M.ckey69.\nReason: 69reason69\nThis will be removed in 69mins6969inutes.")

			if(!delayed)
				del(M.client)
			//qdel(M)	// See no reason why to delete69ob. Important stuff can be lost. And ban can be lifted before round ends.
		if("No")
			var/no_ip = 0
			var/reason = sanitize(input(usr,"Reason?","reason","Griefer") as text|null)
			if(!reason)
				return
			switch(alert(usr,"IP ban?",,"Yes","No","Cancel"))
				if("Cancel")	return
				if("Yes")
					AddBan(M.ckey,69.computer_id, reason, usr.ckey, 0, 0,69.lastKnownIP, delayed_ban = delayed)
				if("No")
					AddBan(M.ckey,69.computer_id, reason, usr.ckey, 0, 0, delayed_ban = delayed)
					no_ip = 1
			to_chat(M, "\red<BIG><B>You have been banned by 69usr.client.ckey69.\nReason: 69reason69.</B></BIG>")
			to_chat(M, "\red This is a permanent ban.")
			if(config.banappeals)
				to_chat(M, "\red To try to resolve this69atter head to 69config.banappeals69")
			else
				to_chat(M, "\red No ban appeals URL has been set.")
			ban_unban_log_save("69usr.client.ckey69 has permabanned 69M.ckey69. - Reason: 69reason69 - This is a permanent ban.")
			log_admin("69usr.client.ckey69 has banned 69M.ckey69.\nReason: 69reason69\nThis is a permanent ban.")
			message_admins("\blue69usr.client.ckey69 has banned 69M.ckey69.\nReason: 69reason69\nThis is a permanent ban.")
			var/banip = no_ip ? null : -1
			source.DB_ban_record(BANTYPE_PERMA,69, -1, reason, banip, delayed_ban = delayed)

			if(!delayed)
				del(M.client)
		if("Cancel")
			return

/datum/admin_topic/sendbacktolobby
	keyword = "sendbacktolobby"
	require_perms = list(R_ADMIN)

/datum/admin_topic/sendbacktolobby/Run(list/input)
	var/mob/M = locate(input69"sendbacktolobby"69)

	if(!isobserver(M))
		to_chat(usr, "<span class='notice'>You can only send ghost players back to the Lobby.</span>")
		return

	if(!M.client)
		to_chat(usr, "<span class='warning'>69M69 doesn't seem to have an active client.</span>")
		return

	if(alert(usr, "Send 69key_name(M)69 back to Lobby?", "Message", "Yes", "No") != "Yes")
		return

	log_admin("69key_name(usr)69 has sent 69key_name(M)69 back to the Lobby.")
	message_admins("69key_name_admin(usr)69 has sent 69key_name_admin(M)69 back to the Lobby.")

	var/mob/new_player/NP = new()
	GLOB.player_list -=69.ckey
	NP.ckey =69.ckey
	qdel(M)

/datum/admin_topic/mute
	keyword = "mute"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/mute/Run(list/input)
	var/mob/M = locate(input69"mute"69)
	if(!ismob(M))
		return
	if(!M.client)
		return

	var/mute_type = input69"mute_type"69
	if(istext(mute_type))
		mute_type = text2num(mute_type)
	if(!isnum(mute_type))
		return

	cmd_admin_mute(M,69ute_type)


/datum/admin_topic/check_antagonist
	keyword = "check_antagonist"
	require_perms = list(R_ADMIN)

/datum/admin_topic/check_antagonist/Run(list/input)
	GLOB.storyteller.storyteller_panel()


/datum/admin_topic/c_mode
	keyword = "c_mode"
	require_perms = list(R_ADMIN)

/datum/admin_topic/c_mode/Run(list/input)
	var/dat = {"<B>What storyteller do you wish to install?</B><HR>"}
	for(var/mode in config.storytellers)
		dat += {"<A href='?src=\ref69source69;c_mode2=69mode69'>69config.storyteller_names69mode6969</A><br>"}
	dat += {"Now: 69master_storyteller69"}
	usr << browse(dat, "window=c_mode")


/datum/admin_topic/c_mode2
	keyword = "c_mode2"
	require_perms = list(R_ADMIN|R_SERVER)

/datum/admin_topic/c_mode2/Run(list/input)
	master_storyteller = input69"c_mode2"69
	set_storyteller(master_storyteller) //This does the actual work
	log_admin("69key_name(usr)69 set the storyteller to 69master_storyteller69.")
	message_admins("\blue 69key_name_admin(usr)69 set the storyteller to 69master_storyteller69.", 1)
	source.Game() // updates the69ain game69enu
	world.save_storyteller(master_storyteller)
	source.Topic(source, list("c_mode"=1))


/datum/admin_topic/monkeyone
	keyword = "monkeyone"
	require_perms = list(R_FUN)

/datum/admin_topic/monkeyone/Run(list/input)
	var/mob/living/carbon/human/H = locate(input69"monkeyone"69)
	if(!istype(H))
		to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
		return

	log_admin("69key_name(usr)69 attempting to69onkeyize 69key_name(H)69")
	message_admins("\blue 69key_name_admin(usr)69 attempting to69onkeyize 69key_name_admin(H)69", 1)
	H.monkeyize()


/datum/admin_topic/corgione
	keyword = "corgione"
	require_perms = list(R_FUN)

/datum/admin_topic/corgione/Run(list/input)
	var/mob/L= locate(input69"corgione"69)
	if(!istype(L))
		to_chat(usr, "This can only be used on instances of type /mob")
		return

	log_admin("69key_name(usr)69 attempting to corgize 69key_name(L)69")
	message_admins("\blue 69key_name_admin(usr)69 attempting to corgize 69key_name_admin(L)69", 1)
	L.corgize()


/datum/admin_topic/forcespeech
	keyword = "forcespeech"
	require_perms = list(R_FUN)

/datum/admin_topic/forcespeech/Run(list/input)
	var/mob/M = locate(input69"forcespeech"69)
	if(!ismob(M))
		to_chat(usr, "this can only be used on instances of type /mob")

	var/speech = input("What will 69key_name(M)69 say?.", "Force speech", "")// Don't need to sanitize, since it does that in say(), we also trust our admins. //don't trust your admins.
	if(!speech)
		return
	M.say(speech)
	speech = sanitize(speech) // Nah, we don't trust them
	log_admin("69key_name(usr)69 forced 69key_name(M)69 to say: 69speech69")
	message_admins("\blue 69key_name_admin(usr)69 forced 69key_name_admin(M)69 to say: 69speech69")

/datum/admin_topic/forcesanity
	keyword = "forcesanity"
	require_perms = list(R_FUN)

/datum/admin_topic/forcesanity/Run(list/input)
	var/mob/living/carbon/human/H = locate(input69"forcesanity"69)
	if(!ishuman(H))
		to_chat(usr, "This can only be used on instances of type /human.")
		return

	var/datum/breakdown/B = input("What breakdown will 69key_name(H)69 suffer from?", "Sanity Breakdown") as null | anything in subtypesof(/datum/breakdown)
	if(!B)
		return
	B = new B(H.sanity)
	if(!B.can_occur())
		to_chat(usr, "69B69 could not occur. 69key_name(H)69 did not69eet the right conditions.")
		qdel(B)
		return
	if(B.occur())
		H.sanity.breakdowns += B
		to_chat(usr, SPAN_NOTICE("69B69 has occurred for 69key_name(H)69."))
		return


/datum/admin_topic/revive
	keyword = "revive"
	require_perms = list(R_FUN)

/datum/admin_topic/revive/Run(list/input)
	var/mob/living/L = locate(input69"revive"69)
	if(!istype(L))
		to_chat(usr, "This can only be used on instances of type /mob/living")
		return

	L.revive()
	message_admins("\red Admin 69key_name_admin(usr)69 healed / revived 69key_name_admin(L)69!", 1)
	log_admin("69key_name(usr)69 healed / Revived 69key_name(L)69")


/datum/admin_topic/makeai
	keyword = "makeai"
	require_perms = list(R_FUN)

/datum/admin_topic/makeai/Run(list/input)
	var/mob/living/L = locate(input69"makeai"69)
	if(!istype(L))
		to_chat(usr, "This can only be used on instances of type /mob/living")
		return

	L.AIize()

/datum/admin_topic/makeslime
	keyword = "makeslime"
	require_perms = list(R_FUN)

/datum/admin_topic/makeslime/Run(list/input)
	var/mob/living/L = locate(input69"makeslime"69)
	if(!istype(L))
		to_chat(usr, "This can only be used on instances of type /mob/living")
		return

	usr.client.cmd_admin_slimeize(L)


/datum/admin_topic/makerobot
	keyword = "makerobot"
	require_perms = list(R_FUN)

/datum/admin_topic/makerobot/Run(list/input)
	var/mob/living/H = locate(input69"makerobot"69)
	if(!istype(H))
		to_chat(usr, "This can only be used on instances of type /mob/living")
		return

	usr.client.cmd_admin_robotize(H)


/datum/admin_topic/makeanimal
	keyword = "makeanimal"
	require_perms = list(R_FUN)

/datum/admin_topic/makeanimal/Run(list/input)
	var/mob/living/carbon/human/H = locate(input69"makerobot"69)
	if(!istype(H))
		to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
		return

	usr.client.cmd_admin_robotize(H)


/datum/admin_topic/togmutate
	keyword = "togmutate"
	require_perms = list(R_FUN)

/datum/admin_topic/togmutate/Run(list/input)
	var/mob/living/carbon/human/H = locate(input69"togmutate"69)
	if(!istype(H))
		to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
		return
	var/block=text2num(input69"block"69)
	usr.client.cmd_admin_toggle_block(H,block)
	source.show_player_panel(H)


/datum/admin_topic/adminplayeropts
	keyword = "adminplayeropts"

/datum/admin_topic/adminplayeropts/Run(list/input)
	var/mob/M = locate(input69"adminplayeropts"69)
	source.show_player_panel(M)


/datum/admin_topic/adminobservejump
	keyword = "adminobservejump"
	require_perms = list(R_MENTOR|R_MOD|R_ADMIN)

/datum/admin_topic/adminobservejump/Run(list/input)
	var/mob/M = locate(input69"adminobservejump"69)

	var/client/C = usr.client
	if(!isghost(usr))
		C.admin_ghost()
		sleep(2)
	C.jumptomob(M)


/datum/admin_topic/adminplayerobservecoodjump
	keyword = "adminplayerobservecoodjump"
	require_perms = list(R_ADMIN)

/datum/admin_topic/adminplayerobservecoodjump/Run(list/input)
	var/x = text2num(input69"X"69)
	var/y = text2num(input69"Y"69)
	var/z = text2num(input69"Z"69)

	var/client/C = usr.client
	if(!isghost(usr))
		C.admin_ghost()
	C.jumptocoord(x,y,z)


/datum/admin_topic/adminchecklaws
	keyword = "adminchecklaws"

/datum/admin_topic/adminchecklaws/Run(list/input)
	source.output_ai_laws()


/datum/admin_topic/adminmoreinfo
	keyword = "adminmoreinfo"

/datum/admin_topic/adminmoreinfo/Run(list/input)
	var/mob/M = locate(input69"adminmoreinfo"69)
	if(!ismob(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return

	var/location_description = ""
	var/special_role_description = ""
	var/health_description = ""
	var/gender_description = ""
	var/turf/T = get_turf(M)

	//Location
	if(isturf(T))
		if(isarea(T.loc))
			location_description = "(69M.loc == T ? "at coordinates " : "in 69M.loc69 at coordinates "69 69T.x69, 69T.y69, 69T.z69 in area <b>69T.loc69</b>)"
		else
			location_description = "(69M.loc == T ? "at coordinates " : "in 69M.loc69 at coordinates "69 69T.x69, 69T.y69, 69T.z69)"

	//Job + antagonist
	if(M.mind)
		var/antag = ""
		for(var/datum/antagonist/A in69.mind.antagonist)
			antag += "69A.role_text69, "
		special_role_description = "Role: <b>69M.mind.assigned_role69</b>; Antagonist: <font color='red'><b>69get_player_antag_name(M.mind)69</b></font>;"
	else
		special_role_description = "Role: <i>Mind datum69issing</i> Antagonist: <i>Mind datum69issing</i>; Has been rev: <i>Mind datum69issing</i>;"

	//Health
	if(isliving(M))
		var/mob/living/L =69
		var/status
		switch (M.stat)
			if (0)
				status = "Alive"
			if (1)
				status = "<font color='orange'><b>Unconscious</b></font>"
			if (2)
				status = "<font color='red'><b>Dead</b></font>"
		health_description = "Status = 69status69"
		health_description += "<BR>Oxy: 69L.getOxyLoss()69 - Tox: 69L.getToxLoss()69 - Fire: 69L.getFireLoss()69 - Brute: 69L.getBruteLoss()69 - Clone: 69L.getCloneLoss()69 - Brain: 69L.getBrainLoss()69"
	else
		health_description = "This69ob type has no health to speak of."

	//Gener
	switch(M.gender)
		if(MALE,FEMALE)
			gender_description = "69M.gender69"
		else
			gender_description = "<font color='red'><b>69M.gender69</b></font>"

	to_chat(source.owner, "<b>Info about 69M.name69:</b> ")
	to_chat(source.owner, "Mob type = 69M.type69; Gender = 69gender_description69 Damage = 69health_description69")
	to_chat(source.owner, "Name = <b>69M.name69</b>; Real_name = 69M.real_name69;69ind_name = 69M.mind?"69M.mind.name69":""69; Key = <b>69M.key69</b>;")
	to_chat(source.owner, "Location = 69location_description69;")
	to_chat(source.owner, "69special_role_description69")
	to_chat(source.owner, "(<a href='?src=\ref69usr69;priv_msg=\ref69M69'>PM</a>) (<A HREF='?src=\ref69source69;adminplayeropts=\ref69M69'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref69M69'>VV</A>) (<A HREF='?src=\ref69source69;subtlemessage=\ref69M69'>SM</A>) (69admin_jump_link(M, source)69) (<A HREF='?src=\ref69source69;secretsadmin=check_antagonist'>CA</A>)")


/datum/admin_topic/adminspawncookie
	keyword = "adminspawncookie"
	require_perms = list(R_ADMIN|R_FUN)

/datum/admin_topic/adminspawncookie/Run(list/input)
	var/mob/living/carbon/human/H = locate(input69"adminspawncookie"69)
	if(!ishuman(H))
		to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
		return

	if(!H.equip_to_slot_or_del( new /obj/item/reagent_containers/food/snacks/cookie(H), slot_l_hand ))
		if(!H.equip_to_slot_or_del( new /obj/item/reagent_containers/food/snacks/cookie(H), slot_r_hand ))
			log_admin("69key_name(H)69 has their hands full, so they did not receive their cookie, spawned by 69key_name(source.owner)69.")
			message_admins("69key_name(H)69 has their hands full, so they did not receive their cookie, spawned by 69key_name(source.owner)69.")
			return
	log_admin("69key_name(H)69 got their cookie, spawned by 69key_name(source.owner)69")
	message_admins("69key_name(H)69 got their cookie, spawned by 69key_name(source.owner)69")

	to_chat(H, "\blue Your prayers have been answered!! You received the <b>best cookie</b>!")


/datum/admin_topic/bluespaceartillery
	keyword = "BlueSpaceArtillery"
	require_perms = list(R_ADMIN|R_FUN)

/datum/admin_topic/bluespaceartillery/Run(list/input)
	var/mob/living/M = locate(input69"BlueSpaceArtillery"69)
	if(!isliving(M))
		to_chat(usr, "This can only be used on instances of type /mob/living")
		return

	if(alert(source.owner, "Are you sure you wish to hit 69key_name(M)69 with Blue Space Artillery?",  "Confirm Firing?" , "Yes" , "No") != "Yes")
		return

	if(BSACooldown)
		to_chat(source.owner, "Standby!  Reload cycle in progress!  Gunnary crews ready in five seconds!")
		return

	BSACooldown = TRUE
	spawn(50)
		BSACooldown = FALSE

	to_chat(M, "You've been hit by bluespace artillery!")
	log_admin("69key_name(M)69 has been hit by Bluespace Artillery fired by 69source.owner69")
	message_admins("69key_name(M)69 has been hit by Bluespace Artillery fired by 69source.owner69")

	var/obj/effect/stop/S
	S = new /obj/effect/stop
	S.victim =69
	S.loc =69.loc
	QDEL_IN(S, 20)

	var/turf/simulated/floor/T = get_turf(M)
	if(istype(T))
		if(prob(80))
			T.break_tile_to_plating()
		else
			T.break_tile()

	if(M.health == 1)
		M.gib()
	else
		M.adjustBruteLoss(69in( 99 , (M.health - 1) )    )
		M.Stun(20)
		M.Weaken(20)
		M.stuttering = 20


/datum/admin_topic/adminfaxview
	keyword = "AdminFaxView"

/datum/admin_topic/adminfaxview/Run(list/input)
	var/obj/item/fax = locate(input69"AdminFaxView"69)

	if (istype(fax, /obj/item/paper))
		var/obj/item/paper/P = fax
		P.show_content(usr, TRUE)
	else if (istype(fax, /obj/item/photo))
		var/obj/item/photo/H = fax
		H.show(usr)
	else if (istype(fax, /obj/item/paper_bundle))
		//having69ultiple people turning pages on a paper_bundle can cause issues
		//open a browse window listing the contents instead
		var/data = ""
		var/obj/item/paper_bundle/B = fax

		for (var/page = 1, page <= B.pages.len, page++)
			var/obj/pageobj = B.pages69page69
			data += "<A href='?src=\ref69source69;AdminFaxViewPage=69page69;paper_bundle=\ref69B69'>Page 69page69 - 69pageobj.name69</A><BR>"

		usr << browse(data, "window=69B.name69")
	else
		to_chat(usr, "\red The faxed item is not69iewable. This is probably a bug, and should be reported on the tracker: 69fax.type69")

/datum/admin_topic/adminfaxviewpage
	keyword = "AdminFaxViewPage"

/datum/admin_topic/adminfaxviewpage/Run(list/input)
	var/page = text2num(input69"AdminFaxViewPage"69)
	var/obj/item/paper_bundle/bundle = locate(input69"paper_bundle"69)

	if (!bundle)
		return

	if (istype(bundle.pages69page69, /obj/item/paper))
		var/obj/item/paper/P = bundle.pages69page69
		P.show_content(source.owner, TRUE)
	else if (istype(bundle.pages69page69, /obj/item/photo))
		var/obj/item/photo/H = bundle.pages69page69
		H.show(source.owner)


/datum/admin_topic/centcomfaxreply
	keyword = "CentcomFaxReply"

/datum/admin_topic/centcomfaxreply/Run(list/input)
	var/mob/sender = locate(input69"CentcomFaxReply"69)
	var/obj/machinery/photocopier/faxmachine/fax = locate(input69"originfax"69)

	//todo: sanitize
	var/msg = input(source.owner, "Please enter a69essage to reply to 69key_name(sender)6969ia secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing69essage from Centcom", "") as69essage|null
	if(!msg)
		return

	var/customname = input(source.owner, "Pick a title for the report", "Title") as text|null

	// Create the reply69essage
	var/obj/item/paper/P = new /obj/item/paper( null ) //hopefully the null loc won't cause trouble for us
	P.name = "69command_name()69- 69customname69"
	P.info =69sg
	P.update_icon()

	// Stamps
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!P.stamped)
		P.stamped = new
	P.stamped += /obj/item/stamp
	P.overlays += stampoverlay
	P.stamps += "<HR><i>This paper has been stamped by the Central Command Quantum Relay.</i>"

	if(fax.recievefax(P))
		to_chat(source.owner, "\blue69essage reply to transmitted successfully.")
		log_admin("69key_name(source.owner)69 replied to a fax69essage from 69key_name(sender)69: 69msg69")
		message_admins("69key_name_admin(source.owner)69 replied to a fax69essage from 69key_name_admin(sender)69", 1)
	else
		to_chat(source.owner, "\red69essage reply failed.")

	QDEL_IN(P, 100)


/datum/admin_topic/jumpto
	keyword = "jumpto"
	require_perms = list(R_ADMIN)

/datum/admin_topic/jumpto/Run(list/input)
	var/mob/M = locate(input69"jumpto"69)
	usr.client.jumptomob(M)


/datum/admin_topic/getmob
	keyword = "getmob"
	require_perms = list(R_ADMIN)

/datum/admin_topic/getmob/Run(list/input)
	if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
		return
	var/mob/M = locate(input69"getmob"69)
	usr.client.Getmob(M)


/datum/admin_topic/narrateto
	keyword = "narrateto"
	require_perms = list(R_ADMIN)

/datum/admin_topic/narrateto/Run(list/input)
	var/mob/M = locate(input69"narrateto"69)
	usr.client.cmd_admin_direct_narrate(M)


/datum/admin_topic/subtlemessage
	keyword = "subtlemessage"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/subtlemessage/Run(list/input)
	var/mob/M = locate(input69"subtlemessage"69)
	usr.client.cmd_admin_subtle_message(M)

/datum/admin_topic/manup
	keyword = "manup"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/manup/Run(list/input)
	var/mob/M = locate(input69"manup"69)
	usr.client.man_up(M)

/datum/admin_topic/paralyze
	keyword = "paralyze"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/paralyze/Run(list/input)
	var/mob/M = locate(input69"paralyze"69)

	var/msg
	if (M.paralysis == 0)
		M.paralysis = 8000
		msg = "has paralyzed 69key_name(M)69."
	else
		M.paralysis = 0
		msg = "has unparalyzed 69key_name(M)69."
		log_and_message_admins(msg)

/datum/admin_topic/viewlogs
	keyword = "viewlogs"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/viewlogs/Run(list/input)
	var/mob/M = locate(input69"viewlogs"69)
	source.view_log_panel(M)


/datum/admin_topic/contractor
	keyword = "contractor"
	require_perms = list(R_MOD|R_ADMIN)

/datum/admin_topic/contractor/Run(list/input)
	if(!GLOB.storyteller)
		alert("The game hasn't started yet!")
		return

	var/mob/M = locate(input69"contractor"69)
	if(!ismob(M))
		to_chat(usr, "This can only be used on instances of type /mob.")
		return
	source.show_contractor_panel(M)


/datum/admin_topic/create_object
	keyword = "create_object"
	require_perms = list(R_FUN)

/datum/admin_topic/create_object/Run(list/input)
	return source.create_object(usr)


/datum/admin_topic/quick_create_object
	keyword = "quick_create_object"
	require_perms = list(R_FUN)

/datum/admin_topic/quick_create_object/Run(list/input)
	return source.quick_create_object(usr)


/datum/admin_topic/create_turf
	keyword = "create_turf"
	require_perms = list(R_FUN)

/datum/admin_topic/create_turf/Run(list/input)
	return source.create_turf(usr)


/datum/admin_topic/create_mob
	keyword = "create_mob"
	require_perms = list(R_FUN)

/datum/admin_topic/create_mob/Run(list/input)
	return source.create_mob(usr)


/datum/admin_topic/object_list
	keyword = "object_list"
	require_perms = list(R_FUN)

/datum/admin_topic/object_list/Run(list/input)
	var/atom/loc = usr.loc

	var/dirty_paths
	if (istext(input69"object_list"69))
		dirty_paths = list(input69"object_list"69)
	else if (istype(input69"object_list"69, /list))
		dirty_paths = input69"object_list"69

	var/paths = list()

	for(var/dirty_path in dirty_paths)
		var/path = text2path(dirty_path)
		if(!path)
			continue
		paths += path

	if(!paths)
		alert("The path list you sent is empty")
		return
	if(length(paths) > 5)
		alert("Select fewer object types, (max 5)")
		return

	var/list/offset = splittext(input69"offset"69,",")
	var/number = dd_range(1, 100, text2num(input69"object_count"69))
	var/X = offset.len > 0 ? text2num(offset69169) : 0
	var/Y = offset.len > 1 ? text2num(offset69269) : 0
	var/Z = offset.len > 2 ? text2num(offset69369) : 0
	var/tmp_dir = input69"object_dir"69
	var/obj_dir = tmp_dir ? text2num(tmp_dir) : 2
	if(!obj_dir || !(obj_dir in list(1,2,4,8,5,6,9,10)))
		obj_dir = 2
	var/obj_name = sanitize(input69"object_name"69)


	var/atom/target //Where the object will be spawned
	var/where = input69"object_where"69
	if (!( where in list("onfloor","inhand","inmarked") ))
		where = "onfloor"

	switch(where)
		if("inhand")
			if (!iscarbon(usr) && !isrobot(usr))
				to_chat(usr, "Can only spawn in hand when you're a carbon69ob or cyborg.")
				where = "onfloor"
			target = usr

		if("onfloor")
			switch(input69"offset_type"69)
				if ("absolute")
					target = locate(0 + X,0 + Y,0 + Z)
				if ("relative")
					target = locate(loc.x + X,loc.y + Y,loc.z + Z)
		if("inmarked")
			if(!source.marked_datum())
				to_chat(usr, "You don't have any object69arked. Abandoning spawn.")
				return
			else if(!istype(source.marked_datum(),  /atom))
				to_chat(usr, "The object you have69arked cannot be used as a target. Target69ust be of type /atom. Abandoning spawn.")
				return
			else
				target = source.marked_datum()

	if(target)
		for (var/path in paths)
			for (var/i = 0; i < number; i++)
				if(path in typesof(/turf))
					var/turf/O = target
					var/turf/N = O.ChangeTurf(path)
					if(N && obj_name)
						N.name = obj_name
				else
					var/atom/O = new path(target)
					if(O)
						O.set_dir(obj_dir)
						if(obj_name)
							O.name = obj_name
							if(ismob(O))
								var/mob/M = O
								M.real_name = obj_name
						if(where == "inhand" && isliving(usr) && istype(O, /obj/item))
							var/mob/living/L = usr
							var/obj/item/I = O
							L.put_in_hands(I)
							if(isrobot(L))
								var/mob/living/silicon/robot/R = L
								if(R.module)
									R.module.modules += I
									I.loc = R.module
									R.module.rebuild()
									R.activate_module(I)

	log_and_message_admins("created 69number69 69english_list(paths)69")


/datum/admin_topic/admin_secrets
	keyword = "admin_secrets"

/datum/admin_topic/admin_secrets/Run(list/input)
	var/datum/admin_secret_item/item = locate(input69"admin_secrets"69) in admin_secrets.items
	item.execute(usr)


/datum/admin_topic/populate_inactive_customitems
	keyword = "populate_inactive_customitems"
	require_perms = list(R_ADMIN|R_SERVER)

/datum/admin_topic/populate_inactive_customitems/Run(list/input)
	populate_inactive_customitems_list(source.owner)


/datum/admin_topic/vsc
	keyword = "vsc"
	require_perms = list(R_ADMIN|R_SERVER)

/datum/admin_topic/vsc/Run(list/input)
	switch(input69"vsc"69)
		if("airflow")
			vsc.ChangeSettingsDialog(usr,vsc.settings)
		if("plasma")
			vsc.ChangeSettingsDialog(usr,vsc.plc.settings)
		if("default")
			vsc.SetDefault(usr)


/datum/admin_topic/toglang
	keyword = "toglang"
	require_perms = list(R_FUN)

/datum/admin_topic/toglang/Run(list/input)
	var/mob/M = locate(input69"toglang"69)
	if(!istype(M))
		to_chat(usr, "69M69 is illegal type,69ust be /mob!")
		return
	var/lang2toggle = input69"lang"69
	var/datum/language/L = all_languages69lang2toggle69

	if(L in69.languages)
		if(!M.remove_language(lang2toggle))
			to_chat(usr, "Failed to remove language '69lang2toggle69' from \the 69M69!")
	else
		if(!M.add_language(lang2toggle))
			to_chat(usr, "Failed to add language '69lang2toggle69' from \the 69M69!")


/datum/admin_topic/viewruntime
	keyword = "viewruntime"
	require_perms = list(R_DEBUG)

/datum/admin_topic/viewruntime/Run(list/input)
	var/datum/ErrorViewer/error_viewer = locate(input69"viewruntime"69)
	if(!istype(error_viewer))
		to_chat(usr, "<span class='warning'>That runtime69iewer no longer exists.</span>")
		return
	if(input69"viewruntime_backto"69)
		error_viewer.showTo(usr, locate(input69"viewruntime_backto"69), input69"viewruntime_linear"69)
	else
		error_viewer.showTo(usr, null, input69"viewruntime_linear"69)


/datum/admin_topic/admincaster
	keyword = "admincaster"

/datum/admin_topic/admincaster/Run(list/input)
	switch(input69"admincaster"69)

		if("view_wanted")
			source.admincaster_screen = 18
			source.access_news_network()

		if("set_channel_name")
			source.admincaster_feed_channel.channel_name = sanitizeSafe(input(usr, "Provide a Feed Channel Name", "Network Channel Handler", ""))
			source.access_news_network()

		if("set_channel_lock")
			source.admincaster_feed_channel.locked = !source.admincaster_feed_channel.locked
			source.access_news_network()

		if("submit_new_channel")
			var/check = FALSE
			for(var/datum/feed_channel/FC in news_network.network_channels)
				if(FC.channel_name == source.admincaster_feed_channel.channel_name)
					check = TRUE
					break
			if(source.admincaster_feed_channel.channel_name == "" || source.admincaster_feed_channel.channel_name == "\69REDACTED\69" || check )
				source.admincaster_screen=7
			else
				var/choice = alert("Please confirm Feed channel creation","Network Channel Handler","Confirm","Cancel")
				if(choice=="Confirm")
					news_network.CreateFeedChannel(source.admincaster_feed_channel.channel_name, source.admincaster_signature, source.admincaster_feed_channel.locked, TRUE)

					log_admin("69key_name_admin(usr)69 created command feed channel: 69source.admincaster_feed_channel.channel_name69!")
					source.admincaster_screen=5
			source.access_news_network()

		if("set_channel_receiving")
			var/list/available_channels = list()
			for(var/datum/feed_channel/F in news_network.network_channels)
				available_channels += F.channel_name
			source.admincaster_feed_channel.channel_name = sanitizeSafe(input(usr, "Choose receiving Feed Channel", "Network Channel Handler") in available_channels )
			source.access_news_network()

		if("set_new_message")
			source.admincaster_feed_message.body = sanitize(input(usr, "Write your Feed story", "Network Channel Handler", ""))
			source.access_news_network()

		if("submit_new_message")
			if(source.admincaster_feed_message.body =="" || source.admincaster_feed_message.body =="\69REDACTED\69" || source.admincaster_feed_channel.channel_name == "" )
				source.admincaster_screen = 6
			else

				news_network.SubmitArticle(source.admincaster_feed_message.body, source.admincaster_signature, source.admincaster_feed_channel.channel_name, null, 1)
				source.admincaster_screen=4

			log_admin("69key_name_admin(usr)69 submitted a feed story to channel: 69source.admincaster_feed_channel.channel_name69!")
			source.access_news_network()

		if("create_channel")
			source.admincaster_screen=2
			source.access_news_network()

		if("create_feed_story")
			source.admincaster_screen=3
			source.access_news_network()

		if("menu_censor_story")
			source.admincaster_screen=10
			source.access_news_network()

		if("menu_censor_channel")
			source.admincaster_screen=11
			source.access_news_network()

		if("menu_wanted")
			var/already_wanted = FALSE
			if(news_network.wanted_issue)
				already_wanted = TRUE

			if(already_wanted)
				source.admincaster_feed_message.author = news_network.wanted_issue.author
				source.admincaster_feed_message.body = news_network.wanted_issue.body
			source.admincaster_screen = 14
			source.access_news_network()

		if("set_wanted_name")
			source.admincaster_feed_message.author = sanitize(input(usr, "Provide the name of the Wanted person", "Network Security Handler", ""))
			source.access_news_network()

		if("set_wanted_desc")
			source.admincaster_feed_message.body = sanitize(input(usr, "Provide the a description of the Wanted person and any other details you deem important", "Network Security Handler", ""))
			source.access_news_network()

		if("submit_wanted")
			var/input_param = text2num(input69"submit_wanted"69)
			if(source.admincaster_feed_message.author == "" || source.admincaster_feed_message.body == "")
				source.admincaster_screen = 16
			else
				var/choice = alert("Please confirm Wanted Issue 69(input_param==1) ? ("creation.") : ("edit.")69","Network Security Handler","Confirm","Cancel")
				if(choice=="Confirm")
					if(input_param==1)          //If input_param == 1 we're submitting a new wanted issue. At 2 we're just editing an existing one. See the else below
						var/datum/feed_message/WANTED = new /datum/feed_message
						WANTED.author = source.admincaster_feed_message.author               //Wanted name
						WANTED.body = source.admincaster_feed_message.body                   //Wanted desc
						WANTED.backup_author = source.admincaster_signature                  //Submitted by
						WANTED.is_admin_message = 1
						news_network.wanted_issue = WANTED
						for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
							NEWSCASTER.newsAlert()
							NEWSCASTER.update_icon()
						source.admincaster_screen = 15
					else
						news_network.wanted_issue.author = source.admincaster_feed_message.author
						news_network.wanted_issue.body = source.admincaster_feed_message.body
						news_network.wanted_issue.backup_author = source.admincaster_feed_message.backup_author
						source.admincaster_screen = 19
					log_admin("69key_name_admin(usr)69 issued a Station-wide Wanted Notification for 69source.admincaster_feed_message.author69!")
			source.access_news_network()

		if("cancel_wanted")
			var/choice = alert("Please confirm Wanted Issue removal","Network Security Handler","Confirm","Cancel")
			if(choice=="Confirm")
				news_network.wanted_issue = null
				for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
					NEWSCASTER.update_icon()
				source.admincaster_screen=17
			source.access_news_network()

		if("censor_channel_author")
			var/datum/feed_channel/FC = locate(input69"censor_channel_author"69)
			if(FC.author != "<B>\69REDACTED\69</B>")
				FC.backup_author = FC.author
				FC.author = "<B>\69REDACTED\69</B>"
			else
				FC.author = FC.backup_author
			source.access_news_network()

		if("censor_channel_story_body")
			var/datum/feed_message/MSG = locate(input69"censor_channel_story_body"69)
			if(MSG.body != "<B>\69REDACTED\69</B>")
				MSG.backup_body =69SG.body
				MSG.body = "<B>\69REDACTED\69</B>"
			else
				MSG.body =69SG.backup_body
			source.access_news_network()

		if("pick_d_notice")
			var/datum/feed_channel/FC = locate(input69"pick_d_notice"69)
			source.admincaster_feed_channel = FC
			source.admincaster_screen=13
			source.access_news_network()

		if("toggle_d_notice")
			var/datum/feed_channel/FC = locate(input69"toggle_d_notice"69)
			FC.censored = !FC.censored
			source.access_news_network()

		if("setScreen") //Brings us to the69ain69enu and resets all fields~
			source.admincaster_screen = text2num(input69"setScreen"69)
			if(source.admincaster_screen == 0)
				if(source.admincaster_feed_channel)
					source.admincaster_feed_channel = new /datum/feed_channel
				if(source.admincaster_feed_message)
					source.admincaster_feed_message = new /datum/feed_message
			source.access_news_network()

		if("show_channel")
			var/datum/feed_channel/FC = locate(input69"show_channel"69)
			source.admincaster_feed_channel = FC
			source.admincaster_screen = 9
			source.access_news_network()

		if("pick_censor_channel")
			var/datum/feed_channel/FC = locate(input69"pick_censor_channel"69)
			source.admincaster_feed_channel = FC
			source.admincaster_screen = 12
			source.access_news_network()

		if("refresh")
			source.access_news_network()

		if("set_signature")
			source.admincaster_signature = sanitize(input(usr, "Provide your desired signature", "Network Identity Handler", ""))
			source.access_news_network()

		if("view")
			source.admincaster_screen = 1
			source.access_news_network()


//Player Notes
/datum/admin_topic/notes
	keyword = "notes"

/datum/admin_topic/notes/Run(list/input)
	var/ckey = input69"ckey"69
	if(!ckey)
		var/mob/M = locate(input69"mob"69)
		if(ismob(M))
			ckey =69.ckey

	switch(input69keyword69)
		if("add")
			notes_add(ckey, input69"text"69)
		if("remove")
			notes_remove(ckey, text2num(input69"from"69), text2num(input69"to"69))

	source.notes_show(ckey)
