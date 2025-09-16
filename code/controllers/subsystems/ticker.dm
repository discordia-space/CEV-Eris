SUBSYSTEM_DEF(ticker)
	name = "Ticker"
	init_order = INIT_ORDER_TICKER
	priority = FIRE_PRIORITY_TICKER
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME

	var/const/restart_timeout = 600
	var/current_state = GAME_STATE_STARTUP
	/// Boolean to track if round should be forcibly ended next ticker tick.
	/// Set by admin intervention ([ADMIN_FORCE_END_ROUND])
	var/force_ending = END_ROUND_AS_NORMAL
	// If true, there is no lobby phase, the game starts immediately.
	var/start_immediately = FALSE

	//setup vars
	var/first_start_trying = TRUE
	var/story_vote_ended = FALSE

	var/event_time = null
	var/event = 0

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/random_players = 0 	// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/list/syndicate_coalition = list() // list of contractor-compatible factions
	var/list/factions = list()			  // list of all factions
	var/list/availablefactions = list()	  // list of factions with openings

	var/pregame_timeleft = 5 MINUTES
	var/start_at
	var/last_player_left_timestamp = 0

	var/end_state = "undefined"

	/// Num of players, used for pregame stats on statpanel
	var/totalPlayers = 0
	/// Num of ready players, used for pregame stats on statpanel (only viewable by admins)
	var/totalPlayersReady = 0
	/// Num of ready admins, used for pregame stats on statpanel (only viewable by admins)
	var/total_admins_ready = 0

	var/delay_end = FALSE //if set true, the round will not restart on it's own
	var/admin_delay_notice = "" //a message to display to anyone who tries to restart the world after a delay
	var/ready_for_reboot = FALSE //all roundend preparation done with, all that's left is reboot

	var/triai = 0//Global holder for Triumvirate

	var/quoted = FALSE
	var/round_start_time = 0
	var/round_end_announced = 0 // Spam Prevention. Announce round end only once.

	/// ID of round reboot timer, if it exists
	var/reboot_timer = null

	var/ship_was_nuked = 0              // See nuclearbomb.dm and malfunction.dm.
	var/ship_nuke_code = "NO CODE"       // Heads will get parts of this code.
	var/ship_nuke_code_rotation_part = 1 // What part of code next Head will get.
	var/nuke_in_progress = 0           	// Sit back and relax
	/// See excelsior_redirector.dm,0 for not happening,  1 for in progress , 2 for finished(And for the round to end immediately)
	var/excelsior_hijacking = 0

	var/newscaster_announcements = null

	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	var/list/round_start_events

/datum/controller/subsystem/ticker/Initialize(start_timeofday)
	if(!syndicate_code_phrase)
		syndicate_code_phrase = generate_code_phrase()
	if(!syndicate_code_response)
		syndicate_code_response = generate_code_phrase()

	setup_objects()
	setup_huds()

	// TODO: make this a config option
	start_at = world.time + (5 MINUTES)

	return ..()

/datum/controller/subsystem/ticker/proc/setup_objects()
	populate_antag_type_list() // Set up antagonists. Do these first since character setup will rely on them

/datum/controller/subsystem/ticker/proc/setup_huds()
	global_hud = new()
	global_huds = list(
		global_hud.druggy,
		global_hud.blurry,
		global_hud.lightMask,
		global_hud.vimpaired,
		global_hud.darkMask,
		global_hud.nvg,
		global_hud.thermal,
		global_hud.meson,
		global_hud.science,
		global_hud.holomap)

