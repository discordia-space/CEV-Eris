	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?

	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	//search the href for script injection
	if( findtext(href,"<script",1,0) )
		log_world("Attempted use of scripts within a topic call, by [src]")
		message_admins("Attempted use of scripts within a topic call, by [src]")
		//del(usr)
		return

	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		if(ismob(C)) 		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client
		cmd_admin_pm(C,null)
		return

	if(href_list["irc_msg"])
		if(!holder && received_irc_pm < world.time - 6000) //Worse they can do is spam IRC for 10 minutes
			to_chat(usr, SPAN_WARNING("You are no longer able to use this, it's been more then 10 minutes since an admin on IRC has responded to you"))
			return
		if(mute_irc)
			to_chat(usr, "<span class='warning'You cannot use this as your client has been muted from sending messages to the admins on IRC</span>")
			return
		cmd_admin_irc_pm(href_list["irc_msg"])
		return



	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		to_chat(href_logfile, "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>")

	switch(href_list["_src_"])
		if("holder")	hsrc = holder
		if("usr")		hsrc = mob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return view_var_Topic(href,href_list,hsrc)
		if("chat")		return chatOutput.Topic(href, href_list)

	switch(href_list["action"])
		if("openLink")
			src << link(href_list["link"])

	..()	//redirect to hsrc.Topic()

