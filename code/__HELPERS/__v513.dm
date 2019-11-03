#if DM_VERSION > 513
#warning Remie said that lummox was adding a way to get a lists
#warning contents via list.values, if that is true remove this
#warning otherwise, update the version and bug lummox
#endif

//Flattens a keyed list into a list of it's contents
/proc/flatten_list(list/key_list)
	if(!islist(key_list))
		return null
	. = list()
	for(var/key in key_list)
		. |= key_list[key]
