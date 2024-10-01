
GLOBAL_LIST_EMPTY(storyteller_cache)

/datum/configuration
	var/server_name				// server name (for world name / status)
	var/server_suffix = 0				// generate numeric suffix based on server port

	var/nudge_script_path = "nudge.py"  // where the nudge.py script is located

	var/log_ooc = 0						// log OOC channel
	var/log_access = 0					// log login/logout
	var/log_say = 0						// log client say
	var/log_admin = 0					// log admin actions
	var/log_debug = 1					// log debug output
	var/log_game = 0					// log game events
	var/log_vote = 0					// log voting
	var/log_whisper = 0					// log client whisper
	var/log_emote = 0					// log emotes
	var/log_attack = 0					// log attack messages
	var/log_adminchat = 0				// log admin chat messages
	var/log_adminwarn = 0				// log warnings admins get about bomb construction and such
	var/log_pda = 0						// log pda messages
	var/log_hrefs = 0					// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	var/log_runtime = 0					// logs world.log to a file
	var/log_world_output = 0			// log log_world(messages)
	var/sql_enabled = 1					// for sql switching
	var/allow_admin_ooccolor = 0		// Allows admins with relevant permissions to have their own ooc colour
	var/allow_vote_restart = 0 			// allow votes to restart
	var/ert_admin_call_only = 0
	var/allow_vote_mode = 0				// allow votes to change mode
	var/vote_delay = 6000				// minimum time between voting sessions (deciseconds, 10 minute default)
	var/vote_period = 600				// length of voting period (deciseconds, default 1 minute)
	var/vote_autogamemode_timeleft = 100 //Length of time before round start when autogamemode vote is called (in seconds, default 100).
	var/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = 0				// dead people can't vote (tbi)
	//var/enable_authentication = 0		// goon authentication
	var/del_new_on_log = 1				// del's new players if they log before they spawn in
	var/objectives_disabled = 0 			//if objectives are disabled or not
	var/protect_roles_from_antagonist = 0// If security and such can be contractor/cult/other
	var/allow_Metadata = 0				// Metadata is supported.
	var/popup_admin_pm = 0				//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/tick_limit_mc_init = TICK_LIMIT_MC_INIT_DEFAULT	//SSinitialization throttling
	var/fps = 40
	var/socket_talk	= 0					// use socket_talk to communicate with other processes
	var/list/resource_urls
	var/antag_hud_allowed = 0			// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/antag_hud_restricted = 0                    // Ghosts that turn on Antagovision cannot rejoin the round.
	var/list/storyteller_names = list()
	var/list/storytellers = list()				// allowed modes
	var/humans_need_surnames = 0
	var/allow_random_events = 0			// enables random events mid-round when set to 1
	var/allow_ai = 0					// allow ai job
	var/hostedby
	var/respawn_delay = 30
	var/guest_jobban = 1
	var/usewhitelist = 0
	var/kick_inactive = 0				//force disconnect for inactive players after this many minutes, if non-0
	var/show_mods = 0
	var/show_mentors = 0
	var/mods_can_tempban = 0
	var/mods_can_job_tempban = 0
	var/mod_tempban_max = 1440
	var/mod_job_tempban_max = 1440
	var/load_jobs_from_txt = 0
	var/ToRban = 0
	var/automute_on = 0					//enables automuting/spam prevention
	var/use_cortical_stacks = 0			//enables neural lace
	var/empty_server_restart_time = 0	// Time in minutes before empty server will restart

	var/character_slots = 10				// The number of available character slots
	var/loadout_slots = 3					// The number of loadout slots per character

	var/max_gear_cost = 10 // Used in chargen for accessory loadout limit. 0 disables loadout, negative allows infinite points.

	var/max_maint_drones = 5				//This many drones can spawn,
	var/allow_drone_spawn = 1				//assuming the admin allow them to.
	var/drone_build_time = 1200				//A drone will become available every X ticks since last drone spawn. Default is 2 minutes.

	var/enable_mob_sleep = 1  //Experimental - make mobs sleep when no danger is present

	var/disable_player_mice = 0
	var/uneducated_mice = 0 //Set to 1 to prevent newly-spawned mice from understanding human speech

	var/allow_extra_antags = 0
	var/guests_allowed = 1
	var/debugparanoid = 0

	var/language
	var/serverurl
	var/server
	var/banappeals
	var/wikiurl
	var/forumurl
	var/githuburl
	var/discordurl

	var/static/ip_reputation = FALSE		//Should we query IPs to get scores? Generates HTTP traffic to an API service.
	var/static/ipr_email					//Left null because you MUST specify one otherwise you're making the internet worse.
	var/static/ipr_block_bad_ips = FALSE	//Should we block anyone who meets the minimum score below? Otherwise we just log it (If paranoia logging is on, visibly in chat).
	var/static/ipr_bad_score = 1			//The API returns a value between 0 and 1 (inclusive), with 1 being 'definitely VPN/Tor/Proxy'. Values equal/above this var are considered bad.
	var/static/ipr_allow_existing = FALSE 	//Should we allow known players to use VPNs/Proxies? If the player is already banned then obviously they still can't connect.
	var/static/ipr_minimum_age = 5			//How many days before a player is considered 'fine' for the purposes of allowing them to use VPNs.
	var/static/ipqualityscore_apikey		//API key for ipqualityscore.com. Optional additional service that can be used if an API key is provided.

	var/static/panic_bunker = FALSE			//Only allow ckeys who have already been seen by the DB. Only makes sense if you have a DB.
	var/static/paranoia_logging = FALSE		//Log new byond accounts and first-time joins

	//Alert level description
	var/alert_desc_green = "All threats to the ship have passed. Security may not have weapons visible, privacy laws are once again fully enforced."
	var/alert_desc_blue_upto = "The ship has received reliable information about possible hostile activity on the ship. Security staff may have weapons visible, random searches are permitted."
	var/alert_desc_blue_downto = "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed."
	var/alert_desc_red_upto = "There is an immediate serious threat to the ship. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	var/alert_desc_red_downto = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the ship. Security may have weapons unholstered at all times, random searches are allowed and advised."

	var/forbid_singulo_possession = 0

	var/organs_decay

	//Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
	//so that it's similar to HALLOSS. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
	var/organ_damage_spillover_multiplier = 0.5

	var/bones_can_break = 0
	var/limbs_can_break = 1

	var/revival_pod_plants = 1
	var/revival_cloning = 1
	var/revival_brain_life = -1

	var/use_loyalty_implants = 0

	var/welder_vision = 1
	var/generate_asteroid = 0
	var/no_click_cooldown = 0
	var/z_level_shooting = TRUE

	var/admin_legacy_system = 0	//Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in config.txt
	var/ban_legacy_system = 0	//Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config.txt
	var/admin_memo_system = 0

	var/simultaneous_pm_warning_timeout = 100

	var/use_recursive_explosions //Defines whether the server uses recursive or circular explosions.

	var/assistant_maint = 0 //Do assistants get maint access?
	var/gateway_delay = 18000 //How long the gateway takes before it activates. Default is half an hour.
	var/ghost_interaction = 0

	var/comms_password = ""

	var/list/forbidden_versions = list() // Clients with these byond versions will be autobanned. Format: string "byond_version.byond_build"; separate with ; in config, e.g. 512.1234;512.1235
	var/minimum_byond_version
	var/minimum_byond_build

	var/enter_allowed = 1

	var/use_irc_bot = 0
	var/irc_bot_host = ""
	var/irc_bot_export = 0 // whether the IRC bot in use is a Bot32 (or similar) instance; Bot32 uses world.Export() instead of nudge.py/libnudge
	var/main_irc = ""
	var/admin_irc = ""
	var/announce_shuttle_dock_to_irc = FALSE
	var/python_path = "" //Path to the python executable.  Defaults to "python" on windows and "/usr/bin/env python2" on unix
	var/use_lib_nudge = 0 //Use the C library nudge instead of the python nudge.
	var/use_overmap = 0

	var/start_location = "asteroid" // Start location defaults to asteroid.

	// Event settings
	var/expected_round_length = 3 * 60 * 60 * 10 // 3 hours
	// If the first delay has a custom start time
	// No custom time, no custom time, between 80 to 100 minutes respectively.
	var/list/event_first_run   = list(
		EVENT_LEVEL_MUNDANE = null,
		EVENT_LEVEL_MODERATE = null,
		EVENT_LEVEL_MAJOR = list("lower" = 48000, "upper" = 60000),
		EVENT_LEVEL_ROLESET = null,
		EVENT_LEVEL_ECONOMY = list("lower" = 16000, "upper" = 20000),
	)
	// The lowest delay until next event
	// 10, 30, 50 minutes respectively
	var/list/event_delay_lower = list(
		EVENT_LEVEL_MUNDANE = 6000,
		EVENT_LEVEL_MODERATE = 18000,
		EVENT_LEVEL_MAJOR = 30000,
		EVENT_LEVEL_ROLESET = null,
		EVENT_LEVEL_ECONOMY = 18000
	)
	// The upper delay until next event
	// 15, 45, 70 minutes respectively
	var/list/event_delay_upper = list(
		EVENT_LEVEL_MUNDANE = 9000,
		EVENT_LEVEL_MODERATE = 27000,
		EVENT_LEVEL_MAJOR = 42000,
		EVENT_LEVEL_ROLESET = null,
		EVENT_LEVEL_ECONOMY = 18000
	)

	var/abandon_allowed = 1
	var/ooc_allowed = 1
	var/looc_allowed = 1
	var/dooc_allowed = 1
	var/dsay_allowed = 1

	var/starlight = "#ffffff"	// null if turned off

	var/list/ert_species = list(SPECIES_HUMAN)

	var/law_zero = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

	var/aggressive_changelog = 0

	var/list/language_prefixes = list(",", "#", "-")//Default language prefixes

	var/ghosts_can_possess_animals = 0

	var/emojis = 0

	var/paper_input = TRUE

	var/random_submap_orientation = FALSE // If true, submaps loaded automatically can be rotated.

	var/webhook_url
	var/webhook_key

	var/tts_key // Login and password that we use to generate tts_bearer
	var/tts_enabled // Global switch
	var/tts_cache // Store generated tts files and reuse them, instead of always requesting new

	var/static/regex/ic_filter_regex //For the cringe filter.

	var/generate_loot_data = FALSE //for loot rework

	var/profiler_permission = R_DEBUG | R_SERVER

