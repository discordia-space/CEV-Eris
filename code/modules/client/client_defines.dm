/client
		//////////////////////
		//BLACK MAGIC THINGS//
		//////////////////////
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
