/datum/gear_tweak/proc/get_contents(var/metadata)
	return

/datum/gear_tweak/proc/get_metadata(var/user,69ar/list/metadata,69ar/title)
	return

/datum/gear_tweak/proc/get_default()
	return

/datum/gear_tweak/proc/tweak_gear_data(var/metadata,69ar/datum/gear_data)
	return

/datum/gear_tweak/proc/tweak_item(var/obj/item/I,69ar/metadata)
	return

/datum/gear_tweak/proc/tweak_description(var/description,69ar/metadata)
	return description

/*
* Color adjustment
*/

/datum/gear_tweak/color
	var/list/valid_colors

/datum/gear_tweak/color/New(var/list/valid_colors)
	src.valid_colors =69alid_colors
	..()

/datum/gear_tweak/color/get_contents(var/metadata)
	return "Color: <font color='69metadata69'>&#9899;</font>"

/datum/gear_tweak/color/get_default()
	return69alid_colors ?69alid_colors69169 : COLOR_WHITE

/datum/gear_tweak/color/get_metadata(var/user,69ar/metadata,69ar/title = CHARACTER_PREFERENCE_INPUT_TITLE)
	if(valid_colors)
		return input(user, "Choose a color.", title,69etadata) as null|anything in69alid_colors
	return input(user, "Choose a color.", title,69etadata) as color|null

/datum/gear_tweak/color/tweak_item(var/obj/item/I,69ar/metadata)
	if(valid_colors && !(metadata in69alid_colors))
		return
	I.color = sanitize_hexcolor(metadata, I.color)

/*
* Path adjustment
*/

/datum/gear_tweak/path
	var/list/valid_paths

/datum/gear_tweak/path/New(var/list/valid_paths)
	if(!valid_paths.len)
		CRASH("No type paths given")
	var/list/duplicate_keys = duplicates(valid_paths)
	if(duplicate_keys.len)
		CRASH("Duplicate names found: 69english_list(duplicate_keys)69")
	var/list/duplicate_values = duplicates(list_values(valid_paths))
	if(duplicate_values.len)
		CRASH("Duplicate types found: 69english_list(duplicate_values)69")
	for(var/path_name in69alid_paths)
		if(!istext(path_name))
			CRASH("Expected a text key, was 69log_info_line(path_name)69")
		var/selection_type =69alid_paths69path_name69
		if(!ispath(selection_type, /obj/item))
			CRASH("Expected an /obj/item path, was 69log_info_line(selection_type)69")
	src.valid_paths = sortAssoc(valid_paths)

/datum/gear_tweak/path/type/New(var/type_path)
	..(atomtype2nameassoclist(type_path))

/datum/gear_tweak/path/subtype/New(var/type_path)
	..(atomtypes2nameassoclist(subtypesof(type_path)))

/datum/gear_tweak/path/specified_types_list/New(var/type_paths)
	..(atomtypes2nameassoclist(type_paths))

/datum/gear_tweak/path/specified_types_args/New()
	..(atomtypes2nameassoclist(args))

/datum/gear_tweak/path/get_contents(var/metadata)
	return "Type: 69metadata69"

/datum/gear_tweak/path/get_default()
	return69alid_paths69169

/datum/gear_tweak/path/get_metadata(var/user,69ar/list/metadata,69ar/title)
	return input(user, "Choose a type.", CHARACTER_PREFERENCE_INPUT_TITLE,69etadata) as null|anything in69alid_paths

/datum/gear_tweak/path/tweak_gear_data(var/metadata,69ar/datum/gear_data/gear_data)
	if(!(metadata in69alid_paths))
		return
	gear_data.path =69alid_paths69metadata69

/datum/gear_tweak/path/tweak_description(var/description,69ar/metadata)
	if(!(metadata in69alid_paths))
		return ..()
	var/obj/O =69alid_paths69metadata69
	return initial(O.desc) || description

/*
* Content adjustment
*/

