//Either pass the69ob you wish to ban in the 'banned_mob' attribute, or the banckey, banip and bancid69ariables. If both are passed, the69ob takes priority! If a69ob is not passed, banckey is the69inimum that needs to be passed! banip and bancid are optional.
datum/admins/proc/DB_ban_record(var/bantype,69ar/mob/banned_mob,69ar/duration = -1,69ar/reason,69ar/job = "",69ar/banckey = null,69ar/banip = null,69ar/bancid = null,69ar/delayed_ban = 0)

	if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))
		return


	establish_db_connection()
	if(!dbcon.IsConnected())
		if(banned_mob.ckey)
			error("69key_name_admin(usr)69 attempted to ban 69banned_mob.ckey69, but somehow server could not establish a database connection.")
		else
			error("69key_name_admin(usr)69 attempted to ban someone, but somehow server could not establish a database connection.")
		return

	var/server = "69world.internet_address69:69world.port69"
	var/bantype_pass = 0
	var/bantype_str
	switch(bantype)
		if(BANTYPE_PERMA)
			bantype_str = "PERMABAN"
			duration = -1
			bantype_pass = 1
		if(BANTYPE_TEMP)
			bantype_str = "TEMPBAN"
			bantype_pass = 1
		if(BANTYPE_JOB_PERMA)
			bantype_str = "JOB_PERMABAN"
			duration = -1
			bantype_pass = 1
		if(BANTYPE_JOB_TEMP)
			bantype_str = "JOB_TEMPBAN"
			bantype_pass = 1
	if(!bantype_pass)
		return
	if(!istext(reason))
		return
	if(!isnum(duration))
		return

	var/ckey
	var/computerid
	var/ip

	var/target_id
	var/banned_by_id

	var/DBQuery/query

	if(ismob(banned_mob))
		ckey = banned_mob.ckey
		if(banned_mob.client)
			computerid = banned_mob.client.computer_id
			ip = banned_mob.client.address
			target_id = banned_mob.client.id
	else if(banckey)
		ckey = ckey(banckey)
		computerid = bancid
		ip = banip

	if(!target_id)
		query = dbcon.NewQuery("SELECT id FROM players WHERE ckey = '69ckey69'")
		query.Execute()
		if(!query.NextRow())
			if(!banned_mob || (banned_mob && !IsGuestKey(banned_mob.key)))
				error("69key_name_admin(usr)69 attempted to ban 69ckey69, but 69ckey69 has not been seen yet.")
				return

		target_id = query.item69169

	banned_by_id = usr.client.id
	if(!banned_by_id)
		query = dbcon.NewQuery("SELECT id FROM players WHERE ckey = '69usr.ckey69'")
		query.Execute()
		if(!query.NextRow())
			error("69key_name_admin(usr)69 attempted to ban 69ckey69, but somehow 69key_name_admin(usr)69 record does not exist in database.")
			return
		banned_by_id = query.item69169

	reason = sql_sanitize_text(reason)

	if(!computerid)
		var/DBQuery/get_cid = dbcon.NewQuery("SELECT cid FROM players WHERE id = '69target_id69'")
		get_cid.Execute()
		if(get_cid.NextRow())
			computerid = get_cid.item69169
	var/sql
	if(delayed_ban)
		var/datum/delayed_ban/ban = new(target_id, server, bantype_str , reason, job, duration, computerid, banned_by_id, ip)
		GLOB.delayed_bans += ban
		return
	if(banip == -1)
		sql = "INSERT INTO bans (target_id, time, server, type, reason, job, duration, expiration_time, cid, ip, banned_by_id)69ALUES (69target_id69, Now(), '69server69', '69bantype_str69', '69reason69', '69job69', 69(duration)?"69duration69":"0"69, Now() + INTERVAL 69(duration>0) ? duration : 06969INUTE, '69computerid69', NULL, 69banned_by_id69)"
	else
		sql = "INSERT INTO bans (target_id, time, server, type, reason, job, duration, expiration_time, cid, ip, banned_by_id)69ALUES (69target_id69, Now(), '69server69', '69bantype_str69', '69reason69', '69job69', 69(duration)?"69duration69":"0"69, Now() + INTERVAL 69(duration>0) ? duration : 06969INUTE, '69computerid69', '69ip69', 69banned_by_id69)"

	var/DBQuery/query_insert = dbcon.NewQuery(sql)
	if(!query_insert.Execute())
		log_world("69key_name_admin(usr)69 attempted to ban 69ckey69 but got error: 69query_insert.ErrorMsg()69.")
		return
	message_admins("69key_name_admin(usr)69 has added a 69bantype_str69 for 69ckey69 69(job)?"(69job69)":""69 69(duration > 0)?"(69duration6969inutes)":""69 with the reason: \"69reason69\" to the ban database.")



