GLOBAL_LIST_EMPTY(admin_ranks) //list of all admin_rank datums
GLOBAL_PROTECT(admin_ranks)


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

		//Split the line at every "="
		var/list/List = splittext(line, "=")
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
		var/rights = GLOB.admin_ranks[rank]

		//create the admin datum and store it for later use
		var/datum/admins/D = new /datum/admins(rank, rights, ckey)

		//find the client for a ckey if they are connected and associate them with the new admin datum
		D.associate(GLOB.directory[ckey])


// This proc is using only without database connection
/proc/load_admin_ranks_legacy()
	GLOB.admin_ranks.Cut()

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
					rights = R_EVERYTHING
				if("ban")
					rights |= R_BAN
				if("mentor")
					rights |= R_MENTOR

		GLOB.admin_ranks[rank] = rights
		previous_rights = rights

/proc/clear_admin_datums()
	GLOB.admin_datums.Cut()
	for(var/client/C in GLOB.admins)
		C.remove_admin_verbs()
		C.holder = null
	GLOB.admins.Cut()

// TODO: Use modern admin ranking n shit for this garbage
/proc/load_admins()
	clear_admin_datums()

	if(CONFIG_GET(flag/admin_legacy_system))
		load_admins_legacy()
		return TRUE

	if(!SSdbcore.IsConnected())
		warning("Failed to connect to database in load_admins(). Reverting to legacy system.")
		load_admins_legacy()
		return FALSE

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT ckey, lastadminrank, flags FROM [format_table_name("player")] WHERE lastadminrank != 'player'")
	query.Execute()
	while(query.NextRow())
		var/ckey = query.item[1]
		var/rank = query.item[2]
		var/flags = query.item[3]

		if(istext(flags))
			flags = text2num(flags)

		// var/permissions = load_permissions(ckey) // Should be used only after permission db schema rework
		var/datum/admins/D = new /datum/admins(rank, flags, ckey)

		//find the client for a ckey if they are connected and associate them with the new admin datum
		D.associate(GLOB.directory[ckey])

	//Clear profile access
	for(var/A in world.GetConfig("admin"))
		world.SetConfig("APP/admin", A, null)

	if(!LAZYLEN(GLOB.admin_datums))
		warning("The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
		CONFIG_SET(flag/admin_legacy_system, 1)
		load_admins_legacy()
		return FALSE

	return TRUE

// TODO: finally rework database schema with separate permissions table
/proc/load_permissions(ckey)
	var/flag = 0

	if(!SSdbcore.Connect())
		return flag

	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT fun, server, debug, permissions, mentor, ban, admin, host FROM [format_table_name("permissions")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
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
			"ban" = query.item[6],
			"admin" = query.item[7],
			"host" = query.item[8],
		)

	for(var/key in permissions)
		if(permissions[key])
			flag |= admin_permissions[key]

	return flag
