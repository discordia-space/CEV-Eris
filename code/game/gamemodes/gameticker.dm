var/global/datum/controller/gameticker/ticker

/datum/controller/gameticker
	var/const/restart_timeout = 600
	var/current_state = GAME_STATE_PREGAME

	//setup vars
	var/first_start_trying = TRUE
	var/story_vote_ended = FALSE

	var/datum/storyteller/storyteller = null
	var/event_time = null
	var/event = 0

	var/login_music			// music played in pregame lobby

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/random_players = 0 	// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/list/syndicate_coalition = list() // list of traitor-compatible factions
	var/list/factions = list()			  // list of all factions
	var/list/availablefactions = list()	  // list of factions with openings

	var/pregame_timeleft = 180

	var/delay_end = 0	//if set to nonzero, the round will not restart on it's own

	var/triai = 0//Global holder for Triumvirate

	var/quoted = FALSE

	var/round_end_announced = 0 // Spam Prevention. Announce round end only once.

	var/ship_was_nuked = 0              // See nuclearbomb.dm and malfunction.dm.
	var/ship_nuke_code = "NO CODE"       // Heads will get parts of this code.
	var/ship_nuke_code_rotation_part = 1 // What part of code next Head will get.
	var/nuke_in_progress = 0           	// Sit back and relax

	var/newscaster_announcements = null

/datum/controller/gameticker/proc/pregame()
	login_music = pick(list(
		'sound/music/tonspender_irritations.ogg',
		'sound/music/i_am_waiting_for_you_last_summer_neon_fever.ogg',
		'sound/music/paradise_cracked_skytown.ogg',
		'sound/music/nervous_testpilot _my_beautiful_escape.ogg',
		'sound/music/deus_ex_unatco_nervous_testpilot_remix.ogg',
		'sound/music/paradise_cracked_title03.ogg'))
	do
		if(first_start_trying)
			pregame_timeleft = 180
			world << "<B><FONT color='blue'>Welcome to the pre-game lobby!</FONT></B>"
		else
			pregame_timeleft = 40

		world << "Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds"


		while(current_state == GAME_STATE_PREGAME)
			sleep(10)

			if(!quoted)
				send_quote_of_the_round()
				quoted = TRUE

			vote.Process()

			if(round_progressing)
				pregame_timeleft--

			if(!story_vote_ended && (pregame_timeleft == config.vote_autogamemode_timeleft || !first_start_trying))
				if(!vote.active_vote)
					vote.autostoryteller()	//Quit calling this over and over and over and over.

			if(pregame_timeleft <= 0 || ((initialization_stage & INITIALIZATION_NOW_AND_COMPLETE) == INITIALIZATION_NOW_AND_COMPLETE))
				current_state = GAME_STATE_SETTING_UP
				Master.SetRunLevel(RUNLEVEL_SETUP)

			first_start_trying = FALSE
	while (!setup())


/datum/controller/gameticker/proc/setup()
	//Create and announce mode

	src.storyteller = config.pick_storyteller(master_storyteller)

	if(!src.storyteller)
		current_state = GAME_STATE_PREGAME
		Master.SetRunLevel(RUNLEVEL_LOBBY)
		world << "<span class='danger'>Serious error storyteller system!</span> Reverting to pre-game lobby."
		return 0

	job_master.ResetOccupations()
	job_master.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	if(!src.storyteller.can_start(TRUE))
		world << "<B>Unable to start game.</B> Reverting to pre-game lobby."
		current_state = GAME_STATE_PREGAME
		Master.SetRunLevel(RUNLEVEL_LOBBY)
		storyteller = null
		story_vote_ended = FALSE
		job_master.ResetOccupations()
		return 0

	src.storyteller.announce()

	setup_economy()
	newscaster_announcements = pick(newscaster_standard_feeds)
	current_state = GAME_STATE_PLAYING
	Master.SetRunLevel(RUNLEVEL_GAME)
	create_characters() //Create player characters and transfer them
	collect_minds()
	equip_characters()
	data_core.manifest()

	callHook("roundstart")

	shuttle_controller.initialize_shuttles()

	spawn(0)//Forking here so we dont have to wait for this to finish
		storyteller.set_up()
		world << "<FONT color='blue'><B>Enjoy the game!</B></FONT>"
		world << sound('sound/AI/welcome.ogg') // Skie
		//Holiday Round-start stuff	~Carn
		Holiday_Game_Start()

		for(var/mob/new_player/N in SSmobs.mob_list)
			N.new_player_panel_proc()
	//start_events() //handles random events and space dust.
	//new random event system is handled from the MC.

	var/admins_number = 0
	for(var/client/C)
		if(C.holder)
			admins_number++
	if(admins_number == 0)
		send2adminirc("Round has started with no admins online.")

/*	supply_controller.Process() 		//Start the supply shuttle regenerating points -- TLE // handled in scheduler
	master_controller.Process()		//Start master_controller.Process()
	lighting_controller.Process()	//Start processing DynamicAreaLighting updates
	*/

	processScheduler.start()

	if(config.sql_enabled)
		statistic_cycle() // Polls population totals regularly and stores them in an SQL DB -- TLE

	return 1

/datum/controller/gameticker
	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
/datum/controller/gameticker/proc/station_explosion_cinematic(var/ship_missed = 0)
	if(cinematic)
		return	//already a cinematic in progress!

	if(ship_missed)
		world << sound('sound/effects/explosionfar.ogg')
		return	//bomb missed the ship

	//initialise our cinematic screen object
	cinematic = new(src)
	cinematic.icon = 'icons/effects/station_explosion.dmi'
	cinematic.icon_state = "station_intact"
	cinematic.layer = 30
	cinematic.mouse_opacity = 0
	cinematic.screen_loc = "1,0"

	for(var/mob/M in SSmobs.mob_list)
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


