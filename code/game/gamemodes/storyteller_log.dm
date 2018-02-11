/datum/storyteller/proc/story_debug(var/message)
	log_debug("STORYTELLER: [message]")

/*
/datum/storyteller/proc/log_spawn(var/list/spawned)
	var/list/log = list()

	log["storyteller"] = config_tag
	log["time"] = world.time
	log["realtime"] = time2text(world.realtime)
	log["stage"] = event_spawn_stage
	log["forced"] = force_spawn_now
	log["debug"] = debug_mode

	log["crew"] = crew
	log["heads"] = heads
	log["sec"] = sec
	log["eng"] = eng
	log["med"] = med
	log["sci"] = sci

	for(var/t in spawnparams)
		log[t] = spawnparams[t]

	for(var/i = 1; i <= spawned.len; i++)
		log["ev[i]"] = spawned[i]

	log["evlen"] = spawned.len

	spawn_log["log[world.time]_[event_spawn_stage]"] = list2params(log)

/datum/storyteller/proc/set_param(var/ptag, var/value)
	spawnparams["[ptag]"] = value
*/

