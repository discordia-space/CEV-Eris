	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?

	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=690xWhatever69
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things69UST be considered whenever adding a Topic() for something:
		- Can it be fed harmful69alues which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr !=69ob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	//search the href for script injection
	if( findtext(href,"<script",1,0) )
		log_world("Attempted use of scripts within a topic call, by 69src69")
		message_admins("Attempted use of scripts within a topic call, by 69src69")
		//del(usr)
		return

	//Admin PM
	if(href_list69"priv_msg"69)
		var/client/C = locate(href_list69"priv_msg"69)
		if(ismob(C)) 		//Old stuff can feed-in69obs instead of clients
			var/mob/M = C
			C =69.client
		cmd_admin_pm(C,null)
		return

	if(href_list69"irc_msg"69)
		if(!holder && received_irc_pm < world.time - 6000) //Worse they can do is spam IRC for 1069inutes
			to_chat(usr, SPAN_WARNING("You are no longer able to use this, it's been69ore then 1069inutes since an admin on IRC has responded to you"))
			return
		if(mute_irc)
			to_chat(usr, "<span class='warning'You cannot use this as your client has been69uted from sending69essages to the admins on IRC</span>")
			return
		cmd_admin_irc_pm(href_list69"irc_msg"69)
		return



	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		to_chat(href_logfile, "<small>69time2text(world.timeofday,"hh:mm")69 69src69 (usr:69usr69)</small> || 69hsrc ? "69hsrc69 " : ""6969href69<br>")

	switch(href_list69"_src_"69)
		if("holder")	hsrc = holder
		if("usr")		hsrc =69ob
		if("prefs")		return prefs.process_link(usr,href_list)
		if("vars")		return69iew_var_Topic(href,href_list,hsrc)
		if("chat")		return chatOutput.Topic(href, href_list)

	switch(href_list69"action"69)
		if("openLink")
			src << link(href_list69"link"69)

	..()	//redirect to hsrc.Topic()

