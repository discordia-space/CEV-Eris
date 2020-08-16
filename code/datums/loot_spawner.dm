/datum/loot_spawner_data
	var/list/all_spawn_list_by_price = list()
	var/list/all_spawn_list_blacklist = list()
	var/list/all_spawn_list_by_frequency = list()
	var/list/all_spawn_list_by_rarity = list()
	var/list/all_spawn_accompanying_obj_by_path = list()
	var/list/all_spawn_list_by_tag = list()
	var/list/all_spawn_bad_paths = list()

/datum/loot_spawner_data/New()
	var/list/paths = list()

	//spawn vars
	var/price
	var/rarity
	var/frequency
	var/blacklisted
	var/list/spawn_tags = list()
	var/list/accompanying_obj_text = list()
	var/list/accompanying_obj_paths = list()
	var/list/bad_paths_text = list()
	var/list/bad_paths = list()

	//Initialise all items, mobs and machinery
	paths = subtypesof(/obj/item)
	paths += subtypesof(/mob/living)
	paths += subtypesof(/obj/machinery)
	for(var/path in paths)
		var/atom/movable/A = path
		bad_paths_text = splittext(initial(A.bad_types), ",")
		if(bad_paths_text.len)
			for(var/bad_path_text in bad_paths_text)
				bad_paths += text2path(bad_path_text)
		if(bad_paths.len)
			for(var/bad_path in bad_paths)
				if(!(bad_path in all_spawn_bad_paths))
					all_spawn_bad_paths += bad_path
		if(path in all_spawn_bad_paths)
			continue

		price = initial(A.price_tag)
		rarity = initial(A.rarity_value)
		blacklisted = initial(A.spawn_blacklisted)
		frequency = initial(A.spawn_frequency)
		spawn_tags = splittext(initial(A.spawn_tags), ",")

		accompanying_obj_text = splittext(initial(A.accompanying_object), ",")
		if(accompanying_obj_text.len)
			for(var/obj_text in accompanying_obj_text)
				accompanying_obj_paths += text2path(obj_text)
		if(accompanying_obj_paths.len)
			for(var/obj_path in accompanying_obj_paths)
				all_spawn_accompanying_obj_by_path[path] = obj_path

		all_spawn_list_by_price["[price]"] += list(path)
		all_spawn_list_by_frequency["[frequency]"] += list(path)
		all_spawn_list_by_rarity["[rarity]"] += list(path)
		if(blacklisted)
			all_spawn_list_blacklist += path
		if(spawn_tags.len)
			for(var/tag in spawn_tags)
				all_spawn_list_by_tag[tag] += list(path)



