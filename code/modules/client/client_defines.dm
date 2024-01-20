/**
 * Client datum
 *
 * A datum that is created whenever a user joins a BYOND world, one will exist for every active connected
 * player
 *
 * when they first connect, this client object is created and [/client/New] is called
 *
 * When they disconnect, this client object is deleted and [/client/Del] is called
 *
 * All client topic calls go through [/client/Topic] first, so a lot of our specialised
 * topic handling starts here
 */
/client
	/**
	 * This line makes clients parent type be a datum
	 *
	 * By default in byond if you define a proc on datums, that proc will exist on nearly every single type
	 * from icons to images to atoms to mobs to objs to turfs to areas, it won't however, appear on client
	 *
	 * instead by default they act like their own independent type so while you can do isdatum(icon)
	 * and have it return true, you can't do isdatum(client), it will always return false.
	 *
	 * This makes writing oo code hard, when you have to consider this extra special case
	 *
	 * This line prevents that, and has never appeared to cause any ill effects, while saving us an extra
	 * pain to think about
	 *
	 * This line is widely considered black fucking magic, and the fact it works is a puzzle to everyone
	 * involved, including the current engine developer, lummox
	 *
	 * If you are a future developer and the engine source is now available and you can explain why this
	 * is the way it is, please do update this comment
	 */
	parent_type = /datum
		////////////////
		//ADMIN THINGS//
		////////////////
	///Contains admin info. Null if client is not an admin.
	var/datum/admins/holder = null
	var/datum/admins/deadmin_holder = null
	var/buildmode		= 0

	///Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message = ""
	///contins a number of how many times a message identical to last_message was sent.
	var/last_message_count = 0
	///How many messages sent in the last 10 seconds
	var/total_message_count = 0
	///Next tick to reset the total message counter
	var/total_count_reset = 0
	///Internal counter for clients sending external (IRC/Discord) relay messages via ahelp to prevent spamming. Set to a number every time an admin reply is sent, decremented for every client send.
	var/externalreplyamount = 0

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs = null
	var/moving			= null
	var/adminobs		= null
	var/area			= null

	var/adminhelped = 0

		///////////////
		//SOUND STUFF//
		///////////////
	var/ambience_playing= null
	var/played			= 0

		////////////
		//SECURITY//
		////////////
	var/received_irc_pm = -99999
	var/irc_admin			//IRC admin that spoke with them last.
	var/mute_irc = 0
	var/warned_about_multikeying = 0	// Prevents people from being spammed about multikeying every time their mob changes.
	var/ip_reputation = 0 //Do we think they're using a proxy/vpn? Only if IP Reputation checking is enabled in config.
	var/account_age_in_days // Byond account age


		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/id = -1
	var/registration_date = ""
	var/first_seen = ""
	var/country = ""
	var/country_code = ""
	var/first_seen_days_ago
	/* security shit from asset cache (what the fuck) */
	var/VPN_whitelist //avoid vpn cheking
	var/list/related_ip = list()
	var/list/related_cid = list()

	preload_rsc = PRELOAD_RSC

		////////////////
		//Mouse things//
		////////////////
	var/datum/click_handler/CH

	///datum that controls the displaying and hiding of tooltips
	var/datum/tooltip/tooltips

	var/datum/interface/UI	//interface for current mob

	var/lastping = 0
	var/avgping = 0
	var/connection_time //world.time they connected
	var/connection_realtime //world.realtime they connected
	var/connection_timeofday //world.timeofday they connected

	var/datum/chatOutput/chatOutput

	// List of all asset filenames sent to this client by the asset cache, along with their assoicated md5s
	var/list/sent_assets = list()
	/// List of all completed blocking send jobs awaiting acknowledgement by send_asset
	var/list/completed_asset_jobs = list()
	/// Last asset send job id.
	var/last_asset_job = 0
	var/last_completed_asset_job = 0

	/// For bottom-left hover-over info.
	var/status_bar_prev_text = ""
