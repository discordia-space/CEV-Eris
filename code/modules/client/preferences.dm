#define SAVE_RESET -1

/datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	var/save_load_cooldown

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change

	var/list/time_of_death = list()//This is a list of last times of death for various things with different respawn timers

	var/list/crew_respawn_bonuses = list()
	//This is a list of bonuses that are subtracted from your crew respawn time
	//This is used to make certain ingame actions allow a dead player to respawn faster
	//It uses an associative list to prevent exploits, so the same bonus cannot be gained repeatedly.
	//It will just overwrite the value

	var/client/client = null
	var/client_ckey = null

	var/savefile/loaded_preferences
	var/savefile/loaded_character
	var/datum/category_collection/player_setup_collection/player_setup
	var/datum/browser/panel

/datum/preferences/New(client/C)
	if(istype(C))
		client = C
		client_ckey = C.ckey
		SScharacter_setup.preferences_datums += src
		if(SScharacter_setup.initialized)
			setup()
		else
			SScharacter_setup.prefs_awaiting_setup += src
	..()

/datum/preferences/proc/setup()
//	if(!length(GLOB.skills))
//		decls_repository.get_decl(/decl/hierarchy/skill)
	player_setup = new(src)
	gender = pick(MALE, FEMALE)
	real_first_name = random_first_name(gender,species)
	real_last_name = random_last_name(species)
	real_name = real_first_name + " " + real_last_name
	b_type = RANDOM_BLOOD_TYPE

	if(client && !IsGuestKey(client.key))
		load_path(client.ckey)
		load_preferences()
		load_and_update_character()

	sanitize_preferences()
	if(client && istype(client.mob, /mob/new_player))
		var/mob/new_player/np = client.mob
		np.new_player_panel(TRUE)
	if(client?.mob)
		client.mob.fullscreen_check()

/datum/preferences/proc/load_and_update_character(var/slot)
	load_character(slot)
	if(update_setup(loaded_preferences, loaded_character))
		save_preferences()
		save_character()

/datum/preferences/proc/ShowChoices(mob/user)
	if(!SScharacter_setup.initialized)
		return
	if(!user || !user.client)
		return

	if(!get_mob_by_key(client_ckey))
		to_chat(user, SPAN_DANGER("No mob exists for the given client!"))
		close_load_dialog(user)
		return

	if(!path && !IsGuestKey(user.client.key))
		error("Prefs failed to setup (datum): [user.client.ckey]")
		load_path(user.client.ckey)
		load_preferences()
		load_and_update_character()

	var/dat = "<html><body><center>"
	if(path)
		SSjob.UpdatePlayableJobs(user.client.ckey)
		dat += "Slot - "
		dat += "<a href='?src=\ref[src];load=1'>Load slot</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Save slot</a> - "
		dat += "<a href='?src=\ref[src];resetslot=1'>Reset slot</a> - "
		dat += "<a href='?src=\ref[src];reload=1'>Reload slot</a>"


	else
		dat += "Please create an account to save your preferences."

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)

	dat += "</html></body>"
	var/datum/browser/popup = new(user, "Character Setup","Character Setup", 1200, 800, src)
	popup.set_content(dat)
	popup.open()

/datum/preferences/proc/process_link(mob/user, list/href_list)

	if(!user)	return
	if(isliving(user)) return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			user << link(config.forumurl)
		else
			to_chat(user, SPAN_DANGER("The forum URL is not set in the server configuration."))
			return
	ShowChoices(usr)
	return 1

/datum/preferences/proc/check_cooldown()
	if(save_load_cooldown != world.time && (save_load_cooldown + PREF_SAVELOAD_COOLDOWN > world.time))
		return FALSE

	save_load_cooldown = world.time
	return TRUE


/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		save_preferences()
		save_character()
	else if(href_list["reload"])
		load_preferences()
		load_character()
		sanitize_preferences()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		sanitize_preferences()
		close_load_dialog(usr)
	else if(href_list["resetslot"])
		if(real_name != input("This will reset the current slot. Enter the character's full name to confirm."))
			return FALSE
		load_character(SAVE_RESET)
		sanitize_preferences()
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, is_preview_copy = FALSE)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()
	character.set_species(species)
	var/random_first = random_first_name(gender, species)
	var/random_last = random_last_name(gender, species)
	var/random_full = real_first_name + " " + real_last_name

	if(be_random_name)
		real_first_name = random_first
		real_last_name = random_last
		real_name = random_full

	if(GLOB.in_character_filter.len) //This does not always work correctly but is here as a backup in case the first two attempts to catch bad names fail.
		if(findtext(real_first_name, config.ic_filter_regex) || findtext(real_last_name, config.ic_filter_regex))
			real_first_name = random_first
			real_last_name = random_last
			real_name = random_full

	if(config.humans_need_surnames)
		if(!real_last_name)	//we need a surname
			real_last_name = "[pick(GLOB.last_names)]"
			real_name += " [real_last_name]"
	character.fully_replace_character_name(newname = real_name)
	character.first_name = real_first_name
	character.last_name = real_last_name
	character.gender = gender
	character.age = age
	character.b_type = b_type
	character.tts_seed = tts_seed
	character.h_style = h_style
	character.f_style = f_style
	// Build mob body from prefs
	character.rebuild_organs(src)

	character.eyes_color = eyes_color
	character.hair_color = hair_color
	character.facial_color = facial_color
	character.skin_color = skin_color

	character.s_tone = s_tone

	QDEL_LIST(character.worn_underwear)
	character.worn_underwear = list()
	for(var/underwear_category_name in all_underwear)
		var/datum/category_group/underwear/underwear_category = GLOB.underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = all_underwear[underwear_category_name]
			var/datum/category_item/underwear/UWD = underwear_category.items_by_name[underwear_item_name]
			var/metadata = all_underwear_metadata[underwear_category_name]
			var/obj/item/underwear/UW = UWD.create_underwear(character, metadata, 'icons/inventory/underwear/mob.dmi')
			if(UW)
				UW.ForceEquipUnderwear(character, FALSE)
		else
			all_underwear -= underwear_category_name


	character.backpack_setup = new(backpack, backpack_metadata["[backpack]"])

	character.force_update_limbs()
	character.update_mutations(0)
	character.update_implants(0)
	character.update_body(0)
	character.update_underwear(0)

	character.update_hair(0)


	character.update_icons()

	if(is_preview_copy)
		return

	for(var/lang in alternate_languages)
		character.add_language(lang)

	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record
	character.exploit_record = exploit_record
	if(!character.isSynthetic())
		character.nutrition = rand(250, 450)


	for(var/options_name in setup_options)
		if(!get_option(options_name))
			continue
		get_option(options_name).apply(character)

	character.post_prefinit()


/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat  = list()
	dat += "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = GLOB.maps_data.character_load_path(S, i)
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	panel = new(user, "Character Slots", "Character Slots", 300, 390, src)
	panel.set_content(jointext(dat,null))
	panel.open()

/datum/preferences/proc/close_load_dialog(mob/user)
	if(panel)
		panel.close()
		panel = null
	user << browse(null, "window=saves")
