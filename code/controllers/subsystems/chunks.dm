#define CHUNKID(x,y,size) ((x - x%size) + (y - y%size) * world.maxx) / size ** 2
#define CHUNKSPERLEVEL(x,y,size) ((world.maxx * world.maxy) / size ** 2;

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
	return ..()


