//Cooking containers are used in ovens, fryers and so on, to hold multiple ingredients for a recipe.
//They interact with the cooking process, and link up with the cooking code dynamically.

//Originally sourced from the Aurora, heavily retooled to actually work with CWJ


//Holder for a portion of an incomplete meal,
//allows a cook to temporarily offload recipes to work on things factory-style, eliminating the need for 20 plates to get things done fast.

/obj/item/reagent_containers/cooking_with_jane/cooking_container
	icon = 'icons/obj/cwj_cooking/kitchen.dmi'
	description_info = "Can be emptied of physical food with alt-click."
	var/shortname
	var/place_verb = "into"
	var/appliancetype //string beans
	w_class = ITEM_SIZE_SMALL
	volume = 240 //Don't make recipes using reagents in larger quantities than this amount; they won't work.
	var/datum/cooking_with_jane/recipe_tracker/tracker = null //To be populated the first time the plate is interacted with.
	var/lip //Icon state of the lip layer of the object
	var/removal_penalty = 0 //A flat quality reduction for removing an unfinished recipe from the container.

	possible_transfer_amounts = list(5,10,30,60,90,120,240)
	amount_per_transfer_from_this = 10

	reagent_flags = OPENCONTAINER | NO_REACT
	var/list/stove_data = list("High"=0 , "Medium" = 0, "Low"=0) //Record of what stove-cooking has been done on this food.
	var/list/grill_data = list("High"=0 , "Medium" = 0, "Low"=0) //Record of what grill-cooking has been done on this food.
	var/list/oven_data = list("High"=0 , "Medium" = 0, "Low"=0) //Record of what oven-cooking has been done on this food.

/obj/item/reagent_containers/cooking_with_jane/cooking_container/Initialize()
	.=..()
	appearance_flags |= KEEP_TOGETHER


/obj/item/reagent_containers/cooking_with_jane/cooking_container/examine(var/mob/user)
	if(!..(user, 1))
		return FALSE
	if(contents)
		to_chat(user, get_content_info())
	if(reagents.total_volume)
		to_chat(user, get_reagent_info())

/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/get_content_info()
	var/string = "It contains:</br><ul><li>"
	string += jointext(contents, "</li><li>") + "</li></ul>"
	return string

/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/get_reagent_info()
	return "It contains [reagents.total_volume] units of reagents."

/obj/item/reagent_containers/cooking_with_jane/cooking_container/attackby(var/obj/item/used_item, var/mob/user)

	#ifdef CWJ_DEBUG
	log_debug("cooking_container/attackby() called!")
	#endif

	if(istype(used_item, /obj/item/tool/shovel))
		do_empty(user, target=null, reagent_clear = FALSE)
		return

	if(!tracker && (contents.len || reagents.total_volume != 0))
		to_chat(user, "The [src] is full. Empty its contents first.")
	else
		process_item(used_item, user)

	return TRUE

/obj/item/reagent_containers/cooking_with_jane/cooking_container/standard_pour_into(mob/user, atom/target)


	#ifdef CWJ_DEBUG
	log_debug("cooking_container/standard_pour_into() called!")
	#endif

	if(tracker)
		if(alert(user, "There is an ongoing recipe in the [src]. Dump it out?",,"Yes","No") == "No")
			return FALSE
		for(var/datum/reagent/our_reagent in reagents.reagent_list)
			if(our_reagent.data && istype(our_reagent.data, /list) && our_reagent.data["FOOD_QUALITY"])
				our_reagent.data["FOOD_QUALITY"] = 0

	do_empty(user, target, reagent_clear = FALSE)

	#ifdef CWJ_DEBUG
	log_debug("cooking_container/do_empty() completed!")
	#endif

	. = ..(user, target)


/obj/item/reagent_containers/cooking_with_jane/cooking_container/afterattack(var/obj/target, var/mob/user, var/flag)
	if(!istype(target, /obj/item/reagent_containers))
		return
	if(!flag)
		return
	if(tracker)
		return
	if(standard_pour_into(user, target))
		return 1

