
/*
Contents:
#######################
+ Toolbox with all tools
	- Node spawner
#######################
*/

/* < ERASE THIS LINE TO ADD ALL DEBUG TOOLS


/obj/item/exceldebugtoolspawnertoolbox/ <FUCKING UNFINISHED

/obj/item/nodespawner
	name = "\improper Node spawner"
	desc = "Fuck my femboy life mane..."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rcd"
	opacity = 0
	density = FALSE
	anchored = FALSE
	w_class = ITEM_SIZE_NORMAL




/obj/item/nodespawner/afterattack(atom/A, mob/user as mob)

	if(istype(A, /obj/machinery/node))
		to_chat(user, "Deleted node womp womp")
		playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
		qdel(A)
		return


	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)

	to_chat(user, "Spawned node YEAAAAAH")
	new /obj/machinery/node(get_turf(A))




*/
