#define BACKPACK_HAS_TYPE_SELECTION 1
#define BACKPACK_HAS_SUBTYPE_SELECTION 2

/*******************
* Outfit Backpacks *
*******************/

/* Setup new backpacks here */
/decl/backpack_outfit/nothing
	name = "Nothing"

/decl/backpack_outfit/nothing/spawn_backpack(var/location,69ar/metadata,69ar/desired_type)
	return

/decl/backpack_outfit/backpack
	name = "Backpack"
	path = /obj/item/storage/backpack

/decl/backpack_outfit/backsport
	name = "Sport Backpack"
	path = /obj/item/storage/backpack/sport

/decl/backpack_outfit/satchel
	name = "Satchel"
	path = /obj/item/storage/backpack/satchel
	is_default = TRUE

/decl/backpack_outfit/duffelbag
	name = "Duffelbag"
	path = /obj/item/storage/backpack/duffelbag

/decl/backpack_outfit/lootbag
	name = "Lootbag"
	path = /obj/item/storage/backpack/duffelbag/loot

/* Code */
/decl/backpack_outfit
	var/flags
	var/name
	var/path
	var/is_default = FALSE
	var/list/tweaks

/decl/backpack_outfit/New()
	tweaks = tweaks || list()

	if(FLAGS_EQUALS(flags, BACKPACK_HAS_TYPE_SELECTION|BACKPACK_HAS_SUBTYPE_SELECTION))
		CRASH("May not have both type and subtype selection tweaks")

	if(flags & BACKPACK_HAS_TYPE_SELECTION)
		tweaks += new/datum/backpack_tweak/selection/types(path)
	if(flags & BACKPACK_HAS_SUBTYPE_SELECTION)
		tweaks += new/datum/backpack_tweak/selection/subtypes(path)

/decl/backpack_outfit/proc/spawn_backpack(var/location,69ar/metadata,69ar/desired_type)
	metadata =69etadata || list()
	desired_type = desired_type || path
	for(var/t in tweaks)
		var/datum/backpack_tweak/bt = t
		var/tweak_metadata =69etadata69"69bt69"69 || bt.get_default_metadata()
		desired_type = bt.get_backpack_type(desired_type, tweak_metadata)

	. = new desired_type(location)

	for(var/t in tweaks)
		var/datum/backpack_tweak/bt = t
		var/tweak_metadata =69etadata69"69bt69"69
		bt.tweak_backpack(., tweak_metadata)

/******************
* Backpack Tweaks *
******************/
/datum/backpack_tweak/proc/get_ui_content(var/metadata)
	return ""

/datum/backpack_tweak/proc/get_default_metadata()
	return

/datum/backpack_tweak/proc/get_metadata(var/user,69ar/metadata,69ar/title = CHARACTER_PREFERENCE_INPUT_TITLE)
	return

/datum/backpack_tweak/proc/validate_metadata(var/metadata)
	return get_default_metadata()

/datum/backpack_tweak/proc/get_backpack_type(var/given_backpack_type)
	return given_backpack_type

/datum/backpack_tweak/proc/tweak_backpack(var/obj/item/storage/backpack/backpack,69ar/metadata)
	return


/* Selection Tweak */
/datum/backpack_tweak/selection
	var/const/RETURN_GIVEN_BACKPACK = "default"
	var/const/RETURN_RANDOM_BACKPACK = "random"
	var/list/selections

/datum/backpack_tweak/selection/New(var/list/selections)
	if(!selections.len)
		CRASH("No selections offered")
	if(RETURN_GIVEN_BACKPACK in selections)
		CRASH("May not use the keyword '69RETURN_GIVEN_BACKPACK69'")
	if(RETURN_RANDOM_BACKPACK in selections)
		CRASH("May not use the keyword '69RETURN_RANDOM_BACKPACK69'")
	var/list/duplicate_keys = duplicates(selections)
	if(duplicate_keys.len)
		CRASH("Duplicate names found: 69english_list(duplicate_keys)69")
	var/list/duplicate_values = duplicates(list_values(selections))
	if(duplicate_values.len)
		CRASH("Duplicate types found: 69english_list(duplicate_values)69")
	for(var/selection_key in selections)
		if(!istext(selection_key))
			CRASH("Expected a69alid selection key, was 69log_info_line(selection_key)69")
		var/selection_type = selections69selection_key69
		if(!ispath(selection_type, /obj/item/storage/backpack))
			CRASH("Expected a69alid selection69alue, was 69log_info_line(selection_type)69")

	src.selections = selections
	selections += RETURN_GIVEN_BACKPACK
	selections += RETURN_RANDOM_BACKPACK

/datum/backpack_tweak/selection/get_ui_content(var/metadata)
	return "Type: 69metadata69"

/datum/backpack_tweak/selection/get_default_metadata()
	return RETURN_GIVEN_BACKPACK

/datum/backpack_tweak/selection/validate_metadata(var/metadata)
	return (metadata in selections) ?69etadata : ..()

/datum/backpack_tweak/selection/get_metadata(var/user,69ar/metadata,69ar/title = CHARACTER_PREFERENCE_INPUT_TITLE)
	return input(user, "Choose a type.", title,69etadata) as null|anything in selections

/datum/backpack_tweak/selection/get_backpack_type(var/given_backpack_type,69ar/metadata)
	switch(metadata)
		if(RETURN_GIVEN_BACKPACK)
			return given_backpack_type
		if(RETURN_RANDOM_BACKPACK)
			var/random_choice = pick(selections - RETURN_RANDOM_BACKPACK)
			return get_backpack_type(given_backpack_type, random_choice)
		else
			return selections69metadata69

/datum/backpack_tweak/selection/types/New(var/selection_type)
	..(atomtype2nameassoclist(selection_type))

/datum/backpack_tweak/selection/subtypes/New(var/selection_type)
	..(atomtypes2nameassoclist(subtypesof(selection_type)))

/datum/backpack_tweak/selection/specified_types_as_list/New(var/selection_list)
	..(atomtypes2nameassoclist(selection_list))

/datum/backpack_tweak/selection/specified_types_as_args/New()
	..(atomtypes2nameassoclist(args))

/******************
* Character setup *
*******************/
/datum/backpack_setup
	var/decl/backpack_outfit/backpack
	var/metadata

/datum/backpack_setup/New(var/backpack,69ar/metadata)
	src.backpack = backpack
	src.metadata =69etadata

/**********
* Helpers *
**********/
/proc/get_default_outfit_backpack()
	var backpacks = decls_repository.get_decls_of_subtype(/decl/backpack_outfit)
	for(var/backpack in backpacks)
		var/decl/backpack_outfit/bo = backpacks69backpack69
		if(bo.is_default)
			return bo

#undef BACKPACK_HAS_TYPE_SELECTION
#undef BACKPACK_HAS_SUBTYPE_SELECTION
