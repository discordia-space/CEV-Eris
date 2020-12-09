/obj/item/craft
	icon = 'icons/obj/crafts.dmi'
	icon_state = "device"
	spawn_tags = null
	var/datum/craft_recipe/recipe
	var/step = 1


/obj/item/craft/New(loc, new_recipe)
	..(loc)
	recipe = new_recipe
	src.name = "crafting [recipe.name]"
	src.icon_state = recipe.icon_state
	update()


/obj/item/craft/proc/update()
	step = recipe.get_actual_step()
	desc = recipe.get_description(step)

/obj/item/craft/proc/continue_crafting(obj/item/I, mob/living/user)
	if(user && istype(loc, /turf))
		user.face_atom(src) //Look at what you're doing please

	if(recipe.try_step(step, I, user, src)) //First step is
		var/datum/craft_step/CS = recipe.steps[step]
		if(CS.completed && recipe.is_compelete(step+1))
			recipe.spawn_result(src, user)
		else
			update()
		return TRUE //Returning true here will prevent afterattack effects for ingredients and tools used on us

	return FALSE

/obj/item/craft/attackby(obj/item/I, mob/living/user)
	return continue_crafting(I, user)

/obj/item/craft/MouseDrop_T(atom/A, mob/user, src_location, over_location, src_control, over_control, params)
	return continue_crafting(A, user)

/obj/item/part
	bad_type = /obj/item/part
	price_tag = 300
	spawn_tags = SPAWN_TAG_PART

/obj/item/part/gun
	name = "gun part"
	desc = "A gun part."
	icon ='icons/obj/crafts.dmi'
	icon_state = "gun"//evan, temp icon
	spawn_tags = SPAWN_TAG_GUN_PART
	matter = list(MATERIAL_PLASTEEL = 1)

/obj/item/craft_frame
	name = "Item assembly"
	desc = "Debug item"
	icon ='icons/obj/crafts.dmi'
	icon_state = "gun_frame"//evan, temp icon
	matter = list()
	bad_type = /obj/item/craft_frame
	spawn_frequency = 0
	var/req_sat = STAT_MEC
	var/suitable_part
	var/view_only = 0
	var/tags_to_spawn = list()
	var/req_parts = 15
	var/complete = FALSE
	var/total_items = 20
	var/list/items = list()
	var/list/paths = list()

/obj/item/craft_frame/guns
	name = "Gun assembly"
	desc = "Add some weapon parts to complete this, use your knowledge of mechanics and create a gun."//EVAN TEMP DESCK
	matter = list(MATERIAL_PLASTEEL = 5)
	suitable_part = /obj/item/part/gun
	spawn_frequency = 0
	tags_to_spawn = list(SPAWN_GUN)

/obj/item/craft_frame/examine(user, distance)
	. = ..()
	if(.)
		to_chat(user, SPAN_NOTICE("Requires [req_parts] gun parts to be complete."))

/obj/item/craft_frame/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, suitable_part))
		if(complete)
			to_chat(user, SPAN_WARNING("[src] is complete"))
			return
		else if(insert_item(I, user))
			req_parts--
			if(req_parts <= 0)
				complete()
				to_chat(user, SPAN_NOTICE("You have completed [src]."))
			return
	. = ..()

/obj/item/craft_frame/proc/complete()
	generate_guns()
	complete = TRUE

/obj/item/craft_frame/proc/generate_guns()
	for(var/i in 1 to total_items)
		var/list/canidates = SSspawn_data.valid_candidates(tags_to_spawn, null, FALSE, i*100, null, TRUE, null, paths, null)
		paths += list(SSspawn_data.pick_spawn(canidates))
	paths = SSspawn_data.sort_paths_by_price(paths)
	for(var/path in paths)
		items += new path()

/obj/item/craft_frame/Destroy()
	drop_parts()
	. = ..()

/obj/item/craft_frame/proc/drop_parts()
	for(var/obj/item/part/P in contents)
		P.forceMove(get_turf(src))

/obj/item/craft_frame/attack_self(mob/user)
	. = ..()
	if(!complete)
		to_chat(user, SPAN_WARNING("[src] is not yet complete."))
	else
		view_only = round((total_items - 1) * (1 - user.stats.getMult(req_sat, STAT_LEVEL_GODLIKE))) + 1
		ui_interact(user)
		SSnano.update_uis(src)

/obj/item/craft_frame/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open = NANOUI_FOCUS)
	var/list/data = list()

	var/list/listed_products = list()
	for(var/key = 1 to view_only)
		var/obj/item/I = items[key]

		listed_products.Add(list(list(
			"key" = key,
			"name" = strip_improper(I.name))))

	data["paths"] = listed_products

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "craft_assambly.tmpl", name, 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/item/craft_frame/Topic(href, href_list)
	if(usr.stat || usr.restrained())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))))
		if((href_list["select"]))
			var/key = text2num(href_list["select"])
			var/obj/item/I = items[key]
			make_obj(I, usr)
	SSnano.update_uis(src)

/obj/item/craft_frame/proc/make_obj(obj/O, mob/user)
	O.forceMove(get_turf(src))
	user.put_in_hands(O)
	to_chat(user, SPAN_NOTICE("You have used [src] to craft a [O.name]."))
	spawn(1)
		if(!QDELETED(src))
			qdel(src)
