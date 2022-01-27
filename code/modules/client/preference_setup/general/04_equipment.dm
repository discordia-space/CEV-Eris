/datum/preferences
	var/list/all_underwear
	var/list/all_underwear_metadata

	var/decl/backpack_outfit/backpack
	var/list/backpack_metadata

/datum/category_item/player_setup_item/physical/equipment
	name = "Clothing"
	sort_order = 4

	var/static/list/backpacks_by_name

/datum/category_item/player_setup_item/physical/equipment/New()
	..()
	if(!backpacks_by_name)
		backpacks_by_name = list()
		var/bos = decls_repository.get_decls_of_subtype(/decl/backpack_outfit)
		for(var/bo in bos)
			var/decl/backpack_outfit/backpack_outfit = bos69bo69
			backpacks_by_name69backpack_outfit.name69 = backpack_outfit

/datum/category_item/player_setup_item/physical/equipment/load_character(var/savefile/S)
	var/load_backbag

	from_file(S69"all_underwear"69, pref.all_underwear)
	from_file(S69"all_underwear_metadata"69, pref.all_underwear_metadata)
	from_file(S69"backpack"69, load_backbag)
	from_file(S69"backpack_metadata"69, pref.backpack_metadata)

	pref.backpack = backpacks_by_name69load_backbag69 || get_default_outfit_backpack()

/datum/category_item/player_setup_item/physical/equipment/save_character(var/savefile/S)
	to_file(S69"all_underwear"69, pref.all_underwear)
	to_file(S69"all_underwear_metadata"69, pref.all_underwear_metadata)
	to_file(S69"backpack"69, pref.backpack.name)
	to_file(S69"backpack_metadata"69, pref.backpack_metadata)

/datum/category_item/player_setup_item/physical/equipment/sanitize_character()
	if(!istype(pref.all_underwear))
		pref.all_underwear = list()

		for(var/datum/category_group/underwear/WRC in GLOB.underwear.categories)
			for(var/datum/category_item/underwear/WRI in WRC.items)
				if(WRI.is_default(pref.gender ? pref.gender :69ALE))
					pref.all_underwear69WRC.name69 = WRI.name
					break

	if(!istype(pref.all_underwear_metadata))
		pref.all_underwear_metadata = list()

	for(var/underwear_category in pref.all_underwear)
		var/datum/category_group/underwear/UWC = GLOB.underwear.categories_by_name69underwear_category69
		if(!UWC)
			pref.all_underwear -= underwear_category
		else
			var/datum/category_item/underwear/UWI = UWC.items_by_name69pref.all_underwear69underwear_category6969
			if(!UWI)
				pref.all_underwear -= underwear_category

	for(var/underwear_metadata in pref.all_underwear_metadata)
		if(!(underwear_metadata in pref.all_underwear))
			pref.all_underwear_metadata -= underwear_metadata

	if(!pref.backpack || !(pref.backpack.name in backpacks_by_name))
		pref.backpack = get_default_outfit_backpack()

	if(!istype(pref.backpack_metadata))
		pref.backpack_metadata = list()

	for(var/backpack_metadata_name in pref.backpack_metadata)
		if(!(backpack_metadata_name in backpacks_by_name))
			pref.backpack_metadata -= backpack_metadata_name

	for(var/backpack_name in backpacks_by_name)
		var/decl/backpack_outfit/backpack = backpacks_by_name69backpack_name69
		var/list/tweak_metadata = pref.backpack_metadata69"69backpack69"69
		if(tweak_metadata)
			for(var/tw in backpack.tweaks)
				var/datum/backpack_tweak/tweak = tw
				var/list/metadata = tweak_metadata69"69tweak69"69
				tweak_metadata69"69tweak69"69 = tweak.validate_metadata(metadata)


/datum/category_item/player_setup_item/physical/equipment/content()
	. = list()
	. += "<div style='clear: both;'"
	. += "<b>Equipment:</b><br>"
	for(var/datum/category_group/underwear/UWC in GLOB.underwear.categories)
		var/item_name = (pref.all_underwear && pref.all_underwear69UWC.name69) ? pref.all_underwear69UWC.name69 : "None"
		. += "69UWC.name69: <a href='?src=\ref69src69;change_underwear=69UWC.name69'><b>69item_name69</b></a>"

		var/datum/category_item/underwear/UWI = UWC.items_by_name69item_name69
		if(UWI)
			for(var/datum/gear_tweak/gt in UWI.tweaks)
				. += " <a href='?src=\ref69src69;underwear=69UWC.name69;tweak=\ref69gt69'>69gt.get_contents(get_underwear_metadata(UWC.name, gt))69</a>"

		. += "<br>"
	. += "Backpack Type: <a href='?src=\ref69src69;change_backpack=1'><b>69pref.backpack.name69</b></a>"
	for(var/datum/backpack_tweak/bt in pref.backpack.tweaks)
		. += " <a href='?src=\ref69src69;backpack=69pref.backpack.name69;tweak=\ref69bt69'>69bt.get_ui_content(get_backpack_metadata(pref.backpack, bt))69</a>"
	. += "<br>"
	. += "</div>"
	return jointext(.,null)

