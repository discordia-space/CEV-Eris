#define LINKIFY_READY(string, value) "<a href='byond://?src=[REF(src)];ready=[value]'>[string]</a>"

/mob/new_player
	var/ready = 0
	var/spawning = 0 //Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	universal_speak = 1

	invisibility = 101

	density = FALSE
	stat = DEAD
	movement_handlers = list()

	anchored = TRUE	//  don't get pushed around

	var/mob/living/new_character //for instant transfer once the round is set up

/mob/new_player/Initialize()
	// if(client && SSticker.state == GAME_STATE_STARTUP)
	// 	var/obj/screen/splash/S = new(client, TRUE, TRUE)
	// 	S.Fade(TRUE)

	// if(length(GLOB.newplayer_start))
	// 	forceMove(pick(GLOB.newplayer_start))
	// else
	// 	forceMove(locate(1,1,1))

	ComponentInitialize()

	. = ..()

	GLOB.new_player_list += src

/mob/new_player/Destroy()
	GLOB.new_player_list -= src

	return ..()

/mob/new_player/say(message, datum/language/speaking = null, verb="says", alt_name="")
	if (client)
		client.ooc(message)

/**
 * This proc generates the panel that opens to all newly joining players, allowing them to join, observe, view polls, view the current crew manifest, and open the character customization menu.
 */
/mob/new_player/verb/new_player_panel()
	set src = usr
	return new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc()
	var/datum/asset/asset_datum = get_asset_datum(/datum/asset/simple/lobby)
	asset_datum.send(client)
	var/list/output = list("<center><p><a href='byond://?src=[REF(src)];show_preferences=1'>Setup Character</a></p>")

	if(SSticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ <span class='linkOn'><b>Ready</b></span> | <a href='byond://?src=[REF(src)];ready=0'>Not Ready</a> \]</p>"
		else
			output += "<p>\[ <a href='byond://?src=[REF(src)];ready=1'>Ready</a> | <span class='linkOn'><b>Not Ready</b></span> \]</p>"

	else
		output += "<p><a href='byond://?src=[REF(src)];manifest=1'>View the Crew Manifest</a></p>"
		output += "<p><a href='byond://?src=[REF(src)];late_join=1'>Join Game!</a></p>"

	output += "<p><a href='byond://?src=[REF(src)];observe=1'>Observe</A></p>"

	if(!IsGuestKey(src.key))
		// options += playerpolls
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
				output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"


	output += "</center>"

	var/datum/browser/popup = new(src, "playersetup", "<div align='center'>New Player Options</div>", 250, 265)
	popup.set_window_options("can_close=0")
	popup.set_content(output.Join())
	popup.open(FALSE)
	return

/mob/new_player/Stat()
	. = ..()

	if(statpanel("Status"))
		if(SSticker.current_state == GAME_STATE_PREGAME)
			stat("Storyteller:", "[master_storyteller]") // Old setting for showing the game mode
			stat("Time To Start:", "[SSticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]")
			stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
			totalPlayers = 0
			totalPlayersReady = 0
			for(var/mob/new_player/player in GLOB.player_list)
				if(player.ready)
					stat("[player.client.prefs.real_name]", (player.ready)?("[player.client.prefs.job_high]"):(null))
				totalPlayers++
				if(player.ready)totalPlayersReady++

