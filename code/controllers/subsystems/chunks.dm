#define CHUNK_SIZE 8
//#define CHUNKID(x,y,size) round((((x - x%size) + (y - y%size) * world.maxx) / size ** 2))
#define CHUNKID(x,y) max(1,round(x/CHUNK_SIZE)+round(y/CHUNK_SIZE)*round(world.maxx / CHUNK_SIZE))
#define CHUNKSPERLEVEL(x,y) round(world.maxx * world.maxy) / (CHUNK_SIZE ** 2) + round(world.maxx / CHUNK_SIZE)
#define CHUNKCOORDCHECK(x,y) (x > world.maxx || y > world.maxy || x <= 0 || y <= 0)
#define CHUNKKEY(x,y,z) (CHUNKID(x,y) * (world.maxz+z))
/// This subsystem is meant for anything that should not be employing byond view() and is generally very constraining to keep track of
/// For now it only has mobs and hearers, but it should also include sanity , signal receivers , and anything that is very frequently
// searched

/datum/chunk
	var/list/mob/mobs = list()
	//var/list/sanity_damagers = list()
	var/list/obj/hearers = list()
	//var/list/signal_receivers = list()

SUBSYSTEM_DEF(chunks)
	name = "Chunks"
	init_order = INIT_ORDER_CHUNKS
	flags = SS_NO_FIRE
	var/list/datum/chunk/chunk_list_by_zlevel

/datum/controller/subsystem/chunks/Initialize(timeofday)
	chunk_list_by_zlevel = new/list(world.maxz)
	for(var/i = 1, i <= world.maxz,i++)
		chunk_list_by_zlevel[i] = new/list(CHUNKSPERLEVEL(world.maxx, world.maxy))
		for(var/j = 1, j <= CHUNKSPERLEVEL(world.maxx, world.maxy), j++)
			chunk_list_by_zlevel[i][j] = new /datum/chunk(src)
	RegisterSignal(SSdcs, COMSIG_MOB_INITIALIZED, PROC_REF(onMobNew))
	RegisterSignal(SSdcs, COMSIG_WORLD_MAXZ_INCREMENTING, PROC_REF(beforeLevelIncrement))
	return ..()

/datum/controller/subsystem/chunks/proc/beforeLevelIncrement(datum/source)
	SIGNAL_HANDLER
	var/temp_list = new/list(world.maxz + 1)
	for(var/i = 1; i <= world.maxz; i++)
		temp_list[i] = chunk_list_by_zlevel[i]

	temp_list[world.maxz + 1] = new/list(CHUNKSPERLEVEL(world.maxx, world.maxy))
	for(var/j = 1, j <= CHUNKSPERLEVEL(world.maxx, world.maxy), j++)
		temp_list[world.maxz + 1][j] = new /datum/chunk(src)
	chunk_list_by_zlevel = temp_list


/datum/controller/subsystem/chunks/proc/onMobNew(atom/signalSource, mob/source)
	SIGNAL_HANDLER
	source.InitiateChunkTracking()

// Get mobs in range using chunks
/proc/getMobsInRangeChunked(atom/source, range, aliveonly = FALSE, canseeonly = FALSE)
	if(!source || !range)
		return
	var/atom/container = source.getContainingAtom()
	var/list/returnValue = list()
	if(container.z == 0)
		return returnValue
	var/coordinates = list(container.x - range - CHUNK_SIZE, container.y - range - CHUNK_SIZE, container.x + range + CHUNK_SIZE,  container.y + range + CHUNK_SIZE)
	if(coordinates[1] == 0)
		coordinates[1] = 1
	if(coordinates[2] == 0)
		coordinates[2] = 1
	if(coordinates[3] > world.maxx)
		coordinates[3] = world.maxx
	if(coordinates[4] > world.maxy)
		coordinates[4] = world.maxy
	var/datum/chunk/chunkReference
	var/turf/containerTurf = get_turf(container)
	if(containerTurf == null)
		return returnValue
	for(var/chunkX = coordinates[1], chunkX <= coordinates[3], chunkX += CHUNK_SIZE)
		for(var/chunkY = coordinates[2], chunkY <= coordinates[4], chunkY += CHUNK_SIZE)
			chunkReference = SSchunks.chunk_list_by_zlevel[container.z][CHUNKID(chunkX, chunkY)]
			for(var/mob/mobToCheck as anything in chunkReference.mobs)
				var/turf/mobTurf = get_turf(mobToCheck)
				if(!mobTurf)
					continue
				if(DIST_EUCLIDIAN(containerTurf.x, containerTurf.y, mobTurf.x, mobTurf.y) < range)
					if(aliveonly && mobToCheck.stat == DEAD)
						continue
					if(canseeonly && !can_see(containerTurf, get_turf(mobToCheck), range * 2))
						continue
					returnValue += mobToCheck
	return returnValue

