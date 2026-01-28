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

/obj/item/centor_kpk/attack_self(mob/user)
	. = ..()
	nano_ui_interact(user)

/obj/item/centor_kpk/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	//var/list/data = nano_ui_data()
	var/list/data = list()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "excelsior_kpk.tmpl", name, 450, 500)
		ui.set_initial_data(data)
		ui.open()

/*************************************
*				Programs			 *
**************************************/
//
//START TOPIC
//
/obj/item/centor_kpk/Topic(href, href_list)
	if(href_list["give_candy"])
		start_pathfind(null, usr)//zero nodes given at the moment

	add_fingerprint(usr)
	return TOPIC_HANDLED // update UIs attached to this object
//
//END TOPIC
//

/obj/item/centor_kpk/proc/start_pathfind(obj/machinery/node/my_node, mob/user as mob)
	var/obj/effect/effect/pathfinder_arrow/first/arrow = new /obj/effect/effect/pathfinder_arrow/first(user.loc)

/obj/item/centor_kpk/proc/end_pathfind()






/*
 PATHFINDER
	[?] Pathfinder is created for situations when:
		- new members join in and lack territorial info
		- or when the node network gets too big to react to threats normally.
		> You can choose to autobuild pathfinder if on same Z-level between 2 nodes
		> Or you can manually lead the path if the first failed (only a matter of time)
		NOTE: In the future, other entities will use the pathfinder.
*/
/obj/effect/effect/pathfinder_arrow/first
	var/list/snake = list()
/obj/effect/effect/pathfinder_arrow
	var/obj/effect/effect/pathfinder_arrow/first/original
	var/counter = 1

/obj/effect/effect/pathfinder_arrow/New(loc, var/obj/effect/effect/pathfinder_arrow/previous)
	..(loc)
	counter = previous.counter++
	original.snake.Add(src)
	return

/obj/effect/effect/pathfinder_arrow/Uncrossed(var/atom/movable/badguy)
	new /obj/effect/effect/pathfinder_arrow(badguy.loc, src)


/obj/effect/effect/pathfinder_arrow/Crossed(var/atom/movable/badguy)
	for(var/obj/effect/effect/pathfinder_arrow/item in original.snake)
		if(item.counter > counter)
			qdel(item)









#undef MODE_NONE
#undef MODE_PATHFINDER
