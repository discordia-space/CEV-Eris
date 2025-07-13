	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT 10485760 //Restricts client uploads to the server to 10MB

GLOBAL_LIST_INIT(blacklisted_builds, list(
	"1407" = "bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1408" = "bug preventing client display overrides from working leads to clients being able to see things/mobs they shouldn't be able to see",
	"1428" = "bug causing right-click menus to show too many verbs that's been fixed in version 1429",
	"1583" = "apparent abuse of terrible byond netcode allowing people to create aimbots and something worse"
	))

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

	// asset_cache
	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		asset_cache_job = asset_cache_confirm_arrival(href_list["asset_cache_confirm_arrival"])
		if (!asset_cache_job)
			return

	// Tgui Topic middleware
	if(tgui_Topic(href_list))
		return
	// if(href_list["reload_tguipanel"])
	// 	nuke_chat()
	// if(href_list["reload_statbrowser"])
	// 	src << browse(file('html/statbrowser.html'), "window=statbrowser")
	// Log all hrefs
	if(config && CONFIG_GET(flag/log_hrefs) && href_logfile)
		DIRECT_OUTPUT(href_logfile, "<small>[time2text(world.timeofday,"hh:mm")]</small>[src] (usr:[usr]\[[COORD(usr)]\]) : [hsrc ? "[hsrc] " : ""][href]")

	//byond bug ID:2256651
	if (asset_cache_job && (asset_cache_job in completed_asset_jobs))
		to_chat(src, span_danger("An error has been detected in how your client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)"))
		src << browse("...", "window=asset_cache_browser")
		return
	if (href_list["asset_cache_preload_data"])
		asset_cache_preload_data(href_list["asset_cache_preload_data"])
		return

	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		if(ismob(C)) 		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client
		// its a fucking ckey
		if(istext(C) || istext(href_list["priv_msg"]))
			C = GLOB.directory[trim(href_list["priv_msg"])]

		cmd_admin_pm(C,null)
		return

	if(href_list["irc_msg"])
		if(!holder && received_irc_pm < world.time - 6000) //Worse they can do is spam IRC for 10 minutes
			to_chat(usr, span_warning("You are no longer able to use this, it's been more then 10 minutes since an admin on IRC has responded to you"))
			return
		if(mute_irc)
			to_chat(usr, "<span class='warning'You cannot use this as your client has been muted from sending messages to the admins on IRC</span>")
			return
		cmd_admin_irc_pm(href_list["irc_msg"])
		return

	if(href_list["commandbar_typing"])
		handle_commandbar_typing(href_list)

	switch(href_list["_src_"])
		if("holder")
			hsrc = holder
		if("usr")
			hsrc = mob
		if("statpanel")
			hsrc = locate(href_list["statpanel_ref"])
		if("prefs")
			return prefs.process_link(usr,href_list)
		if("vars")
			return view_var_Topic(href,href_list,hsrc)
		if("chat")
			return tgui_panel.Topic(href, href_list)

	switch(href_list["action"])
		if("openLink")
			src << link(href_list["link"])
	if (hsrc)
		var/datum/real_src = hsrc
		if(QDELETED(real_src))
			return

	//fun fact: Topic() acts like a verb and is executed at the end of the tick like other verbs. So we have to queue it if the server is
	//overloaded
	if(hsrc && hsrc != holder && DEFAULT_TRY_QUEUE_VERB(VERB_CALLBACK(src, PROC_REF(_Topic), hsrc, href, href_list)))
		return
	..() //redirect to hsrc.Topic()

///dumb workaround because byond doesnt seem to recognize the PROC_REF(Topic) typepath for /datum/proc/Topic() from the client Topic,
///so we cant queue it without this
/client/proc/_Topic(datum/hsrc, href, list/href_list)
	return hsrc.Topic(href, href_list)

/*
 * Call back proc that should be checked in all paths where a client can send messages
 *
 * Handles checking for duplicate messages and people sending messages too fast
 *
 * The first checks are if you're sending too fast, this is defined as sending
 * SPAM_TRIGGER_AUTOMUTE messages in
 * 5 seconds, this will start supressing your messages,
 * if you send 2* that limit, you also get muted
 *
 * The second checks for the same duplicate message too many times and mutes
 * you for it
 */