/proc/getHearersInRangeChunked(atom/source, range)
	if(!source || !range)
		return
	var/atom/container = source.getContainingAtom(source)
	var/list/returnValue = list()
	if(container.z == 0)
		return returnValue
	// IF THE RANGE IS SMALLER THAN CHUNK_SIZE , theres a risk of not  checking all relevant chunks (If anyone can figure the true underlying cause to this,  then feel free to remove this)
	// as it'd basically just improve performance (not like its not improved enough already tho)
	var/coordinates = list(container.x - range - CHUNK_SIZE, container.y - range - CHUNK_SIZE, container.x + range + CHUNK_SIZE,  container.y + range + CHUNK_SIZE)
	if(coordinates[1] == 0)
		coordinates[1] = 1
	if(coordinates[2] == 0)
		coordinates[2] = 1
	if(coordinates[3] > world.maxx)
		coordinates[3] = world.maxx
	if(coordinates[4] > world.maxy)
		coordinates[4] = world.maxy
	var/datum/chunk/chunkReference
	var/turf/containerTurf = get_turf(container)
	if(containerTurf == null)
		return returnValue
	for(var/chunkX = coordinates[1], chunkX <= coordinates[3], chunkX += CHUNK_SIZE)
		for(var/chunkY = coordinates[2], chunkY <= coordinates[4], chunkY += CHUNK_SIZE)
			chunkReference = SSchunks.chunk_list_by_zlevel[container.z][CHUNKID(chunkX, chunkY)]
			for(var/obj/hearerToCheck as anything in chunkReference.hearers)
				var/turf/hearerTurf = get_turf(hearerToCheck)
				if(!hearerTurf)
					continue
				if(DIST_EUCLIDIAN(containerTurf.x, containerTurf.y, hearerTurf.x, hearerTurf.y) < range)
					if(!can_see(source, get_turf(hearerToCheck), range * 2))
						continue
					returnValue += hearerToCheck
	return returnValue

/// Mob tracking and handling
/mob/proc/chunkOnMove(atom/source, atom/oldLocation, atom/newLocation)
	SIGNAL_HANDLER
	var/datum/chunk/chunk_reference
	if(oldLocation?.z && newLocation?.z)
		if((CHUNKID(oldLocation.x, oldLocation.y) == CHUNKID(newLocation.x, newLocation.y)) && (oldLocation.z == newLocation.z))
			return
		chunk_reference = SSchunks.chunk_list_by_zlevel[oldLocation.z][CHUNKID(oldLocation.x, oldLocation.y)]
		chunk_reference.mobs -= src
		//if(ishuman(src))
		//	message_admins("M:[src] removed from chunkID : [CHUNKID(oldLocation.x, oldLocation.y)] Z:[oldLocation.z] 1  [usr]")
		if(CHUNKCOORDCHECK(newLocation.x, newLocation.y))
			return
		/// This is done because we are having cases where forceMove is being called multiple Times , causing duplicated mobs.
		/// Wasn't able to find which part of move/forceMove causes shit to break , currently ExTools debugging don't work on the version were using
		/// Hopefully we fix this once ExTools debugger gets updated to 515.1623 , SPCR - 2023
		if(currentChunk == CHUNKKEY(newLocation.x, newLocation.y, newLocation.z))
			return
		currentChunk = CHUNKKEY(newLocation.x, newLocation.y, newLocation.z)
		chunk_reference = SSchunks.chunk_list_by_zlevel[newLocation.z][CHUNKID(newLocation.x, newLocation.y)]
		chunk_reference.mobs += src
		//if(ishuman(src))
		//	message_admins("M:[src] added to chunkID : [CHUNKID(newLocation.x, newLocation.y)] Z:[newLocation.z] 1 [usr]")
		//if(oldLocation.z != newLocation.z)
		//	stack_trace("Stack tracing mobs")
	else if(newLocation?.z)
		if(CHUNKCOORDCHECK(newLocation.x, newLocation.y))
			return
		/// This is done because we are having cases where forceMove is being called multiple Times , causing duplicated mobs.
		/// Wasn't able to find which part of move/forceMove causes shit to break , currently ExTools debugging don't work on the version were using
		/// Hopefully we fix this once ExTools debugger gets updated to 515.1623 , SPCR - 2023
		if(currentChunk == CHUNKKEY(newLocation.x, newLocation.y, newLocation.z))
			return
		currentChunk = CHUNKKEY(newLocation.x, newLocation.y, newLocation.z)
		chunk_reference = SSchunks.chunk_list_by_zlevel[newLocation.z][CHUNKID(newLocation.x, newLocation.y)]
		chunk_reference.mobs += src
		//if(ishuman(src))
		//	message_admins("M:[src] added to chunkID : [CHUNKID(newLocation.x, newLocation.y)] Z:[newLocation.z] 2 [usr]")
	else if(oldLocation?.z)
		chunk_reference = SSchunks.chunk_list_by_zlevel[oldLocation.z][CHUNKID(oldLocation.x, oldLocation.y)]
		chunk_reference.mobs -= src
		//if(ishuman(src))
		//	message_admins("M:[src] removed from chunkID : [CHUNKID(oldLocation.x, oldLocation.y)] Z:[oldLocation.z] 2 [usr]")

