//	>>>Better info in centor.dm <<<	//


/obj/machinery/node
	name = "Excelsior \"Tochka\" node"
	icon = 'icons/obj/machines/excelsior/redirector.dmi'
	desc = "A retranslator node that amplifies signal from the teleporter"
	icon_state = "redirector_finished"
	anchored = TRUE
	density = TRUE
	circuit = /obj/item/electronics/circuitboard/excelsior_node
	health = 300
	shipside_only = TRUE
	var/list/obj/machinery/linked = list()
	var/list/obj/machinery/node/neighbours = list()
	var/obj/machinery/centor/core

	var/list/localturflist = list() // on destroy will remove the whole list from global one
	var/list/localmarkerlist = list() // if a node got turned off it shouldnt generate power from marked territory

/obj/machinery/node/Initialize(mapload, d)
	. = ..()
	excelsior_nodes.Add(src)
	search_for_machines()
	search_for_nodes()
	define_influence()
	if(excelsior_centor)
		var/obj/machinery/centor/C = excelsior_centor
		C.load_network()
	update_icon()

/obj/machinery/node/Destroy()
	. = ..()
	cleanup_influence()

	excelsior_nodes.Remove(src)
	for(var/obj/machinery/machine in linked)
		SEND_SIGNAL(machine, COMSIG_EX_CONNECT)
	for(var/obj/machinery/node/N in neighbours)
		N.disconnect(src, TRUE)
	if(core)
		core.load_network()


/obj/machinery/node/proc/update_influence()
	cleanup_influence()
	spawn(1)
	define_influence()


/obj/machinery/node/proc/cleanup_influence() 					// REMOVE INFLUENCE
	localturflist = list()

	for(var/marker in localmarkerlist)
		QDEL_NULL(marker)
	localmarkerlist = list()


/obj/machinery/node/proc/define_influence() // ADD INFLUENCE
	for(var/turf/floor/selected in orange(EX_NODE_DISTANCE, src))
		var/obj/item/clothing/head/preacher/influence_marker = new /obj/item/clothing/head/preacher(selected)
		if(influence_marker) // prevent adding NULL to the list
			localmarkerlist.Add(influence_marker)
		if(selected)
			localturflist.Add(selected)
	if(core)
		excelsior_globalturflist += localturflist
		excelsior_globalmarkerlist += localmarkerlist


/obj/machinery/node/Process() // WATCH OUT A MINE BLYAT...
	update_influence()

/obj/machinery/node/update_icon()
	. = ..()
	if(!core)
		icon_state = "redirector_bent"
	else
		icon_state = "redirector_finished"

/obj/machinery/node/attack_hand(mob/user)
	. = ..()
	to_chat(user, "Linked machinery:")
	for(var/obj/machinery/machine in linked)
		to_chat(user, machine.name)
	to_chat(user, "Linked nodes:")
	for(var/obj/machinery/machine in neighbours)
		to_chat(user, "[machine.name] [dist3D(src, machine)]m away")

//This is for structures that are inactive UNTIL they are connected to any node.  (e.g. emplacements)
/obj/machinery/node/proc/search_for_machines()
	for(var/obj/machinery/machine in orange(EX_NODE_DISTANCE))
		SEND_SIGNAL(machine, COMSIG_EX_CONNECT)

//Tries to connect to other nodes EVEN BETWEEN Z LEVELS and tells nodes to spread the net
/obj/machinery/node/proc/search_for_nodes()
	for(var/obj/machinery/node/N in excelsior_nodes)
		if(dist3D(src, N) <= EX_NODE_DISTANCE && N != src)
			connect(N, TRUE)
			N.connect(src, TRUE)
			if(N.core)
				src.spread_signal(N.core)

//Adds machine to ether list of connected nodes or list of connected machines as specified by is_node argument
//Checks if machine is on the list before adding to avoid dupes
/obj/machinery/node/proc/connect(var/obj/machinery/M, var/is_node = FALSE)
	if(is_node)
		if(!neighbours.Find(M))
			neighbours.Add(M)
	else
		if(!linked.Find(M))
			linked.Add(M)

//Removes machine from list of nodes or list of machines as specifed by is_node argument
//Checks if machine is on the list before deletion
/obj/machinery/node/proc/disconnect(var/obj/machinery/M, var/is_node = FALSE)
	if(is_node)
		if(neighbours.Find(M))
			neighbours.Remove(M)
	else
		if(linked.Find(M))
			linked.Remove(M)

//When nodes recieve this proc they check if they are connected to Centor
//and if not - they connect to it and send this proc to other nodes nearby
/obj/machinery/node/proc/spread_signal(var/center)
	if(core)	//checks if already connected to avoid infinite recursion
		return
	core = center
	core.antennas_to_heaven.Add(src)
	update_icon()
	for(var/obj/machinery/node/N in neighbours)
		N.spread_signal(center)

