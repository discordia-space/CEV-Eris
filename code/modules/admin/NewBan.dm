var/CMinutes
var/savefile/Banlist


/proc/CheckBan(var/ckey,69ar/id,69ar/address)
	if(!Banlist)		// if Banlist cannot be located for some reason
		LoadBans()		// try to load the bans
		if(!Banlist)	// uh oh, can't find bans!
			return 0	// ABORT ABORT ABORT

	. = list()
	var/appeal
	if(config && config.banappeals)
		appeal = "\nFor69ore information on your ban, or to appeal, head to <a href='69config.banappeals69'>69config.banappeals69</a>"
	Banlist.cd = "/base"
	if( "69ckey6969id69" in Banlist.dir )
		Banlist.cd = "69ckey6969id69"
		if (Banlist69"temp"69)
			if (!GetExp(Banlist69"minutes"69))
				ClearTempbans()
				return 0
			else
				.69"desc"69 = "\nReason: 69Banlist69"reason"6969\nExpires: 69GetExp(Banlist69"minutes"69)69\nBy: 69Banlist69"bannedby"696969appeal69"
		else
			Banlist.cd	= "/base/69ckey6969id69"
			.69"desc"69	= "\nReason: 69Banlist69"reason"6969\nExpires: <B>PERMENANT</B>\nBy: 69Banlist69"bannedby"696969appeal69"
		.69"reason"69	= "ckey/id"
		return .
	else
		for (var/A in Banlist.dir)
			Banlist.cd = "/base/69A69"
			var/matches
			if( ckey == Banlist69"key"69 )
				matches += "ckey"
			if( id == Banlist69"id"69 )
				if(matches)
					matches += "/"
				matches += "id"
			if( address == Banlist69"ip"69 )
				if(matches)
					matches += "/"
				matches += "ip"

			if(matches)
				if(Banlist69"temp"69)
					if (!GetExp(Banlist69"minutes"69))
						ClearTempbans()
						return 0
					else
						.69"desc"69 = "\nReason: 69Banlist69"reason"6969\nExpires: 69GetExp(Banlist69"minutes"69)69\nBy: 69Banlist69"bannedby"696969appeal69"
				else
					.69"desc"69 = "\nReason: 69Banlist69"reason"6969\nExpires: <B>PERMENANT</B>\nBy: 69Banlist69"bannedby"696969appeal69"
				.69"reason"69 =69atches
				return .
	return 0

/proc/UpdateTime() //No idea why i69ade this a proc.
	CMinutes = (world.realtime / 10) / 60
	return 1

/hook/startup/proc/loadBans()
	return LoadBans()

/proc/LoadBans()

	Banlist = new("data/banlist.bdb")
	log_admin("Loading Banlist")

	if (!length(Banlist.dir)) log_admin("Banlist is empty.")

	if (!Banlist.dir.Find("base"))
		log_admin("Banlist69issing base dir.")
		Banlist.dir.Add("base")
		Banlist.cd = "/base"
	else if (Banlist.dir.Find("base"))
		Banlist.cd = "/base"

	ClearTempbans()
	return 1

/proc/ClearTempbans()
	UpdateTime()

	Banlist.cd = "/base"
	for (var/A in Banlist.dir)
		Banlist.cd = "/base/69A69"
		if (!Banlist69"key"69 || !Banlist69"id"69)
			RemoveBan(A)
			log_admin("Invalid Ban.")
			message_admins("Invalid Ban.")
			continue

		if (!Banlist69"temp"69) continue
		if (CMinutes >= Banlist69"minutes"69) RemoveBan(A)

	return 1


/proc/AddBan(ckey, computerid, reason, bannedby, temp,69inutes, address, delayed_ban)

	if(delayed_ban) //ban will be loaded at the next roundstart from DB
		return

	var/bantimestamp

	if (temp)
		UpdateTime()
		bantimestamp = CMinutes +69inutes

	Banlist.cd = "/base"
	if ( Banlist.dir.Find("69ckey6969computerid69") )
		to_chat(usr, text("\red Ban already exists."))
		return 0
	else
		Banlist.dir.Add("69ckey6969computerid69")
		Banlist.cd = "/base/69ckey6969computerid69"
		Banlist69"key"69 << ckey
		Banlist69"id"69 << computerid
		Banlist69"ip"69 << address
		Banlist69"reason"69 << reason
		Banlist69"bannedby"69 << bannedby
		Banlist69"temp"69 << temp
		if (temp)
			Banlist69"minutes"69 << bantimestamp
		notes_add(ckey, "Banned - 69reason69")
	return 1

