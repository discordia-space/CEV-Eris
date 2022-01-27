datum/preferences
	var/gender =69ALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/spawnpoint = "Aft Cryogenic Storage" 			//where this character will spawn
	var/real_name						//our character's name
	var/real_first_name
	var/real_last_name
	var/be_random_name = 0				//whether we are a random name every round

/datum/category_item/player_setup_item/physical/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/physical/basic/load_character(savefile/S)
	from_file(S69"gender"69,                pref.gender)
	from_file(S69"age"69,                   pref.age)
	from_file(S69"spawnpoint"69,            pref.spawnpoint)
	from_file(S69"real_first_name"69,       pref.real_first_name)
	from_file(S69"real_last_name"69,        pref.real_last_name)
	from_file(S69"real_name"69,             pref.real_name)
	from_file(S69"name_is_always_random"69, pref.be_random_name)

/datum/category_item/player_setup_item/physical/basic/save_character(savefile/S)
	to_file(S69"gender"69,                  pref.gender)
	to_file(S69"age"69,                     pref.age)
	to_file(S69"spawnpoint"69,              pref.spawnpoint)
	to_file(S69"real_first_name"69,         pref.real_first_name)
	to_file(S69"real_last_name"69,          pref.real_last_name)
	to_file(S69"real_name"69,               pref.real_name)
	to_file(S69"name_is_always_random"69,   pref.be_random_name)

/datum/category_item/player_setup_item/physical/basic/sanitize_character()
	var/datum/species/S = all_species69pref.species ? pref.species : SPECIES_HUMAN69
	if(!S) S = all_species69SPECIES_HUMAN69
	pref.age                = sanitize_integer(pref.age, S.min_age, S.max_age, initial(pref.age))
	pref.gender             = sanitize_inlist(pref.gender, S.genders, pick(S.genders))
	pref.spawnpoint         = sanitize_inlist(pref.spawnpoint, get_late_spawntypes(), initial(pref.spawnpoint))
	pref.be_random_name     = sanitize_integer(pref.be_random_name, 0, 1, initial(pref.be_random_name))

	// This is a bit noodly. If pref.cultural_info69TAG_CULTURE69 is null, then we haven't finished loading/sanitizing, which69eans we69ight purge
	// numbers or w/e from someone's name by comparing them to the69ap default. So we just don't bother sanitizing at this point otherwise.
	/*
	if(pref.cultural_info69TAG_CULTURE69)
		var/decl/cultural_info/check = SSculture.get_culture(pref.cultural_info69TAG_CULTURE69)
		if(check)
			pref.real_name = check.sanitize_name(pref.real_name, pref.species)
			if(!pref.real_name)
				pref.real_name = random_name(pref.gender, pref.species)
	*/
/datum/category_item/player_setup_item/physical/basic/content()
	. = list()
	. += "<b>First name:</b> "
	. += "<a href='?src=\ref69src69;fname=1'><b>69pref.real_first_name69</b></a><br>"
	. += "<b>Last name:</b> "
	. += "<a href='?src=\ref69src69;lname=1'><b>69pref.real_last_name69</b></a><br>"
	. += "<a href='?src=\ref69src69;random_name=1'>Randomize Name</A><br>"
	. += "<a href='?src=\ref69src69;always_random_name=1'>Always Random Name: 69pref.be_random_name ? "Yes" : "No"69</a>"
	. += "<hr>"
	. += "<b>Gender:</b> <a href='?src=\ref69src69;gender=1'><b>69gender2text(pref.gender)69</b></a><br>"
	. += "<b>Age:</b> <a href='?src=\ref69src69;age=1'>69pref.age69</a><br>"
	. += "<b>Spawn Point</b>: <a href='?src=\ref69src69;spawnpoint=1'>69pref.spawnpoint69</a><br>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/physical/basic/OnTopic(href, href_list,69ob/user)
	var/datum/species/S = all_species69pref.species69

	if(href_list69"fname"69)
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
				to_chat(user, SPAN_WARNING("Invalid first name. Your name should be at least 2 and at69ost 69MAX_NAME_LEN69 characters long. It69ay only contain the characters A-Z, a-z, -, ' and ."))
				return TOPIC_NOACTION

	if(href_list69"lname"69)
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
					to_chat(user, SPAN_WARNING("Invalid last name. Your name should be at least 2 and at69ost 69last_name_max_length69 characters long. It69ay only contain the characters A-Z, a-z, -, ' and ."))
					return TOPIC_NOACTION

	else if(href_list69"random_name"69)
		pref.real_first_name = random_first_name(pref.gender, pref.species)
		pref.real_last_name = random_last_name(pref.gender, pref.species)
		pref.real_name = pref.real_first_name + " " + pref.real_last_name 
		return TOPIC_REFRESH

	else if(href_list69"always_random_name"69)
		pref.be_random_name = !pref.be_random_name
		return TOPIC_REFRESH

	else if(href_list69"gender"69)
		var/new_gender = input(user, "Choose your character's gender:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.gender) as null|anything in S.genders
		S = all_species69pref.species69
		if(new_gender && CanUseTopic(user) && (new_gender in S.genders))
			pref.gender = new_gender
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"age"69)
		var/new_age = input(user, "Choose your character's age:\n(69S.min_age69-69S.max_age69)", CHARACTER_PREFERENCE_INPUT_TITLE, pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age =69ax(min(round(text2num(new_age)), S.max_age), S.min_age)
			//pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		// The age69ay invalidate skill loadouts
			return TOPIC_REFRESH

	else if(href_list69"spawnpoint"69)
		var/list/spawnkeys = list()
		for(var/spawntype in get_late_spawntypes())
			spawnkeys += spawntype
		var/choice = input(user, "Where would you like to spawn when late-joining?") as null|anything in spawnkeys
		if(!choice || !get_late_spawntypes()69choice69 || !CanUseTopic(user))	return TOPIC_NOACTION
		pref.spawnpoint = choice
		return TOPIC_REFRESH

	return ..()
