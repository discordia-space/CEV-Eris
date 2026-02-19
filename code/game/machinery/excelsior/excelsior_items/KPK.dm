#define MODE_NONE 1
#define MODE_PATHFINDER 2
#define MODE_INFLUENCE 3
#define OVERLAY_CACHE_LEN 200




/obj/item/centor_kpk/
	name = "\improper Excelsior KOMPAK"
	desc = "Comrade's second best friend, besides their first best friend."
	icon = 'icons/obj/machines/excelsior/corenode/pda.dmi'
	icon_state = "kompak_off"
	opacity = 0
	density = FALSE
	anchored = FALSE
	w_class = ITEM_SIZE_NORMAL
	var/mode = MODE_NONE		// TODO return to MODE_NONE
								// TO BE USED BY GUI DON'T FORGET

	var/list/active_scanned = list() //assoc list of objects being scanned, mapped to their overlay
	var/datum/event_source //When listening for movement, this is the source we're listening to
	var/mob/current_user //The last mob who interacted with us. We'll try to fetch the client from them
	var/client/user_client //since making sure overlays are properly added and removed is pretty important, so we track the current user explicitly
	var/enabled = FALSE
	var/active
	var/list/objects_to_overlay = list()
	var/global/list/excelsior_overlay_cache = list()
	var/turn_on_sound = 'sound/effects/Custom_flashlight.ogg'

	//GUI WAR ZONE
	var/path_diologe = FALSE
	var/viewpath_diologe = FALSE
	var/obj/machinery/node/chosen_node
	var/obj/effect/effect/pathfinder_arrow/first/current_route
	var/list/ihaveplacestobe = list()	//kpk receives a list from node to make a long fucking road
	var/list/errors = list()

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
	if(current_user == newuser)
		return //Do nothing

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
	//Check power here#
	if(targetstate == FALSE && enabled)
		playsound(loc, turn_on_sound, 55, 1,-2)
	enabled = FALSE
	if(targetstate == TRUE)
		enabled = TRUE
		playsound(loc, turn_on_sound, 55, 1, -2)

//	if(enabled)							no power for KPK for now so let's comment this for now
//		START_PROCESSING(SSobj, src)
//	else
//		STOP_PROCESSING(SSobj, src)
	check_active(enabled)
//	update_icon()						when you sprite it lmao

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
	switch(mode)
		if(MODE_NONE)
			return .
		if(MODE_PATHFINDER)
			for(var/datum/excelsior_junction/route in ihaveplacestobe)
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

	//Add new overlays
	for(var/obj/O in update_add)
		var/mutable_appearance/overlay = get_overlay(O)
		//var/image/overlay = get_overlay(O)

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

//creates a new overlay for a scanned object, if needed
/obj/item/centor_kpk/proc/get_overlay(obj/scanned)
	//Use a cache so we don't create a whole bunch of new images just because someone's walking back and forth in a room.
	//Also means that images are reused if multiple people are using t-rays to look at the same objects.
	if(scanned in excelsior_overlay_cache)
		. = excelsior_overlay_cache[scanned]
	else
		var/image/I = image(loc = scanned)
		if(istype(scanned, /obj/effect/effect/excelsior_influence))
			var/obj/effect/effect/excelsior_influence/influence = scanned
			if(influence.active)
				I = image('icons/obj/machines/excelsior/corenode/pda.dmi', loc = influence, icon_state = "influence", layer = ON_MOB_HUD_LAYER)
			else
				I = image('icons/obj/machines/excelsior/corenode/pda.dmi', loc = influence, icon_state = "influence_red", layer = ON_MOB_HUD_LAYER)
		if(istype(scanned, /obj/effect/effect/pathfinder_arrow))
			I = image('icons/obj/machines/excelsior/corenode/pda.dmi', loc = scanned, icon_state = "[scanned.icon_state]", layer = BELOW_MOB_LAYER)
			I.dir = scanned.dir
		I.mouse_opacity = 0
		.=I

	// Add it to cache, cutting old entries if the list is too long
	excelsior_overlay_cache[scanned] = .
	if(excelsior_overlay_cache.len > OVERLAY_CACHE_LEN)
		excelsior_overlay_cache.Cut(1, excelsior_overlay_cache.len-OVERLAY_CACHE_LEN-1)

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

	if(href_list["toggle_overlay"])
		set_enabled(!enabled)

	if(href_list["clear_overlay"])
		mode = MODE_NONE
		update_overlay()

	if(href_list["influence_overlay"])
		mode = MODE_INFLUENCE
		update_overlay()

	if(href_list["pathfind_overlay"])
		mode = MODE_PATHFINDER
		update_overlay()

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

	add_fingerprint(usr)
	return TOPIC_HANDLED // update UIs attached to this object

//> END TOPIC






//	Act of creating a path
/obj/item/centor_kpk/proc/start_pathfind(mob/user as mob)
	var/obj/machinery/node/closest = locate(/obj/machinery/node) in orange(1, user.loc) //TODO insert alert for the guy to come closer btw in GUI
	var/obj/effect/effect/pathfinder_arrow/first/arrow = new /obj/effect/effect/pathfinder_arrow/first(user.loc)
	current_route = arrow
	arrow.kpk = src
	path_diologe = FALSE
	chosen_node = closest

/obj/item/centor_kpk/proc/end_pathfind(mob/user as mob)
	var/obj/machinery/node/closest = locate(/obj/machinery/node) in orange(1, user.loc)	//TODO insert alert for the guy to come closer btw in GUI
	new /datum/excelsior_junction(chosen_node, closest, current_route.snake)
	var/obj/arrow = current_route.snake[current_route.snake.len]
	var/dir_to_node = get_dir(arrow, closest)
	if(arrow.dir != dir_to_node)
		arrow.icon_state = "[arrow.dir]-[dir_to_node]"
	chosen_node = null
	current_route = null

/obj/item/centor_kpk/proc/cancel_pathfind()
	chosen_node = null
	for(var/tile in current_route.snake)
		qdel(tile)
	current_route = null






/obj/effect/effect/pathfinder_arrow/first	// # This is a first spawned arrow, pointing in some direction
	var/list/snake = list()						//	- It exists to store the list of the whole "path", nothing more
	var/obj/item/centor_kpk/kpk





/obj/effect/effect/pathfinder_arrow			// # This is created by [pathifnder_arrow/first] above.
	var/obj/effect/effect/pathfinder_arrow/first/original
	var/counter = 1






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
	new /obj/effect/effect/pathfinder_arrow(badguy.loc, src)


/obj/effect/effect/pathfinder_arrow/Crossed(var/atom/movable/badguy)
	if(original.kpk.current_route != original)
		return
	for(var/obj/effect/effect/pathfinder_arrow/item in original.snake)
		if(item.counter > counter)
			original.snake.Remove(item)
			qdel(item)



/* # Path as DATA
	- holds 2 nodes as vars
*/
/datum/excelsior_junction	// Let's write the path down somewhere once we end_...
// get names of the nodes
	var/obj/machinery/node/first	// node chosen at start_pathfind()
	var/obj/machinery/node/second	// and at the end_pathfind(), duh...

	//road itself consisting
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
	closest.sendPath(destination, list(), src)







#undef MODE_NONE
#undef MODE_PATHFINDER
#undef MODE_INFLUENCE
#undef OVERLAY_CACHE_LEN
