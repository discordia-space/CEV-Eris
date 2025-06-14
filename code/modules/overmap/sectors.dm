//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
/obj/effect/overmap
	name = "unknown spatial phenomenon"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "poi"
	bad_type = /obj/effect/overmap
	spawn_tags = null
	var/list/map_z = list()

	var/start_x			//coordinates on the
	var/start_y			//overmap zlevel

	var/known = 1		//shows up on nav computers automatically
	var/in_space = 1	//can be accessed via lucky EVA

	var/global/eris_start_set = FALSE //Tells us if we need to modify a random location for Eris to start at

	// Stage 0: close, well scanned by sensors
	// Stage 1: medium, barely scanned by sensors
	// Stage 2: far, not scanned by sensors
	var/list/name_stages = list("stage0", "stage1", "stage2")
	var/list/icon_stages = list("generic", "object", "poi")

/obj/effect/overmap/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/overmap/LateInitialize()
	map_z = SSmapping.GetConnectedZlevels(z)
	for(var/zlevel in map_z)
		map_sectors["[zlevel]"] = src

	// Spawning location of area is randomized or default values, but can be changed to the Eris Coordinates in the code below.
	// This provides a random starting location for Eris.
	start_x = start_x || rand(OVERMAP_EDGE, OVERMAP_SIZE - OVERMAP_EDGE)
	start_y = start_y || rand(OVERMAP_EDGE, OVERMAP_SIZE - OVERMAP_EDGE)

	if((!eris_start_set) && (name == config.start_location))
		var/obj/effect/overmap/ship/eris/E = (locate(/obj/effect/overmap/ship/eris) in GLOB.ships)
		start_x = E.start_x
		start_y = E.start_y
		eris_start_set = TRUE

	forceMove(locate(start_x, start_y, SSmapping.overmap_z))
	testing("Located sector \"[name_stages[1]]\" at [start_x],[start_y], containing Z [english_list(map_z)]")

/obj/effect/overmap/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "poi"
	anchored = TRUE

/obj/effect/overmap/sector/Initialize()
	. = ..()
	if(known)
		update_known()

/obj/effect/overmap/proc/update_known()
	layer = 2
	set_plane(-1)
	for(var/obj/machinery/computer/helm/H in GLOB.computer_list)
		H.get_known_sectors()
