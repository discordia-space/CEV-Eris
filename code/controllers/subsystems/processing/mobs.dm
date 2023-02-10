PROCESSING_SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = SS_PRIORITY_MOB
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS

	process_proc = /mob/proc/Life

	var/list/high_priority = list()
	var/list/mob_list
	var/list/mob_living_by_zlevel[][]

/datum/controller/subsystem/processing/mobs/PreInit()
	mob_list = processing // Simply setups a more recognizable var name than "processing"
	MaxZChanged()

/datum/controller/subsystem/processing/mobs/add_to_processing(datum/thing)
	if(ishuman(thing))
		high_priority += thing
	else
		processing += thing
	return TRUE

/datum/controller/subsystem/processing/mobs/remove_from_processing(datum/thing)
	if(ishuman(thing))
		high_priority -= thing
	else
		processing -= thing
	return TRUE

/datum/controller/subsystem/processing/mobs/fire(resumed = FALSE)

	// We don't expect the list to change at all.
	for(var/i = 1, i <= length(high_priority), i++)
		var/datum/thing = high_priority[i]
		if(QDELETED(thing))
			high_priority -= thing
			continue
		if((call(thing, process_proc)(wait * 0.1) == PROCESS_KILL))
			STOP_PROCESSING(src, thing)
		if(MC_TICK_CHECK)
			return

	..(resumed)

/datum/controller/subsystem/processing/mobs/proc/MaxZChanged()
	if(!islist(mob_living_by_zlevel))
		mob_living_by_zlevel = new/list(world.maxz, 0)

	while(mob_living_by_zlevel.len < world.maxz)
		mob_living_by_zlevel.len++
		mob_living_by_zlevel[mob_living_by_zlevel.len] = list()