/datum/gear_tweak/contents
	var/list/valid_contents

/datum/gear_tweak/contents/New()
	valid_contents = args.Copy()
	..()

/datum/gear_tweak/contents/get_contents(var/metadata)
	return "Contents: 69english_list(metadata, and_text = ", ")69"

/datum/gear_tweak/contents/get_default()
	. = list()
	for(var/i = 1 to69alid_contents.len)
		. += "Random"

/datum/gear_tweak/contents/get_metadata(var/user,69ar/list/metadata,69ar/title)
	. = list()
	for(var/i =69etadata.len to (valid_contents.len - 1))
		metadata += "Random"
	for(var/i = 1 to69alid_contents.len)
		var/entry = input(user, "Choose an entry.", CHARACTER_PREFERENCE_INPUT_TITLE,69etadata69i69) as null|anything in (valid_contents69i69 + list("Random", "None"))
		if(entry)
			. += entry
		else
			return69etadata

/datum/gear_tweak/contents/tweak_item(var/obj/item/I,69ar/list/metadata)
	if(length(metadata) != length(valid_contents))
		return
	for(var/i = 1 to69alid_contents.len)
		var/path
		var/list/contents =69alid_contents69i69
		if(metadata69i69 == "Random")
			path = pick(contents)
			path = contents69path69
		else if(metadata69i69 == "None")
			continue
		else
			path = 	contents69metadata69i6969
		if(path)
			new path(I)
		else
			log_debug("Failed to tweak item: Index 69i69 in 69json_encode(metadata)69 did not result in a69alid path.69alid contents: 69json_encode(valid_contents)69")

/*
* Ragent adjustment
*/

/datum/gear_tweak/reagents
	var/list/valid_reagents

/datum/gear_tweak/reagents/New(var/list/reagents)
	valid_reagents = reagents.Copy()
	..()

/datum/gear_tweak/reagents/get_contents(var/metadata)
	return "Reagents: 69metadata69"

/datum/gear_tweak/reagents/get_default()
	return "Random"

/datum/gear_tweak/reagents/get_metadata(var/user,69ar/list/metadata,69ar/title)
	. = input(user, "Choose an entry.", CHARACTER_PREFERENCE_INPUT_TITLE,69etadata) as null|anything in (valid_reagents + list("Random", "None"))
	if(!.)
		return69etadata

/datum/gear_tweak/reagents/tweak_item(var/obj/item/I,69ar/list/metadata)
	if(metadata == "None")
		return
	var/reagent
	if(metadata == "Random")
		reagent =69alid_reagents69pick(valid_reagents)69
	else
		reagent =69alid_reagents69metadata69
	if(reagent)
		return I.reagents.add_reagent(reagent, I.reagents.get_free_space())

/datum/gear_tweak/tablet
	var/list/ValidProcessors = list(/obj/item/computer_hardware/processor_unit/small)
	var/list/ValidBatteries = list(/obj/item/cell/small, /obj/item/cell/small/high, /obj/item/cell/small/super)
	var/list/ValidHardDrives = list(/obj/item/computer_hardware/hard_drive/micro, /obj/item/computer_hardware/hard_drive/small, /obj/item/computer_hardware/hard_drive)
	var/list/ValidNetworkCards = list(/obj/item/computer_hardware/network_card, /obj/item/computer_hardware/network_card/advanced)
	var/list/ValidPrinters = list(null, /obj/item/computer_hardware/printer)
	var/list/ValidCardSlots = list(null, /obj/item/computer_hardware/card_slot)
	var/list/ValidTeslaLinks = list(null, /obj/item/computer_hardware/tesla_link)

