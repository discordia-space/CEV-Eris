/datum/preferences
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/spawnpoint = "Aft Cryogenic Storage" 			//where this character will spawn
	var/real_name						//our character's name
	var/real_first_name
	var/real_last_name
	var/be_random_name = 0				//whether we are a random name every round
	var/tts_seed = TTS_SEED_DEFAULT_MALE

/datum/category_item/player_setup_item/physical/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/physical/basic/load_character(savefile/S)
	from_file(S["gender"],                pref.gender)
	from_file(S["age"],                   pref.age)
	from_file(S["spawnpoint"],            pref.spawnpoint)
	from_file(S["real_first_name"],       pref.real_first_name)
	from_file(S["real_last_name"],        pref.real_last_name)
	from_file(S["real_name"],             pref.real_name)
	from_file(S["name_is_always_random"], pref.be_random_name)
	from_file(S["tts_seed"],              pref.tts_seed)

/datum/category_item/player_setup_item/physical/basic/save_character(savefile/S)
	to_file(S["gender"],                  pref.gender)
	to_file(S["age"],                     pref.age)
	to_file(S["spawnpoint"],              pref.spawnpoint)
	to_file(S["real_first_name"],         pref.real_first_name)
	to_file(S["real_last_name"],          pref.real_last_name)
	to_file(S["real_name"],               pref.real_name)
	to_file(S["name_is_always_random"],   pref.be_random_name)
	to_file(S["tts_seed"],                pref.tts_seed)

/datum/category_item/player_setup_item/physical/basic/sanitize_character()
	var/datum/species/S = all_species[pref.species ? pref.species : SPECIES_HUMAN]
	if(!S) S = all_species[SPECIES_HUMAN]
	pref.age                = sanitize_integer(pref.age, S.min_age, S.max_age, initial(pref.age))
	pref.gender             = sanitize_inlist(pref.gender, S.genders, pick(S.genders))
	pref.spawnpoint         = sanitize_inlist(pref.spawnpoint, get_late_spawntypes(), initial(pref.spawnpoint))
	pref.be_random_name     = sanitize_integer(pref.be_random_name, 0, 1, initial(pref.be_random_name))

/datum/category_item/player_setup_item/physical/basic/content()
	. = list()
	. += "<b>First name:</b> "
	. += "<a href='?src=\ref[src];fname=1'><b>[pref.real_first_name]</b></a><br>"
	. += "<b>Last name:</b> "
	. += "<a href='?src=\ref[src];lname=1'><b>[pref.real_last_name]</b></a><br>"
	. += "<a href='?src=\ref[src];random_name=1'>Randomize Name</A><br>"
	. += "<a href='?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a>"
	. += "<hr>"
	. += "<b>Gender:</b> <a href='?src=\ref[src];gender=1'><b>[gender2text(pref.gender)]</b></a><br>"
	. += "<b>Age:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a><br>"
	. += "<b>Spawn Point</b>: <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a><br>"
	. += "<b>Text-to-speech seed</b>: <a href='?src=\ref[src];tts_seed=1'>[pref.tts_seed]</a><br>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/physical/basic/OnTopic(href, href_list, mob/user)
	var/datum/species/S = all_species[pref.species]

	if(href_list["fname"])
		var/raw_first_name = input(user, "Choose your character's first name:", "Character First Name", pref.real_first_name)  as text|null
		if (!isnull(raw_first_name) && CanUseTopic(user))
			var/new_fname = sanitize_name(raw_first_name, pref.species, 14)
			if(new_fname)
				if(GLOB.in_character_filter.len) //If you name yourself brazil, you're getting a random name.
					if(findtext(new_fname, config.ic_filter_regex))
						new_fname = random_first_name(pref.gender, pref.species)
				pref.real_first_name = new_fname
				pref.real_name = pref.real_first_name + " " + pref.real_last_name
				return TOPIC_REFRESH
			else
				to_chat(user, SPAN_WARNING("Invalid first name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
				return TOPIC_NOACTION

	if(href_list["lname"])
		var/last_name_max_length = 14
		var/raw_last_name = input(user, "Choose your character's last name:", "Character Last Name", pref.real_last_name)  as text|null
		if(CanUseTopic(user))
			if(isnull(raw_last_name) || raw_last_name == "")
				pref.real_last_name = null
				pref.real_name = pref.real_first_name
				return TOPIC_REFRESH
			else
				var/new_lname = sanitize_name(raw_last_name, pref.species, last_name_max_length)
				if(new_lname)
					if(GLOB.in_character_filter.len) //Same here too. Naming yourself brazil isn't funny, please stop.
						if(findtext(new_lname, config.ic_filter_regex))
							new_lname = random_last_name(pref.gender, pref.species)
					pref.real_last_name = new_lname
					pref.real_name = pref.real_first_name + " " + pref.real_last_name
					return TOPIC_REFRESH
				else
					to_chat(user, SPAN_WARNING("Invalid last name. Your name should be at least 2 and at most [last_name_max_length] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
					return TOPIC_NOACTION

	else if(href_list["random_name"])
		pref.real_first_name = random_first_name(pref.gender, pref.species)
		pref.real_last_name = random_last_name(pref.gender, pref.species)
		pref.real_name = pref.real_first_name + " " + pref.real_last_name
		return TOPIC_REFRESH

	else if(href_list["always_random_name"])
		pref.be_random_name = !pref.be_random_name
		return TOPIC_REFRESH

	else if(href_list["gender"])
		var/new_gender = input(user, "Choose your character's gender:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.gender) as null|anything in S.genders
		S = all_species[pref.species]
		if(new_gender && CanUseTopic(user) && (new_gender in S.genders))
			pref.gender = new_gender
			var/list/seeds = new()
			for(var/i in tts_seeds)
				var/list/L = tts_seeds[i]
				if((L["category"] == "any" || L["category"] == "human") && (L["gender"] == "any" || L["gender"] == pref.gender))
					seeds += i
			if(!LAZYLEN(seeds))
				seeds = tts_seeds
			pref.tts_seed = pick(seeds)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["age"])
		var/new_age = input(user, "Choose your character's age:\n([S.min_age]-[S.max_age])", CHARACTER_PREFERENCE_INPUT_TITLE, pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)), S.max_age), S.min_age)
			//pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		// The age may invalidate skill loadouts
			return TOPIC_REFRESH

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/spawntype in get_late_spawntypes())
			spawnkeys += spawntype
		var/choice = input(user, "Where would you like to spawn when late-joining?") as null|anything in spawnkeys
		if(!choice || !get_late_spawntypes()[choice] || !CanUseTopic(user))	return TOPIC_NOACTION
		pref.spawnpoint = choice
		return TOPIC_REFRESH

	else if(href_list["tts_seed"])
		var/list/seeds = new()
		for(var/i in tts_seeds)
			var/list/L = tts_seeds[i]
			if((L["category"] == "any" || L["category"] == "human") && (L["gender"] == "any" || L["gender"] == pref.gender))
				seeds += i
		if(!LAZYLEN(seeds))
			seeds = tts_seeds

		var/choice = input(user, "Pick a voice preset.") as null|anything in seeds
		if(choice)
			tts_cast(user, "You'll sound like this... when talking.", choice)
			pref.tts_seed = choice
			return TOPIC_REFRESH
		return TOPIC_NOACTION

	return ..()