/mob/proc/chunkOnContainerization(atom/source, atom/newContainer , atom/oldContainer)
	SIGNAL_HANDLER
	//message_admins("[src] switched container from [oldContainer] to [newContainer]")
	UnregisterSignal(oldContainer , COMSIG_MOVABLE_MOVED)
	RegisterSignal(newContainer, COMSIG_MOVABLE_MOVED, PROC_REF(chunkOnMove))

/mob/proc/tch()
	for(var/mob/thng in getMobsInRangeChunked(get_turf(src), 8, FALSE, TRUE))
		message_admins("Received [thng]")


/mob/proc/chunkClearSelf(atom/source)
	SIGNAL_HANDLER
	var/atom/container = getContainingAtom()
	// in this case we never registered
	if(container.z != 0)
		var/datum/chunk/chunk_reference = SSchunks.chunk_list_by_zlevel[container.z][CHUNKID(container.x, container.y)]
		chunk_reference.mobs -= src

/// Hearer tracking and handling
/obj/proc/chunkHearerOnMove(atom/source, atom/oldLocation , atom/newLocation)
	SIGNAL_HANDLER
	var/datum/chunk/chunk_reference
	if(oldLocation?.z && newLocation?.z)
		if(CHUNKID(oldLocation.x, oldLocation.y) == CHUNKID(newLocation.x, newLocation.y) && oldLocation.z == newLocation.z)
			return
		chunk_reference = SSchunks.chunk_list_by_zlevel[oldLocation.z][CHUNKID(oldLocation.x, oldLocation.y)]
		chunk_reference.hearers -= src
		if(ishuman(src))
			message_admins("H:[src] removed from chunkID : [CHUNKID(oldLocation.x, oldLocation.y)] Z:[oldLocation.z]" )
		if(CHUNKCOORDCHECK(newLocation.x, newLocation.y))
			return
		chunk_reference = SSchunks.chunk_list_by_zlevel[newLocation.z][CHUNKID(newLocation.x, newLocation.y)]
		chunk_reference.hearers += src
		if(ishuman(src))
			message_admins("H:[src] added to chunkID : [CHUNKID(newLocation.x, newLocation.y)] Z:[newLocation.z]")
	else if(newLocation?.z)
		if(CHUNKCOORDCHECK(newLocation.x, newLocation.y))
			return
		chunk_reference = SSchunks.chunk_list_by_zlevel[newLocation.z][CHUNKID(newLocation.x, newLocation.y)]
		chunk_reference.hearers += src
		if(ishuman(src))
			message_admins("H:[src] added to chunkID : [CHUNKID(newLocation.x, newLocation.y)] Z:[newLocation.z]")
	else if(oldLocation?.z)
		chunk_reference = SSchunks.chunk_list_by_zlevel[oldLocation.z][CHUNKID(oldLocation.x, oldLocation.y)]
		chunk_reference.hearers -= src
		if(ishuman(src))
			message_admins("H:[src] removed from chunkID : [CHUNKID(oldLocation.x, oldLocation.y)] Z:[oldLocation.z]")
	/*
	var/datum/chunk/chunk_reference
	if(oldLocation && oldLocation.z != 0)
		if(newLocation)
			if(CHUNKID(oldLocation.x, oldLocation.y) == CHUNKID(newLocation.x, newLocation.y))
				return
		chunk_reference = SSchunks.chunk_list_by_zlevel[oldLocation.z][CHUNKID(oldLocation.x, oldLocation.y)]
		chunk_reference.hearers -= src
		//if(ishuman(src))
		//	message_admins("[src] removed from chunkID : [CHUNKID(oldLocation.x, oldLocation.y)]")
	// The new location has invalid coordinates , so lets get rid of them from the old chunk and not update to another one
	if(newLocation && newLocation.z != 0)
		if(CHUNKCOORDCHECK(newLocation.x, newLocation.y))
			return
		chunk_reference = SSchunks.chunk_list_by_zlevel[newLocation.z][CHUNKID(newLocation.x, newLocation.y)]
		chunk_reference.hearers += src
		//if(ishuman(src))
		//	message_admins("[src] added to chunkID : [CHUNKID(newLocation.x, newLocation.y)]")
	*/

