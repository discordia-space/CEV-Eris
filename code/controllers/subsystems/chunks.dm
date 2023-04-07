#define CHUNK_SIZE 8
//#define CHUNKID(x,y,size) round((((x - x%size) + (y - y%size) * world.maxx) / size ** 2))
#define CHUNKID(x,y,size) round(x/CHUNK_SIZE)+round(y/CHUNK_SIZE)*round(world.maxx / CHUNK_SIZE)
#define CHUNKSPERLEVEL(x,y,size) ((world.maxx * world.maxy) / CHUNK_SIZE ** 2)
#define CHUNKCOORDCHECK(x,y) (x > world.maxx || y > world.maxy || x < 0 || y < 0)
/// This subsystem is meant for anything that should not be employing byond view() and is generally very constraining to keep track of
/// For now it only has mobs, but it should also include sanity

/datum/chunk
	var/list/mob/mobs = list()
	var/list/sanity_damagers = list()
	var/list/hearers = list()
	var/list/signal_receivers = list()

SUBSYSTEM_DEF(chunks)
	name = "Chunks"
	init_order = INIT_ORDER_CHUNKS
	flags = SS_NO_FIRE
	var/list/datum/chunk/chunk_list_by_zlevel

/datum/controller/subsystem/chunks/Initialize(timeofday)
	chunk_list_by_zlevel = new/list(world.maxz)
	for(var/i = 1, i <= world.maxz,i++)
		chunk_list_by_zlevel[i] = new/list(CHUNKSPERLEVEL(world.maxx, world.maxy, CHUNK_SIZE))
		for(var/j = 1, j <= CHUNKSPERLEVEL(world.maxx, world.maxy, CHUNK_SIZE), j++)
			chunk_list_by_zlevel[i][j] = new /datum/chunk(src)
	RegisterSignal(SSdcs, COMSIG_MOB_INITIALIZED, PROC_REF(onMobNew))
	return ..()

/datum/controller/subsystem/chunks/proc/onMobNew(atom/signalSource, mob/source)
	SIGNAL_HANDLER
	source.InitiateChunkTracking()

// Get mobs in range using chunks
/proc/getMobsInRangeChunked(atom/source, range, aliveonly = FALSE)
	if(!source || !range)
		return
	var/atom/container = source.getContainingAtom(source)
	var/coordinates = list(source.x - range, source.y - range, source.x + range,  source.y + range)
	if(coordinates[1] == 0)
		coordinates[1] = 1
	if(coordinates[2] == 0)
		coordinates[2] = 1
	if(coordinates[3] > world.maxx)
		coordinates[3] = world.maxx
	if(coordinates[4] > world.maxy)
		coordinates[4] = world.maxy
	var/list/returnValue = list()
	var/datum/chunk/chunkReference
	for(var/chunkX = coordinates[1], chunkX <= coordinates[3], chunkX += CHUNK_SIZE)
		for(var/chunkY = coordinates[2], chunkY <= coordinates[4], chunkY += CHUNK_SIZE)
			chunkReference = SSchunks.chunk_list_by_zlevel[container.z][CHUNKID(chunkX, chunkY, CHUNK_SIZE)]
			message_admins("SSchunks : checking chunk ID : [CHUNKID(chunkX, chunkY, CHUNK_SIZE)]")
			message_admins("SSchunks : chunk ID coordinates x = [chunkX] y = [chunkY]]")
			var/turf/target = locate(chunkX, chunkY, source.z)
			target.color = COLOR_RED
			for(var/mob/mobToCheck as anything in chunkReference.mobs)
				if(get_dist_euclidian(source, mobToCheck) < range)
					returnValue += mobToCheck
	return returnValue

/mob/proc/chunkOnMove(atom/source, atom/oldLocation, atom/newLocation)
	SIGNAL_HANDLER
	if(CHUNKID(oldLocation.x, oldLocation.y, CHUNK_SIZE) == CHUNKID(newLocation.x, newLocation.y, CHUNK_SIZE))
		return
	var/datum/chunk/chunk_reference = SSchunks.chunk_list_by_zlevel[oldLocation.z][CHUNKID(oldLocation.x, oldLocation.y, CHUNK_SIZE)]
	chunk_reference.mobs -= src
	// The new location has invalid coordinates , so lets get rid of them from the old chunk and not update to another one
	if(CHUNKCOORDCHECK(newLocation.x, newLocation.y))
		return
	// Don't bother with new location coordinates, faster to acces local ones which are also set
	chunk_reference = SSchunks.chunk_list_by_zlevel[newLocation.z][CHUNKID(newLocation.x, newLocation.y, CHUNK_SIZE)]
	chunk_reference.mobs += src

/mob/proc/chunkOnContainerization(atom/source, atom/newContainer , atom/oldContainer)
	SIGNAL_HANDLER
	UnregisterSignal(oldContainer , list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_Z_CHANGED))
	RegisterSignal(newContainer, COMSIG_MOVABLE_MOVED, PROC_REF(chunkOnMove))
	RegisterSignal(newContainer, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(chunkOnLevelChange))

/mob/proc/chunkOnLevelChange(atom/source, oldLevel, newLevel)
	SIGNAL_HANDLER
	if(CHUNKCOORDCHECK(x,y))
		return
	var/datum/chunk/chunk_reference = SSchunks.chunk_list_by_zlevel[oldLevel][CHUNKID(x, y, CHUNK_SIZE)]
	chunk_reference.mobs -= src
	chunk_reference = SSchunks.chunk_list_by_zlevel[newLevel][CHUNKID(x, y, CHUNK_SIZE)]
	chunk_reference.mobs += src

/mob/proc/chunkClearSelf(atom/source)
	SIGNAL_HANDLER
	var/atom/container = getContainingAtom()
	var/datum/chunk/chunk_reference = SSchunks.chunk_list_by_zlevel[container.z][CHUNKID(container.x, container.y, CHUNK_SIZE)]
	chunk_reference.mobs -= src

// This is done by the mob itself because keeping track of them with reference solving is trash and unefficient
// Especially resolving references between container > contained mob to update X mob's chunk
// TGMC Minimaps are a good example
/mob/proc/InitiateChunkTracking()
	SIGNAL_HANDLER
	// No
	if(isnewplayer(src))
		return
	var/atom/highestContainer = getContainingAtom()
	if(highestContainer.z == 0)
		log_debug("SSchunks : Mob initialized with the container : [highestContainer] which has its z-level set to 0. This mob has not been registered.")
		return
	RegisterSignal(highestContainer, COMSIG_MOVABLE_MOVED, PROC_REF(chunkOnMove))
	RegisterSignal(highestContainer, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(chunkOnLevelChange))
	RegisterSignal(src, COMSIG_ATOM_CONTAINERED, PROC_REF(chunkOnContainerization))
	RegisterSignal(src, COMSIG_PARENT_QDELETING, PROC_REF(chunkClearSelf))
	var/datum/chunk/chunk_reference = SSchunks.chunk_list_by_zlevel[highestContainer.z][CHUNKID(highestContainer.x, highestContainer.y, CHUNK_SIZE)]
	chunk_reference.mobs += src

/mob/proc/wnm(range)
	var/list/atom/mobz = getMobsInRangeChunked(src, range, FALSE)
	message_admins("returned  a list of [length(mobz)]")
	for(var/atom/thing in mobz)
		message_admins("[thing]")

