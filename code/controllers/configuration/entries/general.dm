

// server name (for world name / status)
/datum/config_entry/string/servername
// generate numeric suffix based on server port
/datum/config_entry/string/server_suffix

/datum/config_entry/string/hostedby

/// if the game appears on the hub or not
/datum/config_entry/flag/hub

/// Pop requirement for the server to be removed from the hub
/datum/config_entry/number/max_hub_pop
	default = 0 //0 means disabled
	integer = TRUE
	min_val = 0

// Time in minutes before empty server will restart
/datum/config_entry/number/empty_server_restart_time

/****************************/
/*   Client Joining & IPs   */
/****************************/

// panic shit

/datum/config_entry/flag/panic_bunker // prevents people the server hasn't seen before from connecting

/datum/config_entry/number/panic_bunker_living // living time in minutes that a player needs to pass the panic bunker

/datum/config_entry/string/panic_bunker_message
	default = "Sorry but the server is currently not accepting connections from never before seen players."

/datum/config_entry/number/notify_new_player_age // how long do we notify admins of a new player
	min_val = -1

/datum/config_entry/flag/irc_first_connection_alert // do we notify the irc channel when somebody is connecting for the first time?


/datum/config_entry/string/panic_server_name

/datum/config_entry/string/panic_server_name/ValidateAndSet(str_val)
	return str_val != "\[Put the name here\]" && ..()

/datum/config_entry/string/panic_server_address //Reconnect a player this linked server if this server isn't accepting new players

/datum/config_entry/string/panic_server_address/ValidateAndSet(str_val)
	return str_val != "byond://address:port" && ..()

/datum/config_entry/number/client_warn_version
	default = null
	min_val = 500

/datum/config_entry/number/client_warn_build
	default = null
	min_val = 0

/datum/config_entry/string/client_warn_message
	default = "Your version of byond may have issues or be blocked from accessing this server in the future."

/datum/config_entry/flag/client_warn_popup

/datum/config_entry/number/client_error_version
	default = null
	min_val = 500

/datum/config_entry/string/client_error_message
	default = "Your version of byond is too old, may have issues, and is blocked from accessing this server."

/datum/config_entry/number/client_error_build
	default = null
	min_val = 0


/datum/config_entry/flag/paranoia_logging //Log new byond accounts and first-time joins

/datum/config_entry/flag/guests_allowed

/datum/config_entry/flag/debugparanoid

// del's new players if they log before they spawn in
/datum/config_entry/flag/del_new_on_log

/datum/config_entry/flag/usewhitelist

/datum/config_entry/flag/kick_inactive //force disconnect for inactive players

// Ban use of ToR
/datum/config_entry/flag/tor_ban

/datum/config_entry/number/minimum_byond_version
	deprecated_by = /datum/config_entry/number/client_error_version
	min_val = 500
	integer = TRUE

/datum/config_entry/number/minimum_byond_build
	deprecated_by = /datum/config_entry/number/client_error_build
	integer = TRUE


/datum/config_entry/flag/aggressive_changelog

/datum/config_entry/flag/autoconvert_notes //if all connecting player's notes should attempt to be converted to the database
	protection = CONFIG_ENTRY_LOCKED

/******************/
/* Job/Role Prefs */
/******************/

/datum/config_entry/flag/load_jobs_from_txt

// The number of available character slots
/datum/config_entry/number/character_slots
	default = 10
	integer = TRUE

// The number of loadout slots per character
/datum/config_entry/number/loadout_slots
	default = 3
	integer = TRUE


/datum/config_entry/flag/use_age_restriction_for_jobs

/datum/config_entry/flag/use_account_age_for_jobs //Uses the time they made the account for the job restriction stuff. New player joining alerts should be unaffected.

/datum/config_entry/flag/use_age_restriction_for_antags

/datum/config_entry/number/max_gear_cost
	default = 10
	integer = TRUE

/datum/config_entry/number/max_gear_cost/ValidateAndSet(str_val)
	var/valid = ..()
	if(valid)
		var/num_val = text2num(str_val)
		if (num_val < 0)
			config_entry_value = INFINITY
		else
			config_entry_value = num_val

// Allow ai job
/datum/config_entry/flag/allow_ai

/datum/config_entry/number/respawn_delay
	default = 30


// Does nothing, used nowhere
/datum/config_entry/flag/guest_jobban

/*****************/
/*   Mob Prefs   */
/*****************/

/datum/config_entry/flag/disable_player_mice

// Prevent newly-spawned mice from understanding human speech
/datum/config_entry/flag/uneducated_mice

// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
/datum/config_entry/flag/antag_hud_allowed

// Ghosts that turn on Antagovision cannot rejoin the round.
/datum/config_entry/flag/antag_hud_restricted