/client/proc/handle_spam_prevention(message, mute_type)

	//Increment message count
	total_message_count += 1

	//store the total to act on even after a reset
	var/cache = total_message_count

	if(total_count_reset <= world.time)
		total_message_count = 0
		total_count_reset = world.time + (5 SECONDS)

	//If they're really going crazy, mute them
	if(cache >= SPAM_TRIGGER_AUTOMUTE * 2)
		total_message_count = 0
		total_count_reset = 0
		cmd_admin_mute(src.mob, mute_type, 1)
		return TRUE

	//Otherwise just supress the message
	else if(cache >= SPAM_TRIGGER_AUTOMUTE)
		return TRUE


	if(CONFIG_GET(flag/automute_on) && !holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			to_chat(src, span_danger("You have exceeded the spam filter limit for identical messages. An auto-mute was applied."))
			cmd_admin_mute(src.mob, mute_type, 1)
			return TRUE
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			to_chat(src, span_danger("You are nearing the spam filter limit for identical messages."))
			return FALSE
	else
		last_message = message
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return FALSE
	return TRUE


	///////////
	//CONNECT//
	///////////

/client/New(TopicData)
	var/tdata = TopicData //save this for later use
	TopicData = null //Prevent calls to client.Topic from connect

	if(connection != "seeker" && connection != "web")//Invalid connection type.
		return null

	if(!CONFIG_GET(flag/guests_allowed) && IsGuestKey(key))
		del(src)
		return

	GLOB.clients += src
	GLOB.directory[ckey] = src
	var/reconnecting = FALSE
	// TODO: Persistent Clients

	winset(src, null, list("browser-options" = "find,refresh,byondstorage"))

	// Instantiate tgui panel
	tgui_panel = new(src, "browseroutput")

	tgui_say = new(src, "tgui_say")

	initialize_commandbar_spy()

	var/connecting_admin = FALSE //because de-admined admins connecting should be treated like admins.
	//Admin Authorisation
	var/datum/admins/admin_datum = GLOB.admin_datums[ckey]
	if (!isnull(admin_datum))
		admin_datum.associate(src)
		connecting_admin = TRUE
	// if(CONFIG_GET(flag/autoadmin))
	// 	if(!GLOB.admin_datums[ckey])
	// 		var/datum/admin_rank/autorank
	// 		for(var/datum/admin_rank/R in GLOB.GLOB.admin_ranks)
	// 			if(R.name == CONFIG_GET(string/autoadmin_rank))
	// 				autorank = R
	// 				break
	// 		if(!autorank)
	// 			to_chat(world, "Autoadmin rank not found")
	// 		else
	// 			new /datum/admins(autorank, ckey)
	if(CONFIG_GET(flag/enable_localhost_rank) && !connecting_admin)
		var/localhost_addresses = list("127.0.0.1", "::1")
		if(isnull(address) || (address in localhost_addresses))
			var/datum/admins/localhost_rank = new("!localhost!", R_EVERYTHING, ckey)
			localhost_rank.associate(src)

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = SScharacter_setup.preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
		SScharacter_setup.preferences_datums[ckey] = prefs
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning
	fps = 40 //(prefs.clientfps < 0) ? RECOMMENDED_FPS /* <- recommended is 40 */: prefs.clientfps

	var/full_version = "[byond_version].[byond_build ? byond_build : "xxx"]"
	log_access("Login: [key_name(src)] from [address ? address : "localhost"]-[computer_id] || BYOND v[full_version]")


	var/alert_mob_dupe_login = FALSE
	var/alert_admin_multikey = FALSE
	if(CONFIG_GET(flag/log_access))
		var/list/joined_players = list()
		for(var/player_ckey in GLOB.joined_player_list)
			joined_players[player_ckey] = 1

		for(var/joined_player_ckey in (GLOB.directory | joined_players))
			if (!joined_player_ckey || joined_player_ckey == ckey)
				continue

			var/datum/preferences/joined_player_preferences = SScharacter_setup.preferences_datums[joined_player_ckey]
			if(!joined_player_preferences)
				continue //this shouldn't happen.

			var/client/C = GLOB.directory[joined_player_ckey]
			var/in_round = ""
			if (joined_players[joined_player_ckey])
				in_round = " who has played in the current round"
			var/message_type = "Notice"

			var/matches
			if(joined_player_preferences.last_ip == address)
				matches += "IP ([address])"
			if(joined_player_preferences.last_id == computer_id)
				if(matches)
					matches = "BOTH [matches] and "
					alert_admin_multikey = TRUE
					message_type = "MULTIKEY"
				matches += "Computer ID ([computer_id])"
				alert_mob_dupe_login = TRUE

			if(matches)
				if(C)
					message_admins(span_danger("<B>[message_type]: </B></span><span class='notice'>Connecting player [key_name_admin(src)] has the same [matches] as [key_name_admin(C)]<b>[in_round]</b>."))
					log_admin_private("[message_type]: Connecting player [key_name(src)] has the same [matches] as [key_name(C)][in_round].")
				else
					message_admins(span_danger("<B>[message_type]: </B></span><span class='notice'>Connecting player [key_name_admin(src)] has the same [matches] as [joined_player_ckey](no longer logged in)<b>[in_round]</b>. "))
					log_admin_private("[message_type]: Connecting player [key_name(src)] has the same [matches] as [joined_player_ckey](no longer logged in)[in_round].")



	. = ..() //calls mob.Login()
	if (length(GLOB.stickybanadminexemptions))
		GLOB.stickybanadminexemptions -= ckey
		if (!length(GLOB.stickybanadminexemptions))
			restore_stickybans()

	if (byond_version >= 512)
		if (!byond_build || byond_build < 1386)
			message_admins(span_adminnotice("[key_name(src)] has been detected as spoofing their byond version. Connection rejected."))
			// add_system_note("Spoofed-Byond-Version", "Detected as using a spoofed byond version.")
			log_suspicious_login("Failed Login: [key] - Spoofed byond version")
			qdel(src)

		if (num2text(byond_build) in GLOB.blacklisted_builds)
			log_access("Failed login: [key] - blacklisted byond version")
			to_chat_immediate(src, span_userdanger("Your version of byond is blacklisted."))
			to_chat_immediate(src, span_danger("Byond build [byond_build] ([byond_version].[byond_build]) has been blacklisted for the following reason: [GLOB.blacklisted_builds[num2text(byond_build)]]."))
			to_chat_immediate(src, span_danger("Please download a new version of byond. If [byond_build] is the latest, you can go to <a href=\"https://secure.byond.com/download/build\">BYOND's website</a> to download other versions."))
			if(connecting_admin)
				to_chat_immediate(src, "As an admin, you are being allowed to continue using this version, but please consider changing byond versions")
			else
				qdel(src)
				return

	to_chat_immediate(src, span_red("If the title screen is black, resources are still downloading. Please be patient until the title screen appears."))
	if(alert_mob_dupe_login && !holder)
		var/dupe_login_message = "Your ComputerID has already logged in with another key this round, please log out of this one NOW or risk being banned!"
		if (alert_admin_multikey)
			dupe_login_message += "\nAdmins have been informed."
			message_admins(span_danger("<B>MULTIKEYING: </B></span><span class='notice'>[key_name_admin(src)] has a matching CID+IP with another player and is clearly multikeying. They have been warned to leave the server or risk getting banned."))
			log_admin_private("MULTIKEYING: [key_name(src)] has a matching CID+IP with another player and is clearly multikeying. They have been warned to leave the server or risk getting banned.")
		spawn(0.5 SECONDS) //needs to run during world init, do not convert to add timer
			alert(mob, dupe_login_message) //players get banned if they don't see this message, do not convert to tgui_alert (or even tg_alert) please.
			to_chat_immediate(mob, span_danger(dupe_login_message))


	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday
	var/breaking_version = CONFIG_GET(number/client_error_version)
	var/breaking_build = CONFIG_GET(number/client_error_build)
	var/warn_version = CONFIG_GET(number/client_warn_version)
	var/warn_build = CONFIG_GET(number/client_warn_build)

	if (byond_version < breaking_version || (byond_version == breaking_version && byond_build < breaking_build)) //Out of date client.
		to_chat_immediate(src, span_danger("<b>Your version of BYOND is too old:</b>"))
		to_chat_immediate(src, CONFIG_GET(string/client_error_message))
		to_chat_immediate(src, "Your version: [byond_version].[byond_build]")
		to_chat_immediate(src, "Required version: [breaking_version].[breaking_build] or later")
		to_chat_immediate(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")
		if (connecting_admin)
			to_chat_immediate(src, "Because you are an admin, you are being allowed to walk past this limitation, But it is still STRONGLY suggested you upgrade")
		else
			qdel(src)
			return
	else if (byond_version < warn_version || (byond_version == warn_version && byond_build < warn_build)) //We have words for this client.
		if(CONFIG_GET(flag/client_warn_popup))
			var/msg = "<b>Your version of byond may be getting out of date:</b><br>"
			msg += CONFIG_GET(string/client_warn_message) + "<br><br>"
			msg += "Your version: [byond_version].[byond_build]<br>"
			msg += "Required version to remove this message: [warn_version].[warn_build] or later<br>"
			msg += "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.<br>"
			src << browse(HTML_SKELETON(msg), "window=warning_popup")
		else
			to_chat(src, span_danger("<b>Your version of byond may be getting out of date:</b>"))
			to_chat(src, CONFIG_GET(string/client_warn_message))
			to_chat(src, "Your version: [byond_version].[byond_build]")
			to_chat(src, "Required version to remove this message: [warn_version].[warn_build] or later")
			to_chat(src, "Visit <a href=\"https://secure.byond.com/download\">BYOND's website</a> to get the latest version of BYOND.")


	src << browse(file('html/statbrowser.html'), "window=statbrowser")
	// addtimer(CALLBACK(src, PROC_REF(check_panel_loaded)), 30 SECONDS)

	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday
	winset(src, null, "command=\".configure graphics-hwmode on\"")

	// Initialize tgui panel
	tgui_panel.initialize()

	tgui_say.initialize()

	/* byond err version check here (configurable) */

	// if (connection == "web" && !connecting_admin)
	// 	if (!CONFIG_GET(flag/allow_webclient))
	// 		to_chat(src, "Web client is disabled")
	// 		qdel(src)
	// 		return
	// 	if (CONFIG_GET(flag/webclient_only_byond_members) && !IsByondMember())
	// 		to_chat(src, "Sorry, but the web client is restricted to byond members only.")
	// 		qdel(src)
	// 		return

	if( (world.address == address || !address) && !host )
		host = key
		world.update_status()

	if(holder)
		add_admin_verbs()
		admin_memo_show()
		adminGreet()

	if (mob)
		var/stealth_admin = mob.client?.holder?.fakekey
		// var/announce_leave = mob.client?.prefs?.read_preference(/datum/preference/toggle/broadcast_login_logout)
		if (!stealth_admin)
			deadchat_broadcast(" has reconnected.", "<b>[mob][mob.get_realname_string()]</b>", follow_target = mob, turf_target = get_turf(mob), message_type = DEADCHAT_LOGIN_LOGOUT/*, admin_only=!announce_leave*/)

	if(custom_event_msg && custom_event_msg != "")
		to_chat(src, "<h1 class='alert'>Custom Event</h1>")
		to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
		to_chat(src, span_alert("[custom_event_msg]"))
		to_chat(src, "<br>")

	if (mob && reconnecting)
		var/stealth_admin = mob.client?.holder?.fakekey
		// var/announce_leave = mob.client?.prefs?.read_preference(/datum/preference/toggle/broadcast_login_logout)
		var/announce_leave = FALSE
		if (!stealth_admin)
			deadchat_broadcast(" has reconnected.", "<b>[mob][mob.get_realname_string()]</b>", follow_target = mob, turf_target = get_turf(mob), message_type = DEADCHAT_LOGIN_LOGOUT, admin_only=!announce_leave)

	// TODO: Port modern notes
	// This needs to be before the client age from db is updated as it'll be updated by then.
	// var/datum/db_query/query_last_connected = SSdbcore.NewQuery(
	// 	"SELECT lastseen FROM [format_table_name("player")] WHERE ckey = :ckey",
	// 	list("ckey" = ckey)
	// )
	// if(query_last_connected.warn_execute() && length(query_last_connected.rows))
	// 	query_last_connected.NextRow()
	// 	var/time_stamp = query_last_connected.item[1]
	// 	var/unread_notes = get_message_output("note", ckey, FALSE, time_stamp)
	// 	if(unread_notes)
	// 		to_chat(src, unread_notes, type = MESSAGE_TYPE_ADMINPM, confidential = TRUE)
	// qdel(query_last_connected)

	var/cached_player_age = set_client_age_from_db(tdata) //we have to cache this because other shit may change it and we need it's current value now down below.
	if (isnum(cached_player_age) && cached_player_age == -1) //first connection
		if(!SSdbcore.Connect())
			player_age = -1
		else
			account_join_date = findJoinDate()
			if(!account_join_date)
				player_age = 0
			else
				var/datum/db_query/query_datediff = SSdbcore.NewQuery(
					"SELECT DATEDIFF(Now(), :account_join_date)",
					list("account_join_date" = account_join_date)
				)
				if(!query_datediff.Execute())
					qdel(query_datediff)
					return
				if(query_datediff.NextRow())
					account_age = text2num(query_datediff.item[1])
				qdel(query_datediff)
			player_age = account_age

	var/nnpa = CONFIG_GET(number/notify_new_player_age)
	if (isnum(cached_player_age) && cached_player_age == -1) //first connection
		if (nnpa >= 0)
			message_admins("New user: [key_name_admin(src)] is connecting here for the first time.")
			if (CONFIG_GET(flag/irc_first_connection_alert))
				send2tgs_adminless_only("New-user", "[key_name(src)] is connecting for the first time!")
	else if (isnum(cached_player_age) && cached_player_age < nnpa)
		message_admins("New user: [key_name_admin(src)] just connected with an age of [cached_player_age] day[(player_age == 1?"":"s")]")
	if(CONFIG_GET(flag/use_account_age_for_jobs) && account_age >= 0)
		player_age = account_age
	if(account_age >= 0 && account_age < nnpa)
		message_admins("[key_name_admin(src)] (IP: [address], ID: [computer_id]) is a new BYOND account [account_age] day[(account_age == 1?"":"s")] old, created on [account_join_date].")
		if (CONFIG_GET(flag/irc_first_connection_alert))
			send2tgs_adminless_only("new_byond_user", "[key_name(src)] (IP: [address], ID: [computer_id]) is a new BYOND account [account_age] day[(account_age == 1?"":"s")] old, created on [account_join_date].")
	// if(check_overwatch() && CONFIG_GET(flag/vpn_kick))
	// 	return
	validate_key_in_db()
	// If we aren't already generating a ban cache, fire off a build request
	// This way hopefully any users of request_ban_cache will never need to yield
	if(!ban_cache_start && SSban_cache?.query_started)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(build_ban_cache), src)

	send_resources()

	initialize_menus()

	// TODO: Uncomment when new notes system is ported
	// if(CONFIG_GET(flag/autoconvert_notes))
	// 	convert_notes_sql(ckey)
	if(ckey in GLOB.clientmessages)
		for(var/message in GLOB.clientmessages[ckey])
			to_chat(src, message)
		GLOB.clientmessages.Remove(ckey)

	if(prefs.lastchangelog != GLOB.changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		to_chat(src, span_info("You have unread updates in the changelog."))
		if(CONFIG_GET(flag/aggressive_changelog))
			changelog()

	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
		to_chat(src, span_warning("Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you."))

	//This is down here because of the browse() calls in tooltip/New()
	if(!tooltips)
		tooltips = new /datum/tooltip(src)

	Master.UpdateTickRate()

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	if(!gc_destroyed)
		Destroy() //Clean up signals and timers.
	return ..()

/client/Destroy()
	if(mob)
		var/stealth_admin = mob.client?.holder?.fakekey
		// var/announce_join = mob.client?.prefs?.read_preference(/datum/preference/toggle/broadcast_login_logout)
		if (!stealth_admin)
			deadchat_broadcast(" has disconnected.", "<b>[mob][mob.get_realname_string()]</b>", follow_target = mob, turf_target = get_turf(mob), message_type = DEADCHAT_LOGIN_LOGOUT/*, admin_only=!announce_join*/)

	GLOB.clients -= src
	GLOB.directory -= ckey
	log_access("Logout: [key_name(src)]")
	if(holder)
		holder.owner = null
		GLOB.admins -= src
		handle_admin_logout()
	QDEL_NULL(tooltips)
	if(SSdbcore.IsConnected())
		var/datum/db_query/query = SSdbcore.NewQuery("UPDATE [format_table_name("player")] SET lastseen = Now() WHERE ckey = :ckey", list("ckey" = ckey))
		if(!query.Execute())
			log_world("Failed to update players table for ckey [ckey]. Error message: [query.ErrorMsg()].")
		qdel(query)
	Master.UpdateTickRate()
	..() //Even though we're going to be hard deleted there are still some things that want to know the destroy is happening
	return QDEL_HINT_HARDDEL_NOW

/client/proc/findJoinDate()
	var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
	if(!http)
		log_world("Failed to connect to byond member page to age check [ckey]")
		return
	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4}-\\d{2}-\\d{2})\"")
		if(R.Find(F))
			. = R.group[1]
		else
			CRASH("Age check regex failed for [src.ckey]")