/client/proc/handle_spam_prevention(var/message, var/mute_type)
	if(config.automute_on && !holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			to_chat(src, "\red You have exceeded the spam filter limit for identical messages. An auto-mute was applied.")
			cmd_admin_mute(src.mob, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			to_chat(src, "\red You are nearing the spam filter limit for identical messages.")
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
/client/New(TopicData)
	dir = NORTH
	chatOutput = new /datum/chatOutput(src)
	TopicData = null							//Prevent calls to client.Topic from connect

	if(!(connection in list("seeker", "web")))					//Invalid connection type.
		return null

	#if DM_VERSION >= 512
	if(byond_version < config.minimum_byond_version || byond_build < config.minimum_byond_build)		//BYOND out of date.
		to_chat(src, "You are attempting to connect with a out of date version of BYOND. Please update to the latest version at http://www.byond.com/ before trying again.")
		qdel(src)
		return

	if("[byond_version].[byond_build]" in config.forbidden_versions)
		log_and_message_admins("[ckey] Tried to connect with broken and possibly exploitable BYOND build.")
		to_chat(src, "You are attempting to connect with a broken and possibly exploitable BYOND build. Please update to the latest version at http://www.byond.com/ before trying again.")
		qdel(src)
		return
	#endif

	if(!config.guests_allowed && IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		del(src)
		return

	// Change the way they should download resources.
	if(config.resource_urls)
		src.preload_rsc = pick(config.resource_urls)
	else src.preload_rsc = 1 // If config.resource_urls is not set, preload like normal.

	to_chat(src, "\red If the title screen is black, resources are still downloading. Please be patient until the title screen appears.")


	clients += src
	directory[ckey] = src

	//Admin Authorisation
	holder = admin_datums[ckey]
	if(holder)
		admins += src
		holder.owner = src

	// Localhost connections get full admin rights and a special rank
	else if(isnull(address) || (address in list("127.0.0.1", "::1")))
		holder = new /datum/admins("!localhost!", R_HOST, ckey)
		holder.associate(src)


	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = SScharacter_setup.preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		SScharacter_setup.preferences_datums[ckey] = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	. = ..()	//calls mob.Login()

	chatOutput.start() // Starts the chat

	if(custom_event_msg && custom_event_msg != "")
		to_chat(src, "<h1 class='alert'>Custom Event</h1>")
		to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
		to_chat(src, "<span class='alert'>[custom_event_msg]</span>")
		to_chat(src, "<br>")


	if(holder)
		add_admin_verbs()
		admin_memo_show()

	// Forcibly enable hardware-accelerated graphics, as we need them for the lighting overlays.
	// (but turn them off first, since sometimes BYOND doesn't turn them on properly otherwise)
	spawn(5) // And wait a half-second, since it sounds like you can do this too fast.
		if(src)
			winset(src, null, "command=\".configure graphics-hwmode off\"")
			sleep(2) // wait a bit more, possibly fixes hardware mode not re-activating right
			winset(src, null, "command=\".configure graphics-hwmode on\"")

	log_client_to_db()

	send_resources()

	if(prefs.lastchangelog != changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		to_chat(src, "<span class='info'>You have unread updates in the changelog.</span>")
		winset(src, "rpane.changelog", "background-color=#eaeaea;font-style=bold")
		if(config.aggressive_changelog)
			src.changes()

	if(!tooltips)
		tooltips = new /datum/tooltip(src)

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	if(holder)
		holder.owner = null
		admins -= src
	if(dbcon.IsConnected())
		var/DBQuery/query = dbcon.NewQuery("UPDATE players SET last_seen = Now() WHERE id = [src.id]")
		if(!query.Execute())
			log_world("Failed to update players table for user with id [src.id]. Error message: [query.ErrorMsg()].")
	directory -= ckey
	clients -= src
	return ..()
/*
/client/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW
*/
/client/proc/get_registration_date()
	// Return data:
	// Success: "2017-07-28"
	// Fail: null

	var/http[] = world.Export("http://byond.com/members/[src.ckey]?format=text")
	if(http)
		var/F = file2text(http["CONTENT"])
		if(F)
			var/regex/R = regex("joined = \"(\\d{4})-(\\d{2})-(\\d{2})\"")
			if(R.Find(F))
				var/year = R.group[1]
				var/month = R.group[2]
				var/day = R.group[3]
				src.registration_date = "[year]-[month]-[day]"
				return src.registration_date
			else
				log_world("Failed retrieving registration date for player [src.ckey] from byond site.")
	else
		log_world("Failed retrieving registration date for player [src.ckey] from byond site.")
	return null


/client/proc/get_country()
	// Return data:
	// Success: list("country" = "United States", "country_code" = "US")
	// Fail: null

	var/address_check[] = world.Export("http://ip-api.com/line/[sql_sanitize_text(src.address)]")
	/*
	Response
		A successful request will return, by default, the following:
		 1: success
		 2: COUNTRY
		 3: COUNTRY CODE
		 4: REGION CODE
		 5: REGION NAME
		 6: CITY
		 7: ZIP CODE
		 8: LATITUDE
		 9: LONGITUDE
		10: TIME ZONE
		11: ISP NAME
		12: ORGANIZATION NAME
		13: AS NUMBER / NAME
		14: IP ADDRESS USED FOR QUERY

		A failed request will return, by default, the following:

		1: fail
		2: ERROR MESSAGE
		3: IP ADDRESS USED FOR QUERY
	*/
	if(address_check)
		var/list/response = file2list(address_check["CONTENT"])
		if(response.len && response[1] == "success")
			src.country = response[2]
			src.country_code = response[3]
			return list("country" = src.country, "country_code" = src.country_code)

	log_world("Failed on retrieving location for player [src.ckey] from byond site.")
	return null


/client/proc/register_in_db()
	registration_date = src.get_registration_date()
	src.get_country()

	var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO players (ckey, first_seen, last_seen, registered, ip, cid, rank, byond_version, country) VALUES ('[src.ckey]', Now(), Now(), '[registration_date]', '[sql_sanitize_text(src.address)]', '[sql_sanitize_text(src.computer_id)]', 'player', [src.byond_version], '[src.country_code]')")
	if(!query_insert.Execute())
		log_world("##CRITICAL: Failed to create player record for user [ckey]. Error message: [query_insert.ErrorMsg()].")
		return

	else
		var/DBQuery/get_player_id = dbcon.NewQuery("SELECT id FROM players WHERE ckey = '[src.ckey]'")
		get_player_id.Execute()
		if(get_player_id.NextRow())
			src.id = get_player_id.item[1]


/client/proc/log_client_to_db()
	if(IsGuestKey(src.key))
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		return

	// check if client already registered in db
	var/DBQuery/query = dbcon.NewQuery("SELECT id from players WHERE ckey = '[src.ckey]'")
	if(!query.Execute())
		log_world("Failed to get player record for user with ckey '[src.ckey]'. Error message: [query.ErrorMsg()].")
		// don't know how to properly handle this case so let's just quit
		return
	else
		if(query.NextRow())
			// client already registered so we fetch all needed data
			query = dbcon.NewQuery("SELECT id, registered FROM players WHERE id = [query.item[1]]")
			query.Execute()
			if(query.NextRow())
				src.id = query.item[1]
				src.registration_date = query.item[2]
				src.get_country()

				//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id' variables
				var/DBQuery/query_update = dbcon.NewQuery("UPDATE players SET last_seen = Now(), ip = '[src.address]', cid = '[src.computer_id]', byond_version = '[src.byond_version]', country = '[src.country_code]' WHERE id = [src.id]")

				if(!query_update.Execute())
					log_world("Failed to update players table for user with id [src.id]. Error message: [query_update.ErrorMsg()].")
					return
		else
			src.register_in_db()

#undef UPLOAD_LIMIT

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if (duration)
		if(inactivity > duration)
			return inactivity
	return FALSE


/client/proc/inactivity2text()
	var/seconds = inactivity/10
	return "[round(seconds / 60)] minute\s, [seconds % 60] second\s"


//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()

	getFiles(
		'html/search.js',
		'html/panels.css',
		'html/images/loading.gif',
		'html/images/ntlogo.png',
		'html/images/talisman.png'
		)

	spawn (10) //removing this spawn causes all clients to not get verbs.
		//Precache the client with all other assets slowly, so as to not block other browse() calls
		var/list/priority_assets = list()
		var/list/other_assets = list()

		for(var/asset_type in asset_datums)
			var/datum/asset/D = asset_datums[asset_type]
			if(D.isTrivial)
				other_assets += D
			else
				priority_assets += D

		for(var/datum/asset/D in (priority_assets + other_assets))
			D.send_slow(src)

		send_all_cursor_icons(src)

/mob/proc/MayRespawn()
	return FALSE


/client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return FALSE


/client/verb/character_setup()
	set name = "Character Setup"
	set category = "OOC"
	if(prefs)
		prefs.ShowChoices(usr)
/*
/client/proc/apply_fps(var/client_fps)
	if(world.byond_version >= 511 && byond_version >= 511 && client_fps >= CLIENT_MIN_FPS && client_fps <= CLIENT_MAX_FPS)
		vars["fps"] = prefs.clientfps

*/

// Byond seemingly calls stat, each tick.
// Calling things each tick can get expensive real quick.
// So we slow this down a little.
// See: http://www.byond.com/docs/ref/info.html#/client/proc/Stat
/client/Stat()
	if(!usr)
		return
	// Add always-visible stat panel calls here, to define a consistent display order.
	statpanel("Status")

	. = ..()
	sleep(1)

/client/proc/create_UI(var/mob_type)
	destroy_UI()
	if(!mob_type)
		mob_type = mob.type
	if(!UI)
		var/success = FALSE
		for(var/S in GLOB.ui_styles[mob_type])
			var/datum/interface/style = S
			if(initial(style.styleName) == prefs.UI_style)
				UI = new style(src)
				success = TRUE
				break
		if(!success)
			log_debug("Could not find style \"[prefs.UI_style]\" for [mob_type].")

	if(UI)
		UI.show()

/client/proc/destroy_UI()
	if(UI)
		qdel(UI)
		UI = null