//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the69ew_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	var/datum/browser/panel
	universal_speak = 1

	invisibility = 101

	density = FALSE
	stat = DEAD
	movement_handlers = list()

	anchored = TRUE	//  don't get pushed around
/*
/mob/new_player/New()
	mob_list += src*/

/mob/new_player/say(var/message,69ar/datum/language/speaking =69ull,69ar/verb="says",69ar/alt_name="")
	if (client)
		client.ooc(message)

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'><B>New Player Options</B>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref69src69;show_preferences=1'>Setup Character</A></p>"

	if(SSticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\69 <span class='linkOn'><b>Ready</b></span> | <a href='byond://?src=\ref69src69;ready=0'>Not Ready</a> \69</p>"
		else
			output += "<p>\69 <a href='byond://?src=\ref69src69;ready=1'>Ready</a> | <span class='linkOn'><b>Not Ready</b></span> \69</p>"

	else
		output += "<a href='byond://?src=\ref69src69;manifest=1'>View the Crew69anifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref69src69;late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=\ref69src69;observe=1'>Observe</A></p>"

	if(!IsGuestKey(src.key))
		establish_db_connection()
		if(dbcon.IsConnected())
			var/isadmin = FALSE
			if(src.client && src.client.holder)
				isadmin = TRUE
			// TODO: reimplement database interaction
			var/DBQuery/query = dbcon.NewQuery("SELECT id FROM erro_poll_question WHERE 69(isadmin ? "" : "adminonly = false AND")6969ow() BETWEEN starttime AND endtime AND id69OT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"69ckey69\") AND id69OT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"69ckey69\")")
			query.Execute()
			var/newpoll = FALSE
			while(query.NextRow())
				newpoll = TRUE
				break

			if(newpoll)
				output += "<p><b><a href='byond://?src=\ref69src69;showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=\ref69src69;showpoll=1'>Show Player Polls</A></p>"

	output += "</div>"

	panel =69ew(src, "Welcome","Welcome", 210, 280, src)
	panel.set_window_options("can_close=0")
	panel.set_content(output)
	panel.open()
	return

/mob/new_player/Stat()
	. = ..()

	if(statpanel("Status"))
		if(SSticker.current_state == GAME_STATE_PREGAME)
			stat("Storyteller:", "69master_storyteller69") // Old setting for showing the game69ode
			stat("Time To Start:", "69SSticker.pregame_timeleft6969round_progressing ? "" : " (DELAYED)"69")
			stat("Players: 69totalPlayers69", "Players Ready: 69totalPlayersReady69")
			totalPlayers = 0
			totalPlayersReady = 0
			for(var/mob/new_player/player in GLOB.player_list)
				if(player.ready)
					stat("69player.client.prefs.real_name69", (player.ready)?("69player.client.prefs.job_high69"):(null))
				totalPlayers++
				if(player.ready)totalPlayersReady++

/mob/new_player/Topic(href, href_list6969)
	if(src != usr || !client)
		return 0

	if(href_list69"show_preferences"69)
		client.prefs.ShowChoices(src)
		return 1

	if(href_list69"ready"69)
		if(SSticker.current_state <= GAME_STATE_PREGAME) //69ake sure we don't ready up after the round has started
			ready = text2num(href_list69"ready"69)
		else
			ready = 0

	if(href_list69"refresh"69)
		panel.close()
		new_player_panel_proc()

	if(href_list69"observe"69)

		if(alert(src,"Are you sure you wish to observe? You will have to wait 3069inutes before being able join the crew! But you can play as a69ouse or drone immediately.","Player Setup","Yes","No") == "Yes")
			if(!client)	return 1
			var/mob/observer/ghost/observer =69ew()

			spawning = 1
			sound_to(src, sound(null, repeat = 0, wait = 0,69olume = 85, channel = GLOB.lobby_sound_channel))

			observer.started_as_observer = 1
			close_spawn_windows()
			var/turf/T = pick_spawn_location("Observer")
			if(istype(T))
				to_chat(src, SPAN_NOTICE("You are69ow observing."))
				observer.forceMove(T)
			else
				to_chat(src, "<span class='danger'>Could69ot locate an observer spawn point. Use the Teleport69erb to jump to the station69ap.</span>")
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			announce_ghost_joinleave(src)
			observer.icon = client.prefs.update_preview_icon()
			observer.alpha = 127

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
			if(!client.holder && !config.antag_hud_allowed)           // For69ew ghosts we remove the69erb from even showing up if it's69ot allowed.
				observer.verbs -= /mob/observer/ghost/verb/toggle_antagHUD        // Poor guys, don't know what they are69issing!
			//observer.key = key
			observer.ckey = ckey
			observer.initialise_postkey()

			observer.client.create_UI(observer.type)
			qdel(src)

			return 1

	if(href_list69"late_join"69)

		if(SSticker.current_state != GAME_STATE_PLAYING)
			to_chat(usr, "\red The round is either69ot ready, or has already finished...")
			return

		if(!check_rights(R_ADMIN, 0))
			var/datum/species/S = all_species69client.prefs.species69
			if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species))
				src << alert("You are currently69ot whitelisted to play 69client.prefs.species69.")
				return 0

			if(!(S.spawn_flags & CAN_JOIN))
				src << alert("Your current species, 69client.prefs.species69, is69ot available for play on the station.")
				return 0

		LateChoices()

	if(href_list69"manifest"69)
		show_manifest(src,69ano_state = GLOB.interactive_state)

	if(href_list69"SelectedJob"69)

		if(!config.enter_allowed)
			to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
			return
		else if(SSticker.nuke_in_progress)
			to_chat(usr, "<span class='danger'>The station is currently exploding. Joining would go poorly.</span>")
			return

		var/datum/species/S = all_species69client.prefs.species69
		if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species))
			src << alert("You are currently69ot whitelisted to play 69client.prefs.species69.")
			return 0

		if(!(S.spawn_flags & CAN_JOIN))
			src << alert("Your current species, 69client.prefs.species69, is69ot available for play on the station.")
			return 0

		AttemptLateSpawn(href_list69"SelectedJob"69, client.prefs.spawnpoint)
		return

	if(!ready && href_list69"preference"69)
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list69"late_join"69)
		new_player_panel()

	if(href_list69"showpoll"69)
		handle_player_polling()
		return

	if(href_list69"poll_id"69)
		var/poll_id = href_list69"poll_id"69
		if(istext(poll_id))
			poll_id = text2num(poll_id)
		if(isnum(poll_id))
			src.poll_player(poll_id)
		return

	if(href_list69"vote_on_poll"69 && href_list69"vote_type"69)
		var/poll_id = text2num(href_list69"vote_on_poll"69)
		var/vote_type = href_list69"vote_type"69
		switch(vote_type)
			if("OPTION")
				var/option_id = text2num(href_list69"vote_option_id"69)
				vote_on_poll(poll_id, option_id)
			if("TEXT")
				var/reply_text = href_list69"reply_text"69
				log_text_poll_reply(poll_id, reply_text)


