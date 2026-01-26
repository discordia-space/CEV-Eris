//__________________________________//
//		Better info in centor.dm 	// << !
//__________________________________//

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

	var/emplacement_storage = 4
	var/list/localturflist = list() 								// on destroy will remove the whole local list from global one
	var/list/localmarkerlist = list() 								// if a node got turned off it shouldnt generate excelsior power, thus we count locally
	var/list/activemarkerlist = list()
	var/what_is_marker = /obj/effect/effect/excelsior_influence



	//cooldowns
	var/list/intruder_list = list()
	var/report_cooldown






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
	UnregisterSignal(src, COMSIG_TURF_LEVELUPDATE)
	for(var/obj/machinery/node/noder in neighbours)
		noder.update_influence()







	excelsior_nodes.Remove(src)
	for(var/obj/machinery/machine in linked)
		SEND_SIGNAL(machine, COMSIG_EX_CONNECT)
	for(var/obj/machinery/node/N in neighbours)
		N.disconnect(src, TRUE)
	if(core)
		core.load_network()







/obj/machinery/node/proc/update_influence()																	// BOTH	//
	cleanup_influence() 		// remove influence tiles produced by ONE node that it calls
	define_influence() 			// force node to count tiles around for power generation





/obj/machinery/node/proc/define_influence() 	// ADD INFLUENCE //
	for(var/turf/selected in circlerangeturfs(src, EX_NODE_DISTANCE))								// replace from debug_number back to
		if(!locate(/obj/effect/effect/excelsior_influence) in selected)															//
			var/influence_marker = new /obj/effect/effect/excelsior_influence(loc = selected, creator = src)
			if(influence_marker) 																		// prevent adding NULL to the list
				localmarkerlist.Add(influence_marker)
			if(selected)
				localturflist.Add(selected)
//			if(core)
//				excelsior_globalturflist += localturflist
//				excelsior_globalmarkerlist += localmarkerlist
		else
			continue






/obj/machinery/node/proc/cleanup_influence() 	// REMOVE INFLUENCE //
	localturflist = list()

	for(var/marker in localmarkerlist)
		QDEL_NULL(marker)
	localmarkerlist = list()
	activemarkerlist = list()






/obj/machinery/node/proc/pick_up_emplacement(var/mob/living/carbon/human/user)
	if(emplacement_storage >= 1)
		var/obj/item/unemplacement/emplacement = /obj/item/unemplacement	// item that will then become the machinery
		user.put_in_active_hand(new emplacement)
		emplacement_storage--
		//add ability to put it back in - delete comment if done










/*
/obj/machinery/node/Process() 		// Yeah let's not do the lagfest
	update_influence()
*/






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
	pick_up_emplacement(user)






// Some structures need node in radius to power up and work, this is the proc that searches (e.g. emplacements)
/obj/machinery/node/proc/search_for_machines()
	for(var/obj/machinery/machine in circlerangeturfs(src, EX_NODE_DISTANCE))
		SEND_SIGNAL(machine, COMSIG_EX_CONNECT)






//Searches for other nodes EVEN BETWEEN Z LEVELS.
/obj/machinery/node/proc/search_for_nodes()
	for(var/obj/machinery/node/N in excelsior_nodes)
		if(dist3D(src, N) <= EX_NODE_DISTANCE && N != src)
			connect(N, TRUE)
			N.connect(src, TRUE)
			if(N.core)
				src.spread_signal(N.core)






//Adds machine to either list of connected nodes or list of connected machines as specified by is_node argument
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






//Nodes check if they are connected to Centor. If not - connect to Centor, then pass the order like a disease to other nodes.
//	Why? -> Core+Node gameplay is defined by territorial control, "cut off" nodes shouldn't be active.
/obj/machinery/node/proc/spread_signal(var/center)
	if(core)	//checks if already connected to avoid infinite recursion
		return
	core = center
	core.antennas_to_haven.Add(src)
	update_icon()
	for(var/obj/machinery/node/N in neighbours)
		N.spread_signal(center)