/datum/config_entry/flag/enable_mob_sleep

/datum/config_entry/flag/automute_on //enables automuting/spam prevention

/datum/config_entry/flag/ghosts_can_possess_animals

/datum/config_entry/flag/abandon_allowed

/* drones */

/datum/config_entry/flag/allow_drone_spawn

//This many drones can spawn
/datum/config_entry/number/max_maint_drones
	default = 5
	integer = TRUE

//A drone will become available every X ticks since last drone spawn. Default is 2 minutes.
/datum/config_entry/number/drone_build_time
	default = 1200

/*****************/
/*     LOGS      */
/*****************/

/// Log human readable versions of json log entries
/datum/config_entry/flag/log_as_human_readable
	default = TRUE


// log OOC channel
/datum/config_entry/flag/log_ooc

// log login/logout
/datum/config_entry/flag/log_access

// log client say
/datum/config_entry/flag/log_say

/// log speech indicators(started/stopped speaking)
/datum/config_entry/flag/log_speech_indicators

// log admin actions
/datum/config_entry/flag/log_admin
	protection = CONFIG_ENTRY_LOCKED

// log debug output
/datum/config_entry/flag/log_debug

// log game events
/datum/config_entry/flag/log_game

/// log virology data
/datum/config_entry/flag/log_virus

/// log economy actions
/datum/config_entry/flag/log_econ

/// log crew manifest to separate file
/datum/config_entry/flag/log_manifest

/// log assets
/datum/config_entry/flag/log_asset

// log voting
/datum/config_entry/flag/log_vote

/// log manual zone switching
/datum/config_entry/flag/log_zone_switch

/datum/config_entry/flag/log_uplink

/// log economy actions
/dat/obj/machinery/computer/uploadum/config_entry/flag/log_econ

// log client whisper
/datum/config_entry/flag/log_whisper

// log emotes
/datum/config_entry/flag/log_emote

/// log telecomms messages
/datum/config_entry/flag/log_telecomms

// log attack messages
/datum/config_entry/flag/log_attack

/// log prayers
/datum/config_entry/flag/log_prayer

// log admin chat messages
/datum/config_entry/flag/log_adminchat

// log warnings admins get about bomb construction and such
/datum/config_entry/flag/log_adminwarn

// log pda messages
/datum/config_entry/flag/log_pda

// logs all links clicked in-game. Could be used for debugging and tracking down exploits
/datum/config_entry/flag/log_hrefs

// logs world.log to a file
/datum/config_entry/flag/log_runtime

/// log silicons
/datum/config_entry/flag/log_silicon

// log log_world(messages)
/datum/config_entry/flag/log_world_output


/// Config entry which special logging of failed logins under suspicious circumstances.
/datum/config_entry/flag/log_suspicious_login

/datum/config_entry/flag/log_world_topic

/*****************/
/*     VOTES     */
/*****************/

/// minimum time between voting sessions (deciseconds, 10 minute default)
/datum/config_entry/number/vote_delay
	default = 6000
	integer = FALSE
	min_val = 0

/// length of voting period (deciseconds, default 1 minute)
/datum/config_entry/number/vote_period
	default = 600
	integer = FALSE
	min_val = 0

/// Length of time before round start when autogamemode vote is called (in seconds, default 100).
/datum/config_entry/number/vote_autogamemode_timeleft
	default = 100
	integer = FALSE
	min_val = 0

/**
 * vote does not default to nochange/norestart (tbi)
 * /datum/config_entry/flag/vote_no_default
 */

/// Prevents dead people from voting.
/datum/config_entry/flag/vote_no_dead

/// allow votes to change mode
/datum/config_entry/flag/allow_vote_mode

/*****************/
/*     ADMIN     */
/*****************/


/datum/config_entry/flag/mentors

/// allows admins with relevant permissions to have their own ooc colour
/datum/config_entry/flag/allow_admin_ooccolor

/// allows admins with relevant permissions to have a personalized asay color
/datum/config_entry/flag/allow_admin_asaycolor

/// adminPMs to non-admins show in a pop-up 'reply' window when enabled.
/datum/config_entry/flag/popup_admin_pm

/// Forid admins from possessing scringularaitirtiys
/datum/config_entry/flag/forbid_singulo_possession

/// Defines whether the server uses the legacy admin system with admins.txt or the SQL system
/datum/config_entry/flag/admin_legacy_system
	protection = CONFIG_ENTRY_LOCKED

/// Gives the !localhost! rank to any client connecting from 127.0.0.1 or ::1
/datum/config_entry/flag/enable_localhost_rank
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/admin_memo_system
	protection = CONFIG_ENTRY_LOCKED

// /datum/config_entry/flag/protect_legacy_admins //Stops any admins loaded by the legacy system from having their rank edited by the permissions panel
// 	protection = CONFIG_ENTRY_LOCKED