/datum/gear_tweak/tablet/get_contents(var/list/metadata)
	var/list/names = list()
	var/obj/O =69alidProcessors69metadata6916969
	if(O)
		names += initial(O.name)
	O =69alidBatteries69metadata6926969
	if(O)
		names += initial(O.name)
	O =69alidHardDrives69metadata6936969
	if(O)
		names += initial(O.name)
	O =69alidNetworkCards69metadata6946969
	if(O)
		names += initial(O.name)
	O =69alidPrinters69metadata6956969
	if(O)
		names += initial(O.name)
	O =69alidCardSlots69metadata6966969
	if(O)
		names += initial(O.name)
	O =69alidTeslaLinks69metadata6976969
	if(O)
		names += initial(O.name)
	return "69english_list(names, and_text = ", ")69"

/datum/gear_tweak/tablet/get_metadata(var/user,69ar/list/metadata,69ar/title)
	. = list()

	var/list/names = list()
	var/counter = 1
	for(var/i in69alidProcessors)
		if(i)
			var/obj/O = i
			names69initial(O.name)69 = counter++
		else
			names69"None"69 = counter++

	var/entry = input(user, "Choose a processor.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names69entry69

	names = list()
	counter = 1
	for(var/i in69alidBatteries)
		if(i)
			var/obj/O = i
			names69initial(O.name)69 = counter++
		else
			names69"None"69 = counter++

	entry = input(user, "Choose a battery.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names69entry69

	names = list()
	counter = 1
	for(var/i in69alidHardDrives)
		if(i)
			var/obj/O = i
			names69initial(O.name)69 = counter++
		else
			names69"None"69 = counter++

	entry = input(user, "Choose a hard drive.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names69entry69

	names = list()
	counter = 1
	for(var/i in69alidNetworkCards)
		if(i)
			var/obj/O = i
			names69initial(O.name)69 = counter++
		else
			names69"None"69 = counter++

	entry = input(user, "Choose a network card.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names69entry69

	names = list()
	counter = 1
	for(var/i in69alidPrinters)
		if(i)
			var/obj/O = i
			names69initial(O.name)69 = counter++
		else
			names69"None"69 = counter++

	entry = input(user, "Choose a printer.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names69entry69

	names = list()
	counter = 1
	for(var/i in69alidCardSlots)
		if(i)
			var/obj/O = i
			names69initial(O.name)69 = counter++
		else
			names69"None"69 = counter++

	entry = input(user, "Choose a card slot.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names69entry69

	names = list()
	counter = 1
	for(var/i in69alidTeslaLinks)
		if(i)
			var/obj/O = i
			names69initial(O.name)69 = counter++
		else
			names69"None"69 = counter++

	entry = input(user, "Choose a tesla link.", CHARACTER_PREFERENCE_INPUT_TITLE) in names
	. += names69entry69

/datum/gear_tweak/tablet/get_default()
	. = list()
	for(var/i in 1 to TWEAKABLE_COMPUTER_PART_SLOTS)
		. += 1

/datum/gear_tweak/tablet/tweak_item(var/obj/item/modular_computer/tablet/I,69ar/list/metadata)
	if(length(metadata) < TWEAKABLE_COMPUTER_PART_SLOTS)
		return
	if(ValidProcessors69metadata6916969)
		var/t =69alidProcessors69metadata6916969
		I.processor_unit = new t(I)
	if(ValidBatteries69metadata6926969)
		var/t =69alidBatteries69metadata6926969
		I.cell = new t(I)
		I.cell.charge = I.cell.maxcharge
	if(ValidHardDrives69metadata6936969)
		var/t =69alidHardDrives69metadata6936969
		I.hard_drive = new t(I)
	if(ValidNetworkCards69metadata6946969)
		var/t =69alidNetworkCards69metadata6946969
		I.network_card = new t(I)
	if(ValidPrinters69metadata6956969)
		var/t =69alidPrinters69metadata6956969
		I.printer = new t(I)
	if(ValidCardSlots69metadata6966969)
		var/t =69alidCardSlots69metadata6966969
		I.card_slot = new t(I)
	if(ValidTeslaLinks69metadata6976969)
		var/t =69alidTeslaLinks69metadata6976969
		I.tesla_link = new t(I)