/mob/new_player/Topic(href, href_list[])
	if(src != usr || !client)
		return 0

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return TRUE

	if(href_list["ready"])
		//Avoid updating ready if we're after PREGAME (they should use latejoin instead)
		//This is likely not an actual issue but I don't have time to prove that this
		//no longer is required
		if(SSticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
		else
			ready = 0

	if(href_list["refresh"])
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel()

	if(href_list["observe"])
		if(QDELETED(src) || !src.client)
			ready = 0
			return FALSE

		var/this_is_like_playing_right = alert(src,"Are you sure you wish to observe? You will have to wait 30 minutes before being able join the crew! But you can play as a mouse or drone immediately.","Player Setup","Yes","No")

		if(QDELETED(src) || !src.client || this_is_like_playing_right != "Yes")
			ready = 0
			src << browse(null, "window=playersetup") //closes the player setup window
			new_player_panel()
			return FALSE

		var/mob/observer/ghost/observer = new()
		spawning = TRUE

		observer.started_as_observer = TRUE
		close_spawn_windows()
		var/turf/T = pick_spawn_location("Observer")
		to_chat(src, "<span class='notice'>Now teleporting.</span>")
		if (T)
			observer.forceMove(T.loc)
		else
			to_chat(src, "<span class='notice'>Teleporting failed. Ahelp an admin please</span>")
			stack_trace("There's no freaking observer landmark available on this map or you're making observers before the map is initialised")

		// death time handler
		observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.
		// end
		observer.key = key
		observer.client = client
		// observer.set_ghost_appearance()
		observer.icon = observer.client.prefs.update_preview_icon()
		if(observer?.client?.prefs)
			observer.real_name = observer.client.prefs.real_name
			if(observer.client.prefs.be_random_name)
				observer.client.prefs.real_name = random_name(observer.client.prefs.gender)
			observer.name = observer.real_name
			if(!observer.client.holder && !config.antag_hud_allowed) // For new ghosts we remove the verb from even showing up if it's not allowed.
				observer.remove_statverb(/mob/observer/ghost/verb/toggle_antagHUD) // Poor guys, don't know what they are missing!
		observer.update_icon()
		observer.client.create_UI(observer.type)
		observer.initialise_postkey() // ??
		add_verb(observer.client, /mob/observer/ghost/proc/dead_tele) // banaid
		observer.client.init_verbs()

		sound_to(observer, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))
		// observer.stop_sound_channel(CHANNEL_LOBBYMUSIC)
		announce_ghost_joinleave(src)
		// deadchat_broadcast(" has observed.", "<b>[observer.real_name]</b>", follow_target = observer, turf_target = get_turf(observer), message_type = DEADCHAT_DEATHRATTLE)
		QDEL_NULL(mind)
		qdel(src)
		return TRUE

	if(href_list["late_join"])
		if(!SSticker?.IsRoundInProgress())
			to_chat(usr, "<span class='boldwarning'>The round is either not ready, or has already finished...</span>")
			return

		if(href_list["late_join"] == "override")
			LateChoices()
			return

		if(!check_rights(R_ADMIN, 0))
			var/datum/species/S = all_species[client.prefs.species]
			if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species))
				src << alert("You are currently not whitelisted to play [client.prefs.species].")
				return 0

			if(!(S.spawn_flags & CAN_JOIN))
				src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
				return 0

		LateChoices()

	if(href_list["manifest"])
		show_manifest(src, nano_state = GLOB.interactive_state)

	if(href_list["SelectedJob"])
		if(!SSticker?.IsRoundInProgress())
			to_chat(usr, "<span class='danger'>The round is either not ready, or has already finished...</span>")
			return
		if(!config.enter_allowed)
			to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
			return

		var/datum/species/S = all_species[client.prefs.species]
		if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species))
			src << alert("You are currently not whitelisted to play [client.prefs.species].")
			return 0

		if(!(S.spawn_flags & CAN_JOIN))
			src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
			return 0

		AttemptLateSpawn(href_list["SelectedJob"], client.prefs.spawnpoint)
		return
	else if(!href_list["late_join"])
		new_player_panel()

	if(!ready && href_list["preference"]) // what the fuck?
		if(client)
			client.prefs.process_link(src, href_list)

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

/proc/get_job_unavailable_error_message(retval, jobtitle)
	switch(retval)
		if(JOB_AVAILABLE)
			return "[jobtitle] is available."
		if(JOB_UNAVAILABLE_GENERIC)
			return "[jobtitle] is unavailable."
		if(JOB_UNAVAILABLE_BANNED)
			return "You are currently banned from [jobtitle]."
		if(JOB_UNAVAILABLE_PLAYTIME)
			return "You do not have enough relevant playtime for [jobtitle]."
		if(JOB_UNAVAILABLE_ACCOUNTAGE)
			return "Your account is not old enough for [jobtitle]."
		if(JOB_UNAVAILABLE_SLOTFULL)
			return "[jobtitle] is already filled to capacity."
	return "Error: Unknown job availability."

