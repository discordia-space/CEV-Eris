//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
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

/mob/new_player/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="")
	if (client)
		client.ooc(message)

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'><B>New Player Options</B>"
	output +="<hr>"
	output += "<p><a href='byond://?src=[REF(src)];show_preferences=1'>Setup Character</A></p>"

	if(SSticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ [span_linkOn("<b>Ready</b>")] | <a href='byond://?src=[REF(src)];ready=0'>Not Ready</a> \]</p>"
		else
			output += "<p>\[ <a href='byond://?src=[REF(src)];ready=1'>Ready</a> | [span_linkOn("<b>Not Ready</b>")] \]</p>"

	else
		output += "<a href='byond://?src=[REF(src)];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=[REF(src)];late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=[REF(src)];observe=1'>Observe</A></p>"

	if (src.client.holder)
		output += "<hr>"
		output += "<div align='center'>[span_bold("Admin Quick Verbs")]"
		if (SSticker.state <= GAME_STATE_PREGAME)
			output += "<p>\[<a href='byond://?src=[REF(src)];[HrefToken()];startnow=1'>Start Now</a>\]</p>"
		else
			output += "<p>\[<a href='byond://?src=[REF(src)];[HrefToken()];endround=1'>End Round</a>\]</p>"
		output += "<p>\[<a href='byond://?src=[REF(src)];[HrefToken()];restart=1'>Restart</a>\]</p>"
		output += "<p>\[<a href='byond://?src=[REF(src)];[HrefToken()];runtimes=1'>View Runtimes</a>\]</p>"

	if(!IsGuestKey(src.key))
		establish_db_connection()
		if(dbcon.IsConnected())
			var/isadmin = FALSE
			if(src.client && src.client.holder)
				isadmin = TRUE
			// TODO: reimplement database interaction
			var/DBQuery/query = dbcon.NewQuery("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
			query.Execute()
			var/newpoll = FALSE
			while(query.NextRow())
				newpoll = TRUE
				break

			if(newpoll)
				output += "<p><b><a href='byond://?src=[REF(src)];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=[REF(src)];showpoll=1'>Show Player Polls</A></p>"

	output += "</div>"

	if (src.client.holder)
		panel = new(src, "Welcome","Welcome", 230, 330, src)
	else
		panel = new(src, "Welcome","Welcome", 210, 280, src)

	panel.set_window_options("can_close=0")
	panel.set_content(output)
	panel.open()

/mob/new_player/get_status_tab_items()
	. = ..()
	// Leaving here for future use.

/mob/new_player/Topic(href, href_list[])
	if(src != usr || !client)
		return FALSE

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return TRUE

	if(href_list["ready"])
		if(SSticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
			if(ready)
				// Warn the player if they are trying to spawn without a brain
				var/datum/body_modification/mod = client.prefs.get_modification(BP_BRAIN)
				if(istype(mod, /datum/body_modification/limb/amputation))
					if(alert(src,"Are you sure you wish to spawn without a brain? This will likely cause you to do die immediately. \
								If not, go to the Augmentation section of Setup Character and change the \"brain\" slot from Removed to the desired kind of brain.", \
								"Player Setup", "Yes", "No") == "No")
						ready = 0
						return

				// Warn the player if they are trying to spawn without eyes
				mod = client.prefs.get_modification(BP_EYES)
				if(istype(mod, /datum/body_modification/limb/amputation))
					if(alert(src,"Are you sure you wish to spawn without eyes? It will likely be difficult to see without them. \
								If not, go to the Augmentation section of Setup Character and change the \"eyes\" slot from Removed to the desired kind of eyes.", \
								"Player Setup", "Yes", "No") == "No")
						ready = 0
						return
		else
			ready = 0

	if(href_list["refresh"])
		panel.close()
		new_player_panel_proc()

	if(href_list["observe"])

		if(alert(src,"Are you sure you wish to observe? You will have to wait 30 minutes before being able join the crew! But you can play as a mouse or drone immediately.","Player Setup","Yes","No") == "Yes")
			if(!client)	return TRUE
			var/mob/observer/ghost/observer = new()

			spawning = 1
			sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

			observer.started_as_observer = 1
			close_spawn_windows()
			var/turf/T = pick_spawn_location("Observer")
			if(istype(T))
				to_chat(src, span_notice("You are now observing."))
				observer.forceMove(T)
			else
				to_chat(src, span_danger("Could not locate an observer spawn point. Use the Teleport verb to jump to the station map."))
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			announce_ghost_joinleave(src)
			observer.icon = client.prefs.update_preview_icon()
			observer.alpha = 127

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
			if(!client.holder && !CONFIG_GET(flag/antag_hud_allowed)) // For new ghosts we remove the verb from even showing up if it's not allowed.
				remove_verb(observer, /mob/observer/ghost/verb/toggle_antagHUD)
			//observer.key = key
			observer.ckey = ckey
			observer.client.init_verbs()
			observer.initialise_postkey()

			observer.client.create_UI(observer.type)
			qdel(src)

			return 1

	if(href_list["late_join"])

		if(SSticker.current_state != GAME_STATE_PLAYING)
			to_chat(usr, span_red("The round is either not ready, or has already finished..."))
			return

		// Warn the player if they are trying to spawn without a brain
		var/datum/body_modification/mod = client.prefs.get_modification(BP_BRAIN)
		if(istype(mod, /datum/body_modification/limb/amputation))
			if(alert(src,"Are you sure you wish to spawn without a brain? This will likely cause you to do die immediately. \
			              If not, go to the Augmentation section of Setup Character and change the \"brain\" slot from Removed to the desired kind of brain.", \
						  "Player Setup", "Yes", "No") == "No")
				return FALSE

		// Warn the player if they are trying to spawn without eyes
		mod = client.prefs.get_modification(BP_EYES)
		if(istype(mod, /datum/body_modification/limb/amputation))
			if(alert(src,"Are you sure you wish to spawn without eyes? It will likely be difficult to see without them. \
			              If not, go to the Augmentation section of Setup Character and change the \"eyes\" slot from Removed to the desired kind of eyes.", \
						  "Player Setup", "Yes", "No") == "No")
				return FALSE

		if(!check_rights(R_ADMIN, 0))
			var/datum/species/S = GLOB.all_species[client.prefs.species]
			if(!(S.spawn_flags & CAN_JOIN))
				src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
				return FALSE

		LateChoices()

	if(href_list["manifest"])
		show_manifest(src, nano_state = GLOB.interactive_state)

	if(href_list["SelectedJob"])

		if(!CONFIG_GET(flag/enter_allowed))
			to_chat(usr, span_notice("There is an administrative lock on entering the game!"))
			return
		else if(SSticker.nuke_in_progress)
			to_chat(usr, span_danger("The station is currently exploding. Joining would go poorly."))
			return

		var/datum/species/S = GLOB.all_species[client.prefs.species]

		if(!(S.spawn_flags & CAN_JOIN))
			src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
			return FALSE

		AttemptLateSpawn(href_list["SelectedJob"], client.prefs.spawnpoint)
		return

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

	if(href_list["showpoll"])
		handle_player_polling()
		return

	if(href_list["poll_id"])
		var/poll_id = href_list["poll_id"]
		if(istext(poll_id))
			poll_id = text2num(poll_id)
		if(isnum(poll_id))
			src.poll_player(poll_id)
		return

	if(href_list["vote_on_poll"] && href_list["vote_type"])
		var/poll_id = text2num(href_list["vote_on_poll"])
		var/vote_type = href_list["vote_type"]
		switch(vote_type)
			if("OPTION")
				var/option_id = text2num(href_list["vote_option_id"])
				vote_on_poll(poll_id, option_id)
			if("TEXT")
				var/reply_text = href_list["reply_text"]
				log_text_poll_reply(poll_id, reply_text)
		return

	if (!src.client.holder)
		return

	if (href_list["startnow"])
		src.client.holder.startnow()
		return

	if (href_list["endround"])
		src.client.holder.end_round()
		return

	if (href_list["restart"])
		src.client.holder.restart()
		return

	if (href_list["runtimes"])
		src.client.view_runtimes()
		return


/mob/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = SSjob.GetJob(rank)
	if(!job)
		return FALSE
	if(!job.is_position_available())
		return FALSE
	if(IsGuestKey(ckey) && SSjob.job_to_playtime_requirement[job.title])
		return FALSE
	if(!SSjob.ckey_to_job_to_can_play[client.ckey][job.title])
		return FALSE
	if(jobban_isbanned(src,rank))
		return FALSE
	return TRUE

/mob/new_player/proc/AttemptLateSpawn(rank, var/spawning_at)
	if(src != usr)
		return FALSE
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, span_red("The round is either not ready, or has already finished..."))
		return FALSE
	if(!CONFIG_GET(flag/enter_allowed))
		to_chat(usr, span_notice("There is an administrative lock on entering the game!"))
		return FALSE
	if(!IsJobAvailable(rank))
		src << alert("[rank] is not available. Please try another.")
		return FALSE

	spawning = 1
	close_spawn_windows()

	SSjob.AssignRole(src, rank, 1)
	var/datum/job/job = src.mind.assigned_job
	var/mob/living/character = create_character()	//creates the human and transfers vars and mind


	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(rank == "AI")

		character = character.AIize(move=0) // AIize the character, but don't move them yet
		SSticker.minds += character.mind
			// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores[1]
		empty_playable_ai_cores -= C

		character.forceMove(C.loc)

		AnnounceArrival(character, rank, "has been downloaded to the empty core in \the [character.loc.loc]")
		log_manifest(character.mind.key, character.mind, character, latejoin = TRUE)

		qdel(C)
		qdel(src)
		return


	var/datum/spawnpoint/spawnpoint = SSjob.get_spawnpoint_for(character.client, rank, late = TRUE)
	spawnpoint.put_mob(character) // This can fail, and it'll result in the players being left in space and not being teleported to the station. But atleast they'll be equipped. Needs to be fixed so a default case for extreme situations is added.
	character = SSjob.EquipRank(character, rank) //equips the human
	character.lastarea = get_area(loc)

	if(SSjob.ShouldCreateRecords(job.title))
		if(character.mind.assigned_role != "Robot")
			CreateModularRecord(character)
			data_core.manifest_inject(character)
			matchmaker.do_matchmaking()
			SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

			//Grab some data from the character prefs for use in random news procs.

	AnnounceArrival(character, character.mind.assigned_role, spawnpoint.message)	//will not broadcast if there is no message
	log_manifest(character.mind.key, character.mind, character, latejoin = TRUE)

	qdel(src)

/mob/new_player/proc/LateChoices()
	var/name = client.prefs.be_random_name ? "friend" : client.prefs.real_name

	var/dat = ""
	dat += "<b>Welcome, [name].<br></b>"
	dat += "Round Duration: [gameTimestamp()]<br>"

	if(evacuation_controller.has_evacuated()) //In case Nanotrasen decides reposess CentCom's shuttles.
		dat += "<font color='red'><b>The vessel has been evacuated.</b></font><br>"
	else if(evacuation_controller.is_evacuating())
		if(evacuation_controller.emergency_evacuation) // Emergency shuttle is past the point of no recall
			dat += "<font color='red'>The vessel is currently undergoing evacuation procedures.</font><br>"
		else                                           // Crew transfer initiated
			dat += "<font color='red'>The vessel is currently undergoing crew transfer procedures.</font><br>"

	dat += "Choose from the following open/valid positions:<br>"
	SSjob.UpdatePlayableJobs(client.ckey)
	for(var/datum/job/job in SSjob.occupations)
		if(job && IsJobAvailable(job.title))
			if(job.is_restricted(client.prefs))
				continue
			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in GLOB.player_list) if(M.mind && M.client && M.mind.assigned_role == job.title && M.client.inactivity <= 10 * 60 * 10)
				active++
			dat += "<a href='byond://?src=[REF(src)];SelectedJob=[job.title]'>[job.title] ([job.current_positions]) (Active: [active])</a><br>"

	dat += "</center>"
	src << browse(HTML_SKELETON_TITLE("Late join", dat), "window=latechoices;size=400x640;can_close=1")


