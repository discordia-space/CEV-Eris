var/list/loadout_categories = list()
var/list/gear_datums = list()

/datum/preferences
	var/list/gear_list //Custom/fluff item loadouts.
	var/gear_slot = 1  //The current gear save slot

/datum/preferences/proc/Gear()
	return gear_list69gear_slot69

/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/loadout_category/New(var/cat)
	category = cat
	..()

/hook/startup/proc/populate_gear_list()

	//create a list of gear datums to sort
	for(var/geartype in subtypesof(/datum/gear))
		var/datum/gear/G = geartype
		if(initial(G.category) == geartype)
			continue
		if(GLOB.maps_data.loadout_blacklist && (geartype in GLOB.maps_data.loadout_blacklist))
			continue

		var/use_name = initial(G.display_name)
		var/use_category = initial(G.sort_category)

		if(!loadout_categories69use_category69)
			loadout_categories69use_category69 = new /datum/loadout_category(use_category)
		var/datum/loadout_category/LC = loadout_categories69use_category69
		gear_datums69use_name69 = new geartype
		LC.gear69use_name69 = gear_datums69use_name69

	loadout_categories = sortAssoc(loadout_categories)
	for(var/loadout_category in loadout_categories)
		var/datum/loadout_category/LC = loadout_categories69loadout_category69
		LC.gear = sortAssoc(LC.gear)
	return 1

/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	sort_order = 1
	var/current_tab = "General"
	var/hide_unavailable_gear = 0

/datum/category_item/player_setup_item/loadout/load_character(var/savefile/S)
	from_file(S69"gear_list"69, pref.gear_list)
	from_file(S69"gear_slot"69, pref.gear_slot)

/datum/category_item/player_setup_item/loadout/save_character(var/savefile/S)
	to_file(S69"gear_list"69, pref.gear_list)
	to_file(S69"gear_slot"69, pref.gear_slot)

/datum/category_item/player_setup_item/loadout/proc/valid_gear_choices(var/max_cost)
	. = list()
	var/mob/preference_mob = preference_mob()
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums69gear_name69
		var/okay = 1
		if(G.whitelisted && preference_mob)
			okay = 0
			// TODO: enable after baymed
			/*for(var/species in G.whitelisted)
				if(is_species_whitelisted(preference_mob, species))
					okay = 1
					break
					*/
		if(!okay)
			continue
		if(max_cost && G.cost >69ax_cost)
			continue
		. += gear_name

/datum/category_item/player_setup_item/loadout/sanitize_character()
	pref.gear_slot = sanitize_integer(pref.gear_slot, 1, config.loadout_slots, initial(pref.gear_slot))
	if(!islist(pref.gear_list)) pref.gear_list = list()

	if(pref.gear_list.len < config.loadout_slots)
		pref.gear_list.len = config.loadout_slots

	for(var/index = 1 to config.loadout_slots)
		var/list/gears = pref.gear_list69index69

		if(istype(gears))
			for(var/gear_name in gears)
				if(!(gear_name in gear_datums))
					gears -= gear_name

			var/total_cost = 0
			for(var/gear_name in gears)
				if(!gear_datums69gear_name69)
					gears -= gear_name
				else if(!(gear_name in69alid_gear_choices()))
					gears -= gear_name
				else
					var/datum/gear/G = gear_datums69gear_name69
					if(total_cost + G.cost > config.max_gear_cost)
						gears -= gear_name
					else
						total_cost += G.cost
		else
			pref.gear_list69index69 = list()