/datum/category_item/player_setup_item/physical/equipment/proc/get_underwear_metadata(var/underwear_category,69ar/datum/gear_tweak/gt)
	var/metadata = pref.all_underwear_metadata69underwear_category69
	if(!metadata)
		metadata = list()
		pref.all_underwear_metadata69underwear_category69 =69etadata

	var/tweak_data =69etadata69"69gt69"69
	if(!tweak_data)
		tweak_data = gt.get_default()
		metadata69"69gt69"69 = tweak_data
	return tweak_data

/datum/category_item/player_setup_item/physical/equipment/proc/get_backpack_metadata(var/decl/backpack_outfit/backpack_outfit,69ar/datum/backpack_tweak/bt)
	var/metadata = pref.backpack_metadata69backpack_outfit.name69
	if(!metadata)
		metadata = list()
		pref.backpack_metadata69backpack_outfit.name69 =69etadata

	var/tweak_data =69etadata69"69bt69"69
	if(!tweak_data)
		tweak_data = bt.get_default_metadata()
		metadata69"69bt69"69 = tweak_data
	return tweak_data

/datum/category_item/player_setup_item/physical/equipment/proc/set_underwear_metadata(var/underwear_category,69ar/datum/gear_tweak/gt,69ar/new_metadata)
	var/list/metadata = pref.all_underwear_metadata69underwear_category69
	metadata69"69gt69"69 = new_metadata

/datum/category_item/player_setup_item/physical/equipment/proc/set_backpack_metadata(var/decl/backpack_outfit/backpack_outfit,69ar/datum/backpack_tweak/bt,69ar/new_metadata)
	var/metadata = pref.backpack_metadata69backpack_outfit.name69
	metadata69"69bt69"69 = new_metadata

/datum/category_item/player_setup_item/physical/equipment/OnTopic(var/href,var/list/href_list,69ar/mob/user)
	if(href_list69"change_underwear"69)
		var/datum/category_group/underwear/UWC = GLOB.underwear.categories_by_name69href_list69"change_underwear"6969
		if(!UWC)
			return TOPIC_NOACTION
		var/datum/category_item/underwear/selected_underwear = input(user, "Choose underwear:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.all_underwear69UWC.name69) as null|anything in UWC.items
		if(selected_underwear && CanUseTopic(user))
			pref.all_underwear69UWC.name69 = selected_underwear.name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list69"underwear"69 && href_list69"tweak"69)
		var/underwear = href_list69"underwear"69
		if(!(underwear in pref.all_underwear))
			return TOPIC_NOACTION
		var/datum/gear_tweak/gt = locate(href_list69"tweak"69)
		if(!gt)
			return TOPIC_NOACTION
		var/new_metadata = gt.get_metadata(user, get_underwear_metadata(underwear, gt))
		if(new_metadata)
			set_underwear_metadata(underwear, gt, new_metadata)
			return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list69"change_backpack"69)
		var/new_backpack = input(user, "Choose backpack style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.backpack) as null|anything in backpacks_by_name
		if(!isnull(new_backpack) && CanUseTopic(user))
			pref.backpack = backpacks_by_name69new_backpack69
			return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list69"backpack"69 && href_list69"tweak"69)
		var/backpack_name = href_list69"backpack"69
		if(!(backpack_name in backpacks_by_name))
			return TOPIC_NOACTION
		var/decl/backpack_outfit/bo = backpacks_by_name69backpack_name69
		var/datum/backpack_tweak/bt = locate(href_list69"tweak"69) in bo.tweaks
		if(!bt)
			return TOPIC_NOACTION
		var/new_metadata = bt.get_metadata(user, get_backpack_metadata(bo, bt))
		if(new_metadata)
			set_backpack_metadata(bo, bt, new_metadata)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/physical/equipment/update_setup(var/savefile/preferences,69ar/savefile/character)
	if(preferences69"version"69  <= 16)
		var/list/old_index_to_backpack_type = list(
			/decl/backpack_outfit/nothing,
			/decl/backpack_outfit/backsport,
			/decl/backpack_outfit/backpack,
			/decl/backpack_outfit/duffelbag,
			/decl/backpack_outfit/satchel,
		)

		var/old_index
		from_file(character69"backbag"69, old_index)

		if(old_index > 0 && old_index <= old_index_to_backpack_type.len)
			pref.backpack = decls_repository.get_decl(old_index_to_backpack_type69old_index69)
		else
			pref.backpack = get_default_outfit_backpack()

		to_file(character69"backpack"69, pref.backpack.name)
		return 1
