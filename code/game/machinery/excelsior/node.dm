/*
Better info in centor.dm
Don't get spooked - there's comments below
*/
/*
Small Dictionary:
	# Node chain
		- Node chain is when Centor picks up the first node in proximity, tells it it's "powered", making it produce energy,
		control turrets, THEN pass that "powered" status to other nodes they are connected to.
		[Note] The "powered" status is checked with node.core.
*/



/obj/machinery/node
	name = "Excelsior \"Tochka\" node"
	icon = 'icons/obj/machines/excelsior/redirector.dmi'	// TODO replace on finish
	desc = "Nodes both amplify Centor's signals sent to Haven, providing consistent resupplies, and grant it control over turrets far away."
	icon_state = "redirector_finished"						// TODO replace on finish
	description_info = "Nodes chain from Centor outwards, the more \"ship ground\" they cover - the better."
	description_antag = "Node surface coverage can be seen with Excelsior HUD."
	anchored = TRUE
	density = TRUE
	circuit = /obj/item/electronics/circuitboard/excelsior_node
	health = 300
	shipside_only = TRUE
	var/list/obj/machinery/linked = list()
	var/list/obj/machinery/node/neighbours = list()
	var/obj/machinery/centor/core

	//var/emplacement_storage = 4
	var/list/localmarkerlist = list() 	/* On destroy() or "turning off" (only if disconnected from Centor's node chain) will...
											> remove the whole local list (node) from global one (Centor interacts with it)
											- Feature, cut off Excelsior's "logistics" and forward bases won't work */
	var/list/activemarkerlist = list()
	var/what_is_marker = /obj/effect/effect/excelsior_influence

	//# Cooldowns
	var/list/intruder_list = list()
	var/report_cooldown






/obj/machinery/node/proc/make_name()
	var/list/namelist = list(
	"Zvezda",
	"Barrikada",
	"Volna",
	"Abzats",
	"Pioner",
	"Dyatel",
	"Malyutka",
	"Durak",
	"Vampir",
	"Kolobok",
	"Udav",
	"Zenit",
	"Sport",
	"Spidola",
	"Mayak",
	"Zorkiy",
	"Iskra",
	"Lider",
	"Sirius",
	"Yunost",
	"Melodiya",
	"Vega",
	"Rondo",
	"Korvet",
	"Kantata",
	"Serenada",
	"Arktur",
	"Ilga",
	"Tochka",
	"Sovet")


	return  "Excelsior \"[pick(namelist)]-[rand(100, 999)]\" node"





/obj/machinery/node/Initialize(mapload, d)
	. = ..()
	name = make_name()
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







/obj/machinery/node/proc/update_influence()
	cleanup_influence() 						// remove influence the node made
	define_influence() 							// spawn influence around the node





/obj/machinery/node/proc/define_influence()
	for(var/turf/selected in circlerangeturfs(src, EX_NODE_DISTANCE))
		if(!locate(/obj/effect/effect/excelsior_influence) in selected)
			var/influence_marker = new /obj/effect/effect/excelsior_influence(loc = selected, creator = src)
			if(influence_marker)
				localmarkerlist.Add(influence_marker)
		else
			continue






/obj/machinery/node/proc/cleanup_influence()
	for(var/marker in localmarkerlist)
		QDEL_NULL(marker)
	localmarkerlist = list()
	activemarkerlist = list()






/*/obj/machinery/node/proc/pick_up_emplacement(var/mob/living/carbon/human/user)
	if(emplacement_storage >= 1)
		var/obj/item/unemplacement/emplacement = /obj/item/unemplacement	// item that will then become the machinery
		user.put_in_active_hand(new emplacement)
		emplacement_storage--
															//!!!!add ability to put it back in - delete comment if done
*/









/*
/obj/machinery/node/Process() 		// Yeah let's not do the lagfest that was debug
	update_influence()
*/






/obj/machinery/node/update_icon()
	. = ..()
	if(!core)
		icon_state = "redirector_bent"
	else
		icon_state = "redirector_finished"






/obj/machinery/node/attack_hand(mob/user)
//	. = ..()		//uncomment to give power consumption :)		(I dont want it now)
	to_chat(user, "Linked machinery:")
	for(var/obj/machinery/machine in linked)
		to_chat(user, machine.name)
	to_chat(user, "Linked nodes:")
	for(var/obj/machinery/machine in neighbours)
		to_chat(user, "[machine.name] [dist3D(src, machine)]m away")
	//pick_up_emplacement(user)		// later






