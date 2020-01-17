#ifndef OVERRIDE_BAN_SYSTEM
//Blocks an attempt to connect before even creating our client datum thing.
world/IsBanned(key, address, computer_id, real_bans_only=FALSE)
	if(real_bans_only && !key)
		return FALSE

	if(ckey(key) in admin_datums)
		return ..()

	//Guest Checking
	if(!real_bans_only && !config.guests_allowed && IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_admins("\blue Failed Login: [key] - Guests not allowed")
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	//check if the IP address is a known TOR node
	if(!real_bans_only && config && config.ToRban && ToRban_isbanned(address))
		log_access("Failed Login: [src] - Banned: ToR")
		message_admins("\blue Failed Login: [src] - Banned: ToR")
		//ban their computer_id and ckey for posterity
		AddBan(ckey(key), computer_id, "Use of ToR", "Automated Ban", 0, 0)
		return list("reason"="Using ToR", "desc"="\nReason: The network you are using to connect has been banned.\nIf you believe this is a mistake, please request help at [config.banappeals]")


	if(config.ban_legacy_system)

		//Ban Checking
		. = CheckBan( ckey(key), computer_id, address )
		if(.)
			log_access("Failed Login: [key] [computer_id] [address] - Banned [.["reason"]]")
			message_admins("\blue Failed Login: [key] id:[computer_id] ip:[address] - Banned [.["reason"]]")
			return .

		return ..()	//default pager ban stuff

	else

		var/ckeytext = ckey(key)

		if(!establish_db_connection())
			error("Ban database connection failure. Key [ckeytext] not checked")
			log_misc("Ban database connection failure. Key [ckeytext] not checked")
			return

		var/id
		var/DBQuery/get_id = dbcon.NewQuery("SELECT id FROM players WHERE ckey='[ckeytext]'")
		get_id.Execute()
		if(get_id.NextRow())
			id = get_id.item[1]

		var/failedcid = 1
		var/failedip = 1

		var/ipquery = ""
		var/cidquery = ""
		if(address)
			failedip = 0
			ipquery = " OR ip = '[address]' "

		if(computer_id)
			failedcid = 0
			cidquery = " OR cid = '[computer_id]' "

		var/DBQuery/query = dbcon.NewQuery(" \
		SELECT target_id, banned_by_id, reason, expiration_time, duration, time, type \
		FROM bans WHERE \
		(\
			(target_id = '[id]' [ipquery] [cidquery]) \
			AND \
			(type = 'PERMABAN' \
			OR (\
				type = 'TEMPBAN' AND expiration_time > Now()\
				)\
			) \
			AND isnull(unbanned)\
			)")

		if(!query.Execute())
			log_world("Trying to fetch ban record for [ckeytext] but got error: [query.ErrorMsg()].")
			return

		while(query.NextRow())
			var/target_id = query.item[1]
			var/banned_by_id = query.item[2]
			var/reason = query.item[3]
			var/expiration = query.item[4]
			var/duration = query.item[5]
			var/bantime = query.item[6]
			var/bantype = query.item[7]

			var/banned_ckey
			var/DBQuery/get_banned_ckey = dbcon.NewQuery("SELECT ckey FROM players WHERE id=[target_id]")
			get_banned_ckey.Execute()
			if(get_banned_ckey.NextRow())
				banned_ckey = get_banned_ckey.item[1]

			var/banned_by_ckey
			var/DBQuery/get_banned_by_ckey = dbcon.NewQuery("SELECT ckey FROM players WHERE id=[banned_by_id]")
			get_banned_by_ckey.Execute()
			if(get_banned_by_ckey.NextRow())
				banned_by_ckey = get_banned_by_ckey.item[1]

			var/expires = ""
			if(text2num(duration) > 0)
				expires = " The ban is for [duration] minutes and expires on [expiration] (server time)."

			var/desc = "\nReason: You, or another user of this computer or connection ([banned_ckey]) is banned from playing here. The ban reason is:\n[reason]\nThis ban was applied by [banned_by_ckey] on [bantime], [expires]"

			return list("reason"="[bantype]", "desc"="[desc]")

		if (failedcid)
			message_admins("[key] has logged in with a blank computer id in the ban check.")
		if (failedip)
			message_admins("[key] has logged in with a blank ip in the ban check.")
		return ..()	//default pager ban stuff
#endif
