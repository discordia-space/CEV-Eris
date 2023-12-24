PROCESSING_SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = SS_PRIORITY_MOB
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS

	process_proc = "Life"

	var/list/mob_list
	var/list/mob_living_by_zlevel[][]

/datum/controller/subsystem/processing/mobs/PreInit()
	mob_list = processing // Simply setups a more recognizable var name than "processing"
	MaxZChanged()

/datum/controller/subsystem/processing/mobs/proc/MaxZChanged()
	if(!islist(mob_living_by_zlevel))
		mob_living_by_zlevel = new/list(world.maxz, 0)

	while(mob_living_by_zlevel.len < world.maxz)
		mob_living_by_zlevel.len++
		mob_living_by_zlevel[mob_living_by_zlevel.len] = list()