/mob/new_player/proc/IsJobUnavailable(rank, latejoin = FALSE)
	var/datum/job/job = SSjob.GetJob(rank)
	if(!job)
		return JOB_UNAVAILABLE_GENERIC
	if((job.current_positions >= job.total_positions) && job.total_positions != -1) // it's job.is_position_available()'s bigger brother
		if(job.title == ASSISTANT_TITLE)
			// if(isnum(client.player_age) && client.player_age <= 14) //Newbies can always be assistants
			// 	return JOB_AVAILABLE
			for(var/datum/job/J in SSjob.occupations)
				if(J && J.current_positions < J.total_positions && J.title != job.title)
					return JOB_UNAVAILABLE_SLOTFULL
		else
			return JOB_UNAVAILABLE_SLOTFULL
	if(jobban_isbanned(src, rank))
		return JOB_UNAVAILABLE_BANNED
	if(QDELETED(src))
		return JOB_UNAVAILABLE_GENERIC
	// if(latejoin && !job.special_check_latejoin(client))
	// 	return JOB_UNAVAILABLE_GENERIC
	return JOB_AVAILABLE

/mob/new_player/proc/AttemptLateSpawn(rank, spawning_at)
	var/error = IsJobUnavailable(rank)
	if(error != JOB_AVAILABLE)
		alert(src, get_job_unavailable_error_message(error, rank))
		return FALSE

	if(SSticker.late_join_disabled)
		alert(src, "An administrator has disabled late join spawning.")
		return FALSE

	close_spawn_windows()

	SSjob.AssignRole(src, rank, 1)
	var/client/cached_client = client
	var/mob/living/character = create_character(TRUE)	//creates the human and transfers vars and mind

	var/equip = SSjob.EquipRank(character, rank) //, TRUE, is_captain)
	if(isliving(equip)) //Borgs get borged in the equip, so we need to make sure we handle the new mob.
		character = equip

	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(rank == "AI")
		character = character.AIize(move=0) // AIize the character, but don't move them yet
		// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores[1]
		empty_playable_ai_cores -= C
		character.forceMove(C.loc)
		AnnounceArrival(character, rank, "has been downloaded to the empty core in \the [character.loc.loc]")
		qdel(C)
		qdel(src)
		return

	var/datum/job/job = SSjob.GetJob(rank)

	// if(job && !job.override_latejoin_spawn(character))
	// 	SSjob.SendToLateJoin(character)
	// 	if(!arrivals_docked)
	// 		var/atom/movable/screen/splash/Spl = new(character.client, TRUE)
	// 		Spl.Fade(TRUE)
	// 		character.playsound_local(get_turf(character), 'sound/voice/ApproachingTG.ogg', 25)

	// 	character.update_parallax_teleport()

	SSticker.minds |= character.mind
	character.client.init_verbs() // init verbs for the late join

	var/mob/living/carbon/human/humanc
	if(ishuman(character))
		humanc = character //Let's retypecast the var to be human,

	if(humanc) //These procs all expect (non) /humans
		if(SSjob.ShouldCreateRecords(job.title))
			CreateModularRecord(humanc)
			data_core.manifest_inject(humanc)
			matchmaker.do_matchmaking()

		// AnnounceArrival(character, character.mind.assigned_role, spawnpoint.message)	//will not broadcast if there is no message
		// AddEmploymentContract(humanc)

		// humanc.increment_scar_slot()
		// humanc.load_persistent_scars()

		// if(GLOB.curse_of_madness_triggered)
		// 	give_madness(humanc, GLOB.curse_of_madness_triggered)

		// SEND_GLOBAL_SIGNAL(COMSIG_GLOB_CREWMEMBER_JOINED, humanc, rank)

	GLOB.joined_player_list += character.ckey

	var/datum/spawnpoint/spawnpoint = SSjob.get_spawnpoint_for(character.client ? character.client : cached_client, rank, late = TRUE)
	spawnpoint.put_mob(character) // This can fail, and it'll result in the players being left in space and not being teleported to the station. But atleast they'll be equipped. Needs to be fixed so a default case for extreme situations is added.
	equip_custom_items(character)
	character.lastarea = get_area(loc)

	log_manifest(character.mind.key,character.mind,character,latejoin = TRUE)

	qdel(src)