/client/proc/handle_spam_prevention(var/message,69ar/mute_type)
	if(config.automute_on && !holder && src.last_message ==69essage)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			to_chat(src, "\red You have exceeded the spam filter limit for identical69essages. An auto-mute was applied.")
			cmd_admin_mute(src.mob,69ute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			to_chat(src, "\red You are nearing the spam filter limit for identical69essages.")
			return 0
	else
		last_message =69essage
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server69ia input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: 69UPLOAD_LIMIT/102469KiB.</font>")
		return 0
/*	//Don't need this at the69oment. But it's here if it's needed later.
	//Helps prevent69ultiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait 69round(time_to_wait/10)69 seconds.</font>")
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
		to_chat(src, "You are attempting to connect with a out of date69ersion of BYOND. Please update to the latest69ersion at http://www.byond.com/ before trying again.")
		del(src)
		return

	if("69byond_version69.69byond_build69" in config.forbidden_versions)
		log_and_message_admins("69ckey69 Tried to connect with broken and possibly exploitable BYOND build.")
		to_chat(src, "You are attempting to connect with a broken and possibly exploitable BYOND build. Please update to the latest69ersion at http://www.byond.com/ before trying again.")
		del(src)
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
	directory69ckey69 = src

	//Admin Authorisation
	holder = admin_datums69ckey69
	if(holder)
		admins += src
		holder.owner = src

	// Localhost connections get full admin rights and a special rank
	else if(isnull(address) || (address in list("127.0.0.1", "::1")))
		holder = new /datum/admins("!localhost!", R_HOST, ckey)
		holder.associate(src)


	//preferences datum - also holds some persistant data for the client (because we69ay as well keep these datums to a69inimum)
	prefs = SScharacter_setup.preferences_datums69ckey69
	if(!prefs)
		prefs = new /datum/preferences(src)
		SScharacter_setup.preferences_datums69ckey69 = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning

	. = ..()	//calls69ob.Login()

	chatOutput.start() // Starts the chat

	if(custom_event_msg && custom_event_msg != "")
		to_chat(src, "<h1 class='alert'>Custom Event</h1>")
		to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
		to_chat(src, "<span class='alert'>69custom_event_msg69</span>")
		to_chat(src, "<br>")


	if(holder)
		add_admin_verbs()
		admin_memo_show()

	// Forcibly enable hardware-accelerated graphics, as we need them for the lighting overlays.
	// (but turn them off first, since sometimes BYOND doesn't turn them on properly otherwise)
	spawn(5) // And wait a half-second, since it sounds like you can do this too fast.
		if(src)
			winset(src, null, "command=\".configure graphics-hwmode off\"")
			sleep(2) // wait a bit69ore, possibly fixes hardware69ode not re-activating right
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
		var/DBQuery/query = dbcon.NewQuery("UPDATE players SET last_seen = Now() WHERE id = 69src.id69")
		if(!query.Execute())
			log_world("Failed to update players table for user with id 69src.id69. Error69essage: 69query.ErrorMsg()69.")
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

	var/http6969 = world.Export("http://byond.com/members/69src.ckey69?format=text")
	if(http)
		var/F = file2text(http69"CONTENT"69)
		if(F)
			var/regex/R = regex("joined = \"(\\d{4})-(\\d{2})-(\\d{2})\"")
			if(R.Find(F))
				var/year = R.group69169
				var/month = R.group69269
				var/day = R.group69369
				src.registration_date = "69year69-69month69-69day69"
				return src.registration_date
			else
				log_world("Failed retrieving registration date for player 69src.ckey69 from byond site.")
	else
		log_world("Failed retrieving registration date for player 69src.ckey69 from byond site.")
	return null


/client/proc/get_country()
	// Return data:
	// Success: list("country" = "United States", "country_code" = "US")
	// Fail: null

	var/address_check6969 = world.Export("http://ip-api.com/line/69sql_sanitize_text(src.address)69")
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
		2: ERROR69ESSAGE
		3: IP ADDRESS USED FOR QUERY
	*/
	if(address_check)
		var/list/response = file2list(address_check69"CONTENT"69)
		if(response.len && response69169 == "success")
			src.country = response69269
			src.country_code = response69369
			return list("country" = src.country, "country_code" = src.country_code)

	log_world("Failed on retrieving location for player 69src.ckey69 from byond site.")
	return null


/client/proc/register_in_db()
	// Prevents the crash if the DB isn't connected.
	if(!dbcon.IsConnected())
		return

	registration_date = src.get_registration_date()
	src.get_country()
	src.get_byond_age() // Get days since byond join

	var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO players (ckey, first_seen, last_seen, registered, ip, cid, rank, byond_version, country)69ALUES ('69src.ckey69', Now(), Now(), '69registration_date69', '69sql_sanitize_text(src.address)69', '69sql_sanitize_text(src.computer_id)69', 'player', 69src.byond_version69, '69src.country_code69')")
	if(!query_insert.Execute())
		log_world("##CRITICAL: Failed to create player record for user 69ckey69. Error69essage: 69query_insert.ErrorMsg()69.")
		return

	else
		var/DBQuery/get_player_id = dbcon.NewQuery("SELECT id, first_seen FROM players WHERE ckey = '69src.ckey69'")
		get_player_id.Execute()
		if(get_player_id.NextRow())
			src.id = get_player_id.item69169
			src.first_seen = get_player_id.item69269

//Not actually age, but rather time since first seen in days
/client/proc/get_player_age()
	if(first_seen && dbcon.IsConnected())
		var/dateSQL = sanitizeSQL(first_seen)
		var/DBQuery/query_datediff = dbcon.NewQuery("SELECT DATEDIFF(Now(),'69dateSQL69')")
		if(query_datediff.Execute() && query_datediff.NextRow())
			src.first_seen_days_ago = text2num(query_datediff.item69169)

	if(config.paranoia_logging && isnum(src.first_seen_days_ago) && src.first_seen_days_ago == 0)
		log_and_message_admins("PARANOIA: 69key_name(src)69 has connected here for the first time.")
	return src.first_seen_days_ago

//Days since they signed up for their byond account
/client/proc/get_byond_age()
	if(!registration_date)
		get_registration_date()
	if(registration_date && dbcon.IsConnected())
		var/dateSQL = sanitizeSQL(registration_date)
		var/DBQuery/query_datediff = dbcon.NewQuery("SELECT DATEDIFF(Now(),'69dateSQL69')")
		if(query_datediff.Execute() && query_datediff.NextRow())
			src.account_age_in_days = text2num(query_datediff.item69169)
	if(config.paranoia_logging && isnum(src.account_age_in_days) && src.account_age_in_days <= 2)
		log_and_message_admins("PARANOIA: 69key_name(src)69 has a69ery new Byond account. (69src.account_age_in_days69 days old)")
	return src.account_age_in_days

/client/proc/log_client_to_db()
	if(IsGuestKey(src.key))
		return

	establish_db_connection()
	if(dbcon.IsConnected())
		// Get existing player from DB
		var/DBQuery/query = dbcon.NewQuery("SELECT id from players WHERE ckey = '69src.ckey69'")
		if(!query.Execute())
			log_world("Failed to get player record for user with ckey '69src.ckey69'. Error69essage: 69query.ErrorMsg()69.")

		// Not their first time here
		else if(query.NextRow())
			// client already registered so we fetch all needed data
			query = dbcon.NewQuery("SELECT id, registered, first_seen,69PN_check_white FROM players WHERE id = 69query.item6916969")
			query.Execute()
			if(query.NextRow())
				src.id = query.item69169
				src.registration_date = query.item69269
				src.first_seen = query.item69369
				src.VPN_whitelist = query.item69469
				src.get_country()

				//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id'69ariables
				var/DBQuery/query_update = dbcon.NewQuery("UPDATE players SET last_seen = Now(), ip = '69src.address69', cid = '69src.computer_id69', byond_version = '69src.byond_version69', country = '69src.country_code69' WHERE id = 69src.id69")

				if(!query_update.Execute())
					log_world("Failed to update players table for user with id 69src.id69. Error69essage: 69query_update.ErrorMsg()69.")

		//Panic bunker - player not in DB, so they get kicked
		else if(config.panic_bunker && !holder && !deadmin_holder && !(ckey in GLOB.PB_bypass))
			log_adminwarn("Failed Login: 69key69 - New account attempting to connect during panic bunker")
			message_admins("<span class='adminnotice'>Failed Login: 69key69 - New account attempting to connect during panic bunker</span>")
			to_chat(src, "<span class='warning'>Sorry but the server is currently not accepting connections from never before seen players.</span>")
			del(src) // Hard del the client. This terminates the connection.
			return 0
		query = dbcon.NewQuery("SELECT ip_related_ids, cid_related_ids FROM players WHERE id = '69src.id69'")
		query.Execute()
		if(query.NextRow())
			related_ip = splittext(query.item69169, ",")
			related_cid = splittext(query.item69269, ",")
		query = dbcon.NewQuery("SELECT id, ip, cid FROM players WHERE (ip = '69address69' OR cid = '69computer_id69') AND id <> '69src.id69'")
		query.Execute()
		var/changed = 0
		while(query.NextRow())
			var/temp_id = query.item69169
			var/temp_ip = query.item69269
			var/temp_cid = query.item69369
			if(temp_ip == address)
				changed = 1
				related_ip |= temp_id
			if(temp_cid == computer_id)
				changed = 1
				related_cid |= temp_id
		if(changed)
			query = dbcon.NewQuery("UPDATE players SET cid_related_ids = '69jointext(related_cid, ",")69', ip_related_ids = '69jointext(related_ip, ",")69' WHERE id = '69src.id69'")
			query.Execute()


	src.get_byond_age() // Get days since byond join
	src.get_player_age() // Get days since first seen

	// IP Reputation Check
	if(config.ip_reputation)
		if(config.ipr_allow_existing && first_seen_days_ago >= config.ipr_minimum_age)
			log_admin("Skipping IP reputation check on 69key69 with 69address69 because of player age")
		else if(holder)
			log_admin("Skipping IP reputation check on 69key69 with 69address69 because they have a staff rank")
		else if(VPN_whitelist)
			log_admin("Skipping IP reputation check on 69key69 with 69address69 because they have a69PN whitelist")
		else if(update_ip_reputation()) //It is set now
			if(ip_reputation >= config.ipr_bad_score) //It's bad

				//Log it
				if(config.paranoia_logging) //We don't block, but we want paranoia log69essages
					log_and_message_admins("69key69 at 69address69 has bad IP reputation: 69ip_reputation69. Will be kicked if enabled in config.")
				else //We just log it
					log_admin("69key69 at 69address69 has bad IP reputation: 69ip_reputation69. Will be kicked if enabled in config.")

				//Take action if required
				if(config.ipr_block_bad_ips && config.ipr_allow_existing) //We allow players of an age, but you don't69eet it
					to_chat(src, "Sorry, we only allow69PN/Proxy/Tor usage for players who have spent at least 69config.ipr_minimum_age69 days on the server. If you are unable to use the internet without your69PN/Proxy/Tor, please contact an admin out-of-game to let them know so we can accommodate this.")
					del(src) // Hard del the client. This terminates the connection.
					return 0
				else if(config.ipr_block_bad_ips) //We don't allow players of any particular age
					to_chat(src, "Sorry, we do not accept connections from users69ia69PN/Proxy/Tor connections. If you think this is in error, contact an administrator out of game.")
					del(src) // Hard del the client. This terminates the connection.
					return 0
		else
			log_admin("Couldn't perform IP check on 69key69 with 69address69")

	if(text2num(id) < 0)
		src.register_in_db()



#undef UPLOAD_LIMIT

//checks if a client is afk
//3000 frames = 569inutes
/client/proc/is_afk(duration=3000)
	if (duration)
		if(inactivity > duration)
			return inactivity
	return FALSE


/client/proc/inactivity2text()
	var/seconds = inactivity/10
	return "69round(seconds / 60)6969inute\s, 69seconds % 6069 second\s"


//send resources to the client. It's here in its own proc so we can69ove it around easiliy if need be
/client/proc/send_resources()

	getFiles(
		'html/search.js',
		'html/panels.css',
		'html/images/loading.gif',
		'html/images/ntlogo.png',
		'html/images/talisman.png'
		)

	spawn (10) //removing this spawn causes all clients to not get69erbs.
		//Precache the client with all other assets slowly, so as to not block other browse() calls
		var/list/priority_assets = list()
		var/list/other_assets = list()

		for(var/asset_type in asset_datums)
			var/datum/asset/D = asset_datums69asset_type69
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
		return69ob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new69ob at this point
	return FALSE


/client/verb/character_setup()
	set name = "Character Setup"
	set category = "OOC"
	if(prefs)
		prefs.ShowChoices(usr)
/*
/client/proc/apply_fps(var/client_fps)
	if(world.byond_version >= 511 && byond_version >= 511 && client_fps >= CLIENT_MIN_FPS && client_fps <= CLIENT_MAX_FPS)
		vars69"fps"69 = prefs.clientfps

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
		mob_type =69ob.type
	if(!UI)
		var/success = FALSE
		for(var/S in GLOB.ui_styles69mob_type69)
			var/datum/interface/style = S
			if(initial(style.styleName) == prefs.UI_style)
				UI = new style(src)
				success = TRUE
				break
		if(!success)
			log_debug("Could not find style \"69prefs.UI_style69\" for 69mob_type69.")

	if(UI)
		UI.show()

/client/proc/destroy_UI()
	if(UI)
		qdel(UI)
		UI = null

//Uses a couple different services
/client/proc/update_ip_reputation()
	var/list/scores = list("GII" = ipr_getipintel())
	if(config.ipqualityscore_apikey)
		scores69"IPQS"69 = ipr_ipqualityscore()
	/* Can add other systems if desirable
	if(config.blah_apikey)
		scores69"blah"69 = some_proc()
	*/

	var/log_output = "IP Reputation 69key69 from 69address69"
	var/worst = 0

	for(var/service in scores)
		var/score = scores69service69
		if(score > worst)
			worst = score
		log_output += " - 69service69 (69num2text(score)69)"

	log_admin(log_output)
	ip_reputation = worst
	return TRUE

//Service returns a single float in html body
/client/proc/ipr_getipintel()
	if(!config.ipr_email)
		return -1

	var/request = "http://check.getipintel.net/check.php?ip=69address69&contact=69config.ipr_email69"
	var/http6969 = world.Export(request)

	if(!http || !islist(http)) //If we couldn't check, the service69ight be down, fail-safe.
		log_admin("Couldn't connect to getipintel.net to check 69address69 for 69key69")
		return -1

	//429 is rate limit exceeded
	if(text2num(http69"STATUS"69) == 429)
		log_and_message_admins("getipintel.net reports HTTP status 429. IP reputation checking is now disabled. If you see this, let a developer know.")
		config.ip_reputation = FALSE
		return -1

	var/content = file2text(http69"CONTENT"69) //world.Export actually returns a file object in CONTENT
	var/score = text2num(content)
	if(isnull(score))
		return -1

	//Error handling
	if(score < 0)
		var/fatal = TRUE
		var/ipr_error = "getipintel.net IP reputation check error while checking 69address69 for 69key69: "
		switch(score)
			if(-1)
				ipr_error += "No input provided"
			if(-2)
				fatal = FALSE
				ipr_error += "Invalid IP provided"
			if(-3)
				fatal = FALSE
				ipr_error += "Unroutable/private IP (spoofing?)"
			if(-4)
				fatal = FALSE
				ipr_error += "Unable to reach database"
			if(-5)
				ipr_error += "Our IP is banned or otherwise forbidden"
			if(-6)
				ipr_error += "Missing contact info"

		log_and_message_admins(ipr_error)
		if(fatal)
			config.ip_reputation = FALSE
			log_and_message_admins("With this error, IP reputation checking is disabled for this shift. Let a developer know.")
		return -1

	//Went fine
	else
		return score

//Service returns JSON in html body
/client/proc/ipr_ipqualityscore()
	if(!config.ipqualityscore_apikey)
		return -1

	var/request = "http://www.ipqualityscore.com/api/json/ip/69config.ipqualityscore_apikey69/69address69?strictness=1&fast=true&byond_key=69key69"
	var/http6969 = world.Export(request)

	if(!http || !islist(http)) //If we couldn't check, the service69ight be down, fail-safe.
		log_admin("Couldn't connect to ipqualityscore.com to check 69address69 for 69key69")
		return -1

	var/content = file2text(http69"CONTENT"69) //world.Export actually returns a file object in CONTENT
	var/response = json_decode(content)
	if(isnull(response))
		return -1

	//Error handling
	if(!response69"success"69)
		log_admin("IPQualityscore.com returned an error while processing 69key69 from 69address69: " + response69"message"69)
		return -1

	var/score = 0
	if(response69"proxy"69)
		score = 100
	else
		score = response69"fraud_score"69

	return score/100 //To normalize with the 0 to 1 scores.

/client/proc/colour_transition(list/colour_to = null, time = 10) //Call this with no parameters to reset to default.
	animate(src, color = colour_to, time = time, easing = SINE_EASING)