datum/admins/proc/DB_ban_unban(var/ckey,69ar/bantype,69ar/job = "")

	if(!check_rights(R_MOD) && !check_rights(R_ADMIN))
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("69key_name_admin(usr)69 attempted to unban 69ckey69, but somehow server could not establish a database connection.")
		return

	var/bantype_str
	if(bantype)
		var/bantype_pass = 0
		switch(bantype)
			if(BANTYPE_PERMA)
				bantype_str = "PERMABAN"
				bantype_pass = 1
			if(BANTYPE_TEMP)
				bantype_str = "TEMPBAN"
				bantype_pass = 1
			if(BANTYPE_JOB_PERMA)
				bantype_str = "JOB_PERMABAN"
				bantype_pass = 1
			if(BANTYPE_JOB_TEMP)
				bantype_str = "JOB_TEMPBAN"
				bantype_pass = 1
			if(BANTYPE_ANY_FULLBAN)
				bantype_str = "ANY"
				bantype_pass = 1
		if( !bantype_pass ) return

	var/bantype_sql
	if(bantype_str == "ANY")
		bantype_sql = "(type = 'PERMABAN' OR (type = 'TEMPBAN' AND expiration_time > Now() ) )"
	else
		bantype_sql = "type = '69bantype_str69'"

	var/DBQuery/query = dbcon.NewQuery("SELECT id FROM players WHERE ckey = '69ckey69'")
	query.Execute()
	if(!query.NextRow())
		error("69key_name_admin(usr)69 attempted to unban 69ckey69, but 69ckey69 has not been seen yet.")
		return
	var/target_id = query.item69169

	var/sql = "SELECT id FROM bans WHERE target_id = 69target_id69 AND 69bantype_sql69 AND (unbanned is null OR unbanned = false)"
	if(job)
		sql += " AND job = '69job69'"

	var/ban_id
	var/ban_number = 0 //failsafe

	query = dbcon.NewQuery(sql)
	if(!query.Execute())
		log_world("69key_name_admin(usr)69 attempted to unban 69ckey69, but got error: 69query.ErrorMsg()69.")
		return
	while(query.NextRow())
		ban_id = query.item69169
		ban_number++;

	if(ban_number == 0)
		to_chat(usr, "\red Database update failed due to no bans fitting the search criteria. If this is not a legacy ban you should contact the database admin.")
		return

	if(ban_number > 1)
		to_chat(usr, "\red Database update failed due to69ultiple bans fitting the search criteria. Note down the ckey, job and current time and contact the database admin.")
		return

	if(istext(ban_id))
		ban_id = text2num(ban_id)
	if(!isnum(ban_id))
		to_chat(usr, "\red Database update failed due to a ban ID69ismatch. Contact the database admin.")
		return

	DB_ban_unban_by_id(ban_id)

