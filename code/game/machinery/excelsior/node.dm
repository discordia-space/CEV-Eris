/obj/machinery/node
	name = "Excelsior \"Tochka\" node"
	var/shortname = "Tochka-123"
	icon = 'icons/obj/machines/excelsior/corenode/node.dmi'
	desc = "Bullet resistant transmission receiver. It catches teleportation signals sent by Haven."
	icon_state = "on"
	description_info = "Nodes provide teleportation power and activate turrets in a radius. They report any non-Excelsior humans and robots in a radius."
	description_antag = "Nodes connect to Centor and pass his orders to other nodes in a radius. Node surface coverage can be seen with Influence Mode on KOMPAK."
	anchored = TRUE
	density = TRUE
	circuit = /obj/item/electronics/circuitboard/excelsior_node
	health = 1200
	maxHealth = 1200
	shipside_only = TRUE
	layer = 5
	var/list/obj/machinery/linked = list()
	var/list/obj/machinery/node/neighbours = list()
	var/obj/machinery/centor/core
	var/damage_report_cooldown = FALSE

	//var/emplacement_storage = 4
	var/list/localmarkerlist = list() 	/* On destroy() or "turning off" (if disconnected from Centor's node chain) will...
											> remove the whole local list (node's) from global one (Centor interacts with it)
											- Is Feature, cut off Excelsior's "logistics" and forward bases won't work :)
										 */
	var/list/activemarkerlist = list()
	var/what_is_marker = /obj/effect/effect/excelsior_influence

	//# Cooldowns
	var/list/intruder_list = list()
	var/report_cooldown


/*
*	Basics
*/


/obj/machinery/node/examine(mob/user, extra_description)
	if(!core)
		extra_description += "\n<b>Seems to be powered down.</b> No active Excelsior node or Centor found nearby."
	. = ..()


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
	"Sovet",
	"Sakhar",
	"Krona",
	"Praktik",
	"Kozyol",
	"Partisan",
	)

	var/newname = pick(namelist)
	var/cifra = rand(100, 999)
	name = "Excelsior \"[newname]-[cifra]\" node"
	shortname = "[newname]-[cifra]"


/obj/machinery/node/assign_uid()
	uid = rand(1, 3000)


/obj/machinery/node/Initialize(mapload, d)
	. = ..()
	make_name()
	assign_uid()
	excelsior_nodes.Add(src)
	search_for_machines()
	search_for_nodes()
	define_influence()
	if(excelsior_centor)
		var/obj/machinery/centor/C = excelsior_centor
		C.load_network()
	update_icon()







/obj/machinery/node/Destroy()
	for(var/datum/excelsior_junction/route in excelsior_junctions)
		if(route.first == src || route.second == src)
			excelsior_junctions.Remove(route)
			route.Destroy()
	cleanup_influence()
	UnregisterSignal(src, COMSIG_TURF_LEVELUPDATE)
	for(var/obj/machinery/node/noder in neighbours)
		noder.update_influence()
	. = ..()







	excelsior_nodes.Remove(src)
	for(var/obj/machinery/machine in linked)
		SEND_SIGNAL(machine, COMSIG_EX_CONNECT)
	for(var/obj/machinery/node/N in neighbours)
		N.disconnect(src, TRUE)
	if(core)
		core.load_network()







/obj/machinery/node/proc/update_influence()
	cleanup_influence()
	define_influence()





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

/obj/machinery/node/attackby(obj/item/I, mob/user)
	if(user.a_intent == I_HELP)
		if((QUALITY_WELDING in I.tool_qualities) && (health < maxHealth))
			if(I.use_tool(user, src, WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_EASY,  required_stat = STAT_MEC))
				health += 200
				if(health > maxHealth)
					health = maxHealth
				update_icon()
		return 1
	if (!(I.flags & NOBLUDGEON) && I.force)
		//if the turret was attacked with the intention of harming it:
		user.do_attack_animation(src)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

		/* Commented at the time for the lack of better sounds
		if (take_damage(I.force * I.structure_damage_factor))
			playsound(src, 'sound/weapons/smash.ogg', 70, 1)
		else
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
		*/
		take_damage(I.force * I.structure_damage_factor)

	..()

