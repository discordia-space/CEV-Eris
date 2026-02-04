/*
	................................................
	.	ROADMAP - UPDATES:
	.	[>]	Stage I - The Chains of Liberation
	.		Stage II - Echoes of Ambition
	.		S@*&#... - ..?
	................................................				ATTENTION!
												For your convenience, below are structurized contents of Excelsior Code





[NEW CODE]----------------------------------------------[EXPLANATION]
_excelsior_defines.dm									- defines placed above cuz byond


centor.dm 												- Excelsior AI core, generates excelsior power from Nodes
node.dm 												- Generate power if connected to core



emplacement.dm											- Machinery transportation system
excelsior_node.tmpl 									- Network UI code
excelsior_researches.dm 								- Research tree, duh.  			(Well, you have all the blueprints...
																									...it's just a weak Wi-Fi.)
excelsior_items[folder] 										- NEW items, like KOMPAK and something else in the future



excelsior_debug_tools.dm 							- all debug tools we made and used in case you need it dear slopper



[OLD CODE]----------------------------------------------[NOTES]
ex_teleporter.dm
ex_turret.dm
implantmaker.dm
redirector.dm
boombox.dm


[SPRITES]


*/

var/global/excelsior_centor

/obj/machinery/centor
	name = "Excelsior \"Centor\" node"								// TODO consider changing a name just in case
	icon = 'icons/obj/machines/excelsior/central.dmi'
	desc = "An Excelsior AI, reaching far away for the Haven."		// TODO ensure this is fine
	icon_state = "centor"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/electronics/circuitboard/centor
	health = 300
	shipside_only = TRUE
	var/list/obj/machinery/node/antennas_to_haven = list()
	var/timer_set			//world.time goes here :)
	var/stored_nodes = 1




/obj/machinery/centor/Initialize(mapload, d)
	if(excelsior_centor)
		Destroy()
		return
	excelsior_centor = src
	timer_set = world.time
	. = ..()
	load_network()





/obj/machinery/centor/Destroy()
	. = ..()
	for(var/obj/machinery/node/node in excelsior_nodes)
		if(dist3D(src, node) <= EX_NODE_DISTANCE)
			node.spread_signal(null)
	excelsior_centor = null





/obj/machinery/centor/Process()
	collect_tax()	// this is where we get energy :]
	increase_node_amount()




/obj/machinery/centor/proc/collect_tax()
	for(var/obj/machinery/complant_teleporter/tele in excelsior_teleporters)		// !! Debug - Remove on release
		tele.old_energy = excelsior_energy											// !! Debug - Remove on release
	for(var/obj/machinery/node/node in antennas_to_haven)
		excelsior_energy += (node.activemarkerlist.len / node.localmarkerlist.len)	// +1 energy if all markers (influence) are active, see more at [node.dm]
	if(excelsior_energy >= excelsior_max_energy)
		excelsior_energy = excelsior_max_energy
		return

/obj/machinery/centor/proc/increase_node_amount()
	if(world.time >= timer_set + EX_NODE_SPAWN_COOLDOWN)
		stored_nodes++
		timer_set = world.time
		playsound(loc, 'sound/machines/vending_drop.ogg', 25, 1)




/obj/machinery/centor/attack_hand(mob/user)
//	. = ..()		//uncomment to give power consumption :)	(I dont want it...)
	load_network()
	spawn_compact_node(user)
	//nano_ui_interact(user)




/obj/machinery/centor/proc/load_network()
	antennas_to_haven = list()
	for(var/obj/machinery/node/node in excelsior_nodes)
		node.core = null
		node.update_icon()
	for(var/obj/machinery/node/node in excelsior_nodes)
		if(dist3D(src, node) <= EX_NODE_DISTANCE)
			node.spread_signal(src)


// TODO: ASK FOR FACTION!!!
/obj/machinery/centor/proc/spawn_compact_node(mob/user)
	if(is_excelsior(user))
		var/obj/item/machinery_crate/excelsior/node/thething = new()
		if(stored_nodes >= 1)
			stored_nodes--
			to_chat(user, SPAN_NOTICE("You pull out [thething] out of Centor's production slot.[stored_nodes ? " You count [stored_nodes] more" : " You're out of Nodes for now."]"))
			user.put_in_hands(thething)

		else if(world.time >= timer_set + EX_NODE_SPAWN_COOLDOWN)
			to_chat(user, SPAN_NOTICE("You eagerly look into the hatch. It JUST produced a new Node!"))
		else
			to_chat(user, SPAN_WARNING("A new Node will be ready in [time2text(timer_set + EX_NODE_SPAWN_COOLDOWN-world.time, "mm:ss")] minutes."))
	else
		to_chat(user, SPAN_DANGER ("It beeps when I touch it, like in anger."))



/obj/machinery/centor/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(user.stat || user.restrained() || stat & (BROKEN|NOPOWER))
		return
	var/list/data = nano_ui_data()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "excelsior_node.tmpl", name, 390, 450)
		ui.set_initial_data(data)
		ui.open()





/obj/machinery/centor/nano_ui_data()		// TODO check this at the finishing line, there's test stuff
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

	return data