/datum/controller/subsystem/ticker/fire()
	switch(current_state)
		if(GAME_STATE_STARTUP)
			if(Master.initializations_finished_with_no_players_logged_in || first_start_trying)
				start_at = world.time + (5 MINUTES)
			pregame_timeleft = initial(pregame_timeleft)
			for(var/client/C in GLOB.clients)
				window_flash(C) //let them know lobby has opened up.
			if(!start_immediately)
				to_chat(world, span_boldnotice("Please, setup your character and select ready. Game will start in [DisplayTimeText(SSticker.GetTimeLeft())]."))
			to_chat(world, span_notice("<b>Welcome to [station_name()]!</b>"))
			current_state = GAME_STATE_PREGAME
			SEND_SIGNAL(src, COMSIG_TICKER_ENTER_PREGAME)
			fire()
		if(GAME_STATE_PREGAME)
			if(start_immediately)
				SSvote.stop_vote()
				pregame_timeleft = 0

			if(!process_empty_server())
				return

			//lobby stats for statpanels
			if(isnull(pregame_timeleft))
				pregame_timeleft = max(0,start_at - world.time)
			totalPlayers = LAZYLEN(GLOB.player_list)
			totalPlayersReady = 0
			total_admins_ready = 0
			for(var/mob/new_player/player as anything in GLOB.player_list)
				if(!isnewplayer(player))
					continue
				if(player.ready)
					++totalPlayersReady
					if(player.client?.holder)
						++total_admins_ready

			//countdown
			if(pregame_timeleft < 0)
				return
			pregame_timeleft -= wait

			if(pregame_timeleft <= 30 SECONDS && !quoted)
				send_quote_of_the_round()
				quoted = TRUE

			if(!story_vote_ended && (pregame_timeleft == CONFIG_GET(number/vote_autogamemode_timeleft) || !first_start_trying))
				if(!SSvote.active_vote)
					SSvote.autostoryteller()	//Quit calling this over and over and over and over.

			if(pregame_timeleft <= 0)
				SEND_SIGNAL(src, COMSIG_TICKER_ENTER_SETTING_UP)
				current_state = GAME_STATE_SETTING_UP
				Master.SetRunLevel(RUNLEVEL_SETUP)
				if(start_immediately)
					fire()
			first_start_trying = FALSE

		if(GAME_STATE_SETTING_UP)
			if(!setup())
				//setup failed
				current_state = GAME_STATE_STARTUP
				start_at = world.time + (5 MINUTES)
				pregame_timeleft = null
				Master.SetRunLevel(RUNLEVEL_LOBBY)
				SEND_SIGNAL(src, COMSIG_TICKER_ERROR_SETTING_UP)

		if(GAME_STATE_PLAYING)
			GLOB.storyteller.Process()
			GLOB.storyteller.process_events()

			if(!process_empty_server())
				return

			var/game_finished = (evacuation_controller.round_over() || ship_was_nuked || universe_has_ended || excelsior_hijacking == 2 || force_ending)

			if(!nuke_in_progress && game_finished)
				current_state = GAME_STATE_FINISHED
				Master.SetRunLevel(RUNLEVEL_POSTGAME)
				for(var/client_key in SSinactivity_and_job_tracking.current_playtimes)
					SSjob.SavePlaytimes(client_key)
				declare_completion()

// This proc will scan for player and if the game is in progress and...
// there is no player for certain minutes (see config.empty_server_restart_time) it will restart the server and return FALSE
// If the game in pregame state if will reset roundstart timer and return FALSE
// otherwise it will return TRUE
// will also return TRUE if its currently counting down to server's restart after last player left

/datum/controller/subsystem/ticker/proc/process_empty_server()
	if(!CONFIG_GET(number/empty_server_restart_time))
		return TRUE
	switch(current_state)
		if(GAME_STATE_PLAYING)
			if(GLOB.clients.len)
				// Resets countdown if any player connects on empty server
				if(last_player_left_timestamp)
					last_player_left_timestamp = 0
				return TRUE
			else
				// Last player left so we store the time when he left
				if(!last_player_left_timestamp)
					last_player_left_timestamp = world.time
					return TRUE
				// Counting down the world's end
				else if (world.time >= last_player_left_timestamp + (CONFIG_GET(number/empty_server_restart_time) MINUTES))
					last_player_left_timestamp = 0
					log_game("\[Server\] No players were on a server last [CONFIG_GET(number/empty_server_restart_time)] minutes, restarting server...")
					world.Reboot()
					return FALSE
		if(GAME_STATE_PREGAME)
			if(!GLOB.clients.len)
				// if pregame and no player we break fire() execution so no countdown will be done
				if(pregame_timeleft == initial(pregame_timeleft))
					return FALSE
				// Resetting countdown time
				else
					pregame_timeleft = initial(pregame_timeleft)
					quoted = FALSE
					return FALSE
	return TRUE

