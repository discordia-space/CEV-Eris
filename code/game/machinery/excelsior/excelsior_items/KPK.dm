#define MODE_NONE 1
#define MODE_PATHFINDER 2
#define MODE_INFLUENCE 3




/obj/item/centor_kpk/
	name = "\improper Excelsior KOMPAK"
	desc = "A lightweight PDA, that could be your grandfather if it was animated. Compatriot's second best friend."
	description_info = "Every Excelsior agent gets one from Centor, but better not lose it."
	description_antag = "Creates paths between nodes. Choosing a node on KPK constructs a route to it, from the closest node to chosen one."
	icon = 'icons/obj/machines/excelsior/corenode/pda.dmi'
	icon_state = "kompak_off"
	opacity = 0
	density = FALSE
	anchored = FALSE
	w_class = ITEM_SIZE_SMALL
	var/mode = MODE_NONE
	var/code_crutch = TRUE	// TODO: DELETE IF STAGE 2.
								//	- This is here cuz no drones yet, but paths are fundamental design so uhm... Smeakpeek?
	matter = list(MATERIAL_PLASTIC = 5, MATERIAL_GLASS = 1, MATERIAL_PLASMA = 2)

	var/list/active_scanned = list()
	var/datum/event_source
	var/mob/current_user

	var/client/user_client
	var/enabled = FALSE		// visual, no mechanics
	var/active
	var/list/objects_to_overlay = list()
	var/turn_on_sound = 'sound/effects/Custom_flashlight.ogg'
	var/path_diologe = FALSE
	var/viewpath_diologe = FALSE
	var/mappings_diologe = FALSE
	var/obj/machinery/node/chosen_node
	var/obj/effect/effect/pathfinder_arrow/first/current_route
	var/list/ihaveplacestobe = list()	//list of roads from node-to-node, combined into a long road.
	var/obj/machinery/node/viewpath_slot
	var/list/errors = list()
	//


// CRUTCH DETECTOR SCREAMS "DELETE ME I BEG YOU" but I say no... you must be here for now until we release a second update.
/obj/item/centor_kpk/Initialize()
	. = ..()
	if(code_crutch)
		description_antag += " Each path made grants 0.25 energy gain to teleporters."		// Guh...  Т_Т


/obj/item/centor_kpk/update_icon()
	if(current_user)
		icon_state = "kompak_on"
	else
		icon_state = "kompak_off"

/obj/item/centor_kpk/attack_self(mob/user)
	set_user(user)
	nano_ui_interact(user)

/obj/item/centor_kpk/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = nano_ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "excelsior_kpk.tmpl", name, 450, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/item/centor_kpk/nano_ui_data()
	var/list/data = list()
	data["path_diologe"] = path_diologe
	data["current_path"] = current_route ? 1 : 0
	data["current_node"] = chosen_node ? chosen_node.shortname : "ERR: NODE NOT FOUND"
	data["viewpath_dio"] = viewpath_diologe
	data["mappings_dio"] = mappings_diologe

	if(enabled)
		switch(mode)
			if(MODE_NONE)
				data["overlay_enabled"] = "Online: Avaiting mode"
			if(MODE_INFLUENCE)
				data["overlay_enabled"] = "Online: Influence"
			if(MODE_PATHFINDER)
				data["overlay_enabled"] = "Online: Pathfinder"
	else
		data["overlay_enabled"] = "Offline"

	var/list/error_list = list()
	var/z_err = 10
	for(var/error in errors)
		z_err++
		error_list += list(
			list(
				"z_err" = "style=\"z-index: [z_err];\"",
				"text_err" = error,
				"commands_err" = list("ok_error" = error)
			)
		)

	data["error_list"] = error_list

	var/list/node_list = list()
	for(var/obj/machinery/node/noda in excelsior_nodes)
		node_list += list(
			list(
				"name_n" = noda.shortname,
				"commands_n" = list("see_path" = noda.uid)
			)
		)

	data["node_list"] = node_list

	return data

/obj/item/centor_kpk/proc/set_user(mob/living/newuser)
	if(newuser && !is_excelsior(newuser))
		return //Unautharized access
	if(current_user == newuser)
		return

	//If there's an existing user we may need to unregister them first
	if(current_user)
		unset_client()

	//Actually set it
	current_user = newuser
	set_client()
	event_source = get_track_target()
	check_active()
	update_icon()

/obj/item/centor_kpk/proc/set_client()
	if(!current_user || !current_user.client)
		return FALSE

	user_client = current_user.client


	for(var/scanned in active_scanned)
		user_client.images += active_scanned[scanned]