//_____________________________________________________________________________________________________________________________
//													| Node Radio responses |
//_____________________________________________________________________________________________________________________________






// # DETECTION of non-excelsior human

//		- The act of yapping itself

/obj/machinery/node/proc/talk(message)										// the act of yapping
	var/datum/faction/F = get_faction_by_id(FACTION_EXCELSIOR)
	//if(!F)							//DEBUG REMOVE LATER AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	//	return							//DEBUG REMOVE LATER AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	F.communicate_inanimate(src, message)



//		- The thinking behind reporting a bypasser

/obj/machinery/node/proc/intruder_alert(var/mob/living/intruder)
																// TO IMPLEMENT: Ask Node what the human has in weapons through KPK
	if(world.time - report_cooldown >= 15 SECONDS)			// Don't report the same person twice in x seconds
		intruder_list = list()								//!!! TEST THE COOLDOWN. DELETE AFTER TEST
		report_cooldown = world.time

	if(intruder_list.Find(intruder))	// We don't need the same guy reported
		return						//
	if(istype(intruder, /mob/living/carbon/human))
		if(intruder.stats.getPerk(PERK_VAGABOND) || intruder.name == "Unknown")	// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!WARNINGWARNINGWARNING FUCKING CHECK THIS IN GAME ACTUALLY		//vagabonds have long job titles
			talk("A non-crew enemy human [intruder.name] spotted at [name]")
			intruder_list.Add(intruder)
			return
		talk("Enemy human [intruder.name] spotted at [name]")
		intruder_list.Add(intruder)
		return
	if(istype(intruder, /mob/living/silicon/robot))
		talk("Enemy robot [intruder.name] spotted at [name]")
		intruder_list += intruder
		return

	//MESSAGE
	//	//clean stuff that was reported








//_____________________________________________________________________________________________________________________________
//															| Influence |
//_____________________________________________________________________________________________________________________________

/* [?] INFLUENCE is a tile, captured by a NODE into a local list.
		1.	Influence tile Destroy() itself if tile is occupied by another influence
		1.	Core counts all captured by node tiles into local list
*/

/obj/effect/effect/excelsior_influence 												//	# It's shown on Excel HUD. To find the code do either:
	var/active = FALSE																	//	> Search by "process_excel_hud" in
	var/obj/machinery/node/node															//	> hud.dm [code\defines\procs]		[line 60 as of now]






/obj/effect/effect/excelsior_influence/New(loc, var/obj/machinery/node/creator)		// - All the thinking is done at define_influence()
	..(loc)
	icon = null
	icon_state = null
	node = creator
	validate()
	RegisterSignal(src, COMSIG_TURF_LEVELUPDATE, PROC_REF(validate))






/obj/effect/effect/excelsior_influence/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_TURF_LEVELUPDATE)





/obj/effect/effect/excelsior_influence/proc/validate()	// # Checks if marker is "active" from core's connection.
    if(!node)                                            // this... shouldn't happen
        Destroy()
        return
    var/turf/my_turf = get_turf(src)
    for(var/type in excelsior_turf_whitelist)				//	1.	Is whitelist tile?
        if(istype(my_turf, type))
            active = TRUE
            if(!node.activemarkerlist.Find(src))
                node.activemarkerlist.Add(src)
            return TRUE
    active = FALSE
    if(node.activemarkerlist.Find(src))
        node.activemarkerlist.Remove(src)
    return FALSE





/obj/effect/effect/excelsior_influence/Crossed(var/mob/living/intruder)		// # If a living mob steps on influence...
	if(!is_excelsior(intruder))												// 	1.	If EXCELSIOR = STOP
		if(!intruder.restrained() && !intruder.lying)						//	2.	Arrested/Unconcious/Crawling people? - don't care 					(intentional)
			node.intruder_alert(intruder)									// 	3.	All good? report the good guy get his ass!!





