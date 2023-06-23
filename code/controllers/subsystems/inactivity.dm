SUBSYSTEM_DEF(inactivity_and_job_tracking)
	name = "Inactivity and Job tracking"
	wait = 1 MINUTES
	priority = SS_PRIORITY_INACTIVITY_AND_JOB_TRACKING
	var/tmp/list/client_list
	var/list/current_playtimes = list()
	var/number_kicked = 0

/datum/controller/subsystem/inactivity_and_job_tracking/proc/on_job_spawn(mob/target, client_ckey)
	if(!target || !client_ckey)
		return
	if(!target?.mind?.assigned_job?.title)
		return
	if(!length(current_playtimes[client_ckey]))
		current_playtimes[client_ckey] = list()
	current_playtimes[client_ckey][target.mind.assigned_job.title] = 0

/datum/controller/subsystem/inactivity_and_job_tracking/fire(resumed = FALSE)
	if (!resumed)
		client_list = clients.Copy()

	while(client_list.len)
		var/client/C = client_list[client_list.len]
		client_list.len--
		if(!C.holder && C.is_afk(config.kick_inactive MINUTES) && !isobserver(C.mob))
			log_access("AFK: [key_name(C)]")
			to_chat(C, SPAN_WARNING("You have been inactive for more than [config.kick_inactive] minute\s and have been disconnected."))
			del(C) // Don't qdel, cannot override finalize_qdel behaviour for clients.
			number_kicked++
		else if (C.mob && C.mob.mind && C.mob.stat != DEAD)
			C.mob.mind.last_activity = world.time - C.inactivity
			if(C.mob.mind?.assigned_job?.title && !isghost(C.mob))
				// This also shouldn't happen.
				if(!length(current_playtimes[C.ckey]))
					current_playtimes[C.ckey] = list()
					message_admins("Missing ckey-list for playtime in SSinactivity for [C.ckey] with the job [C.mob.mind.assigned_job.title] and mob [C.mob], creating a list.")
			if(C.mob.mind?.assigned_job?.title)
				current_playtimes[C.ckey][C.mob.mind.assigned_job.title] += 1 MINUTE

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/inactivity_and_job_tracking/stat_entry()
	..("Kicked: [number_kicked]")
