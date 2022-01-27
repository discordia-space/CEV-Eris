//Named fate because /datum/category_item/player_setup_item/background/background looks awful
/datum/category_item/player_setup_item/background/fate
	name = "Background Setup"
	sort_order = 6

/datum/category_item/player_setup_item/background/fate/load_character(savefile/S)
	for(var/datum/category_group/setup_option_category/background/BG in SScharacter_setup.setup_options.categories)
		pref.load_option(S, BG)

/datum/category_item/player_setup_item/background/fate/save_character(savefile/S)
	for(var/datum/category_group/setup_option_category/background/BG in SScharacter_setup.setup_options.categories)
		pref.save_option(S, BG)

/datum/category_item/player_setup_item/background/fate/sanitize_character()
	for(var/datum/category_group/setup_option_category/background/BG in SScharacter_setup.setup_options.categories)
		pref.sanitize_option(BG)

/datum/category_item/player_setup_item/background/fate/get_title()
	return ..() + ": 69option_category69"

/datum/category_item/player_setup_item/background/fate/open_popup(category_name)
	if(!istype(SScharacter_setup.setup_options69category_name69, /datum/category_group/setup_option_category/background))
		return FALSE
	option_category = SScharacter_setup.setup_options69category_name69
	return TRUE
