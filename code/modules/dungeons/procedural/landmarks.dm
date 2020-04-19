//114 x 114
//165 secs
/obj/procedural/dungenerator
	var/obj/procedural/jp_DungeonGenerator/generate = null //The actual generator.
	var/width_x = 114
	var/height_y = 114

/obj/procedural/dungenerator/New()
	var/obj/procedural/jp_DungeonGenerator/generate = new /obj/procedural/jp_DungeonGenerator(src)
	generate.setArea(locate(x - round(width_x/2) + 1, y + round(height_y/2) + 1, z), locate(x + round(width_x/2) - 1, y - round(height_y/2) - 1, z))
	generate.setWallType(/turf/simulated/wall/untinted/onestar)
	generate.setFloorType(/turf/simulated/floor/tiled/derelict/red_white_edges)
	generate.setAllowedRooms(list(/obj/procedural/jp_DungeonRoom/preexist/square, /obj/procedural/jp_DungeonRoom/preexist/circle))
	generate.setNumRooms(10)
	generate.setExtraPaths(5)
	generate.setMinPathLength(8)
	generate.setMaxPathLength(45)
	generate.setMinLongPathLength(25)
	generate.setLongPathChance(30)
	generate.setPathEndChance(30)
	generate.setRoomMinSize(4)
	generate.setRoomMaxSize(6)
	generate.generate()


/obj/procedural/dungenerator/deepmaint
	name = "Deep Maint Gen"



/obj/procedural/dungenerator/deepmaint/New()
	var/obj/procedural/jp_DungeonGenerator/generate = new /obj/procedural/jp_DungeonGenerator(src)
	generate.setArea(locate(x - round(width_x/2) + 1, y + round(height_y/2) + 1, z), locate(x + round(width_x/2) - 1, y - round(height_y/2) - 1, z))
	generate.setWallType(/turf/simulated/wall/untinted/onestar)
	generate.setFloorType(/turf/simulated/floor/tiled/derelict/red_white_edges)
	generate.setAllowedRooms(list(/obj/procedural/jp_DungeonRoom/preexist/square))
	generate.setNumRooms(1)
	generate.setExtraPaths(10)
	generate.setMinPathLength(20)
	generate.setMaxPathLength(45)
	generate.setMinLongPathLength(30)
	generate.setLongPathChance(30)
	generate.setPathEndChance(30)
	generate.setRoomMinSize(15)
	generate.setRoomMaxSize(15)
	generate.setPathWidth(1)
	generate.generate()

	sleep(90)

	generate.setAllowedRooms(list(/obj/procedural/jp_DungeonRoom/preexist/square))
	generate.setNumRooms(15)
	generate.setExtraPaths(1)
	generate.setMinPathLength(8)
	generate.setMaxPathLength(45)
	generate.setMinLongPathLength(25)
	generate.setLongPathChance(30)
	generate.setPathEndChance(30)
	generate.setRoomMinSize(5)
	generate.setRoomMaxSize(5)
	generate.setPathWidth(2)
	generate.setUsePreexistingRegions(TRUE)
	generate.setDoAccurateRoomPlacementCheck(TRUE)
	generate.generate()
