/obj/item/pai_cable/proc/plugin(obj/machinery/M as obj,69ob/user as69ob)
	if(istype(M, /obj/machinery/door) || istype(M, /obj/machinery/camera))
		user.visible_message("69user69 inserts 69src69 into a data port on 69M69.", "You insert 69src69 into a data port on 69M69.", "You hear the satisfying click of a wire jack fastening into place.")
		user.drop_item()
		src.loc =69
		src.machine =69
	else
		user.visible_message("69user69 dumbly fumbles to find a place on 69M69 to plug in 69src69.", "There aren't any ports on 69M69 that69atch the jack belonging to 69src69.")

/obj/item/pai_cable/attack(obj/machinery/M as obj,69ob/user as69ob)
	src.plugin(M, user)
