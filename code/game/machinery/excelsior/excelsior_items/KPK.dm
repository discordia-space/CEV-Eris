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
	data["current_path"] = chosen_node ? 1 : 0
	data["current_node"] = chosen_node.name

	return data

/*************************************
*				Programs			 *
**************************************/

/* Dear Alt, please don't forget the following when moving this shit into GUI:
	- KOMPAK needs to choose a node, I am NOT picking the closest node, user's intent is important here for me
	- Ok I may do it but just because I'm too fucking dumb right now
		- I'm killing you if a newbie will cry 2 nodes hes hugging arent pathfinding properly in my DMs
*/





/*
 PATHFINDER
	[?] Pathfinder is created for situations when:
		- new members join in and lack territorial awareness in the moment.
		- there's screams of "Enemies at X node!!!" but none of you know where that is.
	In-game options:
		> You can choose to autobuild pathfinder if on same Z-level between 2 nodes
		> Or you can manually lead the path if the first failed (only a matter of time)
		NOTE: In the future, other entities will use the pathfinder.
*/





//START TOPIC

/obj/item/centor_kpk/Topic(href, href_list)
	if(href_list["open_path_dio"])
		path_diologe = TRUE

	if(href_list["close_path_dio"])
		path_diologe = FALSE

	if(herf_list["start_pathfind"])
		start_pathfind(usr)

	if(herf_list["end_pathfind"])
		end_pathfind()

	if(href_list["cancel_pathfind"])
		cancel_pathfind()

	add_fingerprint(usr)
	return TOPIC_HANDLED // update UIs attached to this object

//END TOPIC






//	Act of creating a path
/obj/item/centor_kpk/proc/start_pathfind(mob/user as mob)
	var/obj/machinery/node/closest = locate() in orange(1, src) //TODO insert alert for the guy to come closer btw in GUI
	var/obj/effect/effect/pathfinder_arrow/first/arrow = new /obj/effect/effect/pathfinder_arrow/first(user.loc)
	arrow.kpk = src

	chosen_node = closest

/obj/item/centor_kpk/proc/end_pathfind()
	var/obj/machinery/node/closest = locate() in orange(1, src)	//TODO insert alert for the guy to come closer btw in GUI


	new /datum/excelsior_junction(chosen_node, closest)






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
	new /obj/effect/effect/pathfinder_arrow(badguy.loc, src)


/obj/effect/effect/pathfinder_arrow/Crossed(var/atom/movable/badguy)
	for(var/obj/effect/effect/pathfinder_arrow/item in original.snake)
		if(item.counter > counter)
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


/datum/excelsior_junction/New(obj/machinery/node/A as obj, obj/machinery/node/B as obj) // pass the info about 2 points of the path
	first = A
	second = B
	excelsior_junctions.Add(src)





#undef MODE_NONE
#undef MODE_PATHFINDER