/datum/controller/gameticker/proc/get_next_nuke_code_part() // returns code string as "XX56XX"
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

/datum/controller/gameticker/proc/send_quote_of_the_round()
	var/message
	var/list/quotes = file2list("strings/quotes.txt")
	if(quotes.len)
		message = pick(quotes)
	if(message)
		world << SPAN_NOTICE("<font color='purple'><b>Quote of the round: </b>[html_encode(message)]</font>")

/datum/controller/gameticker/proc/create_characters()
	for(var/mob/new_player/player in player_list)
		if(player && player.ready && player.mind)
			if(player.mind.assigned_role == "AI")
				player.close_spawn_windows()
				player.AIize()
			else if(!player.mind.assigned_role)
				continue
			else
				player.create_character()
				qdel(player)


/datum/controller/gameticker/proc/collect_minds()
	for(var/mob/living/player in player_list)
		if(player.mind)
			ticker.minds.Add(player.mind)


/datum/controller/gameticker/proc/equip_characters()
	var/captainless = TRUE
	for(var/mob/living/carbon/human/player in player_list)
		if(player && player.mind && player.mind.assigned_role)
			if(player.mind.assigned_role == "Captain")
				captainless = FALSE
			if(!player_is_antag(player.mind, only_offstation_roles = 1))
				job_master.EquipRank(player, player.mind.assigned_role, 0)
				equip_custom_items(player)
	if(captainless)
		for(var/mob/M in player_list)
			if(!isnewplayer(M))
				M << "Captainship not forced on anyone."


/datum/controller/gameticker/Process()
	if(current_state != GAME_STATE_PLAYING)
		return

	storyteller.Process()
	storyteller.process_events()

	var/game_finished = (evacuation_controller.round_over() || ship_was_nuked  || universe_has_ended)

	if(!nuke_in_progress && game_finished)
		current_state = GAME_STATE_FINISHED
		Master.SetRunLevel(RUNLEVEL_POSTGAME)

		spawn
			declare_completion()

		spawn(50)
			callHook("roundend")

			if(universe_has_ended)
				if(!delay_end)
					world << SPAN_NOTICE("<b>Rebooting due to destruction of station in [restart_timeout/10] seconds</b>")
			else
				if(!delay_end)
					world << SPAN_NOTICE("<b>Restarting in [restart_timeout/10] seconds</b>")


			if(!delay_end)
				sleep(restart_timeout)
				if(!delay_end)
					world.Reboot()
				else
					world << SPAN_NOTICE("<b>An admin has delayed the round end</b>")
			else
				world << SPAN_NOTICE("<b>An admin has delayed the round end</b>")


/datum/controller/gameticker/proc/declare_completion()
	world << "<br><br><br><H1>A round has ended!</H1>"
	for(var/mob/Player in player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(evacuation_controller.round_over() && evacuation_controller.emergency_evacuation)
					if(isNotAdminLevel(playerTurf.z))
						Player << "<font color='blue'><b>You managed to survive, but were marooned on [station_name()] as [Player.real_name]...</b></font>"
					else
						Player << "<font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></font>"
				else if(isAdminLevel(playerTurf.z))
					Player << "<font color='green'><b>You successfully underwent crew transfer after events on [station_name()] as [Player.real_name].</b></font>"
				else if(issilicon(Player))
					Player << "<font color='green'><b>You remain operational after the events on [station_name()] as [Player.real_name].</b></font>"
				else
					Player << "<font color='blue'><b>You missed the crew transfer after the events on [station_name()] as [Player.real_name].</b></font>"
			else
				if(isghost(Player))
					var/mob/observer/ghost/O = Player
					if(!O.started_as_observer)
						Player << "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>"
				else
					Player << "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>"
	world << "<br>"

	for(var/mob/living/silicon/ai/aiPlayer in SSmobs.mob_list)
		if(aiPlayer.stat != DEAD)
			world << "<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws at the end of the round were:</b>"
		else
			world << "<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws when it was deactivated were:</b>"
		aiPlayer.show_laws(TRUE)

		if(aiPlayer.connected_robots.len)
			var/robolist = "<b>The AI's loyal minions were:</b> "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated) (Played by: [robo.key]), ":" (Played by: [robo.key]), "]"
			world << "[robolist]"

	var/dronecount = 0

	for(var/mob/living/silicon/robot/robo in SSmobs.mob_list)

		if(isdrone(robo))
			dronecount++
			continue

		if(!robo.connected_ai)
			if(robo.stat != 2)
				world << "<b>[robo.name] (Played by: [robo.key]) survived as an AI-less synthetic! Its laws were:</b>"
			else
				world << "<b>[robo.name] (Played by: [robo.key]) was unable to survive the rigors of being a synthetic without an AI. Its laws were:</b>"

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)

	if(dronecount)
		world << "<b>There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.</b>"

	storyteller.declare_completion()//To declare normal completion.

	//Ask the event manager to print round end information
	event_manager.RoundEnd()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/antagonist/antag in current_antags)
		var/temprole = antag.id
		if(temprole && antag.owner)							//if they are an antagonist of some sort.
			if(!(temprole in total_antagonists))	//If the role doesn't exist in list, create it
				total_antagonists.Add(temprole)
			total_antagonists[temprole] += ", [antag.owner.name]([antag.owner.key])"


	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")
