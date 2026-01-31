#define MODE_NONE 1
#define MODE_PATHFINDER 2





/obj/item/centor_kpk/
	name = "\improper Excelsior KOMPAK"
	desc = "Comrade's second best friend, besides their first best friend."
	icon = 'icons/obj/modular_tablet.dmi' 						 					// get new sproite
	icon_state = "tabletsol" 														// get new sproite
	opacity = 0
	density = FALSE
	anchored = FALSE
	w_class = ITEM_SIZE_NORMAL
	var/mode = MODE_PATHFINDER	// TODO return to MODE_NONE
								// TO BE USED BY GUI DON'T FORGET
	//GUI WAR ZONE
	var/path_diologe = FALSE
	var/obj/machinery/node/chosen_node
	var/obj/effect/effect/pathfinder_arrow/first/current_route
	var/list/ihaveplacestobe = list()	//kpk receives a list from node to make a long fucking road

/obj/item/centor_kpk/attack_self(mob/user)
	. = ..()
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
	data["current_node"] = chosen_node ? chosen_node.name : "ERR: NODE NOT FOUND"

	var/list/node_list = list()
	for(var/obj/machinery/node/noda in excelsior_nodes)
		node_list += list(
			list(
				"name_n" = noda.name,
				"commands_n" = list("see_path" = noda.uid)
			)
		)

	data["node_list"] = node_list

	return data

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

	if(href_list["start_pathfind"])
		start_pathfind(usr)

	if(href_list["end_pathfind"])
		end_pathfind(usr)

	if(href_list["cancel_pathfind"])
		cancel_pathfind()

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
	if(!previous)
		original = src
	else
		original = previous.original
		counter = previous.counter + 1
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
	var/path_result = get_path(user, destination)
	to_chat(user, SPAN_NOTICE(path_result))
//	get_path()

/obj/item/centor_kpk/proc/get_path(mob/user as mob, var/obj/machinery/destination)
	var/obj/machinery/node/closest = locate(/obj/machinery/node) in orange(1, user.loc)
	closest.sendPath(destination, list(), src)
	return



/obj/item/centor_kpk/proc/finish_forming()
	chosen_node = null







#undef MODE_NONE
#undef MODE_PATHFINDER
