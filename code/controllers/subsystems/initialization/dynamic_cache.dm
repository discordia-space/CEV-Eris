// Any cache that created dynamically should be added to GLOB.cacheToClient and then on client connect we send this cache to it
//
// see also
//	/client/proc/sendCache(var/filename, var/icon/I)
//	/client/proc/loadCache()
//
// We have to init this after crafting SS
// 
// cacheToClient global list consist of associative list with sanitized file names like (obj_item_weapon_material_kitchen_utensil_fork) and icons as values
// names are atom types where first slash is removed and other slashes are replaced with underscores (for more info check sanitizeFileName())
GLOBAL_LIST_EMPTY(cacheToClient)

SUBSYSTEM_DEF(dynamic_cache)
	name = "Dynamic Cache"
	init_order = INIT_ORDER_LATELOAD
	flags = SS_NO_FIRE
	var/initialized = FALSE	//set to TRUE after it has been initialized, will obviously never be set if the subsystem doesn't initialize

/datum/controller/subsystem/dynamic_cache/Initialize()
	for(var/type in typesof(/datum/autolathe/recipe)-/datum/autolathe/recipe)
		var/datum/autolathe/recipe/R = type
		addIconToGlobalCache("[initial(R.path)].png", getFlatTypeIcon(initial(R.path)))
	for(var/type in typesof(/datum/design) - /datum/design)
		var/datum/design/D = type
		addIconToGlobalCache("[initial(D.build_path)].png", getFlatTypeIcon(initial(D.build_path)))
	for(var/name in SScraft.categories)
		for(var/datum/craft_recipe/CR in SScraft.categories[name])
			addIconToGlobalCache("[CR.result].png", getFlatTypeIcon(CR.result))
			for(var/datum/craft_step/CS in CR.steps)
				if(CS.reqed_type)
					addIconToGlobalCache("[CS.reqed_type].png", getFlatTypeIcon(CS.reqed_type))
	for(var/type in typesof(/obj/item/stack/material)-/obj/item/stack/material - typesof(/obj/item/stack/material/cyborg))
		addIconToGlobalCache("[type].png", getFlatTypeIcon(type))
	
	initialized = TRUE
	// now lets load cache to all connected clients
	validateClients()
	. = ..()

// This proc will send to clients cache that they are missing
/datum/controller/subsystem/dynamic_cache/proc/validateClients()
	if(initialized)
		spawn(5)
			for(var/client/C in clients)
				C.loadCache()

// After using this proc you should validateClients()
/datum/controller/subsystem/dynamic_cache/proc/addIconToGlobalCache(var/filename, var/icon/I)
	if(!filename || !I || !istype(I))
		error("Invalid arguments passed to addIconToGlobalCache()")
	filename = sanitizeFileName(filename)
	if(!GLOB.cacheToClient[filename])
		GLOB.cacheToClient[filename] = I

// will return filename for cached atom icon or null if not cached
// can accept atom objects or types
/datum/controller/subsystem/dynamic_cache/proc/getCacheFilename(var/atom/A)
	if(!A || (!istype(A) && !ispath(A)))
		return
	var/filename = "[ispath(A) ? A : A.type].png"
	filename = sanitizeFileName(filename)
	log_world("[filename]")
	if(GLOB.cacheToClient[filename])
		return filename