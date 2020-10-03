/datum/loot_spawner_data
	//var/list/all_spawn_bad_paths = list()
	var/list/all_spawn_blacklist = list()//soft
	//var/list/all_spawn_by_price = list()
	var/list/all_price_by_path = list()
	//var/list/all_spawn_by_frequency = list()
	//var/list/all_spawn_frequency_by_path = list()
	//var/list/all_spawn_by_rarity = list()
	//var/list/all_spawn_rarity_by_path = list()
	var/list/all_spawn_by_tag = list()
	var/list/all_spawn_by_spawn_value = list()
	var/list/all_spawn_accompanying_obj_by_path = list()

/datum/loot_spawner_data/New()
	var/list/paths = list()

	//spawn vars
	var/price
	var/rarity
	var/frequency
	var/blacklisted
	var/list/bad_paths = list()
	var/list/spawn_tags = list()
	var/list/accompanying_objs = list()

	//Initialise all paths
	paths = subtypesof(/obj/item) - typesof(/obj/item/projectile)
	paths += subtypesof(/mob/living)
	paths += subtypesof(/obj/machinery)
	paths += subtypesof(/obj/structure)
	paths += subtypesof(/obj/spawner)
	paths += subtypesof(/obj/effect)

	for(var/path in paths)
		var/atom/movable/A = path
		var/bad_path = initial(A.bad_type)
		if(!(bad_path in bad_paths))
			ASSERT(ispath(bad_path) || !bad_path)
			bad_paths += list(bad_path)

		if(path in bad_paths)
			continue

		spawn_tags = splittext(initial(A.spawn_tags), ",")

		if(!spawn_tags.len)
			continue
		//tags//
		for(var/tag in spawn_tags)
			all_spawn_by_tag[tag] += list(path)

		//price//
		price = initial(A.price_tag)
		//all_spawn_by_price["[price]"] += list(path)
		all_price_by_path[path] = price

		//frequency
		frequency = initial(A.spawn_frequency)
		//all_spawn_by_frequency["[frequency]"] += list(path)
		//all_spawn_frequency_by_path[path] = frequency

		//rarity//
		rarity = initial(A.rarity_value)
		ASSERT(rarity >= 1)
		//all_spawn_by_rarity["[rarity]"] += list(path)
		//all_spawn_rarity_by_path[path] = rarity

		//spawn_value//
		all_spawn_by_spawn_value[path] = 10 * frequency/rarity

		//blacklisted//
		blacklisted = initial(A.spawn_blacklisted)
		if(blacklisted)
			all_spawn_blacklist += path

		accompanying_objs = initial(A.accompanying_object)
		if(istext(accompanying_objs))
			accompanying_objs = splittext(accompanying_objs, ",")
			if(accompanying_objs.len)
				var/list/temp_list = accompanying_objs
				accompanying_objs = list()
				for(var/obj_text in temp_list)
					accompanying_objs += text2path(obj_text)
		else if(ispath(accompanying_objs))
			accompanying_objs = list(accompanying_objs)
		if(islist(accompanying_objs) && accompanying_objs.len)
			for(var/obj_path in accompanying_objs)
				if(!ispath(obj_path))
					continue
				all_spawn_accompanying_obj_by_path[path] += list(obj_path)
		if(!all_spawn_accompanying_obj_by_path[path])
			if(ispath(path, /obj/item/weapon/gun/energy))
				var/obj/item/weapon/gun/energy/E = A
				if(!initial(E.use_external_power) && !initial(E.self_recharge))
					all_spawn_accompanying_obj_by_path[path] += list(initial(E.suitable_cell))
			else if(ispath(path, /obj/item/weapon/gun/projectile))
				var/obj/item/weapon/gun/projectile/P = A
				if(initial(P.magazine_type))
					all_spawn_accompanying_obj_by_path[path] += list(initial(P.magazine_type))

/datum/loot_spawner_data/proc/spawn_by_tag(list/tags)
	var/list/things = list()
	for(var/tag in tags)
		if(all_spawn_by_tag["[tag]"] in things)
			continue
		things += all_spawn_by_tag["[tag]"]
	return things

/datum/loot_spawner_data/proc/spawns_lower_price(list/paths, price)
	//if(!paths || !paths.len || !price) //NOPE
	//	return
	var/list/things = list()
	for(var/path in paths)
		if(all_price_by_path[path] < price)
			things += path
	return things

/datum/loot_spawner_data/proc/spawns_upper_price(list/paths, price)
	//if(!paths || !paths.len || !price) //NOPE
	//	return
	var/list/things = list()
	for(var/path in paths)
		if(all_price_by_path[path] > price)
			things += path
	return things

/datum/loot_spawner_data/proc/pick_spawn(list/paths)
	//if(!paths || !paths.len) //NOPE
		//return
	var/list/things = list()
	var/list/values = list()
	for(var/path in paths)
		if(!(all_spawn_by_spawn_value[path] in values))
			values += all_spawn_by_spawn_value[path]
			things[path] = all_spawn_by_spawn_value[path]
	var/spawn_value = pickweight(things, 0)
	spawn_value = all_spawn_by_spawn_value[spawn_value]
	things = list()
	for(var/path in paths)
		if(all_spawn_by_spawn_value[path] == spawn_value)
			things += path
	return pick(things)
