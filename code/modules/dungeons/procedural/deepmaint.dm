/obj/procedural/dungenerator/deepmaint
	name = "Deep Maint Gen"


/obj/procedural/dungenerator/deepmaint/New()
	while(1)
		if(Master.current_runlevel)
			break
		else
			sleep(150)
	var/obj/procedural/jp_DungeonGenerator/generate = new /obj/procedural/jp_DungeonGenerator(src)
	testing("Beggining procedural generation of [name].")
	generate.name = name
	generate.setArea(locate(x - round(width_x/2) + 1, y + round(height_y/2) + 1, z), locate(x + round(width_x/2) - 1, y - round(height_y/2) - 1, z))
	generate.setWallType(/turf/simulated/wall)
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
	generate.setNumRooms(10)
	generate.setExtraPaths(2)
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

	testing("Finished procedural generation of [name].")