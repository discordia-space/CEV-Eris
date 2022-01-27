/*
	Welcome to /datum/mobModification
	this designed to be used as universal system for applying changes to69obs like :
		stats,
		recipes,
		languages,
		memory,
		body changes,
		etc.
	and now... 

	TODO:69ove /datum/body_modification here

	#### IMPORTANT NOTES #####
	-69ars and procs starting with "_" for example _content() should be only used internaly (think of it as private access69odifier)
*/
/*
GLOBAL_LIST_EMPTY(customMobModifications)
/hook/startup/proc/generateCustomMobModifications()
	for(var/mod in subtypesof(/datum/mobModification/custom)
		var/datum/mobModification =69od()
		GLOB.customMobModifications.Add(mobModification)
	return TRUE
*/
/datum/mobModification
	// set to TRUE if you want to replace69alues on give ones, useful only for applying69odifications69id game
	// also you should handle replacement in apply() yourself
	var/replace = FALSE 

// adds stat to recipe of applying recipes
/datum/mobModification/proc/addData()
	log_debug("69type69 doesnt have addValues().")
	return -1

// sets data by calling addData()69ultiple times where data is list of arguments
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
	
	