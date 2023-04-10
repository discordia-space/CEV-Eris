/client/proc/save_playtimes()
	var/client_key = ckey
	if(!ckey)
		return
	if(!establish_db_connection())
		return