/mob/new_player/proc/create_character()
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = GLOB.all_species[client.prefs.species]
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	if(chosen_species && use_species_name)
		new_character = new(NULLSPACE, use_species_name)

	if(!new_character)
		new_character = new(NULLSPACE)

	new_character.lastarea = get_area(NULLSPACE)

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = GLOB.all_languages[lang]
		if(chosen_language)
			if(!(chosen_language.flags & WHITELISTED) || has_admin_rights() \
				|| (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)

	if(mind)
		mind.active = 0//we wish to transfer the key manually
		mind.original = new_character
		if(client.prefs.relations.len)
			for(var/T in client.prefs.relations)
				var/TT = matchmaker.relation_types[T]
				var/datum/relation/R = new TT
				R.holder = mind
				R.info = client.prefs.relations_info[T]
			mind.gen_relations_info = client.prefs.relations_info["general"]
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	if(SSticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_first_name = random_first_name(new_character.gender)
		client.prefs.real_last_name = random_last_name(new_character.gender)
		client.prefs.real_name = client.prefs.real_first_name + " " + client.prefs.real_last_name
		client.prefs.randomize_appearance_and_body_for(new_character)
	else
		client.prefs.copy_to(new_character)

	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

	new_character.name = real_name
	new_character.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		if(client.prefs.disabilities & NEARSIGHTED)
			new_character.add_mutation(MUTATION_NEARSIGHTED)

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()
	new_character.key = key//Manually transfer the key to log them in
	new_character.client.init_verbs()

	return new_character

/mob/new_player/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	return FALSE

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	panel.close()

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = GLOB.all_species[client.prefs.species]

	if(!chosen_species)
		return SPECIES_HUMAN

	return chosen_species.name

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0)
	return

/mob/new_player/MayRespawn()
	return 1