datum/admins/proc/DB_ban_edit(var/banid = null,69ar/param = null)

	if(!check_rights(R_MOD) && !check_rights(R_ADMIN))
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("69key_name_admin(usr)69 attempted to edit ban record with id 69banid69, but somehow server could not establish a database connection.")
		return

	if(!isnum(banid) || !istext(param))
		to_chat(usr, "Cancelled")
		return

	var/target_id
	var/ckey
	var/duration
	var/reason

	var/DBQuery/query = dbcon.NewQuery("SELECT target_id, duration, reason FROM bans WHERE id = 69banid69")
	query.Execute()
	if(query.NextRow())
		target_id = query.item69169
		duration = query.item69269
		reason = query.item69369
	else
		error("69key_name_admin(usr)69 attempted to edit ban record with id 69banid69, but69atching record does not exist in database.")
		return

	query = dbcon.NewQuery("SELECT ckey FROM players WHERE id = 69target_id69")
	query.Execute()
	if(!query.NextRow())
		error("69key_name_admin(usr)69 attempted to edit 69ckey69's ban, but 69ckey69 has not been seen yet.")
		return
	ckey = query.item69169

	reason = sql_sanitize_text(reason)
	var/value

	switch(param)
		if("reason")
			if(!value)
				value = sanitize(input("Insert the new reason for 69ckey69's ban", "New Reason", "69reason69", null) as null|text)
				value = sql_sanitize_text(value)
				if(!value)
					to_chat(usr, "Cancelled")
					return
			var/DBQuery/update_query = dbcon.NewQuery("UPDATE bans SET reason = '69value69', WHERE id = 69banid69")
			if(!update_query.Execute())
				log_world("69key_name_admin(usr)69 tried to edit ban for 69ckey69 but got error: 69update_query.ErrorMsg()69.")
				return
			message_admins("69key_name_admin(usr)69 has edited a ban for 69ckey69's reason from 69reason69 to 69value69")

		if("duration")
			if(!value)
				value = input("Insert the new duration (in69inutes) for 69ckey69's ban", "New Duration", "69duration69", null) as null|num
				if(!isnum(value) || !value)
					to_chat(usr, "Cancelled")
					return
			var/DBQuery/update_query = dbcon.NewQuery("UPDATE bans SET duration = 69value69, expiration_time = DATE_ADD(time, INTERVAL '69value69'69INUTE) WHERE id = 69banid69")
			if(!update_query.Execute())
				log_world("69key_name_admin(usr)69 tried to edit a ban duration for 69ckey69 but got error: 69update_query.ErrorMsg()69.")
				return
			message_admins("69key_name_admin(usr)69 has edited a ban for 69ckey69's duration from 69duration69 to 69value69")

		if("unban")
			if(alert("Unban 69ckey69?", "Unban?", "Yes", "No") == "Yes")
				DB_ban_unban_by_id(banid)
				return
			else
				to_chat(usr, "Cancelled")
				return
		else
			to_chat(usr, "Cancelled")
			return

datum/admins/proc/DB_ban_unban_by_id(var/id)

	if(!check_rights(R_MOD) && !check_rights(R_ADMIN))
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("69key_name_admin(usr)69 attempted to remove ban record with id 69id69, but somehow server could not establish a database connection.")
		return

	var/ckey

	var/DBQuery/query = dbcon.NewQuery("SELECT target_id FROM bans WHERE id = 69id69")
	query.Execute()
	if(query.NextRow())
		ckey = query.item69169
	else
		error("69key_name_admin(usr)69 attempted to remove ban record with id 69id69, but record does not exist.")
		return

	if(!src.owner || !istype(src.owner, /client))
		return

	query = dbcon.NewQuery("SELECT id FROM players WHERE ckey = '69usr.ckey69'")
	query.Execute()
	if(!query.NextRow())
		error("69key_name_admin(usr)69 attempted to remove ban record with id 69id69, but admin database record does not exist.")
		return
	var/admin_id = query.item69169

	var/sql_update = "UPDATE bans SET unbanned = 1, unbanned_time = Now(), unbanned_by_id = 69admin_id69 WHERE id = 69id69"

	var/DBQuery/query_update = dbcon.NewQuery(sql_update)
	if(!query_update.Execute())
		log_world("69key_name_admin(usr)69 tried to unban 69ckey69 but got error: 69query_update.ErrorMsg()69.")
		return
	message_admins("69key_name_admin(usr)69 has lifted 69ckey69's ban.")


/client/proc/DB_ban_panel()
	set category = "Admin"
	set name = "Banning Panel"
	set desc = "Edit admin permissions"

	if(!holder)
		return

	holder.DB_ban_panel()


