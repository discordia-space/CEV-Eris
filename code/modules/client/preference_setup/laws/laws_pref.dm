/datum/preferences
	var/list/laws = list()
	var/is_shackled = FALSE

/datum/preferences/proc/get_lawset()
	if(!laws || !laws.len)
		return
	var/datum/ai_laws/custom_lawset = new
	for(var/law in laws)
		custom_lawset.add_inherent_law(law)
	return custom_lawset

/datum/category_item/player_setup_item/law_pref
	name = "Laws"
	sort_order = 1

/datum/category_item/player_setup_item/law_pref/load_character(var/savefile/S)
	from_file(S69"laws"69, pref.laws)
	from_file(S69"is_shackled"69, pref.is_shackled)

/datum/category_item/player_setup_item/law_pref/save_character(var/savefile/S)
	to_file(S69"laws"69, pref.laws)
	to_file(S69"is_shackled"69, pref.is_shackled)

/datum/category_item/player_setup_item/law_pref/sanitize_character()
	if(!istype(pref.laws))	pref.laws = list()

	pref.is_shackled = initial(pref.is_shackled)

/datum/category_item/player_setup_item/law_pref/content()
	. = list()

	. += "<b>Your Species Has No Laws</b><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/law_pref/OnTopic(href, href_list, user)
	if(href_list69"toggle_shackle"69)
		pref.is_shackled = !pref.is_shackled
		return TOPIC_REFRESH

	else if(href_list69"lawsets"69)
		var/list/valid_lawsets = list()
		var/list/all_lawsets = subtypesof(/datum/ai_laws)

		for(var/law_set_type in all_lawsets)
			var/datum/ai_laws/ai_laws = law_set_type
			var/ai_law_name = initial(ai_laws.name)
			if(initial(ai_laws.shackles)) // Now this is one terribly snowflaky69ar
				ADD_SORTED(valid_lawsets, ai_law_name, /proc/cmp_text_asc)
				valid_lawsets69ai_law_name69 = law_set_type

		// Post selection
		var/chosen_lawset = input(user, "Choose a law set:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.laws)  as null|anything in69alid_lawsets
		if(chosen_lawset)
			var/path =69alid_lawsets69chosen_lawset69
			var/datum/ai_laws/lawset = new path()
			var/list/datum/ai_law/laws = lawset.all_laws()
			pref.laws.Cut()
			for(var/datum/ai_law/law in laws)
				pref.laws += sanitize_text("69law.law69", default="")
		return TOPIC_REFRESH
	return ..()
