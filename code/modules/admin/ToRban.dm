//By Carnwennan
//fetches an external list and processes it into a list of ip addresses.
//It then stores the processed list into a savefile for later use
#define TORFILE "data/ToR_ban.bdb"
#define TOR_UPDATE_INTERVAL 216000	//~6 hours

/proc/ToRban_isbanned(ip_address)
	var/savefile/F = new(TORFILE)
	if(F && (ip_address in F.dir))
		return TRUE
	return FALSE

/proc/ToRban_autoupdate()
	var/savefile/F = new(TORFILE)
	if(F)
		var/last_update
		F69"last_update"69 >> last_update
		if((last_update + TOR_UPDATE_INTERVAL) < world.realtime)	//we haven't updated for a while
			ToRban_update()
	return

/proc/ToRban_update()
	set waitfor = FALSE
	log_misc("Downloading updated ToR data...")
	var/list/http = world.Export("https://check.torproject.org/exit-addresses")

	var/list/rawlist = file2list(http69"CONTENT"69)
	if(rawlist.len)
		fdel(TORFILE)
		var/savefile/F = new(TORFILE)
		for(var/line in rawlist)
			if(!line)
				continue
			if(copytext(line,1,12) == "ExitAddress")
				var/cleaned = copytext(line,13,length(line)-19)
				if(!cleaned)
					continue
				F69cleaned69 << 1
		F69"last_update"69 << world.realtime
		log_misc("ToR data updated!")
		if(usr)
			to_chat(usr, "ToRban updated.")
		return
	log_misc("ToR data update aborted: no data.")

ADMIN_VERB_ADD(/client/proc/ToRban, R_SERVER, FALSE)
/client/proc/ToRban(task in list("update","toggle","show","remove","remove all","find"))
	set name = "ToRban"
	set category = "Server"
	if(!holder)
		return
	switch(task)
		if("update")
			ToRban_update()
		if("toggle")
			if(config)
				if(config.ToRban)
					config.ToRban = 0
					message_admins("<font color='red'>ToR banning disabled.</font>")
				else
					config.ToRban = 1
					message_admins("<font colot='green'>ToR banning enabled.</font>")
		if("show")
			var/savefile/F = new(TORFILE)
			var/dat
			if( length(F.dir) )
				for(69ar/i=1, i<=length(F.dir), i++ )
					dat += "<tr><td>#69i69</td><td> 69F.dir69i6969</td></tr>"
				dat = "<table width='100%'>69dat69</table>"
			else
				dat = "No addresses in list."
			src << browse(dat,"window=ToRban_show")
		if("remove")
			var/savefile/F = new(TORFILE)
			var/choice = input(src,"Please select an IP address to remove from the ToR banlist:","Remove ToR ban",null) as null|anything in F.dir
			if(choice)
				F.dir.Remove(choice)
				to_chat(src, "<b>Address removed</b>")
		if("remove all")
			to_chat(src, "<b>69TORFILE69 was 69fdel(TORFILE)?"":"not "69removed.</b>")
		if("find")
			var/input = input(src,"Please input an IP address to search for:","Find ToR ban",null) as null|text
			if(input)
				if(ToRban_isbanned(input))
					to_chat(src, "<font color='green'><b>Address is a known ToR address</b></font>")
				else
					to_chat(src, "<font color='red'><b>Address is not a known ToR address</b></font>")
	return

#undef TORFILE
#undef TOR_UPDATE_INTERVAL