/obj/proc/chunkHearerOnContainerization(atom/source, atom/newContainer, atom/oldContainer)
	SIGNAL_HANDLER
	//message_admins("[src] switched container from [oldContainer] to [newContainer]")
	UnregisterSignal(oldContainer , COMSIG_MOVABLE_MOVED)
	RegisterSignal(newContainer, COMSIG_MOVABLE_MOVED, PROC_REF(chunkHearerOnMove))

/obj/proc/chunkHearerClearSelf(datum/source)
	var/atom/container = getContainingAtom()
	UnregisterSignal(container, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(src, list(COMSIG_ATOM_CONTAINERED, COMSIG_PARENT_QDELETING))
	// in this case we never registered
	if(container.z != 0)
		var/datum/chunk/chunk_reference = SSchunks.chunk_list_by_zlevel[container.z][CHUNKID(container.x, container.y)]
		chunk_reference.hearers -= src
	SIGNAL_HANDLER


// This is done by the mob itself because keeping track of them with reference solving is trash and unefficient
// Especially resolving references between container > contained mob to update X mob's chunk
// TGMC Minimaps are a good example (old ones they fixed their stuff)
/mob/proc/InitiateChunkTracking()
	SIGNAL_HANDLER
	// No to this!!
	if(isnewplayer(src))
		return
	var/atom/highestContainer = getContainingAtom()
	RegisterSignal(highestContainer, COMSIG_MOVABLE_MOVED, PROC_REF(chunkOnMove))
	RegisterSignal(src, COMSIG_ATOM_CONTAINERED, PROC_REF(chunkOnContainerization))
	RegisterSignal(src, COMSIG_PARENT_QDELETING, PROC_REF(chunkClearSelf))
	if(highestContainer.z != 0)
		var/datum/chunk/chunk_reference = SSchunks.chunk_list_by_zlevel[highestContainer.z][CHUNKID(highestContainer.x, highestContainer.y)]
		chunk_reference.mobs += src

/obj/proc/InitiateHearerTracking()
	var/atom/highestContainer = getContainingAtom()
	RegisterSignal(highestContainer, COMSIG_MOVABLE_MOVED, PROC_REF(chunkHearerOnMove))
	RegisterSignal(src, COMSIG_ATOM_CONTAINERED, PROC_REF(chunkHearerOnContainerization))
	RegisterSignal(src, COMSIG_PARENT_QDELETING, PROC_REF(chunkHearerClearSelf))
	if(highestContainer.z != 0)
		var/datum/chunk/chunk_reference = SSchunks.chunk_list_by_zlevel[highestContainer.z][CHUNKID(highestContainer.x, highestContainer.y)]
		chunk_reference.hearers += src




