#define69AX_LANGUAGES 2

/datum/preferences
	var/list/alternate_languages

/datum/category_item/player_setup_item/background/languages
	name = "Languages"
	sort_order = 2
	var/list/allowed_languages
	var/list/free_languages

/datum/category_item/player_setup_item/background/languages/load_character(var/savefile/S)
	from_file(S69"language"69, pref.alternate_languages)

/datum/category_item/player_setup_item/background/languages/save_character(var/savefile/S)
	to_file(S69"language"69,   pref.alternate_languages)

/datum/category_item/player_setup_item/background/languages/sanitize_character()
	if(!islist(pref.alternate_languages))
		pref.alternate_languages = list()
	sanitize_alt_languages()

/datum/category_item/player_setup_item/background/languages/content()
	. = list()
	. += "<b>Languages</b><br>"
	var/list/show_langs = get_language_text()
	if(LAZYLEN(show_langs))
		for(var/lang in show_langs)
			. += lang
	else
		. += "Your current species, faction or home system selection does not allow you to choose additional languages.<br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/background/languages/OnTopic(var/href,var/list/href_list,69ar/mob/user)

	if(href_list69"remove_language"69)
		var/index = text2num(href_list69"remove_language"69)
		pref.alternate_languages.Cut(index, index+1)
		return TOPIC_REFRESH

	else if(href_list69"add_language"69)

		if(pref.alternate_languages.len >=69AX_LANGUAGES)
			alert(user, "You have already selected the69aximum number of languages!")
			return

		sanitize_alt_languages()
		var/list/available_languages = allowed_languages - free_languages
		if(!LAZYLEN(available_languages))
			alert(user, "There are no additional languages available to select.")
		else
			var/new_lang = input(user, "Select an additional language", "Character Generation", null) as null|anything in available_languages
			if(new_lang)
				pref.alternate_languages |= new_lang
				return TOPIC_REFRESH
	. = ..()

/datum/category_item/player_setup_item/background/languages/proc/rebuild_language_cache(var/mob/user)

	allowed_languages = list()
	free_languages = list()

	if(!user)
		return

	//A quick hack. Todo: Draw this from species or culture or something
	free_languages69LANGUAGE_COMMON69 = TRUE

	/*
	for(var/thing in pref.cultural_info)
		var/decl/cultural_info/culture = SSculture.get_culture(pref.cultural_info69thing69)
		if(istype(culture))
			var/list/langs = culture.get_spoken_languages()
			if(LAZYLEN(langs))
				for(var/checklang in langs)
					free_languages69checklang69 =    TRUE
					allowed_languages69checklang69 = TRUE
			if(LAZYLEN(culture.secondary_langs))
				for(var/checklang in culture.secondary_langs)
					allowed_languages69checklang69 = TRUE
	*/
	for(var/thing in all_languages)
		var/datum/language/lang = all_languages69thing69
		if(!(lang.flags & RESTRICTED))
			allowed_languages69thing69 = TRUE

/datum/category_item/player_setup_item/background/languages/proc/is_allowed_language(var/mob/user,69ar/datum/language/lang)
	if(isnull(allowed_languages) || isnull(free_languages))
		rebuild_language_cache(user)
	if(!user || ((lang.flags & RESTRICTED) && is_alien_whitelisted(user, lang)))
		return TRUE
	return allowed_languages69lang.name69

/datum/category_item/player_setup_item/background/languages/proc/sanitize_alt_languages()
	if(!istype(pref.alternate_languages))
		pref.alternate_languages = list()
	var/preference_mob = preference_mob()
	rebuild_language_cache(preference_mob)
	for(var/L in pref.alternate_languages)
		var/datum/language/lang = all_languages69L69
		if(!lang || !is_allowed_language(preference_mob, lang))
			pref.alternate_languages -= L
	if(LAZYLEN(free_languages))
		for(var/lang in free_languages)
			pref.alternate_languages -= lang
			pref.alternate_languages.Insert(1, lang)

	pref.alternate_languages = uniquelist(pref.alternate_languages)
	if(pref.alternate_languages.len >69AX_LANGUAGES)
		pref.alternate_languages.Cut(MAX_LANGUAGES + 1)

/datum/category_item/player_setup_item/background/languages/proc/get_language_text()
	sanitize_alt_languages()
	if(LAZYLEN(pref.alternate_languages))
		for(var/i = 1 to pref.alternate_languages.len)
			var/lang = pref.alternate_languages69i69
			if(free_languages69lang69)
				LAZYADD(., "- 69lang69 (required).<br>")
			else
				LAZYADD(., "- 69lang69 <a href='?src=\ref69src69;remove_language=69i69'>Remove.</a><br>")
	if(pref.alternate_languages.len <69AX_LANGUAGES)
		var/remaining_langs =69AX_LANGUAGES - pref.alternate_languages.len
		LAZYADD(., "- <a href='?src=\ref69src69;add_language=1'>add</a> (69remaining_langs69 remaining)<br>")

#undef69AX_LANGUAGES