/datum/category_item/player_setup_item/loadout/content(var/mob/user)
	if(!pref.preview_icon)
		pref.update_preview_icon()
	if(pref.preview_north && pref.preview_south && pref.preview_west)
		user << browse_rsc(pref.preview_north, "new_previewicon69NORTH69.png")
		user << browse_rsc(pref.preview_south, "new_previewicon69SOUTH69.png")
		user << browse_rsc(pref.preview_west, "new_previewicon69WEST69.png")
	. = list()
	var/total_cost = 0
	var/list/gears = pref.gear_list69pref.gear_slot69
	for(var/i = 1; i <= gears.len; i++)
		var/datum/gear/G = gear_datums69gears69i6969
		if(G)
			total_cost += G.cost

	var/fcolor =  "#3366cc"
	if(total_cost < config.max_gear_cost)
		fcolor = "#e67300"
	. += "<table align = 'center' width = 100%>"
	. += "<tr><td colspan=3><center>"
	. += "<a href='?src=\ref69src69;prev_slot=1'>\<\<</a><b><font color = '69fcolor69'>\6969pref.gear_slot69\69</font> </b><a href='?src=\ref69src69;next_slot=1'>\>\></a>"

	if(config.max_gear_cost < INFINITY)
		. += "<b><font color = '69fcolor69'>69total_cost69/69config.max_gear_cost69</font> loadout points spent.</b>"

	. += "<a href='?src=\ref69src69;clear_loadout=1'>Clear Loadout</a>"
	. += "<a href='?src=\ref69src69;toggle_hiding=1'>69hide_unavailable_gear ? "Show all" : "Hide unavailable"69</a></center></td></tr>"

	. += "<tr><td colspan=3><center><b>"
	var/firstcat = 1
	for(var/category in loadout_categories)

		if(firstcat)
			firstcat = 0
		else
			. += " |"

		var/datum/loadout_category/LC = loadout_categories69category69
		var/category_cost = 0
		for(var/gear in LC.gear)
			if(gear in pref.gear_list69pref.gear_slot69)
				var/datum/gear/G = LC.gear69gear69
				category_cost += G.cost

		if(category == current_tab)
			. += " <span class='linkOn'>69category69 - 69category_cost69</span> "
		else
			if(category_cost)
				. += " <a href='?src=\ref69src69;select_category=69category69'><font color = '#e67300'>69category69 - 69category_cost69</font></a> "
			else
				. += " <a href='?src=\ref69src69;select_category=69category69'>69category69 - 0</a> "
	. += "<div class='statusDisplay' style = 'max-width: 192px; clear:both;'><img src=new_previewicon69SOUTH69.png width=64 height=64><img src=new_previewicon69WEST69.png width=64 height=64><img src=new_previewicon69NORTH69.png width=64 height=64></div>"
	. += "</b></center></td></tr>"

	var/datum/loadout_category/LC = loadout_categories69current_tab69
	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>69LC.category69</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"
	var/jobs = list()
	if(SSjob)
		for(var/job_title in (pref.job_medium|pref.job_low|pref.job_high))
			var/datum/job/J = SSjob.GetJob(job_title)
			if(J)
				dd_insertObjectList(jobs, J)
	for(var/gear_name in LC.gear)
		if(!(gear_name in69alid_gear_choices()))
			continue
		var/list/entry = list()
		var/datum/gear/G = LC.gear69gear_name69
		var/ticked = (G.display_name in pref.gear_list69pref.gear_slot69)
		entry += "<tr style='vertical-align:top;'><td width=25%><a style='white-space:normal;' 69ticked ? "class='linkOn' " : ""69href='?src=\ref69src69;toggle_gear=69G.display_name69'>69G.display_name69</a></td>"
		entry += "<td width = 10% style='vertical-align:top'>69G.cost69</td>"
		entry += "<td><font size=2>69G.get_description(get_gear_metadata(G,1))69</font>"
		var/allowed = 1
		if(allowed && G.allowed_roles)
			var/good_job = 0
			var/bad_job = 0
			entry += "<br><i>"
			var/ind = 0
			for(var/datum/job/J in jobs)
				++ind
				if(ind > 1)
					entry += ", "
				if(J.title in G.allowed_roles)
					entry += "<font color=55cc55>69J.title69</font>"
					good_job = 1
				else
					entry += "<font color=cc5555>69J.title69</font>"
					bad_job = 1
			allowed = good_job || !bad_job
			entry += "</i>"
		entry += "</tr>"
		if(ticked)
			entry += "<tr><td colspan=3>"
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				entry += " <a href='?src=\ref69src69;gear=69G.display_name69;tweak=\ref69tweak69'>69tweak.get_contents(get_tweak_metadata(G, tweak))69</a>"
			entry += "</td></tr>"
		if(!hide_unavailable_gear || allowed || ticked)
			. += entry
	. += "</table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/loadout/proc/get_gear_metadata(var/datum/gear/G,69ar/readonly)
	var/list/gear = pref.gear_list69pref.gear_slot69
	. = gear69G.display_name69
	if(!.)
		. = list()
		if(!readonly)
			gear69G.display_name69 = .

