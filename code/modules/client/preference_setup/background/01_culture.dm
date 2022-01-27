#define GET_ALLOWED_VALUES(write_to, check_key) \
	var/datum/species/S = all_species69pref.species69; \
	if(!S) { \
		write_to = list(); \
	} else if(S.force_cultural_info69check_key69) { \
		write_to = list(S.force_cultural_info69check_key69 = TRUE); \
	} else { \
		write_to = list(); \
		for(var/cul in S.available_cultural_info69check_key69) { \
			write_to69cul69 = TRUE; \
		} \
	}

/datum/preferences
	var/list/cultural_info = list()

/datum/category_item/player_setup_item/background/culture
	name = "Culture"
	sort_order = 1
	var/list/hidden
	var/list/tokens = ALL_CULTURAL_TAGS

/datum/category_item/player_setup_item/background/culture/New()
	hidden = list()
	for(var/token in tokens)
		hidden69token69 = TRUE
	..()

/datum/category_item/player_setup_item/background/culture/sanitize_character()
	if(!islist(pref.cultural_info))
		pref.cultural_info = list()
	for(var/token in tokens)
		var/list/_cultures
		GET_ALLOWED_VALUES(_cultures, token)
		if(!LAZYLEN(_cultures))
			pref.cultural_info69token69 = GLOB.using_map.default_cultural_info69token69
		else
			var/current_value = pref.cultural_info69token69
			if(!current_value|| !_cultures69current_value69)
				pref.cultural_info69token69 = _cultures69169

/datum/category_item/player_setup_item/background/culture/load_character(var/savefile/S)
	for(var/token in tokens)
		var/load_val
		from_file(S69token69, load_val)
		pref.cultural_info69token69 = load_val

/datum/category_item/player_setup_item/background/culture/save_character(var/savefile/S)
	for(var/token in tokens)
		to_file(S69token69, pref.cultural_info69token69)

/datum/category_item/player_setup_item/background/culture/content()
	. = list()
	for(var/token in tokens)
		var/decl/cultural_info/culture = SSculture.get_culture(pref.cultural_info69token69)
		var/title = "<b>69tokens69token6969<a href='?src=\ref69src69;set_69token69=1'><small>?</small></a>:</b><a href='?src=\ref69src69;set_69token69=2'>69pref.cultural_info69token6969</a>"
		var/append_text = "<a href='?src=\ref69src69;toggle_verbose_69token69=1'>69hidden69token69 ? "Expand" : "Collapse"69</a>"
		. += culture.get_description(title, append_text,69erbose = !hidden69token69)
	. = jointext(.,null)

/datum/category_item/player_setup_item/background/culture/OnTopic(var/href,var/list/href_list,69ar/mob/user)

	for(var/token in tokens)

		if(href_list69"toggle_verbose_69token69"69)
			hidden69token69 = !hidden69token69
			return TOPIC_REFRESH

		var/check_href = text2num(href_list69"set_69token69"69)
		if(check_href > 0)

			var/list/valid_values
			if(check_href == 1)
				valid_values = SSculture.get_all_entries_tagged_with(token)
			else
				GET_ALLOWED_VALUES(valid_values, token)

			var/choice = input("Please select an entry.") as null|anything in69alid_values
			if(!choice)
				return

			// Check if anything changed between now and then.
			if(check_href == 1)
				valid_values = SSculture.get_all_entries_tagged_with(token)
			else
				GET_ALLOWED_VALUES(valid_values, token)

			if(valid_values69choice69)
				var/decl/cultural_info/culture = SSculture.get_culture(choice)
				if(check_href == 1)
					user << browse(culture.get_description(), "window=69token69;size=700x400")
				else
					pref.cultural_info69token69 = choice
				return TOPIC_REFRESH
	. = ..()

#undef GET_ALLOWED_VALUES