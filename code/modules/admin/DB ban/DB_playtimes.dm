/proc/save_playtimes()
	if(!establish_db_connection())
		return FALSE
	for(var/ckey in SSinactivity.ckey_to_job_playtime)
		for(var/job in SSinactivity.ckey_to_job_playtime[ckey])
			var/player_id = null
			var/DBquery/id_query = dbcon.NewQuery("SELECT id FROM players WHERE ckey = '[ckey]'")
			if(!id_query.NextRow)
				message_admins("Failed to obtain player database ID for [ckey]")
				continue
			player_id = id_query.item[1]
			var/DBQuery/job_query = dbcon.NewQuery("SELECT time_played FROM playtimes WHERE id = '[player_id]' ")
			if(!job_query.NextRow)
				var/DBQuery/insertion = dbcon.NewQuery("INSERT INTO playtimes (id, job, time_played) VALUES ([player_id], '[job]', [round((SSinactivity.ckey_to_job_playtime[ckey][job][2] - SSinactivity.ckey_to_job_playtime[ckey][job][1])/600)])")
				if(!insertion.Execute)
					message_admins("Failed to create a playtime database for [ckey] , [job] with error [update.ErrorMsg()]")
			else
				var/cur_playtime = job_query.item[1] + round((SSinactivity.ckey_to_job_playtime[ckey][job][2] - SSinactivity.ckey_to_job_playtime[ckey][job][1])/600)
				var/DBQuery/update = dbcon.NewQuery("UPDATE playtimes SET time_played = [cur_playtime] WHERE id = '[player_id]'")
				if(!update.Execute())
					message_admins("Failed to update time played for [ckey] [job] with error [update.ErrorMsg()]")

/proc/whitelist_from_job_playtimes(ckey)
	if(!establish_db_connection())
		return FALSE
	var/DBQuery/get_him = dbcon.NewQuery("SELECT id FROM whitelisted_from_job_playtimes WHERE ckey = '[ckey]'")
	if(get_him.NextRow())
		var/DBQuery/update = dbcon.NewQuery("UPDATE whitelisted_from_job_playtimes SET whitelisted = 1, WHERE ckey = '[ckey]'")
		if(!update.Execute())
			message_admins("Failed to update whitelisted for [ckey] with error [update.ErrorMsg()]")
	else
		get_him = dbcon.NewQuery("SELECT id FROM players WHERE ckey = '[ckey]'")
		if(get_him.NextRow())
			var/DBQuery/insertion = dbcon.NewQuery("INSERT INTO whitelisted_from_job_playtimes (id, ckey, whitelisted) VALUES ([get_him.item[1]], '[ckey]', 1)")
			if(!insertion.Execute())
				message_servers("Failed to whitelist [ckey] due to error [insertion.ErrorMsg()]")

/proc/unwhitelist_from_job_playtimes(ckey)
	if(!establish_db_connection())
		return FALSE
	var/DBQuery/get_him = dbcon.NewQuery("SELECT id FROM whitelisted_from_job_playtimes WHERE ckey = '[ckey]'")
	if(get_him.NextRow())
		var/DBQuery/update = dbcon.NewQuery("UPDATE whitelisted_from_job_playtimes SET whitelisted = 0, WHERE ckey = '[ckey]'")
		if(!update.Execute())
			message_admins("Failed to unwhitelist for [ckey] with error [update.ErrorMsg()]")
	else
		to_chat(usr, "The target ckey is not whitelisted")


