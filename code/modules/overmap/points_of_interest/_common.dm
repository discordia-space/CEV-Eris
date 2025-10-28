/obj/effect/overmap/sector/map_spawner
	// This object is created when related /obj/effect/overmap_event/poi/ is revealed on the overmap
	// When that happens - we need to make a new Z-level available for players to explore
	// Variable below specifies the .json config we're going to load a map from
	// These configs live in maps/json/ and a full path to the file could be used instead of a name
	var/map_to_load = "blacksite_small"

/obj/effect/overmap/sector/map_spawner/LateInitialize()
	..()
	SSmapping.load_map_from_name(map_to_load)