/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/process_item(var/obj/I, var/mob/user, var/lower_quality_on_fail = 0, var/send_message = TRUE)


	#ifdef CWJ_DEBUG
	log_debug("cooking_container/process_item() called!")
	#endif

	//OK, time to load the tracker
	if(!tracker)
		if(lower_quality_on_fail)
			for (var/obj/item/contained in contents)
				contained?:food_quality -= lower_quality_on_fail
		else
			tracker = new /datum/cooking_with_jane/recipe_tracker(src)

	var/return_value = 0
	switch(tracker.process_item_wrap(I, user))
		if(CWJ_NO_STEPS)
			if(send_message)
				to_chat(user, "It doesn't seem like you can create a meal from that. Yet.")
			if(lower_quality_on_fail)
				for (var/datum/cooking_with_jane/recipe_pointer/pointer in tracker.active_recipe_pointers)
					pointer?:tracked_quality -= lower_quality_on_fail
		if(CWJ_CHOICE_CANCEL)
			if(send_message)
				to_chat(user, "You decide against cooking with the [src].")
		if(CWJ_COMPLETE)
			if(send_message)
				to_chat(user, "You finish cooking with the [src].")
			qdel(tracker)
			tracker = null
			clear_cooking_data()
			update_icon()
			return_value = 1
		if(CWJ_SUCCESS)
			if(send_message)
				to_chat(user, "You have successfully completed a recipe step.")
			clear_cooking_data()
			return_value = 1
			update_icon()
		if(CWJ_PARTIAL_SUCCESS)
			if(send_message)
				to_chat(user, "More must be done to complete this step of the recipe.")
		if(CWJ_LOCKOUT)
			if(send_message)
				to_chat(user, "You can't make the same decision twice!")

	if(tracker && !tracker.recipe_started)
		qdel(tracker)
		tracker = null
	return return_value

//TODO: Handle the contents of the container being ruined via burning.
/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/handle_burning()
	return

//TODO: Handle the contents of the container lighting on actual fire.
/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/handle_ignition()
	return FALSE

/obj/item/reagent_containers/cooking_with_jane/cooking_container/verb/empty()
	set src in view(1)
	set name = "Empty Container"
	set category = "Object"
	set desc = "Removes items from the container, excluding reagents."
	do_empty(usr)

/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/do_empty(mob/user, var/atom/target = null, var/reagent_clear = TRUE)
	#ifdef CWJ_DEBUG
	log_debug("cooking_container/do_empty() called!")
	#endif

	if(contents.len != 0)
		if(tracker && removal_penalty)
			for (var/obj/item/contained in contents)
				contained?:food_quality -= removal_penalty
			to_chat(user, SPAN_WARNING("The quality of ingredients in the [src] was reduced by the extra jostling."))

		//Handle quality reduction for reagents
		if(reagents.total_volume != 0)
			var/reagent_qual_reduction = round(reagents.total_volume/contents.len)
			if(reagent_qual_reduction != 0)
				for (var/obj/item/contained in contents)
					contained?:food_quality -= reagent_qual_reduction
				to_chat(user, SPAN_WARNING("The quality of ingredients in the [src] was reduced by the presence of reagents in the container."))


		for (var/contained in contents)
			var/atom/movable/AM = contained
			remove_from_visible(AM)
			if(!target)
				AM.forceMove(get_turf(src))
			else
				AM.forceMove(get_turf(target))

	//TODO: Splash the reagents somewhere
	if(reagent_clear)
		reagents.clear_reagents()

	update_icon()
	qdel(tracker)
	tracker = null
	clear_cooking_data()

	if(contents.len != 0)
		to_chat(user, SPAN_NOTICE("You remove all the solid items from [src]."))


/obj/item/reagent_containers/cooking_with_jane/cooking_container/AltClick(var/mob/user)
	do_empty(user)

//Deletes contents of container.
//Used when food is burned, before replacing it with a burned mess
/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/clear()
	QDEL_LIST(contents)
	contents=list()
	reagents.clear_reagents()
	if(tracker)
		qdel(tracker)
		tracker = null
	clear_cooking_data()


/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/clear_cooking_data()
	stove_data = list("High"=0 , "Medium" = 0, "Low"=0)
	grill_data = list("High"=0 , "Medium" = 0, "Low"=0)

/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/label(var/number, var/CT = null)
	//This returns something like "Fryer basket 1 - empty"
	//The latter part is a brief reminder of contents
	//This is used in the removal menu
	. = shortname
	if (!isnull(number))
		.+= " [number]"
	.+= " - "
	if (LAZYLEN(contents))
		var/obj/O = locate() in contents
		return . + O.name //Just append the name of the first object
	return . + "empty"

/obj/item/reagent_containers/cooking_with_jane/cooking_container/update_icon()
	cut_overlays()
	for(var/obj/item/our_item in vis_contents)
		src.remove_from_visible(our_item)

	for(var/i=contents.len, i>=1, i--)
		var/obj/item/our_item = contents[i]
		src.add_to_visible(our_item)
	if(lip)
		add_overlay(image(src.icon, icon_state=lip, layer=ABOVE_OBJ_LAYER))