/obj/machinery/node/bullet_act(obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()
	..()
	take_damage(damage*Proj.structure_damage_factor)

/obj/machinery/node/take_damage(amount)
	if(!damage_report_cooldown)
		talk("DAMAGED :: Node [shortname] lost integrity. ")
		damage_report_cooldown = TRUE
		spawn(1 MINUTE)
			if(src)
				damage_report_cooldown = FALSE
	if(!amount)
		return FALSE	//No damage done. Used in attackby()
	health -= amount
	if(health <= 0)
		die()
	update_icon()
	return TRUE	//Actual damage delt. Used in attackby()

/obj/machinery/node/proc/die()
	talk("DESTROYED :: [shortname] reported demolished at [get_area(src)]")
	explosion(get_turf(src), 100, 50)
	Destroy()

/obj/machinery/node/update_icon()
	overlays.Cut()
	icon_state = "on"

	if(!core)
		overlays += "off_overlay"
	if(health <= maxHealth * 0.25)
		icon_state = "damaged_heavy"
		return
	if(health <= maxHealth * 0.5)
		icon_state = "damaged_moderate"
		return
	if(health <= maxHealth * 0.75)
		icon_state = "damaged_light"
		return






/obj/machinery/node/attack_hand(mob/user)
//	. = ..()		// DONT uncomment, unless you wanna give it power consumption :)		(P.S. I DONT want that)
	to_chat(user, "Node's screen blinks for a brief momnet revealing it's statistics")
	to_chat(user, "Linked nodes:")
	for(var/obj/machinery/machine in neighbours)
		to_chat(user, "[machine.name] [dist3D(src, machine)]m away")
	to_chat(user, "Current coverage is at [round(activemarkerlist.len / localmarkerlist.len * 100, 0.1)]%")
	//pick_up_emplacement(user)		// later






// Some structures need node in radius to power up and work, this is the proc that searches (e.g. emplacements)
/obj/machinery/node/proc/search_for_machines()
	for(var/obj/machinery/machine in circlerange(src, EX_NODE_DISTANCE))
		SEND_SIGNAL(machine, COMSIG_EX_CONNECT)






//Searches for other nodes EVEN BETWEEN Z LEVELS.
/obj/machinery/node/proc/search_for_nodes()
	for(var/obj/machinery/node/N in excelsior_nodes)
		if(dist3D(src, N) <= EX_NODE_DISTANCE*2 && N != src)
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
													// NOTE: "Core+Node gameplay is defined by territorial control of excelsior

/obj/machinery/node/verb/pack()
	set name = "Pack node"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return
	if(!is_excelsior(usr))
		to_chat(usr, "It doesn't listen to you.")
		return
	to_chat(usr, "You're start packing node back into compact mode.")
	if(do_after(usr, 2 SECONDS, src))
		new /obj/item/machinery_crate/excelsior/node(loc)
		Destroy()




									/*
									*	      Nodes speak into Excelsior comms
									*/





// # DETECTION of non-excelsior human

//		- The act of yapping itself

/obj/machinery/proc/talk(message)							// the act of yapping
	var/datum/faction/F = get_faction_by_id(FACTION_EXCELSIOR)
	if(!F)
		return
	F.communicate_inanimate(src, message)



//		- The thinking behind reporting a bypasser

/obj/machinery/node/proc/intruder_alert(var/mob/living/intruder)// TODO: Move to KOMPAK logs
																// TODO: Ask Node what the human has in weapons through KPK
	if(world.time - report_cooldown >= 15 SECONDS)	// Don't report the same person twice in x seconds
		intruder_list = list()
		report_cooldown = world.time

	if(intruder_list.Find(intruder))	// We don't need the same guy reported
		return
	if(istype(intruder, /mob/living/carbon/human))
		if(intruder.stats.getPerk(PERK_VAGABOND) || intruder.name == "Unknown")
			talk("SPOTTED: Non-crew [intruder.name] spotted at [name]")
			intruder_list.Add(intruder)
			return
		talk("SPOTTED :: Human [intruder.name] spotted at [name]")
		intruder_list.Add(intruder)
		return
	if(istype(intruder, /mob/living/silicon/robot))
		talk("SPOTTED :: Robot [intruder.name] spotted at [name]")
		intruder_list += intruder
		return

	//MESSAGE
	//	//clean stuff that was reported








												/******************************
 												*		   Influence		  *
 												*******************************/

/* [?] INFLUENCE is an invisible zone, that produces Excelsior energy for Excelsior
		1.	NODE spawns around itself excelsior_influence in a radius, defined by EX_NODE_DISTANCE
							[_excelsior_defines.dm]
		2.	INFLUENCE checks the turf it stands on, if it has whitelisted turfs (floortiles & low walls)

			- by design walls and space aren't rewarded as owning territory.

		3.	CORE gives Excelsior energy
*/

/obj/effect/effect/excelsior_influence	//zone make excel energy :)			//	# Visible on Influence Mode.
	var/active = FALSE														// 	- To find the HUD code do either:
	var/obj/machinery/node/node												//		> Search by "process_excel_hud" in
																			//		> hud.dm [code\defines\procs][line 60~]




/obj/effect/effect/excelsior_influence/New(loc, var/obj/machinery/node/creator)		// > Code 1 layer above is define_influence()
	..(loc)
	icon = null
	icon_state = null
	node = creator
	validate()
	RegisterSignal(src, COMSIG_TURF_LEVELUPDATE, PROC_REF(validate))				// # Any tile on map built/destroyed:
																					//	1.	Sends a COMSIG_TURF_LEVELUPDATE signal
																					//	To every obj standing on top
																					//	2.	It's up to obj to receive that signal
																					//	3.	Marker receives that signal >> validate()






/obj/effect/effect/excelsior_influence/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_TURF_LEVELUPDATE)															// no phantom pain sry