/obj/item/centor_kpk/proc/unset_client()
	if(event_source)
		GLOB.moved_event.unregister(event_source, src)
		event_source = null
	if(user_client)
		for(var/scanned in active_scanned)
			user_client.images -= active_scanned[scanned]

	user_client = null
	active_scanned.Cut()

/obj/item/centor_kpk/proc/get_track_target()
	return current_user

/obj/item/centor_kpk/proc/set_inactive()
	unset_client()
	active = FALSE

/obj/item/centor_kpk/proc/set_active()
	event_source = get_track_target()
	GLOB.moved_event.register(event_source, src, /obj/item/centor_kpk/proc/update_overlay)
	active = TRUE
	update_overlay()

/obj/item/centor_kpk/proc/set_enabled(targetstate)

	if(targetstate == FALSE && enabled)
		playsound(loc, turn_on_sound, 55, 1,-2)
	enabled = FALSE
	if(targetstate == TRUE)
		enabled = TRUE
		playsound(loc, turn_on_sound, 55, 1, -2)

//	if(enabled)							no power/battery need for KPK for now so let's comment this for now
//		START_PROCESSING(SSobj, src)
//	else
//		STOP_PROCESSING(SSobj, src)
	check_active(enabled)
//	update_icon()

/obj/item/centor_kpk/proc/check_location()
	//This proc checks that the scanner is where it needs to be.
	//In this case, this means it must be held in the hands of a mob

	//This is a seperate proc so that it can be overridden later. For example to allow for scanners embedded in other things
	if(!ismob(loc))
		return FALSE

	if(!is_held())
		return FALSE

	return TRUE

/obj/item/centor_kpk/proc/get_scanned_objects()
	. = list()
	if(!enabled)
		return .
	switch(mode)
		if(MODE_NONE)
			return .
		if(MODE_PATHFINDER)
			for(var/i = LAZYLEN(ihaveplacestobe), i > 0, i--)
				var/datum/excelsior_junction/route = ihaveplacestobe[i]
				for(var/arrow in route.track)
					. += arrow
		if(MODE_INFLUENCE)
			for(var/obj/effect/effect/excelsior_influence/influence in view(loc))
				. += influence

/obj/item/centor_kpk/proc/update_overlay()
	//get all objects in scan range
	var/list/scanned = get_scanned_objects()
	var/list/update_add = scanned - active_scanned
	var/list/update_remove = active_scanned - scanned
	var/temp_slot = viewpath_slot
	var/current_route
	var/do_reversed

	for(var/obj/effect/effect/pathfinder_arrow/arrow in update_add)
		if(arrow.my_route != current_route)//first arrow of it's route
			do_reversed = FALSE//reset flag for next cycle
			current_route = arrow.my_route
			if(temp_slot in orange(1, arrow))//if FIRST arrow in near our ENDpoint
				do_reversed = TRUE
				temp_slot = arrow.my_route.second
			else
				temp_slot = arrow.my_route.first

		var/mutable_appearance/overlay = get_overlay(arrow, do_reversed)
		active_scanned[arrow] = overlay
		user_client.images += overlay

	//Add new overlays
	for(var/obj/effect/effect/excelsior_influence/O in update_add)
		var/mutable_appearance/overlay = get_overlay(O)

		active_scanned[O] = overlay
		user_client.images += overlay

	//Remove stale overlays
	for(var/obj/O in update_remove)
		user_client.images -= active_scanned[O]
		active_scanned -= O

/obj/item/centor_kpk/proc/check_active(var/targetstate = TRUE)
	//First of all, check if its being turned off. This is simpler
	if(!targetstate)
		if(!active)
			//If we were just turned off, but we were already inactive, then we don't need to do anything
			return

		//We were active, ok lets shut down things
		set_inactive()
	else
		//We're trying to become active, alright lets do some checks
		//We'll do these checks even if we're already active, they ensure we can remain so
		var/can_activate = TRUE

		//First we must be enabled
		if(!enabled)
			can_activate = FALSE

		//Secondly, we must be held in someone's hands
		else if(!check_location())
			can_activate = FALSE

		//Thirdly, we need a client to display to
		else if(!user_client)
			//The client may not be set if the user logged out and in again
			set_client() //Try re-setting it
			if(!user_client)
				can_activate = FALSE

		if(!can_activate)
			//We failed the above, what now
			if(active)
				set_inactive()

		else if(!active)
			set_active()

/obj/item/centor_kpk/dropped(mob/user)
	.=..()
	set_user(null)

