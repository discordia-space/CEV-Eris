/proc/get_late_spawntypes()
	if(!GLOB.late_spawntypes)
		error("\"late_spawntypes\" list is empty.")
	return GLOB.late_spawntypes

/proc/getSpawnPoint(name, late = FALSE, silenced = FALSE)
	ASSERT(name)
	var/error = FALSE
	if(late)
		if(GLOB.late_spawntypes[name])	
			return GLOB.late_spawntypes[name]
		else
			error = TRUE
	if(GLOB.spawntypes[name])	
		return GLOB.spawntypes[name]
	else
		error = TRUE
	if(error && !silenced)
		error("Trying to get non existing spawnpoint with name \"[name]\".")
	return null
	

/proc/createSpawnPoint(name, late = FALSE)
	ASSERT(name)
	var/error = FALSE
	var/datum/spawnpoint/SP
	if(late)
		if(GLOB.late_spawntypes[name])
			error = TRUE
		else
			SP = new(name)
			GLOB.late_spawntypes[name] = SP
	else
		if(GLOB.spawntypes[name])
			error = TRUE
		else
			SP = new(name)
			GLOB.spawntypes[name] = SP
	if(error)
		error("Trying to create existing spawnpoint.")
	return SP

/proc/getSpawnLocations(name = maps_data.default_spawn, free_only = TRUE, late = FALSE)
	var/datum/spawnpoint/SP = getSpawnPoint(name, late)
	if (SP)
		if(free_only)
			return SP.getFreeTurfs()
		else
			return SP.turfs

/proc/pickSpawnLocation(name, free_only = TRUE, late = FALSE)
	var/list/locations = getSpawnLocations(name, free_only, late)
	return safepick(locations)

/datum/spawnpoint
	var/name = "spawnpoint"
	var/message         //Message to display on the arrivals computer.
	var/list/turfs= new //List of turfs to spawn on.
	var/display_name    //Name used in preference setup.
	var/always_visible = FALSE	// Whether this spawn point is always visible in selection, ignoring map-specific settings.
	var/list/restrict_job = null
	var/list/disallow_job = null

/datum/spawnpoint/New(var/name)
	src.name = name
	..()

/datum/spawnpoint/proc/check_job_spawning(job)
	if(restrict_job && !(job in restrict_job))
		return FALSE
	if(disallow_job && (job in disallow_job))
		return FALSE
	return TRUE

/datum/spawnpoint/proc/getFreeTurfs()
	. = list()
	for(var/turf/T in turfs)
		if(locate(/mob/living) in T)
			continue
		. += T

/datum/spawnpoint/proc/CheckUnsafeSpawn(var/mob/living/spawner, var/turf/spawn_turf)
	//var/radlevel = SSradiation.get_rads_at_turf(spawn_turf)
	var/airstatus = IsTurfAtmosUnsafe(spawn_turf)
	//if(airstatus || radlevel > 0)
	if(airstatus)
		/*var/reply = alert(spawner, "Warning. Your selected spawn location seems to have unfavorable conditions. \
		You may die shortly after spawning. \
		Spawn anyway? More information: [airstatus] Radiation: [radlevel] Bq", "Atmosphere warning", "Abort", "Spawn anyway")
		*/
		var/reply = alert(spawner, "Warning. Your selected spawn location seems to have unfavorable conditions. \
		You may die shortly after spawning. \
		Spawn anyway? More information: [airstatus]", "Atmosphere warning", "Abort", "Spawn anyway")
		if(reply == "Abort")
			return FALSE
		else
			// Let the staff know, in case the person complains about dying due to this later. They've been warned.
			log_and_message_admins("User [spawner] spawned at spawn point with dangerous atmosphere.")
	return TRUE

// Put mob at on of spawn turfs
// return FALSE if player decline to spawn in not living-friendly environmental
/datum/spawnpoint/proc/put_mob(var/mob/M, var/ignore_environment = FALSE, var/announce = TRUE)
	var/list/free_turfs = getFreeTurfs()
	var/turf/spawn_turf
	if(turfs.len)
		spawn_turf = pick(free_turfs)
	else
		spawn_turf = pick(turfs)

	if(!ignore_environment && !CheckUnsafeSpawn(M, spawn_turf))
		return FALSE

	M.forceMove(spawn_turf)

	// Moving wheelchair if they have one
	if(M.buckled && istype(M.buckled, /obj/structure/bed/chair/wheelchair))
		M.buckled.forceMove(M.loc)
		M.buckled.set_dir(M.dir)
	return TRUE
