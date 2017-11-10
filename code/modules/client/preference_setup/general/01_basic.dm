datum/preferences
	var/identifying_gender = MALE

/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1
	var/list/valid_player_genders = list(MALE, FEMALE)

datum/preferences/proc/set_biological_gender(var/set_gender)
	gender = set_gender
	identifying_gender = set_gender

/datum/category_item/player_setup_item/general/basic/load_character(var/savefile/S)
	pref.req_update_icon = 1
	S["real_name"]				>> pref.real_name
	S["name_is_always_random"]	>> pref.be_random_name
	S["gender"]					>> pref.gender
	S["body_build"]				>> pref.body_build
	S["age"]					>> pref.age
	S["spawnpoint"]				>> pref.spawnpoint
	S["OOC_Notes"]				>> pref.metadata

/datum/category_item/player_setup_item/general/basic/save_character(var/savefile/S)
	S["real_name"]				<< pref.real_name
	S["name_is_always_random"]	<< pref.be_random_name
	S["gender"]					<< pref.gender
	S["body_build"]				<< pref.body_build
	S["age"]					<< pref.age
	S["spawnpoint"]				<< pref.spawnpoint
	S["OOC_Notes"]				<< pref.metadata

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	var/datum/species/S = all_species[pref.species ? pref.species : "Human"]
	pref.age			= sanitize_integer(pref.age, S.min_age, S.max_age, initial(pref.age))
	pref.gender 		= sanitize_inlist(pref.gender, valid_player_genders, pick(valid_player_genders))
	pref.body_build 	= sanitize_inlist(pref.body_build, list("Slim", "Default", "Fat"), "Default")
	pref.identifying_gender = (pref.identifying_gender in all_genders_define_list) ? pref.identifying_gender : pref.gender
	pref.real_name		= sanitize_name(pref.real_name, pref.species)
	if(!pref.real_name)
		pref.real_name	= random_name(pref.gender, pref.species)
	pref.spawnpoint		= sanitize_inlist(pref.spawnpoint, spawnpoints_late, spawnpoints_late[1])

	pref.be_random_name	= sanitize_integer(pref.be_random_name, 0, 1, initial(pref.be_random_name))

/datum/category_item/player_setup_item/general/basic/content()
	. = list()
	. += "<b>Name:</b> "
	. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	. += "<a href='?src=\ref[src];random_name=1'>Randomize Name</A><br>"
	. += "<a href='?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a>"
	. += "<br>"
	. += "<b>Gender:</b> <a href='?src=\ref[src];gender=1'><b>[capitalize(lowertext(pref.gender))]</b></a><br>"
	. += "<b>Body Shape:</b> <a href='?src=\ref[src];body_build=1'><b>[pref.body_build]</b></a><br>"
	. += "<b>Age:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a><br>"
	. += "<b>Religion:</b> <a href='?src=\ref[src];religion=1'>[pref.religion]</a><br>"

	if(config.allow_Metadata)
		. += "<b>OOC Notes:</b> <a href='?src=\ref[src];metadata=1'> Edit </a><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/general/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["rename"])
		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species)
			if(new_name)
				pref.real_name = new_name
				return TOPIC_REFRESH
			else
				user << SPAN_WARNING("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .")
				return TOPIC_NOACTION

	else if(href_list["random_name"])
		pref.real_name = random_name(pref.gender, pref.species)
		return TOPIC_REFRESH

	else if(href_list["always_random_name"])
		pref.be_random_name = !pref.be_random_name
		return TOPIC_REFRESH

	else if(href_list["gender"])
		pref.gender = next_in_list(pref.gender, valid_player_genders)
		pref.req_update_icon = 1
		return TOPIC_REFRESH

	else if(href_list["body_build"])
		pref.body_build = input("Body Shape", "Body") in list("Default", "Slim", "Fat")
		pref.req_update_icon = 1
		return TOPIC_REFRESH

	else if(href_list["age"])
		var/datum/species/S = all_species[pref.species]
		var/new_age = input(user, "Choose your character's age:\n([S.min_age]-[S.max_age])", "Character Preference", pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)), S.max_age), S.min_age)
			return TOPIC_REFRESH

	else if(href_list["metadata"])
		var/new_metadata = sanitize(input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , pref.metadata)) as message|null
		if(new_metadata && CanUseTopic(user))
			pref.metadata = sanitize(new_metadata)
			return TOPIC_REFRESH

	else if(href_list["religion"])
		pref.religion = input("Religion") in list("None", "Christianity")
		pref.req_update_icon = 1
		return TOPIC_REFRESH

	return ..()