// Some structures need node in radius to power up and work, this is the proc that searches (e.g. emplacements)
/obj/machinery/node/proc/search_for_machines()
	for(var/obj/machinery/machine in circlerange(src, EX_NODE_DISTANCE))
		SEND_SIGNAL(machine, COMSIG_EX_CONNECT)






//Searches for other nodes EVEN BETWEEN Z LEVELS.
/obj/machinery/node/proc/search_for_nodes()
	for(var/obj/machinery/node/N in excelsior_nodes)
		if(dist3D(src, N) <= EX_NODE_DISTANCE+1 && N != src)
			connect(N, TRUE)
			N.connect(src, TRUE)
			if(N.core)
				src.spread_signal(N.core)






//	# Adds machine to either list of connected nodes or list of connected machines as specified by is_node argument
//Checks if machine is on the list before adding to avoid dupes
/obj/machinery/node/proc/connect(var/obj/machinery/M, var/is_node = FALSE)
	if(is_node)
		if(!neighbours.Find(M)) // > Connect to node
			neighbours.Add(M)
	else
		if(!linked.Find(M))		// > Connect to emplacements, for example.
			linked.Add(M)		//	- If such machinery demands Node's connection to work






//Removes machine from list of nodes or list of machines as specifed by is_node argument
//Checks if machine is on the list before deletion
/obj/machinery/node/proc/disconnect(var/obj/machinery/M, var/is_node = FALSE)
	if(is_node)
		if(neighbours.Find(M))
			neighbours.Remove(M)
	else
		if(linked.Find(M))
			linked.Remove(M)








/obj/machinery/node/proc/spread_signal(var/center)	// 	# Nodes check if they are connected to Centor, directly or not (node chain)
	if(core)										//	 1.	If not - connect to Centor
		return										//	 2.	Pass "core connected" status through the chain
	core = center
	update_icon()
	core.antennas_to_haven.Add(src)
	for(var/obj/machinery/node/N in neighbours)
		N.spread_signal(center)
													//	> "Core+Node gameplay is defined by territorial control of excelsior
													//	"cut off" nodes shouldn't be active (by design)" - me






											/*****************************
											 *	      Node Radio		 *
											 *****************************/





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
	if(world.time - report_cooldown >= 15 SECONDS)				// Don't report the same person twice in x seconds
		intruder_list = list()
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








												/******************************
 														   Influence
 												*******************************/

/* [?] INFLUENCE is an invisible zone, that produces Excelsior energy for Excelsior
		1.	NODE spawns around itself excelsior_influence in a radius, defined by EX_NODE_DISTANCE
							[_excelsior_defines.dm]
		2.	INFLUENCE checks the turf it stands on, if it has whitelisted turfs (floortiles & low walls)

			- by design walls and space aren't rewarded as owning territory

		3.	CORE gives Excelsior energy
*/

/obj/effect/effect/excelsior_influence	//zone								//	# Visible on Excel HUD. (voidsuit)
	var/active = FALSE														// 	- To find the HUD code do either:
	var/obj/machinery/node/node												//		> Search by "process_excel_hud" in
																			//		> hud.dm [code\defines\procs][line 60~]




/obj/effect/effect/excelsior_influence/New(loc, var/obj/machinery/node/creator)		// > All the thinking is done at define_influence()
	..(loc)
	icon = null
	icon_state = null
	node = creator
	validate()
	RegisterSignal(src, COMSIG_TURF_LEVELUPDATE, PROC_REF(validate))				// # Any tile on map built/destroyed:
																					//	1.	Sends a COMSIG_TURF_LEVELUPDATE signal
																					//	To every obj standing on top
																					//	2.	It's up to obj to receive that signal
																					//	3.	Marker receives that node >> validate()






/obj/effect/effect/excelsior_influence/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_TURF_LEVELUPDATE)															// no phantom pain sry





/obj/effect/effect/excelsior_influence/proc/validate()	// # Checks if influence is "active".
    if(!node)                                           //	 It's active if...
        Destroy()
        return
    var/turf/my_turf = get_turf(src)
    for(var/type in excelsior_turf_whitelist)				//	...It's inside whitelist?
        if(istype(my_turf, type))							//		Everything inside whitelist is influence items/tiles/whatever
            active = TRUE									//		We chose it to be floors and low walls. Walls are punished we hate walls.
            if(!node.activemarkerlist.Find(src))			//		That may change because of you, that's why it exists.
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





