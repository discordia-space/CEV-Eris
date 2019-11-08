var/list/admin_ranks = list() //list of all ranks with associated rights


// This proc is using only without database connection
/proc/load_admins_legacy()
	load_admin_ranks_legacy()

	//load text from file
	var/list/Lines = file2list("config/admins.txt")

	//process each line seperately
	for(var/line in Lines)
		if(!length(line))
			continue
		if(copytext(line,1,2) == "#")
			continue

		//Split the line at every "-"
		var/list/List = splittext(line, "-")
		if(!List.len)
			continue

		//ckey is before the first "-"
		var/ckey = ckey(List[1])
		if(!ckey)
			continue

		//rank follows the first "-"
		var/rank = ""
		if(List.len >= 2)
			rank = ckeyEx(List[2])

		//load permissions associated with this rank
		var/rights = admin_ranks[rank]

		//create the admin datum and store it for later use
		var/datum/admins/D = new /datum/admins(rank, rights, ckey)

		//find the client for a ckey if they are connected and associate them with the new admin datum
		D.associate(directory[ckey])


// This proc is using only without database connection
/proc/load_admin_ranks_legacy()
	admin_ranks.Cut()

	var/previous_rights = 0

	//load text from file
	var/list/Lines = file2list("config/admin_ranks.txt")

	//process each line seperately
	for(var/line in Lines)
		if(!length(line))
			continue
		if(copytext(line, 1, 2) == "#")
			continue

		var/list/List = splittext(line, "+")
		if(!List.len)
			continue

		var/rank = ckeyEx(List[1])
		switch(rank)
			if(null, "")
				continue

		var/rights = 0
		for(var/i = 2, i <= List.len, i++)
			switch(ckey(List[i]))

				if("@", "prev")
					rights |= previous_rights
				if("admin")
					rights |= R_ADMIN
				if("fun")
					rights |= R_FUN
				if("server")
					rights |= R_SERVER
				if("debug")
					rights |= R_DEBUG
				if("permissions", "rights")
					rights |= R_PERMISSIONS
				if("everything", "host", "all")
					rights |= (R_ADMIN | R_FUN | R_SERVER | R_DEBUG | R_PERMISSIONS | R_MOD | R_MENTOR)
				if("mod")
					rights |= R_MOD
				if("mentor")
					rights |= R_MENTOR

		admin_ranks[rank] = rights
		previous_rights = rights


/proc/clear_admin_datums()
	admin_datums.Cut()
	for(var/client/C in admins)
		C.remove_admin_verbs()
		C.holder = null
	admins.Cut()


/hook/startup/proc/loadAdmins()
	clear_admin_datums()

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("Failed to connect to database in load_admins(). Reverting to legacy system.")
		log_misc("Failed to connect to database in load_admins(). Reverting to legacy system.")
		load_admins_legacy()
		return

	else
		load_admins()

		if(!admin_datums)
			error("The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
			log_misc("The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
			config.admin_legacy_system = 1
			load_admins_legacy()
			return

/proc/load_admins()
	var/DBQuery/query = dbcon.NewQuery("SELECT ckey, rank, flags FROM players WHERE rank != 'player'")
	query.Execute()
	while(query.NextRow())
		var/ckey = query.item[1]
		var/rank = query.item[2]
		var/flags = query.item[3]

		if(istext(flags))
			flags = text2num(flags)

		// var/permissions = load_permissions(id) // Should be used only after permission db schema rework
		var/datum/admins/D = new /datum/admins(rank, flags, ckey)

		//find the client for a ckey if they are connected and associate them with the new admin datum
		D.associate(directory[ckey])


// TODO: finally rework database schema with separate permissions table
/proc/load_permissions(var/player_id)
	var/flag = 0

	establish_db_connection()
	if(!dbcon.IsConnected())
		return flag

	var/DBQuery/query = dbcon.NewQuery("SELECT fun, server, debug, permissions, mentor, moderator, admin, host FROM permissions WHERE player_id = [player_id]")
	if(!query.Execute())
		return flag

	var/list/permissions = list()
	if(query.NextRow())
		permissions = list(
			"fun" = query.item[1],
			"server" = query.item[2],
			"debug" = query.item[3],
			"permissions" = query.item[4],
			"mentor" = query.item[5],
			"moderator" = query.item[6],
			"admin" = query.item[7],
			"host" = query.item[8],
		)

	for(var/key in permissions)
		if(permissions[key])
			flag |= admin_permissions[key]

	return flag