/mob/new_player/proc/LateChoices()
	var/name = client.prefs.be_random_name ? "friend" : client.prefs.real_name
	var/list/dat = list("<b>Welcome, [name].</b><br><div class='notice'>Round Duration: [roundduration2text()]</div>")
	if(evacuation_controller.has_evacuated())
		dat += "<div class='notice red'>The vessel has been evacuated.</div><br>"
	else if(evacuation_controller.is_evacuating())
		if(evacuation_controller.emergency_evacuation)
			dat += "<div class='notice red'>The vessel is currently undergoing evacuation procedures.</div><br>"
		else
			dat += "<div class='notice red'>The vessel is currently undergoing crew transfer procedures.</div><br>"

	dat += "Choose from the following open/valid positions:<br>"
	for(var/datum/job/job in SSjob.occupations)
		if(job && IsJobUnavailable(job.title, TRUE) == JOB_AVAILABLE)
			if(job.is_restricted(client.prefs))
				continue
			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in GLOB.player_list) if(M.mind && M.client && M.mind.assigned_role == job.title && M.client.inactivity <= 10 * 60 * 10)
				active++
			var/command_bold = ""
			if(job in command_positions)
				command_bold = " command"
			dat += "<a class='job[command_bold]' href='byond://?src=[REF(src)];SelectedJob=[job.title]'>[job.title] ([job.current_positions]) (Active: [active])</a><br>"

	var/datum/browser/popup = new(src, "latechoices", "Choose Profession", 680, 580)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE) // 0 is passed to open so that it doesn't use the onclose() proc

/mob/new_player/proc/create_character(transfer_after)
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/H = new(loc)

	var/use_species_name
	var/datum/species/chosen_species

	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	if(chosen_species && use_species_name)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(is_species_whitelisted(chosen_species) || has_admin_rights())
			H.set_species(use_species_name, TRUE)

	if(SSticker.random_players)
		H.gender = pick(MALE, FEMALE)
		client.prefs.real_first_name = random_first_name(H.gender)
		client.prefs.real_last_name = random_last_name(H.gender)
		client.prefs.real_name = client.prefs.real_first_name + " " + client.prefs.real_last_name
		client.prefs.randomize_appearance_and_body_for(H)
	else
		client.prefs.copy_to(H)

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = all_languages[lang]
		if(chosen_language)
			if(!(chosen_language.flags & WHITELISTED) || is_alien_whitelisted(src, lang) || has_admin_rights() \
				|| (H.species && (chosen_language.name in H.species.secondary_langs)))
				H.add_language(lang)

	if(mind)
		// if(transfer_after)
		// 	mind.late_joiner = TRUE
		mind.active = FALSE //we wish to transfer the key manually
		mind.original = H
		mind.transfer_to(H) //won't transfer key since the mind is not active
		if(client.prefs.relations.len)
			for(var/T in client.prefs.relations)
				var/TT = matchmaker.relation_types[T]
				var/datum/relation/R = new TT
				R.holder = mind
				R.info = client.prefs.relations_info[T]
			mind.gen_relations_info = client.prefs.relations_info["general"]

	H.lastarea = get_area(loc)
	H.dna.ready_dna(H)
	H.dna.b_type = client.prefs.b_type
	H.sync_organ_dna()

	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		H.dna.SetSEState(GLASSESBLOCK,1,0)
		H.disabilities |= NEARSIGHTED

	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	H.force_update_limbs()
	H.update_eyes()
	H.regenerate_icons()

	H.name = real_name
	client.init_verbs()
	. = H
	new_character = .
	if(transfer_after)
		transfer_character()

/mob/new_player/proc/transfer_character()
	. = new_character
	if(.)
		new_character.key = key //Manually transfer the key to log them in,
		// new_character.stop_sound_channel(CHANNEL_LOBBYMUSIC)
		sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))
		new_character = null
		qdel(src)

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window
	src << browse(null, "window=preferences") //closes job selection
	src << browse(null, "window=mob_occupation")
	src << browse(null, "window=latechoices") //closes late job selection

/mob/new_player/proc/is_species_whitelisted(datum/species/S)
	if(!S) return 1
	return is_alien_whitelisted(src, S.name) || !(S.spawn_flags & IS_WHITELISTED)

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

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

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0)
	return

mob/new_player/MayRespawn()
	return 1
