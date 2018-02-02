/datum/storyteller/proc/debugmode(var/message)
	if(debug_mode)
		log_debug("STORY DBGMODE: [message]")

/datum/storyteller/proc/debug(var/message)
	log_debug("STORYTELLER: [message]")

/datum/storyteller/proc/log_spawn(var/list/spawned)
	var/list/log = list()

	log["storyteller"] = config_tag
	log["time"] = world.time
	log["stage"] = event_spawn_stage
	log["forced"] = force_spawn_now
	log["debug"] = debug_mode

	log["crew"] = crew
	log["heads"] = heads
	log["sec"] = sec
	log["eng"] = eng
	log["med"] = med
	log["sci"] = sci

	special_log(log)

	log["evlen"] = spawned.len

	for(var/i = 1; i <= spawned.len; i++)
		log["ev[i]"] = spawned[i]

	spawn_log.Add(list2params(log))

	log_debug("-= STORYTELLER SPAWN LOG ENTRY =-")
	for(var/t in log)
		log_debug("[t] - [log[t]]")

	log_debug("=================================")

/datum/storyteller/proc/special_log(var/list/L)
	for(var/t in spawnparams)
		L[t] = spawnparams[t]