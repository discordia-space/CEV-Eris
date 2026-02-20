/*
	................................................
	.	ROADMAP - UPDATES:
	.	[>]	Stage I
	.		Stage II
	.		S@*&#...
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
	name = "Excelsior \"Centor\" core"								// TODO consider changing a name just in case
	icon = 'icons/obj/machines/excelsior/corenode/centor.dmi'
	desc = "Metallic mind, it's silent thoughts reaching far away to the Haven."		// TODO ensure this is fine
	description_info = "Source of power for teleporters, "
	description_antag = "But with it - find strenght to keep going."
	icon_state = "static"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/electronics/circuitboard/centor
	health = 1200
	maxHealth = 1200
	shipside_only = TRUE
	var/list/obj/machinery/node/antennas_to_haven = list()
	var/timer_set			//world.time goes here :)
	var/stored_list = list()
	layer = 5
	var/cutscene = FALSE // if false = add eye overlay


// FLUFFY ANIMATION :3 //
/obj/machinery/centor/proc/start_cutscene()
	cutscene = TRUE
	update_icon()

/obj/machinery/centor/update_icon()
	overlays.Cut()
	if(!cutscene)
		overlays += "idle_anim"
	else
		overlays.Cut()

/obj/machinery/centor/proc/deploy_animation()	// pop up from the hatch
	start_cutscene()
	icon_state = "static"
	flick("deployment", src)
	spawn(1 SECOND)
		end_cutscene()

/obj/machinery/centor/proc/give_me_nodes_animation()
	var/many_nodes = stored_list + 1 SECOND
	if(!cutscene && stored_list)			// !cutscene is anti-spamclick
		start_cutscene()
		icon_state = "undeployed"
		flick("hide", src)
		spawn(2 SECONDS)
			flick("open_hatch", src)
			icon_state = "hatch"
			spawn(1 SECOND)
				for(var/obj/item in stored_list)
					spawn(5)
						item = new(loc)
						stored_list -= item
						item.throw_at(get_edge_target_turf(item, rand(1, 10)), 2, 1)
			spawn(many_nodes)
				flick("close_hatch", src)
				icon_state = "undeployed"
				spawn(1 SECOND)
					flick("deployment", src)
					icon_state = "static"
					end_cutscene()
		return 1
	return 0

/obj/machinery/centor/proc/looking_around()
	if(!cutscene)
		overlays += "idle_anim"
		spawn(17)	// ^ anim lenght
			update_icon()

/obj/machinery/centor/proc/investigating(atom/overhere) // someone's down... what? what was that? whawasat? hey you okay? BREACHING THE DOOR!!!
	if(!cutscene)
		start_cutscene()
		overlays += image(icon, loc, "dirs", 5, get_dir(src, overhere))
		spawn(1 SECOND)
			end_cutscene()

/obj/machinery/centor/die()
	start_cutscene()
	icon_state = "death_loop"
	sleep(5 SECONDS)
	icon_state = "death"
	sleep(1 SECOND)


/obj/machinery/centor/proc/end_cutscene()
	cutscene = FALSE
	update_icon()

// YOUR ANIMATIONS END HERE //


/obj/machinery/centor/Initialize(mapload, d)
	if(excelsior_centor)
		Destroy()
		return

	var/obj/item/storage/deferred/stash/sack/stash = new
	new /obj/item/computer_hardware/hard_drive/portable/design(stash)
	new /obj/item/computer_hardware/hard_drive/portable/design/excelsior/core(stash)
	new /obj/item/computer_hardware/hard_drive/portable/design/excelsior/weapons(stash)
	new /obj/item/machinery_crate/excelsior/autolathe(stash)
	new /obj/item/electronics/circuitboard/excelsior_teleporter(stash)
	stored_list += stash

	deploy_animation()
	excelsior_centor = src
	timer_set = world.time
	. = ..()
	load_network()





/obj/machinery/centor/Destroy()
	if(src == excelsior_centor)
	for(var/obj/machinery/node/node in excelsior_nodes)
		if(dist3D(src, node) <= EX_NODE_DISTANCE)
			node.spread_signal(null)
	excelsior_centor = null
	die()
	. = ..()





/obj/machinery/centor/Process()
	if(prob(5))
		looking_around()
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
		stored_list += /obj/item/machinery_crate/excelsior/node
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
		if(cutscene)
			to_chat(user, SPAN_WARNING("Please, wait. Can't pay attention now."))
			return
		if(!give_me_nodes_animation())
			if(world.time >= timer_set + EX_NODE_SPAWN_COOLDOWN)
				to_chat(user, SPAN_NOTICE("<h1>Come on, come on, give me the damn thing already!</h1>"))	// resolves a bug with timer :)
			else
				to_chat(user, SPAN_WARNING("A new node will be ready in [time2text(timer_set + EX_NODE_SPAWN_COOLDOWN-world.time, "mm:ss")] minutes."))
				investigating(user)
//		else
//
		else
			to_chat(user, SPAN_NOTICE("You pat Centor - it understands, and goes away to give you equipment..."))
			visible_message()
	else
		to_chat(user, SPAN_NOTICE ("It doesn't want me harm."))
		investigating(user)



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