// /datum/config_entry/flag/protect_legacy_ranks //Stops any ranks loaded by the legacy system from having their flags edited by the permissions panel
// 	protection = CONFIG_ENTRY_LOCKED


// /datum/config_entry/flag/load_legacy_ranks_only //Loads admin ranks only from legacy admin_ranks.txt, while enabled ranks are mirrored to the database
// 	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/mods_can_tempban

/datum/config_entry/flag/mods_can_job_tempban

/datum/config_entry/number/mod_tempban_max
	default = 1440

/datum/config_entry/number/mod_job_tempban_max
	default = 1440

/datum/config_entry/flag/debug_admin_hrefs

/datum/config_entry/flag/forbid_all_profiling

/datum/config_entry/flag/forbid_admin_profiling

/datum/config_entry/flag/see_own_notes //Can players see their own admin notes

/datum/config_entry/number/note_fresh_days
	default = null
	min_val = 0
	integer = FALSE

/datum/config_entry/number/note_stale_days
	default = null
	min_val = 0
	integer = FALSE

/*****************/
/*     GAME      */
/*****************/

/datum/config_entry/number/fps
	default = 20
	integer = FALSE
	min_val = 1
	max_val = 100 //byond will start crapping out at 50, so this is just ridic
	var/sync_validate = FALSE

/datum/config_entry/number/fps/ValidateAndSet(str_val)
	. = ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/ticklag/TL = config.entries_by_type[/datum/config_entry/number/ticklag]
		if(!TL.sync_validate)
			TL.ValidateAndSet(10 / config_entry_value)
		sync_validate = FALSE

/datum/config_entry/number/ticklag
	integer = FALSE
	var/sync_validate = FALSE

/datum/config_entry/number/ticklag/New() //ticklag weirdly just mirrors fps
	var/datum/config_entry/CE = /datum/config_entry/number/fps
	default = 10 / initial(CE.default)
	..()

/datum/config_entry/number/ticklag/ValidateAndSet(str_val)
	. = text2num(str_val) > 0 && ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/fps/FPS = config.entries_by_type[/datum/config_entry/number/fps]
		if(!FPS.sync_validate)
			FPS.ValidateAndSet(10 / config_entry_value)
		sync_validate = FALSE

/datum/config_entry/string/starlight
	default = "#ffffff"

/datum/config_entry/number/rounds_until_hard_restart
	default = -1
	min_val = 0

/*****************/
/*   COOLDOWNS   */
/*****************/

/datum/config_entry/number/error_cooldown // The "cooldown" time for each occurrence of a unique error
	default = 600
	integer = FALSE
	min_val = 0

/datum/config_entry/number/error_limit // How many occurrences before the next will silence them
	default = 50

/datum/config_entry/number/error_silence_time // How long a unique error will be silenced for
	default = 6000
	integer = FALSE

/datum/config_entry/number/error_msg_delay // How long to wait between messaging admins about occurrences of a unique error
	default = 50
	integer = FALSE


/*****************/
/*     MISC      */
/*****************/

/// Defines whether the server uses recursive or circular explosions.
/datum/config_entry/flag/use_recursive_explosions

/datum/config_entry/flag/emojis

/datum/config_entry/flag/paper_input

/// If true, submaps loaded automatically can be rotated.
/datum/config_entry/flag/random_submap_orientation

/datum/config_entry/flag/use_overmap


/// Path to the python2 executable on the system.
/datum/config_entry/string/python_path

/**
 * motd.txt
 * Sets an MOTD of the server.
 * You can use this multiple times, and the MOTDs will be appended in order.
 * Based on config directory, so "motd.txt" points to "config/motd.txt"
 */
/datum/config_entry/str_list/motd

/datum/config_entry/flag/config_errors_runtime
	default = FALSE
/*****************/
/*  URLS & Lang  */
/*****************/

/datum/config_entry/string/language
	default = "En"

/datum/config_entry/string/serverurl

// set a server location for world reboot. Don't include the byond://, just give the address and port.
/datum/config_entry/string/server

/datum/config_entry/string/banappeals

/datum/config_entry/string/wikiurl
	default = "https://wiki.cev-eris.com/Main_Page"

/datum/config_entry/string/forumurl

/datum/config_entry/string/githuburl
	default = "https://github.com/Endless-Horizon/CEV-Eris"

/datum/config_entry/string/discordurl


/// If admins with +DEBUG can initialize byond-tracy midround.
/datum/config_entry/flag/allow_tracy_start
	protection = CONFIG_ENTRY_LOCKED

/// If admins with +DEBUG can queue byond-tracy to run the next round.
/datum/config_entry/flag/allow_tracy_queue
	protection = CONFIG_ENTRY_LOCKED