/client/proc/validate_key_in_db()
	var/sql_key
	var/datum/db_query/query_check_byond_key = SSdbcore.NewQuery(
		"SELECT byond_key FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!query_check_byond_key.Execute())
		qdel(query_check_byond_key)
		return
	if(query_check_byond_key.NextRow())
		sql_key = query_check_byond_key.item[1]
	qdel(query_check_byond_key)
	if(key != sql_key)
		var/list/http = world.Export("http://byond.com/members/[ckey]?format=text")
		if(!http)
			log_world("Failed to connect to byond member page to get changed key for [ckey]")
			return
		var/F = file2text(http["CONTENT"])
		if(F)
			var/regex/R = regex("\\tkey = \"(.+)\"")
			if(R.Find(F))
				var/web_key = R.group[1]
				var/datum/db_query/query_update_byond_key = SSdbcore.NewQuery(
					"UPDATE [format_table_name("player")] SET byond_key = :byond_key WHERE ckey = :ckey",
					list("byond_key" = web_key, "ckey" = ckey)
				)
				query_update_byond_key.Execute()
				qdel(query_update_byond_key)
			else
				CRASH("Key check regex failed for [ckey]")

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


// /client/proc/register_in_db()
// 	// Prevents the crash if the DB isn't connected.
// 	if(!SSdbcore.IsConnected())
// 		return

// 	account_join_date = src.findJoinDate()
// 	src.get_country()
// 	src.get_byond_age() // Get days since byond join
// 	var/admin_rank = holder?.rank || "player"
// 	var/datum/db_query/query_insert = SSdbcore.NewQuery(
// 		"INSERT INTO [format_table_name("player")] (ckey, byond_key, firstseen, firstseen_round_id, lastseen, lastseen_round_id, accountjoindate, ip, computerid, lastadminrank, country) VALUES (:ckey, :byond_key, Now(), :firstseen_round_id, Now(), :lastseen_round_id, :accountjoindate, INET_ATON(:ip), :computerid, :lastadminrank, :country)",
// 		list(
// 			"ckey" = src.ckey,
// 			"byond_key" = src.key,
// 			"firstseen_round_id" = GLOB.round_id,
// 			"lastseen_round_id" = GLOB.round_id,
// 			"accountjoindate" = account_join_date,
// 			"ip" = src.address,
// 			"computerid" = src.computer_id,
// 			"lastadminrank" = admin_rank,
// 			"country" = src.country_code
// 		)
// 	)
// 	if(!query_insert.Execute())
// 		log_world("##CRITICAL: Failed to create player record for user [ckey]. Error message: [query_insert.ErrorMsg()].")
// 		return

// 	else
// 		var/datum/db_query/get_player_id = SSdbcore.NewQuery("SELECT firstseen FROM [format_table_name("player")] WHERE ckey = :ckey", list("ckey" = src.ckey))
// 		get_player_id.Execute()
// 		if(get_player_id.NextRow())
// 			src.first_seen = get_player_id.item[1]

//Not actually age, but rather time since first seen in days
// /client/proc/get_player_age()
// 	if(first_seen && SSdbcore.IsConnected())
// 		var/datum/db_query/query_datediff = SSdbcore.NewQuery("SELECT DATEDIFF(Now(),:datesql)", list("datesql" = first_seen))
// 		if(query_datediff.Execute() && query_datediff.NextRow())
// 			src.player_age = text2num(query_datediff.item[1])

// 	if(CONFIG_GET(flag/paranoia_logging) && isnum(src.player_age) && src.player_age == 0)
// 		log_and_message_admins("PARANOIA: [key_name(src)] has connected here for the first time.")
// 	return src.player_age

//Days since they signed up for their byond account
/client/proc/get_byond_age()
	if(!account_join_date)
		findJoinDate()
	if(account_join_date && SSdbcore.IsConnected())
		var/datum/db_query/query_datediff = SSdbcore.NewQuery("SELECT DATEDIFF(Now(),:datesql)", list("datesql" = account_join_date))
		if(query_datediff.Execute() && query_datediff.NextRow())
			src.account_age_in_days = text2num(query_datediff.item[1])
	if(CONFIG_GET(flag/paranoia_logging) && isnum(src.account_age_in_days) && src.account_age_in_days <= 2)
		log_and_message_admins("PARANOIA: [key_name(src)] has a very new Byond account. ([src.account_age_in_days] days old)")
	return src.account_age_in_days

/client/proc/log_client_to_db_connection_log()
	if(!SSdbcore.shutting_down)
		SSdbcore.FireAndForget({"
			INSERT INTO `[format_table_name("connection_log")]` (`id`,`datetime`,`server_ip`,`server_port`,`round_id`,`ckey`,`ip`,`computerid`,`byond_version`,`byond_build`)
			VALUES(null,Now(),INET_ATON(:internet_address),:port,:round_id,:ckey,INET_ATON(:ip),:computerid,:byond_version,:byond_build)
		"}, list("internet_address" = world.internet_address || "0", "port" = world.port, "round_id" = GLOB.round_id, "ckey" = ckey, "ip" = address, "computerid" = computer_id, "byond_version" = byond_version, "byond_build" = byond_build))

/client/proc/set_client_age_from_db(connectiontopic)
	if (IsGuestKey(src.key))
		return
	if(!SSdbcore.Connect())
		return
	var/datum/db_query/query_get_related_ip = SSdbcore.NewQuery(
		"SELECT ckey FROM [format_table_name("player")] WHERE ip = INET_ATON(:address) AND ckey != :ckey",
		list("address" = address, "ckey" = ckey)
	)
	if(!query_get_related_ip.Execute())
		qdel(query_get_related_ip)
		return
	related_accounts_ip = ""
	while(query_get_related_ip.NextRow())
		related_accounts_ip += "[query_get_related_ip.item[1]], "
	qdel(query_get_related_ip)
	var/datum/db_query/query_get_related_cid = SSdbcore.NewQuery(
		"SELECT ckey FROM [format_table_name("player")] WHERE computerid = :computerid AND ckey != :ckey",
		list("computerid" = computer_id, "ckey" = ckey)
	)
	if(!query_get_related_cid.Execute())
		qdel(query_get_related_cid)
		return
	related_accounts_cid = ""
	while (query_get_related_cid.NextRow())
		related_accounts_cid += "[query_get_related_cid.item[1]], "
	qdel(query_get_related_cid)

	var/admin_rank = holder?.rank || "Player"
	var/new_player
	var/datum/db_query/query_client_in_db = SSdbcore.NewQuery(
		"SELECT 1 FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!query_client_in_db.Execute())
		qdel(query_client_in_db)
		return

	var/client_is_in_db = query_client_in_db.NextRow()
	// If we aren't an admin, and the flag is set (the panic bunker is enabled).
	if(CONFIG_GET(flag/panic_bunker) && !holder && !GLOB.deadmins[ckey])
		// The amount of hours needed to bypass the panic bunker.
		var/living_recs = CONFIG_GET(number/panic_bunker_living)
		// This relies on prefs existing, but this proc is only called after that occurs, so we're fine.
		// var/minutes = get_exp_living(pure_numeric = TRUE)
		var/minutes = SSjob.GetTotalPlaytimeMinutesCkey(ckey)

		// If we don't have panic_bunker_living set and the client is not in the DB, reject them.
		// Otherwise, if we do have a panic_bunker_living set, check if they have enough minutes played.
		if((living_recs == 0 && !client_is_in_db) || living_recs >= minutes)
			var/reject_message = "Failed Login: [key] - [client_is_in_db ? "":"New "]Account attempting to connect during panic bunker, but\
				[living_recs == 0 ? " was rejected due to no prior connections to game servers (no database entry)":" they do not have the required living time [minutes]/[living_recs]"]."
			log_access(reject_message)
			message_admins(span_adminnotice("[reject_message]"))
			var/message = CONFIG_GET(string/panic_bunker_message)
			message = replacetext(message, "%minutes%", living_recs)
			to_chat_immediate(src, message)
			var/list/connectiontopic_a = params2list(connectiontopic)
			var/list/panic_addr = CONFIG_GET(string/panic_server_address)
			if(panic_addr && !connectiontopic_a["redirect"])
				var/panic_name = CONFIG_GET(string/panic_server_name)
				to_chat_immediate(src, span_notice("Sending you to [panic_name ? panic_name : panic_addr]."))
				winset(src, null, "command=.options")
				src << link("[panic_addr]?redirect=1")
			qdel(query_client_in_db)
			qdel(src)
			return

	if(!client_is_in_db)
		new_player = 1
		account_join_date = findJoinDate()
		var/datum/db_query/query_add_player = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("player")] (`ckey`, `byond_key`, `firstseen`, `firstseen_round_id`, `lastseen`, `lastseen_round_id`, `ip`, `computerid`, `lastadminrank`, `accountjoindate`)
			VALUES (:ckey, :key, Now(), :round_id, Now(), :round_id, INET_ATON(:ip), :computerid, :adminrank, :account_join_date)
		"}, list("ckey" = ckey, "key" = key, "round_id" = GLOB.round_id, "ip" = address, "computerid" = computer_id, "adminrank" = admin_rank, "account_join_date" = account_join_date || null))
		if(!query_add_player.Execute())
			qdel(query_client_in_db)
			qdel(query_add_player)
			return
		qdel(query_add_player)
		if(!account_join_date)
			account_join_date = "Error"
			account_age = -1
	qdel(query_client_in_db)
	var/datum/db_query/query_get_client_age = SSdbcore.NewQuery(
		"SELECT firstseen, DATEDIFF(Now(),firstseen), accountjoindate, DATEDIFF(Now(),accountjoindate) FROM [format_table_name("player")] WHERE ckey = :ckey",
		list("ckey" = ckey)
	)
	if(!query_get_client_age.Execute())
		qdel(query_get_client_age)
		return
	if(query_get_client_age.NextRow())
		player_join_date = query_get_client_age.item[1]
		player_age = text2num(query_get_client_age.item[2])
		if(!account_join_date)
			account_join_date = query_get_client_age.item[3]
			account_age = text2num(query_get_client_age.item[4])
			if(!account_age)
				account_join_date = findJoinDate()
				if(!account_join_date)
					account_age = -1
				else
					var/datum/db_query/query_datediff = SSdbcore.NewQuery(
						"SELECT DATEDIFF(Now(), :account_join_date)",
						list("account_join_date" = account_join_date)
					)
					if(!query_datediff.Execute())
						qdel(query_datediff)
						qdel(query_get_client_age)
						return
					if(query_datediff.NextRow())
						account_age = text2num(query_datediff.item[1])
					qdel(query_datediff)
	qdel(query_get_client_age)
	if(!new_player)
		SSdbcore.FireAndForget(
			"UPDATE [format_table_name("player")] SET lastseen = Now(), lastseen_round_id = :round_id, ip = INET_ATON(:ip), computerid = :computerid, lastadminrank = :admin_rank, accountjoindate = :account_join_date WHERE ckey = :ckey",
			list("round_id" = GLOB.round_id, "ip" = address, "computerid" = computer_id, "admin_rank" = admin_rank, "account_join_date" = account_join_date || null, "ckey" = ckey)
		)
	if(!account_join_date)
		account_join_date = "Error"
	log_client_to_db_connection_log()

	// TODO: Port SSserver_maint
	// SSserver_maint.UpdateHubStatus()

	if(new_player)
		player_age = -1
	. = player_age


	// src.get_byond_age() // Get days since byond join
	// src.get_player_age() // Get days since first seen

	// IP Reputation Check
	if(CONFIG_GET(flag/ip_reputation))
		if(CONFIG_GET(flag/ipr_allow_existing) && player_age >= CONFIG_GET(number/ipr_minimum_age))
			log_admin("Skipping IP reputation check on [key] with [address] because of player age")
		else if(holder)
			log_admin("Skipping IP reputation check on [key] with [address] because they have a staff rank")
		else if(VPN_whitelist)
			log_admin("Skipping IP reputation check on [key] with [address] because they have a VPN whitelist")
		else if(update_ip_reputation()) //It is set now
			if(ip_reputation >= CONFIG_GET(number/ipr_bad_score)) //It's bad

				//Log it
				if(CONFIG_GET(flag/paranoia_logging)) //We don't block, but we want paranoia log messages
					log_and_message_admins("[key] at [address] has bad IP reputation: [ip_reputation]. Will be kicked if enabled in config.")
				else //We just log it
					log_admin("[key] at [address] has bad IP reputation: [ip_reputation]. Will be kicked if enabled in config.")

				//Take action if required
				if(CONFIG_GET(flag/ipr_block_bad_ips) && CONFIG_GET(flag/ipr_allow_existing)) //We allow players of an age, but you don't meet it
					to_chat(src, "Sorry, we only allow VPN/Proxy/Tor usage for players who have spent at least [CONFIG_GET(number/ipr_minimum_age)] days on the server. If you are unable to use the internet without your VPN/Proxy/Tor, please contact an admin out-of-game to let them know so we can accommodate this.")
					del(src) // Hard del the client. This terminates the connection.
					return 0
				else if(CONFIG_GET(flag/ipr_block_bad_ips)) //We don't allow players of any particular age
					to_chat(src, "Sorry, we do not accept connections from users via VPN/Proxy/Tor connections. If you think this is in error, contact an administrator out of game.")
					del(src) // Hard del the client. This terminates the connection.
					return 0
		else
			log_admin("Couldn't perform IP check on [key] with [address]")


//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(duration)
		if(inactivity > duration)
			return inactivity
	return FALSE


/client/proc/inactivity2text()
	var/seconds = inactivity/10
	return "[round(seconds / 60)] minute\s, [seconds % 60] second\s"


//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/// Send resources to the client.
/// Sends both game resources and browser assets.
/client/proc/send_resources()
#if (PRELOAD_RSC == 0)
	var/static/next_external_rsc = 0
	var/list/external_rsc_urls = CONFIG_GET(keyed_list/external_rsc_urls)
	if(length(external_rsc_urls))
		next_external_rsc = WRAP(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]
#endif

	spawn (10) //removing this spawn causes all clients to not get verbs. (this can't be addtimer because these assets may be needed before the mc inits)

		//load info on what assets the client has
		src << browse('code/modules/asset_cache/validate_assets.html', "window=asset_cache_browser")

		//Precache the client with all other assets slowly, so as to not block other browse() calls
		if (CONFIG_GET(flag/asset_simple_preload))
			addtimer(CALLBACK(SSassets.transport, TYPE_PROC_REF(/datum/asset_transport, send_assets_slow), src, SSassets.transport.preload), 5 SECONDS)

		send_all_cursor_icons(src)

//Hook, override it to run code when dir changes
//Like for /atoms, but clients are their own snowflake FUCK
/client/proc/setDir(newdir)
	dir = newdir

/mob/proc/MayRespawn()
	return FALSE


/client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return FALSE

/datum/verbs/menu/Preferences/verb/character_setup()
	set category = "OOC"
	set name = "Character Setup"
	set desc = "Character Setup"

	if(usr.client.prefs)
		usr.client.prefs.ShowChoices(usr)

/client/proc/create_UI(mob_type)
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
		for(var/i in screen)
			if(UI._elements.Find(i))
				screen.Remove(i)
		qdel(UI)
		UI = null

//Uses a couple different services
/client/proc/update_ip_reputation()
	var/list/scores = list("GII" = ipr_getipintel())
	if(CONFIG_GET(string/ipqualityscore_apikey))
		scores["IPQS"] = ipr_ipqualityscore()
	/* Can add other systems if desirable
	if(config.blah_apikey)
		scores["blah"] = some_proc()
	*/

	var/log_output = "IP Reputation [key] from [address]"
	var/worst = 0

	for(var/service in scores)
		var/score = scores[service]
		if(score > worst)
			worst = score
		log_output += " - [service] ([num2text(score)])"

	log_admin(log_output)
	ip_reputation = worst
	return TRUE

//Service returns a single float in html body
/client/proc/ipr_getipintel()
	if(!CONFIG_GET(string/ipr_email))
		return -1

	var/request = "http://check.getipintel.net/check.php?ip=[address]&contact=[CONFIG_GET(string/ipr_email)]"
	var/http[] = world.Export(request)

	if(!http || !islist(http)) //If we couldn't check, the service might be down, fail-safe.
		log_admin("Couldn't connect to getipintel.net to check [address] for [key]")
		return -1

	//429 is rate limit exceeded
	if(text2num(http["STATUS"]) == 429)
		log_and_message_admins("getipintel.net reports HTTP status 429. IP reputation checking is now disabled. If you see this, let a developer know.")
		CONFIG_SET(flag/ip_reputation, FALSE)
		return -1

	var/content = file2text(http["CONTENT"]) //world.Export actually returns a file object in CONTENT
	var/score = text2num(content)
	if(isnull(score))
		return -1

	//Error handling
	if(score < 0)
		var/fatal = TRUE
		var/ipr_error = "getipintel.net IP reputation check error while checking [address] for [key]: "
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
			CONFIG_SET(flag/ip_reputation, FALSE)
			log_and_message_admins("With this error, IP reputation checking is disabled for this shift. Let a developer know.")
		return -1

	//Went fine
	else
		return score

//Service returns JSON in html body
/client/proc/ipr_ipqualityscore()
	if(!CONFIG_GET(string/ipqualityscore_apikey))
		return -1

	var/request = "http://www.ipqualityscore.com/api/json/ip/[CONFIG_GET(string/ipqualityscore_apikey)]/[address]?strictness=1&fast=true&byond_key=[key]"
	var/http[] = world.Export(request)

	if(!http || !islist(http)) //If we couldn't check, the service might be down, fail-safe.
		log_admin("Couldn't connect to ipqualityscore.com to check [address] for [key]")
		return -1

	var/content = file2text(http["CONTENT"]) //world.Export actually returns a file object in CONTENT
	var/response = json_decode(content)
	if(isnull(response))
		return -1

	//Error handling
	if(!response["success"])
		log_admin("IPQualityscore.com returned an error while processing [key] from [address]: " + response["message"])
		return -1

	var/score = 0
	if(response["proxy"])
		score = 100
	else
		score = response["fraud_score"]

	return score/100 //To normalize with the 0 to 1 scores.

/client/proc/colour_transition(list/colour_to = null, time = 10) //Call this with no parameters to reset to default.
	animate(src, color = colour_to, time = time, easing = SINE_EASING)

/// Compiles a full list of verbs and sends it to the browser
/client/proc/init_verbs()
	var/list/verblist = list()
	verb_tabs.Cut()
	for(var/thing in (verbs + mob?.verbs))
		var/procpath/verb_to_init = thing
		if(!verb_to_init)
			continue
		if(verb_to_init.hidden)
			continue
		if(!istext(verb_to_init.category))
			continue
		verb_tabs |= verb_to_init.category
		verblist[++verblist.len] = list(verb_to_init.category, verb_to_init.name)
	src << output("[url_encode(json_encode(verb_tabs))];[url_encode(json_encode(verblist))]", "statbrowser:init_verbs")

/**
 * Initializes dropdown menus on client
 */
/client/proc/initialize_menus()
	var/list/topmenus = GLOB.menulist[/datum/verbs/menu]
	for (var/thing in topmenus)
		var/datum/verbs/menu/topmenu = thing
		var/topmenuname = "[topmenu]"
		if (topmenuname == "[topmenu.type]")
			var/list/tree = splittext(topmenuname, "/")
			topmenuname = tree[tree.len]
		winset(src, "[topmenu.type]", "parent=menu;name=[url_encode(topmenuname)]")
		var/list/entries = topmenu.Generate_list(src)
		for (var/child in entries)
			winset(src, "[child]", "[entries[child]]")
			if (!ispath(child, /datum/verbs/menu))
				var/procpath/verbpath = child
				if (verbpath.name[1] != "@")
					new child(src)

/client/verb/fix_stat_panel()
	set name = "Fix Stat Panel"
	set category = "OOC"

	init_verbs()

// /client/verb/enable_fullscreen()
// 	set hidden = TRUE
// 	winset(usr, "mainwindow", "titlebar=false")
// 	winset(usr, "mainwindow", "menu=")
// 	winset(usr, "mainwindow", "is-maximized=false")
// 	winset(usr, "mainwindow", "is-maximized=true")
// 	fit_viewport()

// /client/verb/disable_fullscreen()
// 	set hidden = TRUE
// 	winset(usr, "mainwindow", "titlebar=true")
// 	winset(usr, "mainwindow", "menu=menu")
// 	winset(usr, "mainwindow", "is-maximized=false")
// 	fit_viewport()

/client/verb/toggle_fullscreen()
	set name = "Toogle Fullscreen"
	set category = "OOC"

	fullscreen = !fullscreen

	if(fullscreen)
		winset(usr, "mainwindow", "titlebar=false")
		winset(usr, "mainwindow", "menu=")
		winset(usr, "mainwindow", "is-maximized=false")
		winset(usr, "mainwindow", "is-maximized=true")
	else
		winset(usr, "mainwindow", "titlebar=true")
		winset(usr, "mainwindow", "menu=menu")
		winset(usr, "mainwindow", "is-maximized=false")
	fit_viewport()

/// Handles any "fluff" or supplementary procedures related to an admin logout event. Should not have anything critically related cleaning up an admin's logout.
/client/proc/handle_admin_logout()
	adminGreet(logout = TRUE)
	if(length(GLOB.admins) > 0 || !SSticker.IsRoundInProgress()) // We only want to report this stuff if we are currently playing.
		return

	var/list/message_to_send = list()
	var/static/list/cheesy_messages = null

	cheesy_messages ||= list(
		"Forever alone :(",
		"I have no admins online!",
		"I need a hug :(",
		"I need someone on me :(",
		"I want a man :(",
		"I'm all alone :(",
		"I'm feeling lonely :(",
		"I'm so lonely :(",
		"Someone come hold me :(",
		"What happened? Where has everyone gone?",
		"Where has everyone gone?",
		"Why does nobody love me? :(",
	)

	message_to_send += pick(cheesy_messages)
	message_to_send += "(No admins online)"

	send2adminchat("Server", jointext(message_to_send, " "))

#undef UPLOAD_LIMIT

