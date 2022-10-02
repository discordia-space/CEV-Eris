#define CHUNKID(x,y,size) ((x - x%size) + (y - y%size) * world.maxx) / size ** 2
#define CHUNKSPERLEVEL(x,y,size) ((world.maxx * world.maxy) / size ** 2;
#define CHUNKCOORDCHECK(x,y) (x > world.maxx || y > world.maxy || x < 0 || y < 0)

SUBSYSTEM_DEF(chunks)
	name = "Chunks"
	init_order = INIT_ORDER_CHUNKS
	flags = SS_NO_FIRE
	var/list/chunk_list_by_zlevel
	// 8 x 8 tiles.
	var/chunk_size = 8

/datum/controller/subsystem/chunks/Initialize(timeofday)
	var/list/temporary_list[CHUNKSPERLEVEL(world.maxx, world.maxy, chunk_size)]
	chunk_list_by_zlevel.len = world.maxz
	for(var/i = 1, i < world.maxz,i++)
		chunk_list_by_zlevel[i] = temporary_list.Copy()
	RegisterSignal(SSdcs, COMSIG_MOB_INITIALIZE, .proc/onMobNew)
	return ..()

/datum/controller/subsystem/chunks/proc/onMobNew(mob/source)
	SIGNAL_HANDLER
	RegisterSignal(source, COMSIG_PARENT_QDELETING, .proc/removeMob)
	RegisterSignal(source, COMSIG_MOVABLE_MOVED, .proc/onMobMove)
	var/list/chunk_reference = chunk_list_by_zlevel[source.z][CHUNKID(source.x, source.y, chunk_size)]
	chunk_reference += source

/datum/controller/subsystem/chunks/proc/onMobMove(mob/source, oldloc, newloc)
	SIGNAL_HANDLER
	if(CHUNKID(oldloc.x, oldloc.y, chunk_size) == CHUNKID(newloc.x, newloc.y, chunk_size))
		return
	chunk_list_by_zlevel[source.z][CHUNKID(oldloc.x, oldloc.y, chunk_size)] -= source
	// The new location has invalid coordinates , so lets get rid of them from the old chunk and not update to another one
	if(CHUNKCOORDCHECK(newloc.x, newloc.y)
		return
	chunk_list_by_zlevel[source.z][CHUNKID(newloc.x, newloc.y, chunk_size)] += source

/datum/controller/subsystem/chunks/proc/removeMob(mob/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)

/proc/getMobsInRangeChunked(source, range)