/datum/controller/subsystem/ticker/proc/setup()
	to_chat(world, span_boldannounce("Starting game..."))
	if (start_immediately)
		to_chat(world, span_warning("The game was told to start immediately! Lighting may be temporarily askew if this was right after initializations finished!"))
	var/init_start = world.timeofday
	//Create and announce mode

	if(!GLOB.storyteller)
		set_storyteller(announce = FALSE)

	if(!GLOB.storyteller)
		to_chat(world, "[span_danger("Serious error storyteller system!")] Reverting to pre-game lobby.")
		return FALSE

	SSjob.ResetOccupations()
	SSjob.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	CHECK_TICK

	if(!GLOB.storyteller.can_start(TRUE))
		log_game("Game failed pre_setup")
		to_chat(world, "<B>Unable to start game.</B> Reverting to pre-game lobby.")
		//GLOB.storyteller = null //Possibly bring this back in future if we have storytellers with differing requirements
		//story_vote_ended = FALSE
		SSjob.ResetOccupations()
		return FALSE

	GLOB.storyteller.announce()

	setup_economy()
	newscaster_announcements = pick(newscaster_standard_feeds)

	create_characters() //Create player characters and transfer them
	collect_minds()
	move_characters_to_spawnpoints()
	equip_characters()

	CHECK_TICK

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.mind || player_is_antag(H.mind, only_offstation_roles = 1) || !SSjob.ShouldCreateRecords(H.mind.assigned_role))
			continue
		CreateModularRecord(H)
	data_core.manifest()

	CHECK_TICK

	for(var/I in round_start_events)
		var/datum/callback/cb = I
		cb.InvokeAsync()
	LAZYCLEARLIST(round_start_events)
	log_world("Game start took [(world.timeofday - init_start)/10]s")
	INVOKE_ASYNC(SSdbcore, TYPE_PROC_REF(/datum/controller/subsystem/dbcore,SetRoundStart))

	current_state = GAME_STATE_PLAYING
	Master.SetRunLevel(RUNLEVEL_GAME)

	callHook("roundstart")

	// no, block the main thread.
	GLOB.storyteller.set_up()
	to_chat(world, span_notice("<B>Welcome to [station_name()], enjoy your stay!</B>"))

	SEND_SOUND(world, sound('sound/AI/welcome.ogg', volume = 50)) // Skie

	for(var/mob/new_player/N in SSmobs.mob_list)
		N.new_player_panel_proc()

	CHECK_TICK
	setup_codespeak()
	generate_contracts(min(6 + round(minds.len / 5), 12))
	generate_excel_contracts(min(6 + round(minds.len / 5), 12))
	excel_check()
	addtimer(CALLBACK(src, PROC_REF(contract_tick)), 15 MINUTES)
	//start_events() //handles random events and space dust.
	//new random event system is handled from the MC.

	var/admins_number = 0
	for(var/client/C)
		if(C.holder)
			admins_number++
	if(admins_number == 0)
		send2adminchat("Round has started with no admins online.")

	round_start_time = world.time //otherwise round_start_time would be 0 for the signals

	PostSetup()
	return TRUE

/datum/controller/subsystem/ticker/proc/PostSetup()
	if(SSdbcore.Connect())
		var/list/to_set = list()
		var/arguments = list()
		if(GLOB.storyteller)
			to_set += "game_mode = :game_mode"
			arguments["game_mode"] = GLOB.storyteller.name
		if(GLOB.revdata.originmastercommit)
			to_set += "commit_hash = :commit_hash"
			arguments["commit_hash"] = GLOB.revdata.originmastercommit
		if(to_set.len)
			arguments["round_id"] = GLOB.round_id
			var/datum/db_query/query_round_game_mode = SSdbcore.NewQuery(
				"UPDATE [format_table_name("round")] SET [to_set.Join(", ")] WHERE id = :round_id",
				arguments
			)
			query_round_game_mode.Execute()
			qdel(query_round_game_mode)

//These callbacks will fire after roundstart key transfer
/datum/controller/subsystem/ticker/proc/OnRoundstart(datum/callback/cb)
	if(!HasRoundStarted())
		LAZYADD(round_start_events, cb)
	else
		cb.InvokeAsync()

/datum/controller/subsystem/ticker/proc/GetTimeLeft()
	if(isnull(SSticker.pregame_timeleft))
		return max(0, start_at - world.time)
	return pregame_timeleft

/datum/controller/subsystem/ticker/proc/SetTimeLeft(newtime)
	if(newtime >= 0 && isnull(pregame_timeleft)) //remember, negative means delayed
		start_at = world.time + newtime
	else
		pregame_timeleft = newtime