/datum/category_item/player_setup_item/loadout/proc/get_tweak_metadata(var/datum/gear/G,69ar/datum/gear_tweak/tweak)
	var/list/metadata = get_gear_metadata(G)
	. =69etadata69"69tweak69"69
	if(!.)
		. = tweak.get_default()
		metadata69"69tweak69"69 = .

/datum/category_item/player_setup_item/loadout/proc/set_tweak_metadata(var/datum/gear/G,69ar/datum/gear_tweak/tweak,69ar/new_metadata)
	var/list/metadata = get_gear_metadata(G)
	metadata69"69tweak69"69 = new_metadata

/datum/category_item/player_setup_item/loadout/OnTopic(href, href_list, user)
	if(href_list69"toggle_gear"69)
		var/datum/gear/TG = gear_datums69href_list69"toggle_gear"6969
		if(!TG)
			return TOPIC_REFRESH
		if(TG.display_name in pref.gear_list69pref.gear_slot69)
			pref.gear_list69pref.gear_slot69 -= TG.display_name
		else
			var/total_cost = 0
			for(var/gear_name in pref.gear_list69pref.gear_slot69)
				var/datum/gear/G = gear_datums69gear_name69
				if(istype(G)) total_cost += G.cost
			if((total_cost+TG.cost) <= config.max_gear_cost)
				pref.gear_list69pref.gear_slot69 += TG.display_name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list69"gear"69 && href_list69"tweak"69)
		var/datum/gear/gear = gear_datums69href_list69"gear"6969
		var/datum/gear_tweak/tweak = locate(href_list69"tweak"69)
		if(!tweak || !istype(gear) || !(tweak in gear.gear_tweaks))
			return TOPIC_NOACTION
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
		if(!metadata || !CanUseTopic(user))
			return TOPIC_NOACTION
		set_tweak_metadata(gear, tweak,69etadata)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list69"next_slot"69)
		pref.gear_slot = pref.gear_slot+1
		if(pref.gear_slot > config.loadout_slots)
			pref.gear_slot = 1
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list69"prev_slot"69)
		pref.gear_slot = pref.gear_slot-1
		if(pref.gear_slot < 1)
			pref.gear_slot = config.loadout_slots
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list69"select_category"69)
		current_tab = href_list69"select_category"69
		return TOPIC_REFRESH
	if(href_list69"clear_loadout"69)
		var/list/gear = pref.gear_list69pref.gear_slot69
		gear.Cut()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list69"toggle_hiding"69)
		hide_unavailable_gear = !hide_unavailable_gear
		return TOPIC_REFRESH
	return ..()

