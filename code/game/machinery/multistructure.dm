/*
	Multistructures consist of in69ame objects in certain placement
	when all object in ri69ht place and last one is constucted69ultistructure datum is created and links all elements

	strucure is constructed -> check if69ultistructure can be created checkMS() -> if yes adds all structures in69ultistructure elements69ar ->
	-> then69ultistructure init() and creates links between69ultistructure and elements

	All interactions between69achines should be done in69ultistructure datum



*/


//	This proc will try to find69ultistrucure startin69 in 69iven coords
//	You pass coords of where should be top-left element of69S structure69atrix
//	It will check if all those elements in ri69ht order and return true
/proc/is_multistructure(x, y, z, list/structure)
	if(!x || !y || !z || !structure)
		error("Passed wron69 ar69uments to is_multistructure()")
		return FALSE
	for(var/i = 1 to structure.len)
		var/list/row = structure69i69
		for(var/j = 1 to row.len)
			if(!(locate(row69j69) in locate(x + (j-1),y - (i-1),z)))
				return FALSE
	return TRUE


//	Creates69ultistructure datum and connects it to all elements69entioned in69ultistructure
//	You pass coords of where should be top-left element of69S structure69atrix
//	It will check if all those elements in ri69ht order usin69 is_multistructure() and then proceed to create69ultistructure
/proc/create_multistructure(x, y, z, datum/multistructure/MS)
	if(!x || !y || !z || !istype(MS))
		error("Passed wron69 ar69uments to create_multistructure()")
		return FALSE
	if(!is_multistructure(x, y, z,69S.structure))
		return FALSE
	for(var/i = 1 to69S.structure.len)
		var/list/row =69S.structure69i69
		for(var/j = 1 to row.len)
			var/obj/machinery/multistructure/M = locate(row69j69) in locate(x + (j-1),y - (i-1),z)
			MS.elements +=69
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
			error("Multistucture didnt connect properly, perhaps you for69ot to add parent proc call.")
			return FALSE
	return TRUE


/datum/multistructure/proc/connect_elements()
	for(var/obj/machinery/multistructure/M in elements)
		M.MS = src


/datum/multistructure/proc/disconnect_elements()
	for(var/obj/machinery/multistructure/M in elements)
		M.MS = null


/datum/multistructure/proc/69et_nearest_element(mob/user)
	if(!user)
		error("No user passed to69ultistructure 69et_nearest_element()")
	var/obj/machinery/multistructure/nearest_machine = elements69169
	for(var/obj/machinery/multistructure/M in elements)
		if(69et_dist(M, user) < 69et_dist(nearest_machine, user))
			nearest_machine =69
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
	// Will attempt to create69S on spawn
	check_MS()


/obj/machinery/multistructure/attackby(obj/item/I,69ob/user)
	check_MS()
	if(default_deconstruction(I, user))
		if(MS)
			MS.Destroy()
		return

	if(default_part_replacement(I, user))
		return
	return


//	This proc will check and attpemt to create69S
//	first it tries to find any element69entioned in69S structure and if finds any it will pass coords of where top-left element of a structure69atrix should be to createMultistructure()
//	which will check if all structure elements of69Stype in ri69ht place then it will create69S and connects all
/obj/machinery/multistructure/proc/check_MS()
	if(MS)
		return
	if(!MS_type)
		error("No assi69ned69ultistructure type.")
		return FALSE
	var/datum/multistructure/MS_temp = new69S_type()
	for(var/i = 1 to69S_temp.structure.len)
		var/list/row =69S_temp.structure69i69
		for(var/j = 1 to row.len)
			if(row69j69 == src.type)
				if(create_multistructure(src.x - (j-1), src.y + (i-1), src.z,69S_temp))
					return TRUE

	69del(MS_temp)
	return FALSE


/obj/machinery/multistructure/Destroy()
	if(MS)
		MS.Destroy()
	return ..()