// Provides an easy way to make cinematics for other events. Just use this as a template :)
/datum/controller/subsystem/ticker/proc/station_explosion_cinematic(ship_missed = 0)
	if(cinematic)
		return	//already a cinematic in progress!

	if(ship_missed)
		world << sound('sound/effects/explosionfar.ogg')
		return	//bomb missed the ship

	//initialise our cinematic screen object
	cinematic = new(src)
	cinematic.icon = 'icons/effects/station_explosion.dmi'
	cinematic.icon_state = "station_intact"
	cinematic.plane = CINEMATIC_PLANE
	cinematic.layer = CINEMATIC_LAYER
	cinematic.mouse_opacity = 0
	cinematic.screen_loc = "1,0"

	for(var/mob/M in SSmobs.mob_list | SShumans.mob_list)
		if(isOnStationLevel(M))
			if(M.client)
				M.client.screen += cinematic
			if(isliving(M))
				var/mob/living/LM = M
				LM.health = 0
				LM.stat = DEAD

	//Now animate the cinematic
	sleep(30)

	flick("intro_nuke", cinematic)

	sleep(30)

	flick("ship_explode_fade_red", cinematic)

	sleep(15)

	world << sound('sound/effects/explosionfar.ogg')

	sleep(5)

	world << sound('sound/effects/explosionfar.ogg')

	sleep(4)

	world << sound('sound/effects/explosionfar.ogg')

	sleep(6)

	world << sound('sound/effects/explosionfar.ogg')
	world << sound('sound/effects/explosionfar.ogg')
	world << sound('sound/effects/explosionfar.ogg')

	sleep(30)

	cinematic.icon_state = "summary_selfdes"
	//If its actually the end of the round, wait for it to end.
	//Otherwise if its a verb it will continue on afterwards.
	sleep(300)

	if(cinematic)
		qdel(cinematic)		//end the cinematic

/datum/controller/subsystem/ticker/proc/get_next_nuke_code_part() // returns code string as "XX56XX"
	var/this_many = 2 // how many digits to return (this proc only tested with this value and 6 digit passwords).

	if(ship_nuke_code == initial(ship_nuke_code) || length(ship_nuke_code) < this_many)
		return initial(ship_nuke_code)

	var/part_of_code = "[copytext(ship_nuke_code, ship_nuke_code_rotation_part, ship_nuke_code_rotation_part + this_many)]"
	var/hidden_digit = "X"

	if(ship_nuke_code_rotation_part > 1)
		. = add_characters(hidden_digit, ship_nuke_code_rotation_part - 1) + part_of_code + add_characters(hidden_digit, length(ship_nuke_code) - ship_nuke_code_rotation_part - 1)
	else
		. = part_of_code + add_characters(hidden_digit, length(ship_nuke_code) - this_many)

	ship_nuke_code_rotation_part += this_many // new head of staff gets next this_many digits
	if(ship_nuke_code_rotation_part > length(ship_nuke_code)) // or we start over if we moved out of range
		ship_nuke_code_rotation_part = 1

/datum/controller/subsystem/ticker/proc/send_quote_of_the_round()
	var/message
	var/list/quotes = file2list("strings/quotes.txt")
	if(quotes.len)
		message = pick(quotes)
	if(!message)
		return
	if(message[1] != "@")
		message = html_encode(message)
	else
		message = copytext(message, 2)
	if(message)
		to_chat(world, custom_boxed_message("purple_box", span_purple("<span class='oocplain'><b>Quote of the round: </b>[message]</span>")))

/datum/controller/subsystem/ticker/proc/create_characters()
	for(var/mob/new_player/player in GLOB.player_list)
		if(player && player.ready && player.mind)
			if(player.mind.assigned_role == "AI")
				player.close_spawn_windows()
				player.AIize()
			else if(!player.mind.assigned_role)
				continue
			else
				GLOB.joined_player_list += player.ckey
				player.create_character()
				qdel(player)


/datum/controller/subsystem/ticker/proc/collect_minds()
	for(var/mob/living/player in GLOB.player_list)
		if(player.mind)
			SSticker.minds |= player.mind

/datum/controller/subsystem/ticker/proc/generate_contracts(count)
	var/list/candidates = (subtypesof(/datum/antag_contract) - typesof(/datum/antag_contract/excel))
	while(count--)
		while(candidates.len)
			var/contract_type = pick(candidates)
			var/datum/antag_contract/C = new contract_type
			if(!C.can_place())
				candidates -= contract_type
				qdel(C)
				continue
			C.place()
			if(C.unique)
				candidates -= contract_type
			break

/datum/controller/subsystem/ticker/proc/generate_excel_contracts(count)
	var/list/candidates = subtypesof(/datum/antag_contract/excel)
	while(count--)
		while(candidates.len)
			var/contract_type = pick(candidates)
			var/datum/antag_contract/C = new contract_type
			if(!C.can_place())
				candidates -= contract_type
				qdel(C)
				continue
			C.place()
			if(C.unique)
				candidates -= contract_type
			break

