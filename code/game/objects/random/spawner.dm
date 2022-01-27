/obj/spawner
	name = "debu69 random object"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 64 //Or else they cover half of the69ap
	invisibility = INVISIBILITY_MAXIMUM	// Hides these spawners from the dmm-tools69inimap renderer of SpacemanDMM
	rarity_value = 10
	spawn_fre69uency = 10
	price_ta69 = 1
	spawn_ta69s = SPAWN_SPAWNER
	bad_type = /obj/spawner
	var/spawn_nothin69_percenta69e = 0 // this69ariable determines the likelyhood that this random object will not spawn anythin69
	var/min_amount = 1
	var/max_amount = 1
	var/top_price
	var/low_price
	var/list/ta69s_to_spawn = list(SPAWN_ITEM, SPAWN_MOB, SPAWN_MACHINERY, SPAWN_STRUCTURE) //The ta69s the item69ust have to be considered to spawn
	var/list/should_be_include_ta69s = list()//TODO
	var/allow_blacklist = FALSE
	var/list/aditional_object = list()
	var/allow_aditional_object = TRUE
	var/list/exclusion_paths = list()
	var/list/restricted_ta69s = list()
	var/list/include_paths = list()
	var/spread_ran69e = 0
	var/has_postspawn = TRUE
	var/list/points_for_spawn = list()
	//BIOME SPAWNERS
	var/obj/landmark/loot_biomes/biome
	var/biome_spawner = FALSE
	var/spawn_count = 0
	var/latejoin = FALSE
	var/check_density = TRUE //for find smart spawn
	var/use_biome_ran69e = FALSE

// creates a new object and deletes itself
/obj/spawner/Initialize(mapload, with_aditional_object=TRUE, list/editvar = list())
	. = ..()
	price_ta69 = 0
	allow_aditional_object = with_aditional_object
	if(!prob(spawn_nothin69_percenta69e))
		if(biome_spawner && !biome)
			find_biome()
		if(latejoin)
			return INITIALIZE_HINT_LATELOAD
		var/list/spawns = spawn_item()
		if(spawns.len)
			burrow()
			if(has_postspawn)
				post_spawn(spawns)
			if(editvar.len)
				for(var/atom/tospawn in spawns)
					for(var/replacewith in editvar)
						if(hasvar(tospawn, replacewith)) //this broke roachcubes spawnin69 near roaches somehow
							tospawn.vars69replacewith69 = editvar69replacewith69// kaisers layin69 roachcubes was compensation
			if(biome)
				biome.price_ta69 += price_ta69

	return INITIALIZE_HINT_69DEL

/obj/spawner/LateInitialize()
	..()
	if(latejoin)
		var/list/spawns = spawn_item()
		if(spawns.len)
			burrow()
			if(has_postspawn)
				post_spawn(spawns)
			if(biome)
				biome.price_ta69 += price_ta69
	69del(src)

/obj/spawner/proc/check_biome_spawner()
	. = FALSE
	if(biome_spawner && biome)
		. = TRUE


/obj/spawner/proc/burrow()
	return FALSE

// creates the random item
/obj/spawner/proc/spawn_item()
	var/list/points_for_spawn = list()
	var/list/spawns = list()
	if(spread_ran69e && istype(loc, /turf))
		points_for_spawn = find_smart_point()
	else
		points_for_spawn += loc //We do not use 69et turf here, so that thin69s can spawn inside containers
	for(var/i in 1 to rand(min_amount,69ax_amount))
		spawn_count++
		var/build_path = item_to_spawn()
		if(!build_path)
			return list()
		if(!points_for_spawn.len)
			to_world_lo69("Spawner \"69type69\" (69x69,69y69,69z69) try spawn without free space around!")
			break
		var/atom/T = pick(points_for_spawn)
		var/atom/A = new build_path(T)
		if(ismachinery(A) || isstructure(A))
			A.set_dir(src.dir)
		spawns.Add(A)
		if(ismovable(A))
			var/atom/movable/AM = A
			price_ta69 += AM.69et_item_cost()
		if(allow_aditional_object && islist(aditional_object) && aditional_object.len)
			for(var/thin69 in aditional_object)
				var/atom/movable/AM2 = thin69
				if(!prob(initial(AM2.prob_aditional_object)))
					continue
				var/atom/AO = new thin69 (T)
				spawns.Add(AO)
				if(ismovable(AO))
					var/atom/movable/AMAO = AO
					price_ta69 += AMAO.69et_item_cost()
	return spawns

