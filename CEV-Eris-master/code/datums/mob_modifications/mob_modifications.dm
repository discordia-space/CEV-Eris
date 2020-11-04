/*
	Welcome to /datum/mobModification
	this designed to be used as universal system for applying changes to mobs like :
		stats,
		recipes,
		languages,
		memory,
		body changes,
		etc.
	and now... 

	TODO: move /datum/body_modification here

	#### IMPORTANT NOTES #####
	- vars and procs starting with "_" for example _content() should be only used internaly (think of it as private access modifier)
*/
/*
GLOBAL_LIST_EMPTY(customMobModifications)
/hook/startup/proc/generateCustomMobModifications()
	for(var/mod in subtypesof(/datum/mobModification/custom)
		var/datum/mobModification = mod()
		GLOB.customMobModifications.Add(mobModification)
	return TRUE
*/
/datum/mobModification
	// set to TRUE if you want to replace values on give ones, useful only for applying modifications mid game
	// also you should handle replacement in apply() yourself
	var/replace = FALSE 

// adds stat to recipe of applying recipes
/datum/mobModification/proc/addData()
	log_debug("[type] doesnt have addValues().")
	return -1

// sets data by calling addData() multiple times where data is list of arguments
// see Byond documentation for call() proc or look for examples
/datum/mobModification/proc/setData(var/data)
	if(islist(data))
		for(var/entry in data)
			if(call(src, "addData")(entry) == -1)
				return

/datum/mobModification/proc/apply(var/mob/M)
	if(!istype(M))
		return FALSE
	return TRUE
	
	