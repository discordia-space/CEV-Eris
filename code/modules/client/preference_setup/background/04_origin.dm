//Named origin because /datum/category_item/player_setup_item/background/background looks awful
/datum/category_item/player_setup_item/background/origin
	name = "Background Setup"
	sort_order = 6

/datum/category_item/player_setup_item/background/origin/load_character(savefile/S)
	for(var/datum/category_group/setup_option_category/background/BG in SScharacter_setup.setup_options.categories)
		pref.load_option(S, BG)

/datum/category_item/player_setup_item/background/origin/save_character(savefile/S)
	for(var/datum/category_group/setup_option_category/background/BG in SScharacter_setup.setup_options.categories)
		pref.save_option(S, BG)

/datum/category_item/player_setup_item/background/origin/sanitize_character()
	for(var/datum/category_group/setup_option_category/background/BG in SScharacter_setup.setup_options.categories)
		pref.sanitize_option(BG)

/datum/category_item/player_setup_item/background/origin/content(mob/user)
	. = list()
	. += "<b>Background</b><br>"
	for(var/datum/category_group/setup_option_category/background/BG in SScharacter_setup.setup_options.categories)
		. += "69BG69: <a href='?src=\ref69src69;options_popup=69BG69'>69pref.setup_options69BG.name6969</a><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/background/origin/get_title()
	return ..() + ": 69option_category69"

/datum/category_item/player_setup_item/background/origin/open_popup(category_name)
	if(!istype(SScharacter_setup.setup_options69category_name69, /datum/category_group/setup_option_category/background))
		return FALSE
	option_category = SScharacter_setup.setup_options69category_name69
	return TRUE
