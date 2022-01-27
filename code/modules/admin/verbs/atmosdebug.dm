/client/proc/atmosscan()
	set category = "Mapping"
	set name = "Check Piping"
	set background = 1
	if(!src.holder)
		to_chat(src, "Only administrators69ay use this command.")
		return


	if(alert("WARNING: This command should not be run on a live server. Do you want to continue?", "Check Piping", "No", "Yes") == "No")
		return

	to_chat(usr, "Checking for disconnected pipes...")
	//all plumbing - yes, some things69ight get stated twice, doesn't69atter.
	for (var/obj/machinery/atmospherics/plumbing in world)
		if (plumbing.nodealert)
			to_chat(usr, "Unconnected 69plumbing.name69 located at 69plumbing.x69,69plumbing.y69,69plumbing.z69 (69get_area(plumbing.loc)69)")

	//Manifolds
	for (var/obj/machinery/atmospherics/pipe/manifold/pipe in world)
		if (!pipe.node1 || !pipe.node2 || !pipe.node3)
			to_chat(usr, "Unconnected 69pipe.name69 located at 69pipe.x69,69pipe.y69,69pipe.z69 (69get_area(pipe.loc)69)")

	//Pipes
	for (var/obj/machinery/atmospherics/pipe/simple/pipe in world)
		if (!pipe.node1 || !pipe.node2)
			to_chat(usr, "Unconnected 69pipe.name69 located at 69pipe.x69,69pipe.y69,69pipe.z69 (69get_area(pipe.loc)69)")

	to_chat(usr, "Checking for overlapping pipes...")
	next_turf:
		for(var/turf/T in turfs)
			for(var/dir in cardinal)
				var/list/connect_types = list(1 = 0, 2 = 0, 3 = 0)
				for(var/obj/machinery/atmospherics/pipe in T)
					if(dir & pipe.initialize_directions)
						for(var/connect_type in pipe.connect_types)
							connect_types69connect_type69 += 1
						if(connect_types69169 > 1 || connect_types69269 > 1 || connect_types69369 > 1)
							to_chat(usr, "Overlapping pipe (69pipe.name69) located at 69T.x69,69T.y69,69T.z69 (69get_area(T)69)")
							continue next_turf
	to_chat(usr, "Done")

/client/proc/powerdebug()
	set category = "Mapping"
	set name = "Check Power"
	if(!src.holder)
		to_chat(src, "Only administrators69ay use this command.")
		return


	for (var/datum/powernet/PN in SSmachines.powernets)
		if (!PN.nodes || !PN.nodes.len)
			if(PN.cables && (PN.cables.len > 1))
				var/obj/structure/cable/C = PN.cables69169
				to_chat(usr, "Powernet with no nodes! (number 69PN.number69) - example cable at 69C.x69, 69C.y69, 69C.z69 in area 69get_area(C.loc)69")

		if (!PN.cables || (PN.cables.len < 10))
			if(PN.cables && (PN.cables.len > 1))
				var/obj/structure/cable/C = PN.cables69169
				to_chat(usr, "Powernet with fewer than 10 cables! (number 69PN.number69) - example cable at 69C.x69, 69C.y69, 69C.z69 in area 69get_area(C.loc)69")