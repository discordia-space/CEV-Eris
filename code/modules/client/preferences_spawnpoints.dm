/proc/get_late_spawntypes()
	if(!GLOB.late_spawntypes)
		error("\"late_spawntypes\" list is empty.")
	return GLOB.late_spawntypes



//Called by spawnpoint landmarks. A landmark creates a new /datum/spawnpoint, or adds its own data to an existing one
/proc/landmark_create_spawn_point(var/obj/landmark/join/LM, late = FALSE, silenced = FALSE)
	if (!istype(LM))
		return

	//Spawnpoints are unique by name, try to find one with a matching name first
	var/datum/spawnpoint/S = get_spawn_point(LM.name, late, silenced)

	//If not, we create it
	if (!S)
		S = create_spawn_point(LM.name, late, LM.spawn_datum_type)
		S.display_name = LM.name
		if (late)
			var/obj/landmark/join/late/LM2 = LM
			S.restrict_job = LM2.restrict_job
			S.disallow_job = LM2.disallow_job
			S.message = LM2.message
		GLOB.late_spawntypes[S.name] = S
	S.points |= get_turf(LM) //Add the landmark's turf as a point of reference


/proc/get_spawn_point(name, late = FALSE)
	if(late)
		if(GLOB.late_spawntypes[name])
			return GLOB.late_spawntypes[name]

	else if(GLOB.spawntypes[name])
		return GLOB.spawntypes[name]




/proc/create_spawn_point(name, late = FALSE, newtype = /datum/spawnpoint)
	ASSERT(name)
	var/error = FALSE
	var/datum/spawnpoint/SP
	if(late)
		if(GLOB.late_spawntypes[name])
			error = TRUE
		else
			SP = new newtype(name)
			GLOB.late_spawntypes[name] = SP
	else
		if(GLOB.spawntypes[name])
			error = TRUE
		else
			SP = new newtype(name)
			GLOB.spawntypes[name] = SP
	if(error)
		error("Trying to create existing spawnpoint.")
	return SP

/proc/get_datum_spawn_locations(name = GLOB.maps_data.default_spawn, free_only = TRUE, late = FALSE)
	var/datum/spawnpoint/SP = get_spawn_point(name, late)
	if (SP)
		return SP.get_spawn_locations()

/proc/pick_spawn_location(name, free_only = TRUE, late = FALSE)
	var/list/locations = get_datum_spawn_locations(name, free_only, late)
	return safepick(locations)

/datum/spawnpoint
	var/name = "spawnpoint"
	var/message         //Message to display on the arrivals computer.
	var/list/points = list() //List of turfs or atoms that represent where this spawn point "is". We will look for spawning turfs in a radius around it
	var/list/turfs = list() //List of turfs to spawn on.
	var/display_name    //Name used in preference setup.
	var/always_visible = FALSE	// Whether this spawn point is always visible in selection, ignoring map-specific settings.
	var/list/restrict_job = null
	var/list/disallow_job = null
	var/search_range = 4
	var/search_type = "view"

/datum/spawnpoint/New(name)
	src.name = name
	..()

/datum/spawnpoint/proc/get_spawn_locations()
	return get_free_turfs()

/datum/spawnpoint/proc/can_spawn(mob/M, job, report = FALSE)
	if(restrict_job && !(job in restrict_job))
		return FALSE
	if(disallow_job && (job in disallow_job))
		return FALSE
	for (var/turf/T in points)
		if (!check_unsafe_spawn(M, T, report))
			return FALSE
	return TRUE

/datum/spawnpoint/proc/get_free_turfs(update = FALSE)
	if (!update && turfs.len)
		return turfs

	turfs = list()
	var/list/things = list()
	for (var/turf/P in points)
		if (search_type == "view")
			things += dview(search_range, P)
		else if (search_type == "range")
			things += range(search_range, P)

	for (var/turf/T in things)
		if (clear_interior(T))
			turfs |= T
	return turfs

/datum/spawnpoint/proc/check_unsafe_spawn(mob/living/spawner, turf/spawn_turf, confirm = TRUE)
	//var/radlevel = SSradiation.get_rads_at_turf(spawn_turf)
	var/airstatus = is_turf_atmos_unsafe(spawn_turf)
	//if(airstatus || radlevel > 0)
	if(airstatus)
		/*var/reply = alert(spawner, "Warning. Your selected spawn location seems to have unfavorable conditions. \
		You may die shortly after spawning. \
		Spawn anyway? More information: [airstatus] Radiation: [radlevel] Bq", "Atmosphere warning", "Abort", "Spawn anyway")
		*/
		if (!confirm)
			return FALSE
		var/reply = alert(spawner, "Warning. Your selected spawn location seems to have unfavorable conditions. \
		You may die shortly after spawning. \
		Spawn anyway? Alternatively you can be sent to a different random spawnpoint. More information: [airstatus]", "Atmosphere warning", "Elsewhere", "Spawn anyway")
		if(reply == "Elsewhere")
			return FALSE
		else
			// Let the staff know, in case the person complains about dying due to this later. They've been warned.
			log_and_message_admins("User [spawner] spawned at spawn point with dangerous atmosphere.")
	return TRUE

