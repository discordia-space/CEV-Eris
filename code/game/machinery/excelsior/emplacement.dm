/*

stage 2

/obj/machinery/emplacement
	name = "Excelsior emplacement"
	icon = 'icons/obj/machines/excelsior/emplacement.dmi'
	description_info = "It won't work without the screened coaxial cable leading to Excelsior Node. T-ray scanners can detect one under the floor for easy cutting."
	description_antag = "This contraption transports Excelsior buildings, standing on top of it."
	desc = "A new era trapdoor. It's dangerous now."
	icon_state = "pol"
	density = FALSE
	health = 300
	shipside_only = TRUE
	var/obj/machinery/node/my_node

/obj/machinery/emplacement/Initialize(mapload, d)
	. = ..()
	RegisterSignal(src, COMSIG_EX_CONNECT, PROC_REF(search_for_node))
	search_for_node()

/obj/machinery/emplacement/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_EX_CONNECT)
	if(my_node)
		my_node.disconnect(src)

/obj/machinery/emplacement/update_icon()
	..()
	if(my_node)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)

/obj/machinery/emplacement/proc/search_for_node()
	var/obj/machinery/node/closest
	var/closest_dist = EX_NODE_DISTANCE + 1
	for (var/obj/machinery/node/node in excelsior_nodes)
		if(get_dist(src, node) < closest_dist)
			closest = node
			closest_dist = dist3D(src, closest)
	if(closest)
		closest.connect(src)
		my_node = closest
		update_icon()
		return TRUE
	else
		my_node = null
		update_icon()
		return FALSE

/obj/item/unemplacement
	name = "Packaged Excelsior emplacement"
	desc = "A new era trapdoor. Harmless."
	description_info = "It won't work without the wire leading to a Node. T-ray scanners can detect one under the floor."	// DEBUG DEBUG DEBUG
	description_antag = "This contraption transports Excelsior buildings, standing on top of it. Place on a floor tile."
	icon = 'icons/obj/machinery_crates.dmi'
	icon_state = "standart"
	anchored = FALSE
	w_class = ITEM_SIZE_HUGE
	slowdown_hold = 0.5
	throw_range = 2
	matter = list(MATERIAL_PLASTIC = 10, MATERIAL_PLASTEEL = 5, MATERIAL_STEEL = 10)
*/