/obj/effect/effect/excelsior_influence/proc/validate()	// # Checks if influence zone is "active".
    if(!node)                                           //	 It's active if...
        Destroy()
        return
    var/turf/my_turf = get_turf(src)
    for(var/type in excelsior_turf_whitelist)				//	...It's insides match whitelist
        if(istype(my_turf, type))							//		Everything inside whitelist is "influence tiles"
            active = TRUE									//		We chose it to be floors and low walls. Walls are punished we hate walls.
            if(!node.activemarkerlist.Find(src))			//		That may change because of YOU, you stinky game designer, that's why the list exists.
                node.activemarkerlist.Add(src)
            return TRUE
    active = FALSE
    if(node.activemarkerlist.Find(src))
        node.activemarkerlist.Remove(src)
    return FALSE





/obj/effect/effect/excelsior_influence/Crossed(atom/movable/O)
	var/mob/living/intruder = O
	if(!intruder)
		return
	if(!istype(intruder, /mob))												//apparently var above didnt cut out flying cigarettes somehow
		return
	if(!is_excelsior(intruder))												// 	1.	If EXCELSIOR = STOP
		if(!intruder.restrained() && !intruder.lying)						//	2.	Arrested/Unconcious/Crawling people? - don't care 					(intentional)
			node.intruder_alert(intruder)									// 	3.	All good? report the good guy get his ass!!





//noda.sendPath("Artem-123", list())

/obj/machinery/node/proc/sendPath(var/obj/machinery/node/end, var/list/doroga, var/obj/item/centor_kpk/kpk, var/list/way_to_go = list())
	if(src in doroga)
		return
	doroga.Add(src)
	if(src == end)
		kpk.ihaveplacestobe = way_to_go
		kpk.viewpath_slot = end
		return
	for(var/datum/excelsior_junction/route in excelsior_junctions)
		if(route.first == src) //there's a route coming FROM us to other node
			if(!(route in way_to_go))
				way_to_go.Add(route)
			route.second.sendPath(end, doroga, kpk, way_to_go) //send pathfinding signal to this other node
		if(route.second == src) //there's a route coming TO us from other node
			if(!(route in way_to_go))
				way_to_go.Add(route)
			route.first.sendPath(end, doroga, kpk, way_to_go) //send pathfinding signal to this other node

/*
*	Packaged Node
*/

// machinery_crates.dm