/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/add_to_visible(var/obj/item/our_item)
	our_item.pixel_x = initial(our_item.pixel_x)
	our_item.pixel_y = initial(our_item.pixel_y)
	our_item.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	our_item.blend_mode = BLEND_INSET_OVERLAY
	our_item.transform *= 0.6
	src.vis_contents += our_item

/obj/item/reagent_containers/cooking_with_jane/cooking_container/proc/remove_from_visible(var/obj/item/our_item)
	our_item.vis_flags = 0
	our_item.blend_mode = 0
	our_item.transform = null
	src.vis_contents.Remove(our_item)

/obj/item/reagent_containers/cooking_with_jane/cooking_container/plate
	icon = 'icons/obj/cwj_cooking/eris_kitchen.dmi'
	name = "serving plate"
	shortname = "plate"
	desc = "A shitty serving plate. You probably shouldn't be seeing this."
	icon_state = "plate"
	matter = list(MATERIAL_STEEL = 5)
	appliancetype = PLATE

/obj/item/reagent_containers/cooking_with_jane/cooking_container/board
	name = "cutting board"
	shortname = "cutting_board"
	desc = "Good for making sandwiches on, too."
	icon_state = "cutting_board"
	item_state = "cutting_board"
	matter = list(MATERIAL_WOOD = 5)
	appliancetype = CUTTING_BOARD

/obj/item/reagent_containers/cooking_with_jane/cooking_container/oven
	name = "oven dish"
	shortname = "shelf"
	desc = "Put ingredients in this; designed for use with an oven. Warranty void if used."
	icon_state = "oven_dish"
	lip = "oven_dish_lip"
	item_state = "oven_dish"
	matter = list(MATERIAL_STEEL = 10)
	appliancetype = OVEN

/obj/item/reagent_containers/cooking_with_jane/cooking_container/pan
	name = "pan"
	desc = "An normal pan."

	icon_state = "pan" //Default state is the base icon so it looks nice in the map builder
	lip = "pan_lip"
	item_state = "pan"
	matter = list(MATERIAL_PLASTEEL = 5)
	hitsound = 'sound/weapons/smash.ogg'
	appliancetype = PAN

/obj/item/reagent_containers/cooking_with_jane/cooking_container/pot
	name = "cooking pot"
	shortname = "pot"
	desc = "Boil things with this. Maybe even stick 'em in a stew."

	icon_state = "pot"
	lip = "pot_lip"
	item_state = "pot"
	matter = list(MATERIAL_STEEL = 5)

	hitsound = 'sound/weapons/smash.ogg'
	removal_penalty = 5
	appliancetype = POT
	w_class = ITEM_SIZE_BULKY

/obj/item/reagent_containers/cooking_with_jane/cooking_container/deep_basket
	name = "deep fryer basket"
	shortname = "basket"
	desc = "Cwispy! Warranty void if used."

	icon_state = "deepfryer_basket"
	lip = "deepfryer_basket_lip"
	item_state = "deepfryer_basket"
	removal_penalty = 5
	appliancetype = DF_BASKET

/obj/item/reagent_containers/cooking_with_jane/cooking_container/air_basket
	name = "air fryer basket"
	shortname = "basket"
	desc = "Permanently laminated with dried oil and late-stage capitalism."

	icon_state = "airfryer_basket"
	lip = "airfryer_basket_lip"
	item_state = "airfryer_basket"
	removal_penalty = 5
	appliancetype = AF_BASKET

/obj/item/reagent_containers/cooking_with_jane/cooking_container/grill_grate
	name = "grill grate"
	shortname = "grate"
	place_verb = "onto"
	desc = "Primarily used to grill meat, place this on a grill and enjoy an ancient human tradition."

	icon_state = "grill_grate"
	matter = list(MATERIAL_STEEL = 5)

	appliancetype = GRILL

/obj/item/reagent_containers/cooking_with_jane/cooking_container/bowl
	name = "prep bowl"
	shortname = "bowl"
	desc = "A bowl for mixing, or tossing a salad. Not to be eaten out of"

	icon_state = "bowl"
	lip = "bowl_lip"
	item_state = "pot"
	matter = list(MATERIAL_PLASTIC = 5)

	removal_penalty = 2
	appliancetype = BOWL