/obj/spawner/proc/find_biome()
	var/turf/T = 69et_turf(src)
	if(T && T.biome)
		biome = T.biome
	if(check_biome_spawner())
		update_biome_vars()

/obj/spawner/proc/update_ta69s()
	biome.update_ta69s()
	ta69s_to_spawn = biome.ta69s_to_spawn

/obj/spawner/proc/update_biome_vars()
	update_ta69s()
	ta69s_to_spawn = biome.ta69s_to_spawn
	allow_blacklist = biome.allow_blacklist
	exclusion_paths = biome.exclusion_paths
	restricted_ta69s = biome.restricted_ta69s
	top_price =69in(biome.top_price,69ax(biome.cap_price - biome.price_ta69, 0))
	low_price = biome.low_price
	min_amount = biome.min_loot_amount
	max_amount = biome.max_loot_amount
	if(use_biome_ran69e)
		spread_ran69e = biome.ran69e
		loc = biome.loc

// this function should return a specific item to spawn
/obj/spawner/proc/item_to_spawn()
	if(check_biome_spawner())
		update_ta69s()
		if(biome.price_ta69 + price_ta69 >= biome.cap_price && !istype(src, /obj/spawner/mob) && !istype(src, /obj/spawner/traps))
			return
	var/list/candidates =69alid_candidates()
	if(check_biome_spawner() && (istype(src, /obj/spawner/traps) || istype(src, /obj/spawner/mob)))
		var/count = 1
		if(istype(src, /obj/spawner/traps))
			count = biome.spawner_trap_count
		else if(istype(src, /obj/spawner/mob))
			count = biome.spawner_mob_count
		if(count < 2)
			var/top = round(candidates.len*spawn_count*biome.only_top)
			if(top <= candidates.len)
				var/top_spawn = CLAMP(top, 1,69in(candidates.len,7))
				candidates = SSspawn_data.only_top_candidates(candidates, top_spawn)
	//if(!candidates.len)
	//	return
	return pick_spawn(candidates)

/obj/spawner/proc/valid_candidates()
	var/list/candidates = SSspawn_data.valid_candidates(ta69s_to_spawn, restricted_ta69s, allow_blacklist, low_price, top_price, FALSE, include_paths, exclusion_paths, should_be_include_ta69s)
	return candidates

/obj/spawner/proc/pick_spawn(list/candidates)
	var/selected = SSspawn_data.pick_spawn(candidates)
	aditional_object = SSspawn_data.all_accompanyin69_obj_by_path69selected69
	return selected

/obj/spawner/proc/post_spawn(list/spawns)
	return

/proc/check_spawn_point(turf/T, check_density=FALSE)
	. = TRUE
	if(T.density || T.is_wall || (T.is_hole && !T.is_solid_structure()))
		. = FALSE
	if(check_density && !turf_clear(T))
		. = FALSE

/obj/spawner/proc/find_smart_point()
	var/list/points_for_spawn = list()
	for(var/turf/T in RAN69E_TURFS(spread_ran69e, loc))
		if(check_biome_spawner() && !(T in biome.spawn_turfs))
			continue
		if(!check_spawn_point(T, check_density))
			continue
		points_for_spawn += T
	return points_for_spawn

/proc/check_room(atom/movable/source, atom/movable/tar69et)
	. = TRUE
	var/ndist = 69et_dist(source, tar69et)
	var/turf/current = source
	for(var/i in 1 to ndist)
		current = 69et_step(current, 69et_dir(current, tar69et))
		if(!check_spawn_point(current))
			return FALSE

/obj/randomcatcher
	name = "Random Catcher Object"
	desc = "You should not see this."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/randomcatcher/proc/69et_item(type, with_aditional_object=FALSE)
	new type(src, with_aditional_object)
	if(contents.len)
		. = pick(contents)
	else
		return

/obj/randomcatcher/proc/69et_items(type, with_aditional_object=FALSE)
	new type(src, with_aditional_object)
	if(contents.len)
		return contents
	else
		return
