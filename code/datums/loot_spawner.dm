///datum/controller/subsystem/spawn_data
	//var/list/all_spawn_bad_paths = list()//hard
	//var/list/all_spawn_blacklist = list()//soft
	//var/list/all_spawn_by_price = list()
	//var/list/all_price_by_path = list()
	//var/list/all_spawn_by_frequency = list()
	//var/list/all_spawn_frequency_by_path = list()
	//var/list/all_spawn_by_rarity = list()
	//var/list/all_spawn_rarity_by_path = list()
	//var/list/all_spawn_value_by_path = list()
	//var/list/all_spawn_by_tag = list()
	//var/list/all_accompanying_obj_by_path = list()

///datum/controller/subsystem/spawn_data/Initialize()
//	..()
//	generate_data()

/datum/controller/subsystem/spawn_data/proc/generate_data()
	var/list/paths = list()
	//spawn vars
	//var/rarity
	//var/frequency
	//var/blacklisted
	//var/list/bad_paths = list()
	var/list/spawn_tags = list()
	var/list/accompanying_objs = list()
	var/generate_files = config.generate_loot_data
	var/file_dir = "strings/loot_data"
	var/source_dir = file("[file_dir]/")
	var/loot_data = file("[file_dir]/all_spawn_data.txt")
	var/loot_data_paths = file("[file_dir]/all_spawn_paths.txt")
	var/hard_blacklist_data = file("[file_dir]/hard_blacklist.txt")
	var/blacklist_paths_data = file("[file_dir]/blacklist.txt")
	var/file_dir_tags = "[file_dir]/tags/"
	if(generate_files)
		fdel(source_dir)
		loot_data  << "paths    spawn_tags    blacklisted    spawn_value    spawn_price    prob_accompanying_obj    all_accompanying_obj"

	//Initialise all paths
	paths = subtypesof(/obj/item) - typesof(/obj/item/projectile)
	paths += subtypesof(/mob/living)
	paths += subtypesof(/obj/machinery)
	paths += subtypesof(/obj/structure)
	paths += subtypesof(/obj/spawner)
	paths += subtypesof(/obj/effect)

	for(var/path in paths)
		var/atom/movable/A = path
		if(path == initial(A.bad_type))
			if(generate_files)
				hard_blacklist_data  << "[path]"
			continue

		spawn_tags = params2list(initial(A.spawn_tags))
		if(!spawn_tags.len)
			if(generate_files)
				hard_blacklist_data  << "[path]"
			continue

		//frequency = initial(A.spawn_frequency)
		if(initial(A.spawn_frequency) <= 0)
			if(generate_files)
				hard_blacklist_data  << "[path]"
			continue

		/* //this works but is unnecessary for now.
		//icon check
		var/icon/icon_to_check = icon(initial(A.icon), initial(A.icon_state), initial(A.dir))
		var/icon_check = FALSE
		if(isicon(icon_to_check))
			for(var/y = 0 to icon_to_check.Width())
				if(icon_check)
					break
				for(var/x = 0 to icon_to_check.Height())
					if(icon_to_check.GetPixel(x, y))
						icon_check = TRUE
						break
		if(!icon_check)
			if(generate_files)
				hard_blacklist_data  << "[path]"
			continue
		*/ //this works but is unnecessary for now.

		//frequency
		//frequency = initial(A.spawn_frequency)
		//all_spawn_by_frequency["[frequency]"] += list(path)
		//all_spawn_frequency_by_path[path] = frequency

		//rarity//
		//rarity = initial(A.rarity_value)
		ASSERT(initial(A.rarity_value) >= 1)
		//all_spawn_by_rarity["[rarity]"] += list(path)
		//all_spawn_rarity_by_path[path] = rarity

		//aditional_objs
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
				all_accompanying_obj_by_path[path] += list(obj_path)
		if(ispath(path, /obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/E = A
			if(!initial(E.use_external_power) && !initial(E.self_recharge))
				all_accompanying_obj_by_path[path] += list(initial(E.suitable_cell))
		else if(ispath(path, /obj/item/weapon/gun/projectile))
			var/obj/item/weapon/gun/projectile/P = A
			if(initial(P.magazine_type))
				all_accompanying_obj_by_path[path] += list(initial(P.magazine_type))

		//price//
		var/price = get_spawn_price(path)

		//spawn_value//
		var/spawn_value = get_spawn_value(path)
		//all_spawn_value_by_path[path] = spawn_value
		//blacklisted//
		//blacklisted = initial(A.spawn_blacklisted)
		//if(blacklisted)
		//	all_spawn_blacklist += path

		//tags//
		for(var/tag in spawn_tags)
			all_spawn_by_tag[tag] += list(path)
			if(ispath(path, /obj/item) && tag != SPAWN_OBJ &&!initial(A.density) && ISINRANGE(price, 1, CHEAP_ITEM_PRICE) && !lowkeyrandom_tags.Find(tag))
				lowkeyrandom_tags += list(tag)
			if(generate_files)
				var/tag_data_i = file("[file_dir_tags][tag].txt")
				tag_data_i << "[path]    blacklisted=[initial(A.spawn_blacklisted)]    spawn_value=[spawn_value]   spawn_price=[price]   prob_accompanying_obj=[initial(A.prob_aditional_object)]    accompanying_objs=[all_accompanying_obj_by_path[path] ? english_list(all_accompanying_obj_by_path[path], "nothing", ",") : "nothing"]"
		if(generate_files)
			loot_data << "[path]    [initial(A.spawn_tags)]    blacklisted=[initial(A.spawn_blacklisted)]    spawn_value=[spawn_value]   spawn_price=[price]   prob_accompanying_obj=[initial(A.prob_aditional_object)]    accompanying_objs=[all_accompanying_obj_by_path[path] ? english_list(all_accompanying_obj_by_path[path], "nothing", ",") : "nothing"]"
			loot_data_paths << "[path]"
			if(initial(A.spawn_blacklisted))
				blacklist_paths_data << "[path]"

/datum/controller/subsystem/spawn_data/proc/get_spawn_value(npath)
	var/atom/movable/A = npath
	var/spawn_value = 10 * initial(A.spawn_frequency)/(initial(A.rarity_value) + log(10,max(get_spawn_price(A),1)))
	return spawn_value

/datum/controller/subsystem/spawn_data/proc/get_spawn_price(path, with_accompaying_obj = TRUE)
	var/atom/movable/A = path
	. = initial(A.price_tag)
	if(with_accompaying_obj && all_accompanying_obj_by_path[path])
		for(var/a_obj in all_accompanying_obj_by_path[path])
			. += get_spawn_price(a_obj, FALSE)
	if(ispath(path, /obj/item/weapon/stock_parts))//see /obj/item/weapon/stock_parts/get_item_cost(export)
		var/obj/item/weapon/stock_parts/S = path
		. *= initial(S.rating)
	else if(ispath(path, /obj/item/stack))///obj/item/stack/get_item_cost(export)
		var/obj/item/stack/S = path
		. *= initial(S.amount)
	else if(ispath(path, /obj/item/ammo_casing))///obj/item/ammo_casing/get_item_cost(export)
		var/obj/item/ammo_casing/AC = path
		. *= initial(AC.amount)
	else if(ispath(path, /obj/item/weapon/handcuffs))///obj/item/weapon/handcuffs/get_item_cost(export)
		var/obj/item/weapon/handcuffs/H = path
		. += initial(H.breakouttime) / 20
	else if(ispath(path, /obj/structure/reagent_dispensers))///obj/machinery/get_item_cost(export)
		var/obj/structure/reagent_dispensers/R = path
		. += initial(R.contents_cost)
	else if(ispath(path, /obj/item/ammo_magazine))///obj/item/ammo_magazine/get_item_cost(export)
		var/obj/item/ammo_magazine/M = path
		var/amount = initial(M.initial_ammo)
		if(isnull(amount))
			amount = initial(M.max_ammo)
		. += amount * get_spawn_price(initial(M.ammo_type))
	else if(ispath(path, /obj/item/weapon/tool))
		var/obj/item/weapon/tool/T = path
		if(initial(T.suitable_cell))
			. += get_spawn_price(initial(T.suitable_cell))
	else if(ispath(path, /obj/item/weapon/storage/box))
		var/obj/item/weapon/storage/box/B = path
		if(initial(B.initial_amount) > 0 && initial(B.spawn_type))
			. += initial(B.initial_amount) * get_spawn_price(initial(B.spawn_type))
	else if(ispath(path, /obj/item/weapon/storage/fancy))
		var/obj/item/weapon/storage/fancy/F = path
		if(initial(F.item_obj) && initial(F.storage_slots))
			. += initial(F.storage_slots) * get_spawn_price(initial(F.item_obj))
	else if(ispath(path, /obj/item/weapon/storage/pill_bottle))
		var/obj/item/weapon/storage/pill_bottle/PB = path
		if(initial(PB.initial_amt) && initial(PB.pill_type))
			. += initial(PB.initial_amt) * get_spawn_price(initial(PB.pill_type))
	else if(ispath(path, /obj/item/clothing))
		var/obj/item/clothing/C = path
		. += 5 * initial(C.style)
		if(ispath(path, /obj/item/clothing/suit/space/void))
			var/obj/item/clothing/suit/space/void/V = A
			if(initial(V.tank))
				. += get_spawn_price(initial(V.tank))
			if(initial(V.boots))
				. += get_spawn_price(initial(V.boots))
	else if(ispath(path, /obj/item/weapon/cell))
		var/obj/item/weapon/cell/C = path
		if(initial(C.price_tag))
			var/bonus = initial(C.maxcharge)/(initial(C.price_tag)*2)
			if(initial(C.autorecharging))
				bonus *= 2
			. += bonus
	else if(ispath(path, /obj/item/device))
		if(. == 0)
			. += 1 //for pure random
		var/obj/item/device/D = path
		if(initial(D.starting_cell) && initial(D.suitable_cell))
			. += get_spawn_price(initial(D.suitable_cell))
	else if(ispath(path, /obj/item/weapon/reagent_containers/glass/beaker))
		var/obj/item/weapon/reagent_containers/glass/beaker/B = path
		. += initial(B.volume)/100

/datum/controller/subsystem/spawn_data/proc/spawn_by_tag(list/tags)
	var/list/things = list()
	for(var/tag in tags)
		things |= all_spawn_by_tag["[tag]"]
	return things

/datum/controller/subsystem/spawn_data/proc/spawns_lower_price(list/paths, price)
	//if(!paths || !paths.len || !price) //NOPE
	//	return
	var/list/things = list()
	for(var/path in paths)
		if(get_spawn_price(path) < price)
			things += path
	return things

/datum/controller/subsystem/spawn_data/proc/spawns_upper_price(list/paths, price)
	//if(!paths || !paths.len || !price) //NOPE
	//	return
	var/list/things = list()
	for(var/path in paths)
		if(get_spawn_price(path) > price)
			things += path
	return things

/datum/controller/subsystem/spawn_data/proc/filter_densty(list/paths)
	//if(!paths || !paths.len || !price) //NOPE
	//	return
	var/list/things = list()
	for(var/path in paths)
		var/atom/movable/AM = path
		if(!initial(AM.density))
			things += path
	return things

/datum/controller/subsystem/spawn_data/proc/only_top_candidates(list/paths, top=7)
	//if(!paths || !paths.len) //NOPE
		//return
	if(paths.len <= top)
		return paths
	var/list/valid_spawn_value = list()
	var/max_value = 0
	var/list/things = list()
	for(var/j=1 to top)
		var/low = INFINITY
		for(var/path in paths)
			var/sapwn_value = get_spawn_value(path)
			if((sapwn_value < low) && !(sapwn_value in valid_spawn_value))
				low = sapwn_value
		valid_spawn_value += low
	for(var/value in valid_spawn_value)
		if(value > max_value)
			max_value = value
	for(var/path in paths)
		if(get_spawn_value(path) <= max_value)
			things += path
	return things

/datum/controller/subsystem/spawn_data/proc/pick_spawn(list/paths, invert_value=FALSE)
	//if(!paths || !paths.len) //NOPE
		//return
	var/list/things = list()
	var/list/values = list()
	for(var/path in paths)
		var/spawn_value = get_spawn_value(path)
		if(!(spawn_value in values) && spawn_value > 0)
			values += spawn_value
			if(invert_value)
				spawn_value = 1/spawn_value
			things[path] = spawn_value
	var/spawn_value = pickweight(things, 0)
	spawn_value = get_spawn_value(spawn_value)
	things = list()
	for(var/path in paths)
		if(get_spawn_value(path) == spawn_value)
			things += path
	return pick(things)

/datum/controller/subsystem/spawn_data/proc/take_tags(list/paths, list/exclude)
	var/list/local_tags = list()
	var/atom/movable/A
	for(var/path in paths)
		A = path
		var/list/spawn_tags = params2list(initial(A.spawn_tags))
		for(var/tag in spawn_tags)
			if(tag in local_tags)
				continue
			local_tags += list(tag)
	local_tags -= exclude
	return local_tags

/datum/controller/subsystem/spawn_data/proc/valid_candidates(list/tags, list/bad_tags, allow_blacklist=FALSE, low_price=0, top_price=0, filter_density=FALSE, list/include, list/exclude, list/should_be_include_tags)
	var/list/candidates = spawn_by_tag(tags)
	candidates -= spawn_by_tag(bad_tags)
	if(!allow_blacklist)
		var/atom/movable/A
		for(var/path in candidates)
			A = path
			if(!initial(A.spawn_blacklisted))
				continue
			candidates -= path
	if(low_price)
		candidates -= spawns_lower_price(candidates, low_price)
	if(top_price)
		candidates -= spawns_upper_price(candidates, top_price)
	if(filter_density)
		candidates = filter_densty(candidates)
	candidates -= exclude
	candidates |= include
	candidates = removeNullsFromList(candidates)
	return candidates
