/*
[INFO] Every file that interacts with Excelsior network anyhow:
#####################################
[CODE]
_excelsior_defines.dm								- defines placed above cuz byond
centor.dm 											- core that spreads the signal through nodes
emplacement.dm 										-
excelsior_node.tmpl 								- Network UI code
node.dm 											- retranslator of the core's signal
excelsior_researches.dm 							- research tree
excelsior_items.dm 									- KPK, drones
excelsior_debug_tools.dm 							- all debug tools we made and used in case you need it

[SPRITES]

#####################################
*/

var/global/excelsior_centor

/obj/machinery/centor
	name = "Excelsior \"Centor\" node"
	icon = 'icons/obj/machines/excelsior/central.dmi'
	desc = "Central antenna of the Excelsior group connecting far into the Haven"
	icon_state = "centor"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/electronics/circuitboard/centor
	health = 300
	shipside_only = TRUE
	var/list/obj/machinery/node/antennas_to_heaven = list()

/obj/machinery/centor/Initialize(mapload, d)
	if(excelsior_centor)
		Destroy()
		return
	excelsior_centor = src
	. = ..()
	load_network()

/obj/machinery/centor/Destroy()
	. = ..()
	for(var/obj/machinery/node/node in excelsior_nodes)
		if(dist3D(src, node) <= EX_NODE_DISTANCE)
			node.spread_signal(null)
	excelsior_centor = null

/obj/machinery/centor/attack_hand(mob/user)
	. = ..()
	load_network()
	nano_ui_interact(user)

/obj/machinery/centor/proc/load_network()
	antennas_to_heaven = list()
	for(var/obj/machinery/node/node in excelsior_nodes)
		node.core = null
		node.update_icon()
	for(var/obj/machinery/node/node in excelsior_nodes)
		if(dist3D(src, node) <= EX_NODE_DISTANCE)
			node.spread_signal(src)

/obj/machinery/centor/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(user.stat || user.restrained() || stat & (BROKEN|NOPOWER))
		return
	var/list/data = nano_ui_data()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "excelsior_node.tmpl", name, 390, 450)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/centor/nano_ui_data()
	var/list/data = list()
	var/list/node_list = list()
	for(var/obj/machinery/node/node in excelsior_nodes)
		node_list += list(
			list(
				"name" = node.name,
				"x" = node.loc.x,
				"y" = node.loc.y,
				"z" = node.loc.z

		)
		)
	data["test"] = "ITS WORKING"
	data["node_list"] = node_list
									//Создаёт в пустом списке пункт test и задаёт значение ITS WORKING этому пункту
	return data										//Возвращает список data тому, кто спрашивал



