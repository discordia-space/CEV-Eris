#define CHUNKID(x,y,size) round((((x - x%size) + (y - y%size) * world.maxx) / size ** 2), 1)
#define CHUNKSPERLEVEL(x,y,size) ((world.maxx * world.maxy) / size ** 2)
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
	var/list/zlevel_toreference_to_mob
	// 8 x 8 tiles.
	var/chunk_size = 8

/datum/controller/subsystem/chunks/Initialize(timeofday)
	chunk_list_by_zlevel = new/list(world.maxz)
	for(var/i = 1, i <= world.maxz,i++)
		chunk_list_by_zlevel[i] = new/list(CHUNKSPERLEVEL(world.maxx, world.maxy, chunk_size))
		for(var/j = 1, j <= CHUNKSPERLEVEL(world.maxx, world.maxy, chunk_size), j++)
			chunk_list_by_zlevel[i][j] = new /datum/chunk(src)
	zlevel_toreference_to_mob = new/list(world.maxz)
	for(var/i = 1; i <= world.maxz, i++)
		zlevel_toreference_to_mob = new/list(0,0)
	RegisterSignal(SSdcs, COMSIG_MOB_INITIALIZE, PROC_REF(onMobNew))
	return ..()
/*
/datum/controller/subsystem/chunks/proc/addToReferenceTracking(mob/target)
	zlevel_toreference_to_mob[target.z][target.getContainingMovable()] += target

/datum/controller/subsystem/chunks/proc/removeFromReferenceTracking(mob/target)
	zlevel_to_reference_to_mob[target.z][target.getContainingMovable()] -= target
*/

/datum/controller/subsystem/chunks/proc/onContainerization(mob/containered, atom/movable/container, atom/movable/oldContainer)
	SIGNAL_HANDLER
	UnregisterSignal(oldContainer, list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_Z_CHANGED))
	zlevel_to_reference_to_mob[containered.z][oldContainer] -= containered
	RegisterSignal(container), COMSIG_MOVABLE_MOVED, PROC_REF(onMobMove)
	RegisterSignal(container, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(onLevelChange))
	zlevel_to_reference_to_mob[containered.z][container] += containered

/datum/controller/subsystem/chunks/proc/onMobNew(mob/source)
	SIGNAL_HANDLER
	var/atom/movable/container = source.getContainingMovable()
	RegisterSignal(source, COMSIG_PARENT_QDELETING, PROC_REF(removeMob))
	RegisterSignal(container, COMSIG_MOVABLE_MOVED, PROC_REF(onMobMove))
	RegisterSignal(container, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(onLevelChange))
	RegisterSignal(source, COMSIG_ATOM_CONTAINERED, PROC_REF(onContainerization))
	var/datum/chunk/chunk_reference = chunk_list_by_zlevel[container.z][CHUNKID(container.x, container.y, chunk_size)]
	chunk_reference.mobs += source
	zlevel_to_reference_to_mob[container.z][container] += source

/datum/controller/subsystem/chunks/proc/onMobMove(atom/source, turf/oldloc, turf/newloc)
	SIGNAL_HANDLER
	if(CHUNKID(oldloc.x, oldloc.y, chunk_size) == CHUNKID(newloc.x, newloc.y, chunk_size))
		return
	var/list/mob/sourceMobs = zlevel_toreference_to_mob[source.z][source]
	var/datum/chunk/chunk_reference = chunk_list_by_zlevel[source.z][CHUNKID(oldloc.x, oldloc.y, chunk_size)]
	chunk_reference.mobs -= sourceMobs
	// The new location has invalid coordinates , so lets get rid of them from the old chunk and not update to another one
	if(CHUNKCOORDCHECK(newloc.x, newloc.y))
		return
	chunk_reference = chunk_list_by_zlevel[source.z][CHUNKID(newloc.x, newloc.y, chunk_size)]
	chunk_reference.mobs += sourceMobs

/datum/controller/subsyste/chunks/proc/onLevelChange(atom/source, oldLevel, newLevel)
	SIGNAL_HANDLER
	var/list/mob/sourceMobs = zlevel_toreference_to_mob[oldLevel][source]
	zlevel_to_reference_to_mob[oldLevel] -= source
	zlevel_to_reference_to_mob[newLevel] += source
	zlevel_to_reference_to_mob[newLevel][source] = sourceMobs
	if(CHUNKCOORDCHECK(source.x, source.y))
		return
	var/datum/chunk/chunk_reference = chunk_list_by_zlevel[oldLevel][CHUNKID(source.x, source.y, chunk_size)]
	chunk_reference.mobs -= sourceMobs
	chunk_reference = chunk_list_by_zlevel[newLevel][CHUNKID(source.x, source.y, chunk_size)]
	chunk_reference.mobs += sourceMobs


/datum/controller/subsystem/chunks/proc/removeMob(mob/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)


// Get mobs in range using chunks
/proc/getMobsInRangeChunked(atom/source, range, aliveonly = FALSE)
	if(!source || !range)
		return null
	var/topX = source.x - range
	var/topY = source.y - range
	var/bottomX = source.x + range
	var/bottomY = source.y + range
	if(topX < 0)
		topX = 1
	if(topY < 0)
		topY = 1
	if(bottomX > world.maxx)
		bottomX = world.maxx
	if(bottomY > world.maxy)
		bottomY = world.maxy
	. = list()
	var/chunksize = SSchunks.chunk_size
	var/list/mob2check = list()
	// we go backwards so we don't have to check for chunk validity every time
	while(bottomY > topY)
		while(bottomX > topX)
			mob2check += SSchunks.chunk_list_by_zlevel[source.z][CHUNKID(bottomX, bottomY, chunksize)]
			bottomX -= chunksize
		bottomX = topX + range * 2
		bottomY -= chunksize
	for(var/mob/poss_mob as anything in mob2check)
		if(get_dist(poss_mob, source) < range)
			if(aliveonly && poss_mob.stat == DEAD)
				continue
			. += poss_mob