/datum/controller/subsystem/ticker/proc/excel_check()

	for(var/datum/antag_contract/excel/targeted/overthrow/M in GLOB.excel_antag_contracts)
		if (isnull(M))
			GLOB.excel_antag_contracts -= M
		var/mob/living/carbon/human/H = M.target_mind.current
		if (H.stat == DEAD || is_excelsior(H))
			M.complete()

	for(var/datum/antag_contract/excel/targeted/liberate/M in GLOB.excel_antag_contracts)
		var/mob/living/carbon/human/H = M.target_mind.current
		if (is_excelsior(H))
			M.complete()

	for(var/datum/antag_contract/excel/propaganda/M in GLOB.excel_antag_contracts)
		var/list/area/targets = M.targets
		var/marked_areas = 0
		if(M.completed)
			return
		for (var/obj/item/device/propaganda_chip/C in SSobj.processing) // Doubles as an active check
			if (get_area(C) in targets)
				marked_areas += 1
		if (marked_areas >= 3)
			M.complete()
	addtimer(CALLBACK(src, PROC_REF(excel_check)), 3 MINUTES)

/datum/controller/subsystem/ticker/proc/contract_tick()
	generate_contracts(1)
	generate_excel_contracts(1)
	addtimer(CALLBACK(src, PROC_REF(contract_tick)), 15 MINUTES)


/datum/controller/subsystem/ticker/proc/equip_characters()
	var/captainless = TRUE
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player && player.mind && player.mind.assigned_role)
			if(player.mind.assigned_role == "Captain")
				captainless = FALSE
			if(!player_is_antag(player.mind, only_offstation_roles = 1))
				SSjob.EquipRank(player, player.mind.assigned_role)
	if(captainless)
		for(var/mob/M in GLOB.player_list)
			if(!isnewplayer(M))
				to_chat(M, "Captainship not forced on anyone.")

/datum/controller/subsystem/ticker/proc/move_characters_to_spawnpoints()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		var/datum/spawnpoint/SP = SSjob.get_spawnpoint_for(player.client, player.mind.assigned_role)
		SP.put_mob(player)


/datum/controller/subsystem/ticker/proc/declare_completion()
	to_chat(world, "<br><br><br><H1>A round has ended!</H1>")
	for(var/mob/Player in GLOB.player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(evacuation_controller.round_over() && evacuation_controller.emergency_evacuation)
					if(isNotAdminLevel(playerTurf.z))
						to_chat(Player, "<font color='blue'><b>You managed to survive, but were marooned on [station_name()] as [Player.real_name]...</b></font>")
					else
						to_chat(Player, "<font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></font>")
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, "<font color='green'><b>You successfully underwent crew transfer after events on [station_name()] as [Player.real_name].</b></font>")
				else if(issilicon(Player))
					to_chat(Player, "<font color='green'><b>You remain operational after the events on [station_name()] as [Player.real_name].</b></font>")
				else
					to_chat(Player, "<font color='blue'><b>You missed the crew transfer after the events on [station_name()] as [Player.real_name].</b></font>")
			else
				if(isghost(Player))
					var/mob/observer/ghost/O = Player
					if(!O.started_as_observer)
						to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
				else
					to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
	to_chat(world, "<br>")

	for(var/mob/living/silicon/ai/aiPlayer in SSmobs.mob_list)
		if(aiPlayer.stat != DEAD)
			to_chat(world, "<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws at the end of the round were:</b>")
		else
			to_chat(world, "<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws when it was deactivated were:</b>")
		aiPlayer.show_laws(TRUE)

		if(aiPlayer.connected_robots.len)
			var/robolist = "<b>The AI's loyal minions were:</b> "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated) (Played by: [robo.key]), ":" (Played by: [robo.key]), "]"
			to_chat(world, "[robolist]")



	for(var/mob/living/silicon/robot/robo in SSmobs.mob_list)
		if(!isdrone(robo) && !robo.connected_ai)
			if(robo.stat != 2)
				to_chat(world, "<b>[robo.name] (Played by: [robo.key]) survived as an AI-less synthetic! Its laws were:</b>")
			else
				to_chat(world, "<b>[robo.name] (Played by: [robo.key]) was unable to survive the rigors of being a synthetic without an AI. Its laws were:</b>")

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)
	var/dronecount = GLOB.drones.len
	if(dronecount)
		to_chat(world, "<b>There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.</b>")

	GLOB.storyteller.declare_completion()//To declare normal completion.
	scoreboard()//scores
	//Ask the event manager to print round end information
	SSevent.RoundEnd()
	SSdbcore.SetRoundEnd()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/antagonist/antag in GLOB.current_antags)
		var/temprole = antag.id
		if(temprole && antag.owner)							//if they are an antagonist of some sort.
			if(!(temprole in total_antagonists))	//If the role doesn't exist in list, create it
				total_antagonists.Add(temprole)
			total_antagonists[temprole] += ", [antag.owner.name]([antag.owner.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	sleep(5 SECONDS)
	callHook("roundend")
	ready_for_reboot = TRUE
	standard_reboot()

