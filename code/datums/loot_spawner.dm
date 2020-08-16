/datum/loot_spawner_data
	var/list/all_spawn_list_by_price = list()
	var/list/all_spawn_list_blacklist = list()
	var/list/all_spawn_list_by_frequency = list()
	var/list/all_spawn_list_by_rarity = list()
	var/list/all_spawn_list_with_accompanying_obj = list()
	var/list/all_spawn_list_by_tag = list()

/datum/loot_spawner_data/New()
	var/list/paths = list()

	//spawn vars
	var/price
	var/rarity
	var/frequency
	var/blacklisted
	var/list/spawn_tags = list()
	var/list/accompanying_obj = list()
	var/list/bad_types = list()

	//Initialise all items, mobs and machinery
	paths = subtypesof(/obj/item)
	paths += subtypesof(/mob/living)
	paths += subtypesof(/obj/machinery)
	for(var/path in paths)
		var/atom/movable/A = path
		bad_types = initial(A.bad_types)
		price = initial(A.price_tag)
		rarity = initial(A.rarity_value)
		blacklisted = initial(A.spawn_blacklisted)
		frequency = initial(A.spawn_frequency)
		spawn_tags = initial(A.spawn_tags)
		accompanying_obj = initial(A.accompanying_object)

		if(islist(bad_types))
			if(bad_types.len && (path in bad_types))
				continue

		all_spawn_list_by_price["[price]"] += list(path)
		all_spawn_list_by_frequency["[frequency]"] += list(path)
		all_spawn_list_by_rarity["[rarity]"] += list(path)
		if(blacklisted)
			all_spawn_list_blacklist += path
		if(islist(accompanying_obj))
			if(accompanying_obj.len)
				all_spawn_list_with_accompanying_obj += path
		if(islist(spawn_tags))
			if(spawn_tags.len)
				for(var/tag in spawn_tags)
					all_spawn_list_by_tag[tag] += list(path)



