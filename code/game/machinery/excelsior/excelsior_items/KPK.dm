
#define MODE_NONE 1
#define MODE_PATHFINDER 2





/obj/item/centor_kpk/
	name = "\improper Excelsior KOMPAK"
	desc = "Comrade's second best friend, besides their first best friend."
	icon = 'icons/obj/machines/excelsior/central.dmi'   					// get new sproite
	icon_state = "rcd" 														// get new sproite
	opacity = 0
	density = FALSE
	anchored = FALSE
	w_class = ITEM_SIZE_NORMAL

	var/mode = MODE_PATHFINDER	// TODO return to MODE_NONE



/*************************************
*				Programs			 *
**************************************/
/obj/item/centor_kpk/afterattack(var/obj/machinery/node/my_node, mob/user as mob)
	switch(mode)
		if(MODE_NONE)
			return
		if(MODE_PATHFINDER)
			start_pathfind(my_node, user)





/*
 PATHFINDER
	[?] Pathfinder is created for situations when:
		- new members join in and lack territorial info
		- or when the node network gets too big to react to threats normally.
		> You can choose to autobuild pathfinder if on same Z-level between 2 nodes
		> Or you can manually lead the path if the first failed (only a matter of time)
		NOTE: In the future, other entities will use the pathfinder.
*/

/obj/effect/effect/pathfinder_arrow
	var/list/snake = list()
	var/original
	var/counter = 1

/obj/effect/effect/pathfinder_arrow/New(loc, var/obj/effect/effect/pathfinder_arrow/previous)
	..(loc)
	counter = previous.counter++
	snake.Add(src)

/obj/effect/effect/pathfinder_arrow/Uncrossed(var/atom/movable/badguy)
	new /obj/effect/effect/pathfinder_arrow(badguy.loc, src)




/obj/item/centor_kpk/proc/start_pathfind(/obj/machinery/node/my_node, mob/user as mob)
	var/obj/effect/effect/pathfinder_arrow/arrow = new /obj/effect/effect/pathfinder_arrow(user)








/obj/item/centor_kpk/proc/end_pathfind()

#undef MODE_NONE
#undef MODE_PATHFINDER
