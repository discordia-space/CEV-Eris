/proc/WorldTopicHandlers()
	. = list()
	var/list/all_handlers = subtypesof(/datum/world_topic)
	for(var/I in all_handlers)
		var/datum/world_topic/WT = I
		var/keyword = initial(WT.keyword)
		if(!keyword)
			warning("69WT69 has no keyword! Ignoring...")
			continue
		var/existing_path = .69keyword69
		if(existing_path)
			warning("69existing_path69 and 69WT69 have the same keyword! Ignoring 69WT69...")
		else if(keyword == "key")
			warning("69WT69 has keyword 'key'! Ignoring...")
		else
			.69keyword69 = WT

/proc/AdminTopicHandlers()
	. = list()
	var/list/all_handlers = subtypesof(/datum/admin_topic)
	for(var/I in all_handlers)
		var/datum/admin_topic/AT = I
		var/keyword = initial(AT.keyword)
		if(!keyword)
			warning("69AT69 has no keyword! Ignoring...")
			continue
		var/existing_path = .69keyword69
		if(existing_path)
			warning("69existing_path69 and 69AT69 have the same keyword! Ignoring 69AT69...")
		else if(keyword == "key")
			warning("69AT69 has keyword 'key'! Ignoring...")
		else
			.69keyword69 = AT