// Put mob at one of spawn turfs
// return FALSE if player decline to spawn in not living-friendly environmental
/datum/spawnpoint/proc/put_mob(mob/M, ignore_environment = FALSE, announce = TRUE)
	var/list/free_turfs = get_free_turfs()
	if(!free_turfs.len)
		return FALSE
	var/turf/spawn_turf = pick(free_turfs)

	if(!ignore_environment && !check_unsafe_spawn(M, spawn_turf))
		return FALSE

	M.forceMove(spawn_turf)

	// Moving wheelchair if they have one
	if(M.buckled && istype(M.buckled, /obj/structure/bed/chair/wheelchair))
		M.buckled.forceMove(M.loc)
		M.buckled.set_dir(M.dir)
	return TRUE

/datum/spawnpoint/nosearch //for when we want people to start on the exact tile of the spawn landmark
	search_range = 0

/**********************
	Cryostorage Spawning
**********************/
/datum/spawnpoint/cryo

/datum/spawnpoint/cryo/get_spawn_locations()
	. = list()
	var/list/things = list()
	for (var/turf/P in points)
		if (search_type == "view")
			things += dview(search_range, P)
		else if (search_type == "range")
			things += range(search_range, P)

	for (var/obj/machinery/cryopod/C in things)
		if (C.occupant)
			continue

		//TODO: Power checks here?
		. |= C

/datum/spawnpoint/cryo/can_spawn(mob/M, job, report = FALSE)
	. = ..()
	if (.)
		var/list/cryopods = get_spawn_locations()
		if (cryopods.len)
			return TRUE
	return FALSE

/datum/spawnpoint/cryo/get_free_turfs(update = FALSE)
	return null
	//This doesn't spawn people on turfs

/datum/spawnpoint/cryo/put_mob(mob/M, ignore_environment = FALSE, announce = TRUE)
	var/list/cryopods = get_spawn_locations()
	if (cryopods.len)
		var/obj/machinery/cryopod/C = pick(cryopods)
		C.set_occupant(M, FALSE)

		//When spawning in cryo, you start off asleep for a few moments and wake up
		M.Paralyse(2)

		//You can get yourself out of the cryopod, or it will auto-eject after one minute
		spawn(600)
			if (C && C.occupant == M)
				C.eject()
		return TRUE
	return FALSE

//Starboard Cryogenics
/datum/spawnpoint/cryo/starboard


/**********************
	DORMITORY SPAWNING
**********************/
/*
	You wake up from a nice nap, in a dormitory somewhere
*/
/datum/spawnpoint/dormitory

/datum/spawnpoint/dormitory/get_spawn_locations()
	. = list()
	var/list/things = list()
	for (var/turf/P in points)
		if (search_type == "view")
			things += dview(search_range, P)
		else if (search_type == "range")
			things += range(search_range, P)

	//We have to search specifically for padded subtype, because the main bed type is used for a lot of things, including chairs
	for (var/obj/structure/bed/padded/C in things)
		var/datum/component/buckling/buckle = C.GetComponent(/datum/component/buckling)
		if (buckle.buckled)
			continue

		. |= C

/datum/spawnpoint/dormitory/can_spawn(mob/M, job, report = FALSE)
	. = ..()
	if (.)
		var/list/cryopods = get_spawn_locations()
		if (cryopods.len)
			return TRUE
	return FALSE

/datum/spawnpoint/dormitory/get_free_turfs(update = FALSE)
	return null
	//This doesn't spawn people on turfs

/datum/spawnpoint/dormitory/put_mob(mob/M, ignore_environment = FALSE, announce = TRUE)
	var/list/beds = get_spawn_locations()
	if (beds.len)
		var/obj/structure/bed/C = pick(beds)
		M.forceMove(C.loc)
		//C.buckle_mob(M)

		//When spawning in bed, you start off asleep for a moment
		M.Paralyse(2)

		//Once you wake up, you can get yourself out of bed. I've made it real easy, just click basically anything

		return TRUE
	return FALSE
