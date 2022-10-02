#define CHUNKID(x,y,size) (((x - x%size) + (y - y%size) * world.maxx) / size ** 2)
#define CHUNKSPERLEVEL(x,y,size) ((world.maxx * world.maxy) / size ** 2)
#define CHUNKCOORDCHECK(x,y) (x > world.maxx || y > world.maxy || x < 0 || y < 0)

SUBSYSTEM_DEF(chunks)
	name = "Chunks"
	init_order = INIT_ORDER_CHUNKS
	flags = SS_NO_FIRE
	var/list/chunk_list_by_zlevel
	// 8 x 8 tiles.
	var/chunk_size = 8

/datum/controller/subsystem/chunks/Initialize(timeofday)
	chunk_list_by_zlevel = new/list(world.maxz)
	for(var/i = 1, i <= world.maxz,i++)
		chunk_list_by_zlevel[i] = new/list(CHUNKSPERLEVEL(world.maxx, world.maxy, chunk_size))
		for(var/j = 1, j < CHUNKSPERLEVEL(world.maxx, world.maxy, chunk_size), j++)
			chunk_list_by_zlevel[i][j] = list()
	RegisterSignal(SSdcs, COMSIG_MOB_INITIALIZE, .proc/onMobNew)
	return ..()

/datum/controller/subsystem/chunks/proc/onMobNew(mob/source)
	SIGNAL_HANDLER
	RegisterSignal(source, COMSIG_PARENT_QDELETING, .proc/removeMob)
	RegisterSignal(source, COMSIG_MOVABLE_MOVED, .proc/onMobMove)
	var/list/chunk_reference = chunk_list_by_zlevel[source.z][CHUNKID(source.x, source.y, chunk_size)]
	message_admins("added [source] to [CHUNKID(source.x, source.y, chunk_size)]")
	chunk_reference += source

/datum/controller/subsystem/chunks/proc/onMobMove(mob/source, turf/oldloc, turf/newloc)
	SIGNAL_HANDLER
	if(CHUNKID(oldloc.x, oldloc.y, chunk_size) == CHUNKID(newloc.x, newloc.y, chunk_size))
		return
	chunk_list_by_zlevel[source.z][CHUNKID(oldloc.x, oldloc.y, chunk_size)] -= source
	// The new location has invalid coordinates , so lets get rid of them from the old chunk and not update to another one
	if(CHUNKCOORDCHECK(newloc.x, newloc.y))
		return
	chunk_list_by_zlevel[source.z][CHUNKID(newloc.x, newloc.y, chunk_size)] += source

/datum/controller/subsystem/chunks/proc/removeMob(mob/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_PARENT_QDELETING)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)


// Get mobs in range using chunks
/proc/getMobsInRangeChunked(atom/source, range)
	if(!source || !range)
		return null
	. = list()
	var/topX = source.x - range
	var/topY = source.y - range
	var/bottomX = source.x + range
	var/bottomY = source.y + range
	var/chunksize = SSchunks.chunk_size
	while(bottomY > topY)
		bottomX = topX + range * 2
		while(bottomX > topX)
			. += SSchunks.chunk_list_by_zlevel[source.z][CHUNKID(bottomX, bottomY, chunksize)]
			bottomX -= chunksize
		bottomY -= chunksize
	for(var/mob/guy in .)
		message_admins("got [guy] as part of returned mobs from the chunk proc")
	for(var/list/ref in .)
		for(var/mob/ler in ref)
			message_admins("got [ler]")

/mob/verb/get_mobs()
	set name = "Getmobs"
	set desc = "No desc"
	set src in view(10)
	getMobsInRangeChunked(src, 32)






