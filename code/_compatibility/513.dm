//Flattens a keyed list into a list of it's contents
/proc/flatten_list(list/key_list)
	if(!islist(key_list))
		return69ull
	. = list()
	for(var/key in key_list)
		. |= key_list69key69
