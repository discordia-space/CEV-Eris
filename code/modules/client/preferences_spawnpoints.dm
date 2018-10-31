GLOBAL_VAR(spawntypes)
GLOBAL_LIST_EMPTY(spawnpoints)
GLOBAL_LIST_EMPTY(spawnpoints_late)

/proc/spawntypes()
	if(!GLOB.spawntypes)
		GLOB.spawntypes = list()
		for(var/type in typesof(/datum/spawnpoint)-/datum/spawnpoint)
			var/datum/spawnpoint/S = type
			var/display_name = initial(S.display_name)
			if((display_name in GLOB.using_map.allowed_spawns) || initial(S.always_visible))
				GLOB.spawntypes[display_name] = new S
	return GLOB.spawntypes

/datum/spawnpoint
	var/msg         //Message to display on the arrivals computer.
	var/list/turfs   //List of turfs to spawn on.
	var/display_name //Name used in preference setup.
	var/always_visible = FALSE	// Whether this spawn point is always visible in selection, ignoring map-specific settings.
	var/list/restrict_job = null
	var/list/disallow_job = null

/datum/spawnpoint/proc/check_job_spawning(job)
	if(restrict_job && !(job in restrict_job))
		return 0

	if(disallow_job && (job in disallow_job))
		return 0

	return 1

#ifdef UNIT_TEST
/datum/spawnpoint/Del()
	crash_with("Spawn deleted: [log_info_line(src)]")
	..()

/datum/spawnpoint/Destroy()
	crash_with("Spawn destroyed: [log_info_line(src)]")
	. = ..()
#endif

/datum/spawnpoint/default
	display_name = DEFAULT_SPAWNPOINT_ID
	msg = "has arrived on the station"
	always_visible = TRUE

/proc/getSpawnPoint(name, safety = TRUE)
	ASSERT(name)
	if(!GLOB.spawnpoints[name])
		if(safety)
			new /datum/spawnpoint (name)
		else
			return null
	return GLOB.spawnpoints[name]

/proc/getSpawnLocations(name = "Cryogenic Storage", free_only = TRUE)
	var/datum/spawnpoint/SP = getSpawnPoint(name)
	if(free_only)
		return SP.getFreeTurfs()
	else
		return SP.turfs

/proc/pickSpawnLocation(name, free_only = TRUE)
	var/list/locations = getSpawnLocations(name, free_only)
	return safepick(locations)