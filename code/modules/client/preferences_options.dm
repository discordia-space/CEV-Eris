/datum/preferences
	var/list/setup_options = list()

/datum/preferences/proc/get_option(category)
	if(!SScharacter_setup.setup_options[category])
		warning("Asking for invalid setup_option category: [category]")
		return
	return SScharacter_setup.setup_options[category][setup_options[category]]

/datum/preferences/proc/load_option(savefile/S, datum/category_group/setup_option_category/category)
	from_file(S[category.name], setup_options[category.name])

/datum/preferences/proc/save_option(savefile/S, datum/category_group/setup_option_category/category)
	to_file(S[category.name], setup_options[category.name])

/datum/preferences/proc/sanitize_option(datum/category_group/setup_option_category/category)
	if(!setup_options[category.name])
		setup_options[category.name] = "None"
