/*
	For the sake of dungeon generator being modular and not tied exclusively to deepmaint,
	most of the objects and modifications required exclusively for it will be kept here.
*/

var/global/list/free_deepmaint_ladders = list()
/proc/check_deepmaint_list()
	return (free_deepmaint_ladders.len)

/obj/procedural/jp_DungeonGenerator/deepmaint
	name = "Deep Maintenance Procedural Generator"


/obj/procedural/jp_DungeonGenerator/deepmaint/generate(seed=null)
	..(seed)
	var/ladders_to_place = 4
	if(numRooms < ladders_to_place)
		return
	var/list/obj/procedural/jp_DungeonRoom/done_rooms = list()
	while(ladders_to_place > 0)
		if(numRooms > 1)
			if(done_rooms.len == out_rooms.len)
				testing("Deepmaint generator went through all rooms, but couldn't place all ladders! Ladders left - [ladders_to_place]")
				break
		var/obj/procedural/jp_DungeonRoom/picked_room = pick(out_rooms)
		if(picked_room in done_rooms)
			continue
		var/list/turf/viable_turfs = list()
		for (var/turf/simulated/floor/F in range(roomMinSize + 1, picked_room.centre))
			//not under walls
			if (F.is_wall)
				continue

			//No airlocks
			if (locate(/obj/machinery/door) in F)
				continue

			//No ladders or stairs
			if (locate(/obj/structure/multiz) in F)
				done_rooms += picked_room
				viable_turfs = list()
				break;

			//No turfs in space
			if (turf_is_external(F))
				continue

			//To be valid, the floor needs to have a wall in a cardinal direction
			for (var/d in cardinal)
				var/turf/T = get_step(F, d)
				if (T.is_wall)
					//Its got a wall!
					viable_turfs[F] = T //We put this floor and its wall into the possible turfs list
					break

		if(viable_turfs.len == 0)
			done_rooms += picked_room
			continue

		var/turf/ladder_turf = pick(viable_turfs)
		var/obj/structure/multiz/ladder/up/deepmaint/newladder = new/obj/structure/multiz/ladder/up/deepmaint(ladder_turf)
		free_deepmaint_ladders += newladder
		ladders_to_place--
		done_rooms += picked_room






/obj/procedural/dungenerator/deepmaint
	name = "Deep Maint Gen"


/obj/procedural/dungenerator/deepmaint/New()
	while(1)
		if(Master.current_runlevel)
			break
		else
			sleep(150)
	var/obj/procedural/jp_DungeonGenerator/generate = new /obj/procedural/jp_DungeonGenerator/deepmaint(src)
	testing("Beggining procedural generation of [name].")
	generate.name = name
	generate.setArea(locate(x - round(width_x/2) + 1, y + round(height_y/2) + 1, z), locate(x + round(width_x/2) - 1, y - round(height_y/2) - 1, z))
	generate.setWallType(/turf/simulated/wall)
	generate.setLightChance(2)
	generate.setFloorType(/turf/simulated/floor/tiled/techmaint_perforated)
	generate.setAllowedRooms(list(/obj/procedural/jp_DungeonRoom/preexist/square/submap))
	generate.setSubmapPath(/datum/map_template/deepmaint_template/big)
	generate.setNumRooms(1)
	generate.setExtraPaths(10)
	generate.setMinPathLength(20)
	generate.setMaxPathLength(45)
	generate.setMinLongPathLength(30)
	generate.setLongPathChance(30)
	generate.setPathEndChance(30)
	generate.setRoomMinSize(10)
	generate.setRoomMaxSize(10)
	generate.setPathWidth(1)
	generate.generate()

	sleep(90)

	generate.setAllowedRooms(list(/obj/procedural/jp_DungeonRoom/preexist/square/submap))
	generate.setSubmapPath(/datum/map_template/deepmaint_template/room)
	generate.setNumRooms(15)
	generate.setExtraPaths(8)
	generate.setMinPathLength(1)
	generate.setMaxPathLength(50)
	generate.setMinLongPathLength(25)
	generate.setLongPathChance(30)
	generate.setPathEndChance(30)
	generate.setRoomMinSize(5)
	generate.setRoomMaxSize(5)
	generate.setPathWidth(2)
	generate.setUsePreexistingRegions(TRUE)
	generate.setDoAccurateRoomPlacementCheck(TRUE)
	generate.generate()

	testing("Finished procedural generation of [name].")