/datum/category_item/player_setup_item/loadout/update_setup(var/savefile/preferences,69ar/savefile/character)
	if(preferences69"version"69 < 14)
		var/list/old_gear = character69"gear"69
		if(istype(old_gear)) // During updates data isn't sanitized yet, we have to do69anual checks
			if(!istype(pref.gear_list)) pref.gear_list = list()
			if(!pref.gear_list.len) pref.gear_list.len++
			pref.gear_list69169 = old_gear
		return 1

	if(preferences69"version"69 < 15)
		if(istype(pref.gear_list))
			// Checks if the key of the pref.gear_list is a list.
			// If not the key is replaced with the corresponding69alue.
			// This will convert the loadout slot data to a reasonable and (more importantly) compatible format.
			// I.e. list("1" = loadout_data1, "2" = loadout_data2, "3" = loadout_data3) becomes list(loadout_data1, loadout_data2, loadaout_data3)
			for(var/index = 1 to pref.gear_list.len)
				var/key = pref.gear_list69index69
				if(islist(key))
					continue
				var/value = pref.gear_list69key69
				pref.gear_list69index69 =69alue
		return 1

/datum/gear
	var/display_name       //Name/index.69ust be unique.
	var/description        //Description of this gear. If left blank will default to the description of the pathed item.
	var/path               //Path to item.
	var/cost = 1           //Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/list/allowed_branches //Service branches that can spawn with it.
	var/whitelisted        //Term to check the whitelist for..
	var/sort_category = "General"
	var/flags              //Special tweaks in new
	var/category
	var/list/gear_tweaks = list() //List of datums which will alter the item after it has been spawned.

/datum/gear/New()
	if(FLAGS_EQUALS(flags, GEAR_HAS_TYPE_SELECTION|GEAR_HAS_SUBTYPE_SELECTION))
		CRASH("May not have both type and subtype selection tweaks")
	if(!description)
		var/obj/O = path
		description = initial(O.desc)
	if(flags & GEAR_HAS_COLOR_SELECTION)
		gear_tweaks += gear_tweak_free_color_choice()
	if(flags & GEAR_HAS_TYPE_SELECTION)
		gear_tweaks += new/datum/gear_tweak/path/type(path)
	if(flags & GEAR_HAS_SUBTYPE_SELECTION)
		gear_tweaks += new/datum/gear_tweak/path/subtype(path)

/datum/gear/proc/get_description(var/metadata)
	. = description
	for(var/datum/gear_tweak/gt in gear_tweaks)
		. = gt.tweak_description(.,69etadata69"69gt69"69)

/datum/gear_data
	var/path
	var/location

/datum/gear_data/New(var/path,69ar/location)
	src.path = path
	src.location = location

/datum/gear/proc/spawn_item(var/location,69ar/metadata)
	var/datum/gear_data/gd = new(path, location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_gear_data(metadata &&69etadata69"69gt69"69, gd)
	var/item = new gd.path(gd.location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_item(item,69etadata &&69etadata69"69gt69"69)
	return item

/datum/gear/proc/spawn_on_mob(var/mob/living/carbon/human/H,69ar/metadata)
	var/obj/item/item = spawn_item(H,69etadata)
	if(SSinventory.initialized && H.replace_in_slot(item, slot, put_in_storage = TRUE, skip_covering_check = TRUE, del_if_failed_to_equip = TRUE))
		if(istype(item, /obj/item/clothing/under))
			// this69eans we replaced jumpsuit and all items inside now on the floor
			// so we need to pick them up
			for(var/obj/item/I in get_turf(H))
				H.equip_to_appropriate_slot(I)
		to_chat(H, "<span class='notice'>Equipping you with \the 69item69!</span>")
		. = item

/datum/gear/proc/spawn_in_storage_or_drop(var/mob/living/carbon/human/H,69ar/metadata)
	var/obj/item/item = spawn_item(H,69etadata)
	item.add_fingerprint(H)

	var/atom/placed_in = H.equip_to_storage(item)
	if(placed_in)
		to_chat(H, "<span class='notice'>Placing \the 69item69 in your 69placed_in.name69!</span>")
	else if(H.equip_to_appropriate_slot(item))
		to_chat(H, "<span class='notice'>Placing \the 69item69 in your inventory!</span>")
	else if(H.put_in_hands(item))
		to_chat(H, "<span class='notice'>Placing \the 69item69 in your hands!</span>")
	else
		to_chat(H, "<span class='danger'>Dropping \the 69item69 on the ground!</span>")