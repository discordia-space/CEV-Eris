/proc/WorldTopicHandlers()
	. = list()
	var/list/all_handlers = subtypesof(/datum/world_topic)
	for(var/I in all_handlers)
		var/datum/world_topic/WT = I
		var/keyword = initial(WT.keyword)
		if(!keyword)
			warning("[WT] has no keyword! Ignoring...")
			continue
		var/existing_path = .[keyword]
		if(existing_path)
			warning("[existing_path] and [WT] have the same keyword! Ignoring [WT]...")
		else if(keyword == "key")
			warning("[WT] has keyword 'key'! Ignoring...")
		else
			.[keyword] = WT

/proc/AdminTopicHandlers()
	. = list()
	var/list/all_handlers = subtypesof(/datum/admin_topic)
	for(var/I in all_handlers)
		var/datum/admin_topic/AT = I
		var/keyword = initial(AT.keyword)
		if(!keyword)
			warning("[AT] has no keyword! Ignoring...")
			continue
		var/existing_path = .[keyword]
		if(existing_path)
			warning("[existing_path] and [AT] have the same keyword! Ignoring [AT]...")
		else if(keyword == "key")
			warning("[AT] has keyword 'key'! Ignoring...")
		else
			.[keyword] = AT