/datum/configuration/New()
	fill_storyevents_list()

	var/list/L = typesof(/datum/storyteller)-/datum/storyteller
	for (var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/storyteller/S = new T()
		if (S.config_tag)
			GLOB.storyteller_cache[S.config_tag] = S // So we don't instantiate them repeatedly.
			if(!(S.config_tag in storytellers))		// ensure each mode is added only once
				log_misc("Adding storyteller [S.name] ([S.config_tag]) to configuration.")
				src.storytellers += S.config_tag
				src.storyteller_names[S.config_tag] = S.name

/datum/configuration/proc/load(filename, type = "config") //the type can also be game_options, in which case it uses a different switch. not making it separate to not copypaste code - Urist
	var/list/Lines = file2list(filename)

	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name
		var/value

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		if(type == "config")
			switch (name)
				if ("resource_urls")
					config.resource_urls = splittext(value, " ")

				if ("admin_legacy_system")
					config.admin_legacy_system = 1

				if ("ban_legacy_system")
					config.ban_legacy_system = 1

				if ("admin_memo_system")
					config.admin_memo_system = 1

				if ("use_recursive_explosions")
					use_recursive_explosions = 1

				if ("log_ooc")
					config.log_ooc = 1

				if ("log_access")
					config.log_access = 1

				if ("sql_enabled")
					config.sql_enabled = 1

				if ("log_say")
					config.log_say = 1

				if ("debug_paranoid")
					config.debugparanoid = 1

				if ("log_admin")
					config.log_admin = 1

				if ("log_debug")
					config.log_debug = 1

				if ("log_game")
					config.log_game = 1

				if ("log_vote")
					config.log_vote = 1

				if ("log_whisper")
					config.log_whisper = 1

				if ("log_attack")
					config.log_attack = 1

				if ("log_emote")
					config.log_emote = 1

				if ("log_adminchat")
					config.log_adminchat = 1

				if ("log_adminwarn")
					config.log_adminwarn = 1

				if ("log_pda")
					config.log_pda = 1

				if ("log_world_output")
					config.log_world_output = 1

				if ("log_hrefs")
					config.log_hrefs = 1

				if ("log_runtime")
					config.log_runtime = 1
					var/newlog = file("data/logs/runtimes/runtime-[time2text(world.realtime, "YYYY-MM-DD")].log")
					if(runtime_diary != newlog)
						world.log << "Now logging runtimes to data/logs/runtimes/runtime-[time2text(world.realtime, "YYYY-MM-DD")].log"
						runtime_diary = newlog

				if ("generate_asteroid")
					config.generate_asteroid = 1

				if ("no_click_cooldown")
					config.no_click_cooldown = 1

				if("allow_admin_ooccolor")
					config.allow_admin_ooccolor = 1

				if ("allow_vote_restart")
					config.allow_vote_restart = 1

				if ("allow_vote_mode")
					config.allow_vote_mode = 1

				if ("no_dead_vote")
					config.vote_no_dead = 1

				if ("default_no_vote")
					config.vote_no_default = 1

				if ("vote_delay")
					config.vote_delay = text2num(value)

				if ("vote_period")
					config.vote_period = text2num(value)

				if ("vote_autogamemode_timeleft")
					config.vote_autogamemode_timeleft = text2num(value)

				if("ert_admin_only")
					config.ert_admin_call_only = 1

				if ("allow_ai")
					config.allow_ai = 1

//				if ("authentication")
//					config.enable_authentication = 1

				if ("respawn_delay")
					config.respawn_delay = text2num(value)

				if ("servername")
					config.server_name = value

				if ("serversuffix")
					config.server_suffix = 1

				if ("nudge_script_path")
					config.nudge_script_path = value

				if ("hostedby")
					config.hostedby = value

				if ("serverurl")
					config.serverurl = value

				if ("language")
					config.language = value

				if ("server")
					config.server = value

				if ("banappeals")
					config.banappeals = value

				if ("wikiurl")
					config.wikiurl = value

				if ("discordurl")
					config.discordurl = value

				if ("forumurl")
					config.forumurl = value

				if ("githuburl")
					config.githuburl = value

				if("ip_reputation")
					config.ip_reputation = 1

				if("ipr_email")
					config.ipr_email = value

				if("ipr_block_bad_ips")
					config.ipr_block_bad_ips = 1

				if("ipr_bad_score")
					config.ipr_bad_score = text2num(value)

				if("ipr_allow_existing")
					config.ipr_allow_existing = 1

				if("ipr_minimum_age")
					config.ipr_minimum_age = text2num(value)

				if ("ipqualityscore_apikey")
					config.ipqualityscore_apikey = value

				if ("panic_bunker")
					config.panic_bunker = 1

				if ("paranoia_logging")
					config.paranoia_logging = 1

				if ("ghosts_can_possess_animals")
					config.ghosts_can_possess_animals = value

				if ("guest_jobban")
					config.guest_jobban = 1

				if ("guest_ban")
					config.guests_allowed = 0

				if ("disable_ooc")
					config.ooc_allowed = 0
					config.looc_allowed = 0

				if ("disable_entry")
					config.enter_allowed = 0

				if ("disable_dead_ooc")
					config.dooc_allowed = 0

				if ("disable_dsay")
					config.dsay_allowed = 0

				if ("disable_respawn")
					config.abandon_allowed = 0

				if ("usewhitelist")
					config.usewhitelist = 1

				if ("allow_metadata")
					config.allow_Metadata = 1

				if ("objectives_disabled")
					config.objectives_disabled = 1

				if("protect_roles_from_antagonist")
					config.protect_roles_from_antagonist = 1

				if("allow_random_events")
					config.allow_random_events = 1

				if("kick_inactive")
					config.kick_inactive = text2num(value)

				if("show_mods")
					config.show_mods = 1

				if("show_mentors")
					config.show_mentors = 1

				if("mods_can_tempban")
					config.mods_can_tempban = 1

				if("mods_can_job_tempban")
					config.mods_can_job_tempban = 1

				if("mod_tempban_max")
					config.mod_tempban_max = text2num(value)

				if("mod_job_tempban_max")
					config.mod_job_tempban_max = text2num(value)

				if("load_jobs_from_txt")
					load_jobs_from_txt = 1

				if("alert_red_upto")
					config.alert_desc_red_upto = value

				if("alert_red_downto")
					config.alert_desc_red_downto = value

				if("alert_blue_downto")
					config.alert_desc_blue_downto = value

				if("alert_blue_upto")
					config.alert_desc_blue_upto = value

				if("alert_green")
					config.alert_desc_green = value

				if("forbid_singulo_possession")
					forbid_singulo_possession = 1

				if("popup_admin_pm")
					config.popup_admin_pm = 1

				if("use_irc_bot")
					use_irc_bot = 1

				if("irc_bot_export")
					irc_bot_export = 1

				if("fps")
					fps = text2num(value)

				if("tick_limit_mc_init")
					tick_limit_mc_init = text2num(value)

				if("allow_antag_hud")
					config.antag_hud_allowed = 1
				if("antag_hud_restricted")
					config.antag_hud_restricted = 1

				if("socket_talk")
					socket_talk = text2num(value)

				if("humans_need_surnames")
					humans_need_surnames = 1

				if("tor_ban")
					ToRban = 1

				if("automute_on")
					automute_on = 1

				if("assistant_maint")
					config.assistant_maint = 1

				if("gateway_delay")
					config.gateway_delay = text2num(value)

				if("ghost_interaction")
					config.ghost_interaction = 1

				if("disable_player_mice")
					config.disable_player_mice = 1

				if("uneducated_mice")
					config.uneducated_mice = 1

				if("comms_password")
					config.comms_password = value

				if("forbidden_versions")
					config.forbidden_versions = splittext(value, ";")

				if("minimum_byond_version")
					config.minimum_byond_version = text2num(value)

				if("minimum_byond_build")
					config.minimum_byond_build = text2num(value)

				if("irc_bot_host")
					config.irc_bot_host = value

				if("main_irc")
					config.main_irc = value

				if("admin_irc")
					config.admin_irc = value

				if("announce_shuttle_dock_to_irc")
					config.announce_shuttle_dock_to_irc = TRUE

				if("python_path")
					if(value)
						config.python_path = value

				if("use_lib_nudge")
					config.use_lib_nudge = 1

				if("max_gear_cost")
					max_gear_cost = text2num(value)
					if(max_gear_cost < 0)
						max_gear_cost = INFINITY

				if("character_slots")
					config.character_slots = text2num(value)

				if("allow_drone_spawn")
					config.allow_drone_spawn = text2num(value)

				if("drone_build_time")
					config.drone_build_time = text2num(value)

				if("max_maint_drones")
					config.max_maint_drones = text2num(value)

				if("use_overmap")
					config.use_overmap = 1

				if("expected_round_length")
					config.expected_round_length = MinutesToTicks(text2num(value))

				if("disable_welder_vision")
					config.welder_vision = 0

				if("allow_extra_antags")
					config.allow_extra_antags = 1

				if("event_custom_start_mundane")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MUNDANE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_moderate")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MODERATE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_major")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MAJOR] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_economy")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_ECONOMY] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_delay_lower")
					var/values = text2numlist(value, ";")
					config.event_delay_lower[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config.event_delay_lower[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config.event_delay_lower[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])
					config.event_delay_lower[EVENT_LEVEL_ECONOMY] = MinutesToTicks(values[4])

				if("event_delay_upper")
					var/values = text2numlist(value, ";")
					config.event_delay_upper[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config.event_delay_upper[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config.event_delay_upper[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])
					config.event_delay_upper[EVENT_LEVEL_ECONOMY] = MinutesToTicks(values[4])

				if("starlight")
					config.starlight = value ? value : 0

				if("random_submap_orientation")
					config.random_submap_orientation = 1

				if("ert_species")
					config.ert_species = splittext(value, ";")
					if(!config.ert_species.len)
						config.ert_species += SPECIES_HUMAN

				if("use_cortical_stacks")
					config.use_cortical_stacks = 1

				if("loadout_slots")
					config.loadout_slots = text2num(value)

				if("law_zero")
					law_zero = value

				if("aggressive_changelog")
					config.aggressive_changelog = 1

				if("default_language_prefixes")
					var/list/values = splittext(value, " ")
					if(values.len > 0)
						language_prefixes = values

				if("empty_server_restart_time")
					config.empty_server_restart_time = text2num(value)

				if("emojis")
					config.emojis = 1

				if("paper_input")
					config.paper_input = text2num(value)

				if("enable_mob_sleep")
					config.enable_mob_sleep = 1

				if("webhook_key")
					config.webhook_key = value

				if("webhook_url")
					config.webhook_url = value

				if("tts_key")
					config.tts_key = value

				if("tts_enabled")
					config.tts_enabled = config.tts_key ? value : FALSE

				if("tts_cache")
					config.tts_cache = value

				if("random_start")
					var/list/startlist = list(
						"asteroid",
						"abandoned fortress",
						"space ruins")
					var/pick = rand(1, startlist.len)
					config.start_location = startlist[pick]

				if("asteroid_start")
					config.start_location = "asteroid"

				if("fortress_start")
					config.start_location = "abandoned fortress"

				if("ruins_start")
					config.start_location = "space ruins"

				if("profiler_permission")
					config.profiler_permission = text2num(value)

				if("generate_loot_data")
					config.generate_loot_data = TRUE
				else
					log_misc("Unknown setting in configuration: '[name]'")


		else if(type == "game_options")
			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")
			value = text2num(value)

			switch(name)
				if("revival_pod_plants")
					config.revival_pod_plants = value
				if("revival_cloning")
					config.revival_cloning = value
				if("revival_brain_life")
					config.revival_brain_life = value
				if("organ_damage_spillover_multiplier")
					config.organ_damage_spillover_multiplier = value / 100
				if("organs_can_decay")
					config.organs_decay = 1
				if("bones_can_break")
					config.bones_can_break = value
				if("limbs_can_break")
					config.limbs_can_break = value


				if("use_loyalty_implants")
					config.use_loyalty_implants = 1




				else
					log_misc("Unknown setting in configuration: '[name]'")
	LoadChatFilter()

/datum/configuration/proc/loadsql(filename)  // -- TLE
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name
		var/value

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("address")
				sqladdress = value
			if ("port")
				sqlport = value
			if ("database")
				sqldb = value
			if ("login")
				sqllogin = value
			if ("password")
				sqlpass = value
			else
				log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration/proc/pick_storyteller(story_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	if(story_name in GLOB.storyteller_cache)
		return GLOB.storyteller_cache[story_name]

	return GLOB.storyteller_cache[STORYTELLER_BASE]

/datum/configuration/proc/get_storytellers()
	var/list/runnable_storytellers = list()
	for(var/storyteller in GLOB.storyteller_cache)
		var/datum/storyteller/S = GLOB.storyteller_cache[storyteller]
		if(S)
			runnable_storytellers |= S
	return runnable_storytellers



/datum/configuration/proc/post_load()
	//apply a default value to config.python_path, if needed
	if (!config.python_path)
		if(world.system_type == UNIX)
			config.python_path = "/usr/bin/env python2"
		else //probably windows, if not this should work anyway
			config.python_path = "python"

	world.name = station_name


/datum/configuration/proc/LoadChatFilter()
	GLOB.in_character_filter = list()

	for(var/line in world.file2list("config/in_character_filter.txt"))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.in_character_filter += line

	if(!ic_filter_regex && GLOB.in_character_filter.len)
		ic_filter_regex = regex("\\b([jointext(GLOB.in_character_filter, "|")])\\b", "i")
