#ifndef OVERRIDE_BAN_SYSTEM
//Blocks an attempt to connect before even creating our client datum thing.
world/IsBanned(key, address, computer_id, real_bans_only=FALSE)
	if(real_bans_only && !key)
		return FALSE

	if(ckey(key) in admin_datums)
		return ..()

	//Guest Checking
	if(!real_bans_only && !config.guests_allowed && IsGuestKey(key))
		log_access("Failed Login: 69key69 - Guests not allowed")
		message_admins("\blue Failed Login: 69key69 - Guests not allowed")
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	//check if the IP address is a known TOR node
	if(!real_bans_only && config && config.ToRban && ToRban_isbanned(address))
		log_access("Failed Login: 69src69 - Banned: ToR")
		message_admins("\blue Failed Login: 69src69 - Banned: ToR")
		//ban their computer_id and ckey for posterity
		AddBan(ckey(key), computer_id, "Use of ToR", "Automated Ban", 0, 0)
		return list("reason"="Using ToR", "desc"="\nReason: The network you are using to connect has been banned.\nIf you believe this is a69istake, please request help at 69config.banappeals69")


	if(config.ban_legacy_system)

		//Ban Checking
		. = CheckBan( ckey(key), computer_id, address )
		if(.)
			log_access("Failed Login: 69key69 69computer_id69 69address69 - Banned 69.69"reason"6969")
			message_admins("\blue Failed Login: 69key69 id:69computer_id69 ip:69address69 - Banned 69.69"reason"6969")
			return .

		return ..()	//default pager ban stuff

	else

		var/ckeytext = ckey(key)

		if(!establish_db_connection())
			error("Ban database connection failure. Key 69ckeytext69 not checked")
			log_misc("Ban database connection failure. Key 69ckeytext69 not checked")
			return

		var/id
		var/DBQuery/get_id = dbcon.NewQuery("SELECT id FROM players WHERE ckey='69ckeytext69'")
		get_id.Execute()
		if(get_id.NextRow())
			id = get_id.item69169

		var/failedcid = 1
		var/failedip = 1

		var/ipquery = ""
		var/cidquery = ""
		if(address)
			failedip = 0
			ipquery = " OR ip = '69address69' "

		if(computer_id)
			failedcid = 0
			cidquery = " OR cid = '69computer_id69' "

		var/DBQuery/query = dbcon.NewQuery(" \
		SELECT target_id, banned_by_id, reason, expiration_time, duration, time, type \
		FROM bans WHERE \
		(\
			(target_id = '69id69' 69ipquery69 69cidquery69) \
			AND \
			(type = 'PERMABAN' \
			OR (\
				type = 'TEMPBAN' AND expiration_time > Now()\
				)\
			) \
			AND isnull(unbanned)\
			)")

		if(!query.Execute())
			log_world("Trying to fetch ban record for 69ckeytext69 but got error: 69query.ErrorMsg()69.")
			return

		while(query.NextRow())
			var/target_id = query.item69169
			var/banned_by_id = query.item69269
			var/reason = query.item69369
			var/expiration = query.item69469
			var/duration = query.item69569
			var/bantime = query.item69669
			var/bantype = query.item69769

			var/banned_ckey
			var/DBQuery/get_banned_ckey = dbcon.NewQuery("SELECT ckey FROM players WHERE id=69target_id69")
			get_banned_ckey.Execute()
			if(get_banned_ckey.NextRow())
				banned_ckey = get_banned_ckey.item69169

			var/banned_by_ckey
			var/DBQuery/get_banned_by_ckey = dbcon.NewQuery("SELECT ckey FROM players WHERE id=69banned_by_id69")
			get_banned_by_ckey.Execute()
			if(get_banned_by_ckey.NextRow())
				banned_by_ckey = get_banned_by_ckey.item69169

			var/expires = ""
			if(text2num(duration) > 0)
				expires = " The ban is for 69duration6969inutes and expires on 69expiration69 (server time)."

			var/desc = "\nReason: You, or another user of this computer or connection (69banned_ckey69) is banned from playing here. The ban reason is:\n69reason69\nThis ban was applied by 69banned_by_ckey69 on 69bantime69, 69expires69"

			return list("reason"="69bantype69", "desc"="69desc69")

		if (failedcid)
			message_admins("69key69 has logged in with a blank computer id in the ban check.")
		if (failedip)
			message_admins("69key69 has logged in with a blank ip in the ban check.")
		return ..()	//default pager ban stuff
#endif