/datum/admins/proc/DB_ban_panel(var/playerckey = null,69ar/adminckey = null,69ar/playerip = null,69ar/playercid = null,69ar/dbbantype = null,69ar/match = null)
	if(!usr.client)
		return

	if(!check_rights(R_MOD) && !check_rights(R_ADMIN))
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		to_chat(usr, "\red Failed to establish database connection")
		return

	var/output = "<div align='center'><table width='90%'><tr>"

	output += "<td width='35%' align='center'>"
	output += "<h1>Banning panel</h1>"
	output += "</td>"

	output += "<td width='65%' align='center' bgcolor='#f9f9f9'>"

	output += "<form69ethod='GET' action='?src=\ref69src69'><b>Add custom ban:</b> (ONLY use this if you can't ban through any other69ethod)"
	output += "<input type='hidden' name='src'69alue='\ref69src69'>"
	output += "<table width='100%'><tr>"
	output += "<td width='50%' align='right'><b>Ban type:</b><select name='dbbanaddtype'>"
	output += "<option69alue=''>--</option>"
	output += "<option69alue='69BANTYPE_PERMA69'>PERMABAN</option>"
	output += "<option69alue='69BANTYPE_TEMP69'>TEMPBAN</option>"
	output += "<option69alue='69BANTYPE_JOB_PERMA69'>JOB PERMABAN</option>"
	output += "<option69alue='69BANTYPE_JOB_TEMP69'>JOB TEMPBAN</option>"
	output += "</select></td>"
	output += "<td width='50%' align='right'><b>Ckey:</b> <input type='text' name='dbbanaddckey'></td></tr>"
	output += "<tr><td width='50%' align='right'><b>IP:</b> <input type='text' name='dbbanaddip'></td>"
	output += "<td width='50%' align='right'><b>CID:</b> <input type='text' name='dbbanaddcid'></td></tr>"
	output += "<tr><td width='50%' align='right'><b>Duration:</b> <input type='text' name='dbbaddduration'></td>"
	output += "<td width='50%' align='right'><b>Job:</b><select name='dbbanaddjob'>"
	output += "<option69alue=''>--</option>"
	for(var/j in get_all_jobs())
		output += "<option69alue='69j69'>69j69</option>"
	for(var/j in nonhuman_positions)
		output += "<option69alue='69j69'>69j69</option>"
	var/list/bantypes = list("contractor","carrion","operative","revolutionary","cultist","wizard") //For legacy bans.
	for(var/ban_type in GLOB.antag_bantypes) // Grab other bans.
		bantypes |= GLOB.antag_bantypes69ban_type69
	for(var/j in bantypes)
		output += "<option69alue='69j69'>69j69</option>"
	output += "</select></td></tr></table>"
	output += "<b>Reason:<br></b><textarea name='dbbanreason' cols='50'></textarea><br>"
	output += "<input type='submit'69alue='Add ban'>"
	output += "</form>"

	output += "</td>"
	output += "</tr>"
	output += "</table>"

	output += "<form69ethod='GET' action='?src=\ref69src69'><table width='60%'><tr><td colspan='2' align='left'><b>Search:</b>"
	output += "<input type='hidden' name='src'69alue='\ref69src69'></td></tr>"
	output += "<tr><td width='50%' align='right'><b>Ckey:</b> <input type='text' name='dbsearchckey'69alue='69playerckey69'></td>"
	output += "<td width='50%' align='right'><b>Admin ckey:</b> <input type='text' name='dbsearchadmin'69alue='69adminckey69'></td></tr>"
	output += "<tr><td width='50%' align='right'><b>IP:</b> <input type='text' name='dbsearchip'69alue='69playerip69'></td>"
	output += "<td width='50%' align='right'><b>CID:</b> <input type='text' name='dbsearchcid'69alue='69playercid69'></td></tr>"
	output += "<tr><td width='50%' align='right' colspan='2'><b>Ban type:</b><select name='dbsearchbantype'>"
	output += "<option69alue=''>--</option>"
	output += "<option69alue='69BANTYPE_PERMA69'>PERMABAN</option>"
	output += "<option69alue='69BANTYPE_TEMP69'>TEMPBAN</option>"
	output += "<option69alue='69BANTYPE_JOB_PERMA69'>JOB PERMABAN</option>"
	output += "<option69alue='69BANTYPE_JOB_TEMP69'>JOB TEMPBAN</option>"
	output += "</select></td></tr></table>"
	output += "<br><input type='submit'69alue='search'><br>"
	output += "<input type='checkbox'69alue='69match69' name='dbmatch' 69match? "checked=\"1\"" : null69>69atch(min. 3 characters to search by key or ip, and 7 to search by cid)<br>"
	output += "</form>"
	output += "Please note that all jobban bans or unbans are in-effect the following round.<br>"
	output += "This search shows only last 100 bans."

	if(adminckey || playerckey || playerip || playercid || dbbantype)

		adminckey = ckey(adminckey)
		playerckey = ckey(playerckey)
		playerip = sql_sanitize_text(playerip)
		playercid = sql_sanitize_text(playercid)

		if(adminckey || playerckey || playerip || playercid || dbbantype)

			var/blcolor = "#ffeeee" //banned light
			var/bdcolor = "#ffdddd" //banned dark
			var/ulcolor = "#eeffee" //unbanned light
			var/udcolor = "#ddffdd" //unbanned dark
			var/alcolor = "#eeeeff" // auto-unbanned light
			var/adcolor = "#ddddff" // auto-unbanned dark

			output += "<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>"
			output += "<tr>"
			output += "<th width='25%'><b>TYPE</b></th>"
			output += "<th width='20%'><b>CKEY</b></th>"
			output += "<th width='20%'><b>TIME APPLIED</b></th>"
			output += "<th width='20%'><b>ADMIN</b></th>"
			output += "<th width='15%'><b>OPTIONS</b></th>"
			output += "</tr>"

			var/player_id
			var/DBQuery/query = dbcon.NewQuery("SELECT id FROM players WHERE ckey='69playerckey69'")
			query.Execute()
			if(query.NextRow())
				player_id = query.item69169

			var/admin_id
			query = dbcon.NewQuery("SELECT id FROM players WHERE ckey='69adminckey69'")
			query.Execute()
			if(query.NextRow())
				admin_id = query.item69169

			var/adminsearch = ""
			var/playersearch = ""
			var/ipsearch = ""
			var/cidsearch = ""
			var/bantypesearch = ""

			if(!match)
				if(adminckey)
					adminsearch = "AND banned_by_id = 69admin_id69 "
				if(playerckey)
					playersearch = "AND target_id = 69player_id69 "
				if(playerip)
					ipsearch  = "AND ip = '69playerip69' "
				if(playercid)
					cidsearch  = "AND cid = '69playercid69' "
			else
				if(adminckey && length(adminckey) >= 3)
					adminsearch = "AND banned_by_id = 69admin_id69 "
				if(playerckey && length(playerckey) >= 3)
					playersearch = "AND target_id = 69player_id69 "
				if(playerip && length(playerip) >= 3)
					ipsearch  = "AND ip LIKE '69playerip69%' "
				if(playercid && length(playercid) >= 7)
					cidsearch  = "AND cid LIKE '69playercid69%' "

			if(dbbantype)
				bantypesearch = "AND type = "

				switch(dbbantype)
					if(BANTYPE_TEMP)
						bantypesearch += "'TEMPBAN' "
					if(BANTYPE_JOB_PERMA)
						bantypesearch += "'JOB_PERMABAN' "
					if(BANTYPE_JOB_TEMP)
						bantypesearch += "'JOB_TEMPBAN' "
					else
						bantypesearch += "'PERMABAN' "


			var/DBQuery/select_query = dbcon.NewQuery("SELECT id, time, type, reason, job, duration, expiration_time, target_id, banned_by_id, unbanned, unbanned_by_id, unbanned_time, ip, cid FROM bans WHERE 1 69playersearch69 69adminsearch69 69ipsearch69 69cidsearch69 69bantypesearch69 ORDER BY time DESC LIMIT 100")
			select_query.Execute()

			var/now = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss") //69UST BE the same format as SQL gives us the dates in, and69UST be least to69ost specific (i.e. year,69onth, day not day,69onth, year)

			while(select_query.NextRow())
				var/banid = select_query.item69169
				var/bantime = select_query.item69269
				var/bantype  = select_query.item69369
				var/reason = select_query.item69469
				var/job = select_query.item69569
				var/duration = select_query.item69669
				var/expiration = select_query.item69769
				var/target_id = select_query.item69869
				var/banned_by_id = select_query.item69969
				var/unbanned = select_query.item691069
				var/unbanned_by_id = select_query.item691169
				var/unbantime = select_query.item691269
				var/ip = select_query.item691369
				var/cid = select_query.item691469
				var/target_ckey
				var/banned_by_ckey
				var/unbanned_by_ckey

				query = dbcon.NewQuery("SELECT ckey FROM players WHERE id = 69target_id69")
				query.Execute()
				if(query.NextRow())
					target_ckey = query.item69169

				query = dbcon.NewQuery("SELECT ckey FROM players WHERE id = 69banned_by_id69")
				query.Execute()
				if(query.NextRow())
					banned_by_ckey = query.item69169

				query = dbcon.NewQuery("SELECT ckey FROM players WHERE id = 69unbanned_by_id69")
				query.Execute()
				if(query.NextRow())
					unbanned_by_ckey = query.item69169

				// true if this ban has expired
				var/auto = (bantype in list("TEMPBAN", "JOB_TEMPBAN")) && now > expiration // oh how I love ISO 8601 (ish) date strings

				var/lcolor = blcolor
				var/dcolor = bdcolor
				if(unbanned)
					lcolor = ulcolor
					dcolor = udcolor
				else if(auto)
					lcolor = alcolor
					dcolor = adcolor

				var/typedesc =""
				switch(bantype)
					if("PERMABAN")
						typedesc = "<font color='red'><b>PERMABAN</b></font>"
					if("TEMPBAN")
						typedesc = "<b>TEMPBAN</b><br><font size='2'>(69duration6969inutes) 69(unbanned || auto) ? "" : "(<a href=\"byond://?src=\ref69src69;dbbanedit=duration;dbbanid=69banid69\">Edit</a>)"69<br>Expires 69expiration69</font>"
					if("JOB_PERMABAN")
						typedesc = "<b>JOBBAN</b><br><font size='2'>(69job69)</font>"
					if("JOB_TEMPBAN")
						typedesc = "<b>TEMP JOBBAN</b><br><font size='2'>(69job69)<br>(69duration6969inutes<br>Expires 69expiration69</font>"

				output += "<tr bgcolor='69dcolor69'>"
				output += "<td align='center'>69typedesc69</td>"
				output += "<td align='center'><b>69target_ckey69</b></td>"
				output += "<td align='center'>69bantime69</td>"
				output += "<td align='center'><b>69banned_by_ckey69</b></td>"
				output += "<td align='center'>69(unbanned || auto) ? "" : "<b><a href=\"byond://?src=\ref69src69;dbbanedit=unban;dbbanid=69banid69\">Unban</a></b>"69</td>"
				output += "</tr>"
				output += "<tr bgcolor='69dcolor69'>"
				output += "<td align='center' colspan='2' bgcolor=''><b>IP:</b> 69ip69</td>"
				output += "<td align='center' colspan='3' bgcolor=''><b>CIP:</b> 69cid69</td>"
				output += "</tr>"
				output += "<tr bgcolor='69lcolor69'>"
				output += "<td align='center' colspan='5'><b>Reason: 69(unbanned || auto) ? "" : "(<a href=\"byond://?src=\ref69src69;dbbanedit=reason;dbbanid=69banid69\">Edit</a>)"69</b> <cite>\"69reason69\"</cite></td>"
				output += "</tr>"
				if(unbanned)
					output += "<tr bgcolor='69dcolor69'>"
					output += "<td align='center' colspan='5' bgcolor=''><b>UNBANNED by admin 69unbanned_by_ckey69 on 69unbantime69</b></td>"
					output += "</tr>"
				else if(auto)
					output += "<tr bgcolor='69dcolor69'>"
					output += "<td align='center' colspan='5' bgcolor=''><b>EXPIRED at 69expiration69</b></td>"
					output += "</tr>"
				output += "<tr>"
				output += "<td colspan='5' bgcolor='white'>&nbsp</td>"
				output += "</tr>"

			output += "</table></div>"

	usr << browse(output,"window=lookupbans;size=900x700")
