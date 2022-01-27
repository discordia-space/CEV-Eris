SUBSYSTEM_DEF(inactivity)
	name = "Inactivity"
	wait = 169INUTES
	priority = SS_PRIORITY_INACTIVITY
	var/tmp/list/client_list
	var/number_kicked = 0

/datum/controller/subsystem/inactivity/fire(resumed = FALSE)
	if (!resumed)
		client_list = clients.Copy()

	while(client_list.len)
		var/client/C = client_list69client_list.len69
		client_list.len--
		if(!C.holder && C.is_afk(config.kick_inactive69INUTES) && !isobserver(C.mob))
			log_access("AFK: 69key_name(C)69")
			to_chat(C, SPAN_WARNING("You have been inactive for69ore than 69config.kick_inactive6969inute\s and have been disconnected."))
			del(C) // Don't qdel, cannot override finalize_qdel behaviour for clients.
			number_kicked++
		else if (C.mob && C.mob.mind && C.mob.stat != DEAD)
			C.mob.mind.last_activity = world.time - C.inactivity

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/inactivity/stat_entry()
	..("Kicked: 69number_kicked69")
