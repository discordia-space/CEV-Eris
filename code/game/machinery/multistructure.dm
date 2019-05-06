/*
	Multistructures consist of ingame objects in certain placement
	when all object in right place and last one is constucted multistructure datum is created and links all elements

	strucure is constructed -> check if multistructure can be created checkMS() -> if yes adds all structures in multistructure elements var ->
	-> then multistructure init() and creates links between multistructure and elements

	All interactions between machines should be done in multistructure datum



*/


//	This proc will try to find multistrucure starting in given coords
//	You pass coords of where should be top-left element of MS structure matrix
//	It will check if all those elements in right order and return true
/proc/is_multistructure(var/x, var/y, var/z, var/list/structure)
	if(!x || !y || !z || !structure)
		error("Passed wrong arguments to is_multistructure()")
		return FALSE
	for(var/i = 1 to structure.len)
		var/list/row = structure[i]
		for(var/j = 1 to row.len)
			if(!(locate(row[j]) in locate(x + (j-1),y - (i-1),z)))
				return FALSE
	return TRUE


//	Creates multistructure datum and connects it to all elements mentioned in multistructure
//	You pass coords of where should be top-left element of MS structure matrix
//	It will check if all those elements in right order using is_multistructure() and then proceed to create multistructure
/proc/create_multistructure(var/x, var/y, var/z, var/datum/multistructure/MS)
	if(!x || !y || !z || !istype(MS))
		error("Passed wrong arguments to create_multistructure()")
		return FALSE
	if(!is_multistructure(x, y, z, MS.structure))
		return FALSE
	for(var/i = 1 to MS.structure.len)
		var/list/row = MS.structure[i]
		for(var/j = 1 to row.len)
			var/obj/machinery/multistructure/M = locate(row[j]) in locate(x + (j-1),y - (i-1),z)
			MS.elements += M
	MS.init()
	if(MS.validate())
		return TRUE
	return FALSE


/datum/multistructure
	var/list/structure = list()
	var/list/elements = list()


/datum/multistructure/Destroy()
	disconnect_elements()
	return ..()


/datum/multistructure/proc/init()
	connect_elements()
	return TRUE


/datum/multistructure/proc/validate()
	for(var/obj/machinery/multistructure/M in elements)
		if(M.MS != src)
			error("Multistucture didnt connect properly, perhaps you forgot to add parent proc call.")
			return FALSE
	return TRUE


/datum/multistructure/proc/connect_elements()
	for(var/obj/machinery/multistructure/M in elements)
		M.MS = src


/datum/multistructure/proc/disconnect_elements()
	for(var/obj/machinery/multistructure/M in elements)
		M.MS = null


/datum/multistructure/proc/get_nearest_element(var/mob/user)
	if(!user)
		error("No user passed to multistructure get_nearest_element()")
	var/obj/machinery/multistructure/nearest_machine = elements[1]
	for(var/obj/machinery/multistructure/M in elements)
		if(get_dist(M, user) < get_dist(nearest_machine, user))
			nearest_machine = M
	return nearest_machine


/datum/multistructure/proc/is_operational()
	for(var/obj/machinery/multistructure/part in elements)
		if((part.stat & BROKEN) || (part.stat & EMPED) || (part.stat & NOPOWER))
			return FALSE
	return TRUE

//#########################################

/obj/machinery/multistructure
	var/datum/multistructure/MS
	var/MS_type


/obj/machinery/multistructure/Initialize()
	. = ..()
	// Will attempt to create MS on spawn
	check_MS()


/obj/machinery/multistructure/attackby(var/obj/item/I, var/mob/user)
	check_MS()
	if(default_deconstruction(I, user))
		MS.Destroy()
		return

	if(default_part_replacement(I, user))
		return
	return


//	This proc will check and attpemt to create MS
//	first it tries to find any element mentioned in MS structure and if finds any it will pass coords of where top-left element of a structure matrix should be to createMultistructure()
//	which will check if all structure elements of MStype in right place then it will create MS and connects all
/obj/machinery/multistructure/proc/check_MS()
	if(MS)
		return
	if(!MS_type)
		error("No assigned multistructure type.")
		return FALSE
	var/datum/multistructure/MS_temp = new MS_type()
	for(var/i = 1 to MS_temp.structure.len)
		var/list/row = MS_temp.structure[i]
		for(var/j = 1 to row.len)
			if(row[j] == src.type)
				if(create_multistructure(src.x - (j-1), src.y + (i-1), src.z, MS_temp))
					return TRUE

	qdel(MS_temp)
	return FALSE


/obj/machinery/multistructure/Destroy()
	if(MS)
		MS.Destroy()
	return ..()