/mob/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = SSjob.GetJob(rank)
	if(!job)	return 0
	if(!job.is_position_available()) return 0
	if(jobban_isbanned(src,rank))	return 0
	return 1

/mob/new_player/proc/AttemptLateSpawn(rank,69ar/spawning_at)
	if(src != usr)
		return 0
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, "\red The round is either69ot ready, or has already finished...")
		return 0
	if(!config.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return 0
	if(!IsJobAvailable(rank))
		src << alert("69rank69 is69ot available. Please try another.")
		return 0

	spawning = 1
	close_spawn_windows()

	SSjob.AssignRole(src, rank, 1)
	var/datum/job/job = src.mind.assigned_job
	var/mob/living/character = create_character()	//creates the human and transfers69ars and69ind

	// AIs don't69eed a spawnpoint, they69ust spawn at an empty core
	if(rank == "AI")

		character = character.AIize(move=0) // AIize the character, but don't69ove them yet
		SSticker.minds += character.mind
			// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores69169
		empty_playable_ai_cores -= C

		character.forceMove(C.loc)

		AnnounceArrival(character, rank, "has been downloaded to the empty core in \the 69character.loc.loc69")

		qdel(C)
		qdel(src)
		return


	var/datum/spawnpoint/spawnpoint = SSjob.get_spawnpoint_for(character.client, rank, late = TRUE)
	spawnpoint.put_mob(character) // This can fail, and it'll result in the players being left in space and69ot being teleported to the station. But atleast they'll be equipped.69eeds to be fixed so a default case for extreme situations is added.
	character = SSjob.EquipRank(character, rank) //equips the human
	equip_custom_items(character)
	character.lastarea = get_area(loc)

	if(SSjob.ShouldCreateRecords(job.title))
		if(character.mind.assigned_role != "Robot")
			CreateModularRecord(character)
			data_core.manifest_inject(character)
			matchmaker.do_matchmaking()
			SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

			//Grab some data from the character prefs for use in random69ews procs.

	AnnounceArrival(character, character.mind.assigned_role, spawnpoint.message)	//will69ot broadcast if there is69o69essage



	qdel(src)

/mob/new_player/proc/LateChoices()
	var/name = client.prefs.be_random_name ? "friend" : client.prefs.real_name

	var/dat = "<html><body><center>"
	dat += "<b>Welcome, 69name69.<br></b>"
	dat += "Round Duration: 69roundduration2text()69<br>"

	if(evacuation_controller.has_evacuated()) //In case69anotrasen decides reposess CentCom's shuttles.
		dat += "<font color='red'><b>The69essel has been evacuated.</b></font><br>"
	else if(evacuation_controller.is_evacuating())
		if(evacuation_controller.emergency_evacuation) // Emergency shuttle is past the point of69o recall
			dat += "<font color='red'>The69essel is currently undergoing evacuation procedures.</font><br>"
		else                                           // Crew transfer initiated
			dat += "<font color='red'>The69essel is currently undergoing crew transfer procedures.</font><br>"

	dat += "Choose from the following open/valid positions:<br>"
	for(var/datum/job/job in SSjob.occupations)
		if(job && IsJobAvailable(job.title))
			if(job.is_restricted(client.prefs))
				continue
			var/active = 0
			// Only players with the job assigned and AFK for less than 1069inutes count as active
			for(var/mob/M in GLOB.player_list) if(M.mind &&69.client &&69.mind.assigned_role == job.title &&69.client.inactivity <= 10 * 60 * 10)
				active++
			dat += "<a href='byond://?src=\ref69src69;SelectedJob=69job.title69'>69job.title69 (69job.current_positions69) (Active: 69active69)</a><br>"

	dat += "</center>"
	src << browse(dat, "window=latechoices;size=400x640;can_close=1")


/mob/new_player/proc/create_character()
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species69client.prefs.species69
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	if(chosen_species && use_species_name)
		// Have to recheck admin due to69o usr at roundstart. Latejoins are fine though.
		if(is_species_whitelisted(chosen_species) || has_admin_rights())
			new_character =69ew(loc, use_species_name)

	if(!new_character)
		new_character =69ew(loc)

	new_character.lastarea = get_area(loc)

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = all_languages69lang69
		if(chosen_language)
			if(!(chosen_language.flags & WHITELISTED) || is_alien_whitelisted(src, lang) || has_admin_rights() \
				|| (new_character.species && (chosen_language.name in69ew_character.species.secondary_langs)))
				new_character.add_language(lang)

	if(mind)
		mind.active = 0//we wish to transfer the key69anually
		mind.original =69ew_character
		if(client.prefs.relations.len)
			for(var/T in client.prefs.relations)
				var/TT =69atchmaker.relation_types69T69
				var/datum/relation/R =69ew TT
				R.holder =69ind
				R.info = client.prefs.relations_info69T69
			mind.gen_relations_info = client.prefs.relations_info69"general"69
		mind.transfer_to(new_character)					//won't transfer key since the69ind is69ot active

	if(SSticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_first_name = random_first_name(new_character.gender)
		client.prefs.real_last_name = random_last_name(new_character.gender)
		client.prefs.real_name = client.prefs.real_first_name + " " + client.prefs.real_last_name
		client.prefs.randomize_appearance_and_body_for(new_character)
	else
		client.prefs.copy_to(new_character)

	sound_to(src, sound(null, repeat = 0, wait = 0,69olume = 85, channel = GLOB.lobby_sound_channel))

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		// Set defer to 1 if you add69ore crap here so it only recalculates struc_enzymes once. -693X
		new_character.dna.SetSEState(GLASSESBLOCK,1,0)
		new_character.disabilities |=69EARSIGHTED

	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()
	new_character.key = key//Manually transfer the key to log them in

	return69ew_character

/mob/new_player/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)
	return 0

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	panel.close()

/mob/new_player/proc/is_species_whitelisted(datum/species/S)
	if(!S) return 1
	return is_alien_whitelisted(src, S.name) || !(S.spawn_flags & IS_WHITELISTED)

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species69client.prefs.species69

	if(!chosen_species)
		return SPECIES_HUMAN

	if(is_species_whitelisted(chosen_species) || has_admin_rights())
		return chosen_species.name

	return SPECIES_HUMAN

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message,69ar/verb = "says",69ar/datum/language/language =69ull,69ar/alt_name = "",var/italics = 0,69ar/mob/speaker =69ull)
	return

/mob/new_player/hear_radio(var/message,69ar/verb="says",69ar/datum/language/language=null,69ar/part_a,69ar/part_b,69ar/mob/speaker =69ull,69ar/hard_to_hear = 0)
	return

mob/new_player/MayRespawn()
	return 1
