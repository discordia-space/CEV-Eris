/datum/preferences
	var/list/setup_options = list()

/datum/preferences/proc/get_option(category)
	RETURN_TYPE(/datum/category_item/setup_option)
	if(!SScharacter_setup.setup_options69category69)
		warning("Asking for invalid setup_option category: 69category69")
		return
	return SScharacter_setup.setup_options69category6969setup_options69category6969

/datum/preferences/proc/load_option(savefile/S, datum/category_group/setup_option_category/category)
	from_file(S69category.name69, setup_options69category.name69)

/datum/preferences/proc/save_option(savefile/S, datum/category_group/setup_option_category/category)
	to_file(S69category.name69, setup_options69category.name69)

/datum/preferences/proc/sanitize_option(datum/category_group/setup_option_category/category)
	if(!setup_options69category.name69)
		setup_options69category.name69 = "None"