/obj/item/centor_kpk/equipped(mob/M)
	.=..()
	set_user(M)

/obj/item/centor_kpk/Destroy()
	set_user(null)
	.=..()

/obj/item/centor_kpk/proc/reverse_arrow(var/curDir)
	switch(curDir)
		if("1-4")
			return "8-2"
		if("8-2")
			return "1-4"

		if("8-1")
			return "2-4"
		if("2-4")
			return "8-1"

		if("1-8")
			return "4-2"
		if("4-2")
			return "1-8"

		if("2-8")
			return "4-1"
		if("4-1")
			return "2-8"


//creates a new overlay for a scanned object
/obj/item/centor_kpk/proc/get_overlay(obj/scanned, reversing)
	var/image/I = image(loc = scanned)
	if(istype(scanned, /obj/effect/effect/excelsior_influence))
		var/obj/effect/effect/excelsior_influence/influence = scanned
		if(influence.active)
			I = image('icons/obj/machines/excelsior/corenode/pda.dmi', loc = influence, icon_state = "influence", layer = ON_MOB_HUD_LAYER)
		else
			I = image('icons/obj/machines/excelsior/corenode/pda.dmi', loc = influence, icon_state = "influence_red", layer = ON_MOB_HUD_LAYER)
	if(istype(scanned, /obj/effect/effect/pathfinder_arrow))
		I = image('icons/obj/machines/excelsior/corenode/pda.dmi', loc = scanned, icon_state = "[scanned.icon_state]", layer = BELOW_MOB_LAYER)
		if(reversing)
			I.dir = reverse_direction(scanned.dir)
			if(I.icon_state != "straight")
				I.icon_state = reverse_arrow(I.icon_state)
		else
			I.dir = scanned.dir
	I.mouse_opacity = 0
	.=I


/*************************************
*				Programs			 *
**************************************/




/*
 PATHFINDER
	[?] Pathfinder is created for situations when:
		- new members join in and lack territorial awareness in the moment.
		- there's screams of "Enemies at X node!!!" but none of you know where that is.
	In-game options:
		> You can choose to autobuild pathfinder if on same Z-level between 2 nodes
		> Or you can manually lead the path if the first failed (only a matter of time)
		NOTE: In the future, other entities will use the pathfinder.



------------------------------------------| PATHFINDER - Building the path |------------------------------------------
*/

/obj/item/centor_kpk/Topic(href, href_list)
	if(href_list["open_path_dio"])
		path_diologe = TRUE

	if(href_list["close_path_dio"])
		path_diologe = FALSE

	if(href_list["open_viewpath_dio"])
		viewpath_diologe = TRUE

	if(href_list["close_viewpath_dio"])
		viewpath_diologe = FALSE

	if(href_list["open_mappings_dio"])
		mappings_diologe = TRUE

	if(href_list["close_mappings_dio"])
		mappings_diologe = FALSE

	if(href_list["toggle_overlay"])
		set_enabled(!enabled)
		mode = MODE_NONE
		ihaveplacestobe.Cut()

	if(href_list["influence_overlay"])
		mode = MODE_INFLUENCE
		set_enabled(TRUE)

	if(href_list["pathfind_overlay"])
		mode = MODE_PATHFINDER
		set_enabled(TRUE)

	if(href_list["start_pathfind"])
		start_pathfind(usr)

	if(href_list["end_pathfind"])
		end_pathfind(usr)

	if(href_list["cancel_pathfind"])
		cancel_pathfind()

	if(href_list["ok_error"])
		errors.Remove(href_list["ok_error"])

	if(href_list["see_path"])
		for(var/obj/machinery/node/noda in excelsior_nodes)
			if(noda.uid == text2num(href_list["see_path"]))
				build_path(usr, noda)
				viewpath_diologe = FALSE
				mode = MODE_PATHFINDER
				update_overlay()

	add_fingerprint(usr)
	return TOPIC_HANDLED // update UIs attached to this object

//> END TOPIC






