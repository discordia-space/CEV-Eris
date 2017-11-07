var/list/spawnpoints = new
var/list/spawnpoints_late = new

/*
ADMIN_VERB_ADD(/client/proc/debug_spawnpoints, R_DEBUG, FALSE)
/client/proc/debug_spawnpoints()
	set name = "Debug spawnpoints"
	set category = "Debug"

	for(var/X in spawnpoints)
		var/datum/spawnpoint/SP = spawnpoints[X]
		usr << "[SP.name]: [X in spawnpoints_late ? "is selectabe, " : null], [SP.turfs.len] point/s"
*/

/proc/getSpawnPoint(name, safety = TRUE)
	ASSERT(name)
	if(!spawnpoints[name])
		if(safety)
			new /datum/spawnpoint (name)
		else
			return null
	return spawnpoints[name]

/proc/getSpawnLocations(name = "Cryogenic Storage", free_only = TRUE)
	var/datum/spawnpoint/SP = getSpawnPoint(name)
	if(free_only)
		return SP.getFreeTurfs()
	else
		return SP.turfs

/proc/pickSpawnLocation(name, free_only = TRUE)
	var/list/locations = getSpawnLocations(name, free_only)
	return safepick(locations)

/datum/spawnpoint
	var/name = "spawnpoint"
	var/message         //Message to display on the arrivals computer.
	var/list/turfs= new //List of turfs to spawn on.
	var/display_name    //Name used in preference setup.
	var/list/restrict_job = null
	var/list/disallow_job = null

/datum/spawnpoint/New(var/name)
	src.name = name
	spawnpoints[name] = src
	..()

/datum/spawnpoint/proc/check_job_spawning(job)
	if(restrict_job && !(job in restrict_job))
		return 0

	if(disallow_job && (job in disallow_job))
		return 0

	return 1

/datum/spawnpoint/proc/getFreeTurfs()
	. = list()
	for(var/turf/T in turfs)
		if(locate(/mob/living) in T)
			continue
		. += T