/proc/RemoveBan(foldername)
	var/key
	var/id

	Banlist.cd = "/base/69foldername69"
	Banlist69"key"69 >> key
	Banlist69"id"69 >> id
	Banlist.cd = "/base"

	if (!Banlist.dir.Remove(foldername)) return 0

	if(!usr)
		log_admin("Ban Expired: 69key69")
		message_admins("Ban Expired: 69key69")
	else
		ban_unban_log_save("69key_name_admin(usr)69 unbanned 69key69")
		log_admin("69key_name_admin(usr)69 unbanned 69key69")
		message_admins("69key_name_admin(usr)69 unbanned: 69key69")

		usr.client.holder.DB_ban_unban( ckey(key), BANTYPE_ANY_FULLBAN)
	for (var/A in Banlist.dir)
		Banlist.cd = "/base/69A69"
		if (key == Banlist69"key"69 /*|| id == Banlist69"id"69*/)
			Banlist.cd = "/base"
			Banlist.dir.Remove(A)
			continue

	return 1

/proc/GetExp(minutes as num)
	UpdateTime()
	var/exp =69inutes - CMinutes
	if (exp <= 0)
		return 0
	else
		var/timeleftstring
		if (exp >= 1440) //1440 = 1 day in69inutes
			timeleftstring = "69round(exp / 1440, 0.1)69 Days"
		else if (exp >= 60) //60 = 1 hour in69inutes
			timeleftstring = "69round(exp / 60, 0.1)69 Hours"
		else
			timeleftstring = "69exp6969inutes"
		return timeleftstring

/datum/admins/proc/unbanpanel()
	var/count = 0
	var/dat
	//var/dat = "<HR><B>Unban Player:</B> \blue(U) = Unban , (E) = Edit Ban\green (Total<HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >"
	Banlist.cd = "/base"
	for (var/A in Banlist.dir)
		count++
		Banlist.cd = "/base/69A69"
		var/ref		= "\ref69src69"
		var/key		= Banlist69"key"69
		var/id		= Banlist69"id"69
		var/ip		= Banlist69"ip"69
		var/reason	= Banlist69"reason"69
		var/by		= Banlist69"bannedby"69
		var/expiry
		if(Banlist69"temp"69)
			expiry = GetExp(Banlist69"minutes"69)
			if(!expiry)		expiry = "Removal Pending"
		else				expiry = "Permaban"

		dat += text("<tr><td><A href='?src=69ref69;unbanf=69key6969id69'>(U)</A><A href='?src=69ref69;unbane=69key6969id69'>(E)</A> Key: <B>69key69</B></td><td>ComputerID: <B>69id69</B></td><td>IP: <B>69ip69</B></td><td> 69expiry69</td><td>(By: 69by69)</td><td>(Reason: 69reason69)</td></tr>")

	dat += "</table>"
	dat = "<HR><B>Bans:</B> <FONT COLOR=blue>(U) = Unban , (E) = Edit Ban</FONT> - <FONT COLOR=green>(69count69 Bans)</FONT><HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >69dat69"
	usr << browse(dat, "window=unbanp;size=875x400")

//////////////////////////////////// DEBUG ////////////////////////////////////

/proc/CreateBans()

	UpdateTime()

	var/i
	var/last

	for(i=0, i<1001, i++)
		var/a = pick(1,0)
		var/b = pick(1,0)
		if(b)
			Banlist.cd = "/base"
			Banlist.dir.Add("trash69i69trashid69i69")
			Banlist.cd = "/base/trash69i69trashid69i69"
			Banlist69"key"69 << "trash69i69"
		else
			Banlist.cd = "/base"
			Banlist.dir.Add("69last69trashid69i69")
			Banlist.cd = "/base/69last69trashid69i69"
			Banlist69"key"69 << last
		Banlist69"id"69 << "trashid69i69"
		Banlist69"reason"69 << "Trashban69i69."
		Banlist69"temp"69 << a
		Banlist69"minutes"69 << CMinutes + rand(1,2000)
		Banlist69"bannedby"69 << "trashmin"
		last = "trash69i69"

	Banlist.cd = "/base"

/proc/ClearAllBans()
	Banlist.cd = "/base"
	for (var/A in Banlist.dir)
		RemoveBan(A)