//	Act of creating a path
/obj/item/centor_kpk/proc/start_pathfind(mob/user as mob)
	var/obj/machinery/node/closest = locate(/obj/machinery/node) in orange(1, user.loc) //TODO insert alert for the guy to come closer btw in GUI
	if(get_dir(user, closest) in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		throw_error("Please approach node from a straight angle.")
		return
	var/obj/effect/effect/pathfinder_arrow/first/arrow = new /obj/effect/effect/pathfinder_arrow/first(user.loc)
	current_route = arrow
	arrow.kpk = src
	path_diologe = FALSE
	chosen_node = closest

/obj/item/centor_kpk/proc/end_pathfind(mob/user as mob)
	var/obj/machinery/node/closest = locate(/obj/machinery/node) in orange(1, user.loc)	//TODO insert alert for the guy to come closer btw in GUI
	for(var/datum/excelsior_junction/route in excelsior_junctions)
		if(route.first == chosen_node || route.second == chosen_node)
			if(route.first == closest || route.second == closest)
				throw_error("There's already a route between those two points. Cannot create duplicates.")
				return
	var/obj/arrow = current_route.snake[current_route.snake.len]
	var/dir_to_node = get_dir(arrow, closest)
	if(dir_to_node in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		throw_error("Please approach node from a straight angle.")
		return
	if(arrow.dir != dir_to_node)
		arrow.icon_state = "[arrow.dir]-[dir_to_node]"
	var/datum/excelsior_junction/write_this_down = new /datum/excelsior_junction(chosen_node, closest, current_route.snake)
	for(var/obj/effect/effect/pathfinder_arrow/arr in write_this_down.track)
		arr.my_route = write_this_down
	chosen_node = null
	current_route = null

/obj/item/centor_kpk/proc/cancel_pathfind()
	chosen_node = null
	for(var/tile in current_route.snake)
		qdel(tile)
	current_route = null

/obj/item/centor_kpk/proc/throw_error(var/context)
	errors.Add(context)
	SSnano.update_uis(src)






/obj/effect/effect/pathfinder_arrow/first	// # This is a first spawned arrow, pointing in some direction
	var/list/snake = list()						//	- It exists to store the list of the whole "path", nothing more
	var/obj/item/centor_kpk/kpk





/obj/effect/effect/pathfinder_arrow			// # This is created by [pathifnder_arrow/first] above.
	var/obj/effect/effect/pathfinder_arrow/first/original
	var/counter = 1
	var/datum/excelsior_junction/my_route






/obj/effect/effect/pathfinder_arrow/New(loc, var/obj/effect/effect/pathfinder_arrow/previous)
	..(loc)
	icon = null
	icon_state = "straight"
	if(!previous)
		original = src
		for(var/obj/machinery/node/closest in orange(1, src))
			dir = get_dir(closest, src)
	else
		original = previous.original
		counter = previous.counter + 1
		dir = get_dir(previous, src)
		if(dir != previous.dir)
			previous.icon_state = "[previous.dir]-[get_dir(previous, src)]"
	original.snake.Add(src)
	return






/obj/effect/effect/pathfinder_arrow/Uncrossed(var/atom/movable/badguy)
	if(original.kpk.current_route != original)
		return
	if(original.kpk.get_holding_mob() != badguy)
		return
	new /obj/effect/effect/pathfinder_arrow(badguy.loc, src)


/obj/effect/effect/pathfinder_arrow/Crossed(var/atom/movable/badguy)
	if(original.kpk.current_route != original)
		return
	if(original.kpk.get_holding_mob() != badguy)
		return
	for(var/obj/effect/effect/pathfinder_arrow/item in original.snake)
		if(item.counter > counter)
			original.snake.Remove(item)
			qdel(item)



/* # Path as DATA
	- holds 2 nodes as vars
	- list/track contains
*/
/datum/excelsior_junction	// Let's write the path down somewhere once we end_...
// get names of the nodes
	var/obj/machinery/node/first	// node chosen at start_pathfind()
	var/obj/machinery/node/second	// and at the end_pathfind(), duh...

	var/list/track = list()


/datum/excelsior_junction/New(obj/machinery/node/A as obj, obj/machinery/node/B as obj, list/route) // pass the info about 2 points of the path
	first = A
	second = B
	track = route
	excelsior_junctions.Add(src)


//------------------------------------------| PATHFINDER - The act of finding |------------------------------------------
//	/obj/item/centor_kpk/build_path(usr, destination) ;*  <-- GUI
/obj/item/centor_kpk/proc/build_path(mob/user as mob, var/obj/machinery/destination)
	var/obj/machinery/node/closest = locate(/obj/machinery/node) in orange(1, user.loc)
	if(!closest)
		throw_error("You need to stand next to a node")
	else
		ihaveplacestobe.Cut()
		closest.sendPath(destination, list(), src)
		spawn(3 SECONDS)
			if(!ihaveplacestobe.len)
				throw_error("No routes found, try building one.")
				mode = MODE_NONE
				update_overlay()







#undef MODE_NONE
#undef MODE_PATHFINDER
#undef MODE_INFLUENCE