/datum/controller/subsystem/ticker/proc/HasRoundStarted()
	return current_state >= GAME_STATE_PLAYING

/datum/controller/subsystem/ticker/proc/IsRoundInProgress()
	return current_state == GAME_STATE_PLAYING

/datum/controller/subsystem/ticker/proc/standard_reboot()
	if(ready_for_reboot)
		if(universe_has_ended)
			Reboot("Station destroyed", "nuke")
		else
			Reboot("Round ended.", "proper completion")
	else
		CRASH("Attempted standard reboot without ticker roundend completion")

/datum/controller/subsystem/ticker/proc/Reboot(reason, end_string, delay)
	set waitfor = FALSE
	if(usr && !check_rights(R_SERVER, TRUE))
		return

	if(!delay)
		// TOOD: Move to a config
		delay = 1 MINUTE + 30 SECONDS

	var/skip_delay = check_rights()
	if(delay_end && !skip_delay)
		to_chat(world, span_boldannounce("An admin has delayed the round end."))
		return

	to_chat(world, span_boldannounce("Rebooting World in [DisplayTimeText(delay)]. [reason]"))

	// var/start_wait = world.time
	// UNTIL((world.time - start_wait) > (delay * 2)) //don't wait forever
	reboot_timer = addtimer(CALLBACK(src, PROC_REF(reboot_callback), reason, end_string), delay, TIMER_STOPPABLE)

/datum/controller/subsystem/ticker/proc/reboot_callback(reason, end_string)
	// if(end_string)
	// 	end_state = end_string

	// var/statspage = CONFIG_GET(string/roundstatsurl)
	// var/gamelogloc = CONFIG_GET(string/gamelogurl)
	// if(statspage)
	// 	to_chat(world, span_info("Round statistics and logs can be viewed <a href=\"[statspage][GLOB.round_id]\">at this website!</a>"))
	// else if(gamelogloc)
	// 	to_chat(world, span_info("Round logs can be located <a href=\"[gamelogloc]\">at this website!</a>"))

	log_game(span_boldannounce("Rebooting World. [reason]"))

	world.Reboot()

/**
 * Deletes the current reboot timer and nulls the var
 *
 * Arguments:
 * * user - the user that cancelled the reboot, may be null
 */
/datum/controller/subsystem/ticker/proc/cancel_reboot(mob/user)
	if(!reboot_timer)
		to_chat(user, span_warning("There is no pending reboot!"))
		return FALSE
	to_chat(world, span_boldannounce("An admin has delayed the round end."))
	deltimer(reboot_timer)
	reboot_timer = null
	return TRUE

// expand me pls
/datum/controller/subsystem/ticker/Recover()
	current_state = SSticker.current_state

	minds = SSticker.minds

	delay_end = SSticker.delay_end

	triai = SSticker.triai

	switch (current_state)
		if(GAME_STATE_SETTING_UP)
			Master.SetRunLevel(RUNLEVEL_SETUP)
		if(GAME_STATE_PLAYING)
			Master.SetRunLevel(RUNLEVEL_GAME)
		if(GAME_STATE_FINISHED)
			current_state = SSticker.current_state

	quoted = SSticker.quoted

	pregame_timeleft = SSticker.pregame_timeleft

	totalPlayers = SSticker.totalPlayers
	totalPlayersReady = SSticker.totalPlayersReady
	total_admins_ready = SSticker.total_admins_ready

	round_start_time = SSticker.round_start_time

	if (Master) //Set Masters run level if it exists
		switch (current_state)
			if(GAME_STATE_SETTING_UP)
				Master.SetRunLevel(RUNLEVEL_SETUP)
			if(GAME_STATE_PLAYING)
				Master.SetRunLevel(RUNLEVEL_GAME)
			if(GAME_STATE_FINISHED)
				Master.SetRunLevel(RUNLEVEL_POSTGAME)
