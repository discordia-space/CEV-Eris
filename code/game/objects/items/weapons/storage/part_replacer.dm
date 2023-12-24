/obj/item/storage/part_replacer
	name = "rapid part exchange device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon_state = "RPED"
	item_state = "RPED"
	volumeClass = ITEM_SIZE_HUGE
	can_hold = list(/obj/item/stock_parts)
	storage_slots = 50
	use_to_pickup = TRUE
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	collection_mode = TRUE
	display_contents_with_number = TRUE
	max_volumeClass = ITEM_SIZE_NORMAL
	max_storage_space = 100
	matter = list(MATERIAL_PLASTIC = 5, MATERIAL_STEEL = 2)

/obj/item/storage/part_replacer/debugparts
	bad_type = /obj/item/storage/part_replacer/debugparts

/obj/item/storage/part_replacer/debugparts/populate_contents()
	var/list/spawnedAtoms = list()

	spawnedAtoms.Add(new /obj/item/stock_parts/capacitor/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/capacitor/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/capacitor/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/scanning_module/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/scanning_module/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/scanning_module/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/manipulator/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/manipulator/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/manipulator/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/micro_laser/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/micro_laser/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/micro_laser/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/matter_bin/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/matter_bin/debug(NULLSPACE))
	spawnedAtoms.Add(new /obj/item/stock_parts/matter_bin/debug(NULLSPACE))
	for(var/atom/movable/a in spawnedAtoms)
		a.forceMove(src)
