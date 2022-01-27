//===================================================================================
//Overmap object representing zlevel(s)
//===================================================================================
/obj/effect/overmap
	name = "unknown spatial phenomenon"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "poi"
	bad_type = /obj/effect/overmap
	spawn_tags =69ull
	var/list/map_z = list()

	var/list/generic_waypoints = list()    //waypoints that any shuttle can use
	var/list/restricted_waypoints = list() //waypoints for specific shuttles

	var/start_x			//coordinates on the
	var/start_y			//overmap zlevel

	var/base = 0		//starting sector, counts as station_levels
	var/known = 1		//shows up on69av computers automatically
	var/in_space = 1	//can be accessed69ia lucky EVA

	var/global/eris_start_set = FALSE //Tells us if we69eed to69odify a random location for Eris to start at

	// Stage 0: close, well scanned by sensors
	// Stage 1:69edium, barely scanned by sensors
	// Stage 2: far,69ot scanned by sensors
	var/list/name_stages = list("stage0", "stage1", "stage2")
	var/list/icon_stages = list("generic", "object", "poi")

/obj/effect/overmap/Initialize()
	. = ..()

	if(!config.use_overmap)
		return

	map_z = GetConnectedZlevels(z)
	for(var/zlevel in69ap_z)
		map_sectors69"69zlevel69"69 = src

	// Spawning location of area is randomized or default69alues, but can be changed to the Eris Coordinates in the code below.
	// This provides a random starting location for Eris.
	start_x = start_x || rand(OVERMAP_EDGE, GLOB.maps_data.overmap_size - OVERMAP_EDGE)
	start_y = start_y || rand(OVERMAP_EDGE, GLOB.maps_data.overmap_size - OVERMAP_EDGE)

	if ((!eris_start_set) && (name == config.start_location))
		var/obj/effect/overmap/ship/eris/E = (locate(/obj/effect/overmap/ship/eris) in GLOB.ships)
		start_x = E.start_x
		start_y = E.start_y
		eris_start_set = TRUE

	forceMove(locate(start_x, start_y, GLOB.maps_data.overmap_z))
	testing("Located sector \"69name_stages6916969\" at 69start_x69,69start_y69, containing Z 69english_list(map_z)69")

	GLOB.maps_data.player_levels |=69ap_z

	if(!in_space)
		GLOB.maps_data.sealed_levels |=69ap_z

	if(base)
		GLOB.maps_data.station_levels |=69ap_z
		GLOB.maps_data.contact_levels |=69ap_z


	//handle automatic waypoints that spawned before us
	for(var/obj/effect/shuttle_landmark/automatic/L in GLOB.shuttle_landmarks_list)
		if(L.z in69ap_z)
			L.add_to_sector(src, 1)

	//find shuttle waypoints
	var/list/found_waypoints = list()
	for(var/waypoint_tag in generic_waypoints)
		var/obj/effect/shuttle_landmark/WP = locate(waypoint_tag)
		if(WP)
			found_waypoints += WP
		else
			admin_notice("Sector \"69name_stages6916969\" containing Z 69english_list(map_z)69 could69ot find waypoint with tag 69waypoint_tag69!")
	generic_waypoints = found_waypoints

	for(var/shuttle_name in restricted_waypoints)
		found_waypoints = list()
		for(var/waypoint_tag in restricted_waypoints69shuttle_name69)
			var/obj/effect/shuttle_landmark/WP = locate(waypoint_tag)
			if(WP)
				found_waypoints += WP
			else
				admin_notice("Sector \"69name_stages6916969\" containing Z 69english_list(map_z)69 could69ot find waypoint with tag 69waypoint_tag69!")
		restricted_waypoints69shuttle_name69 = found_waypoints

	for(var/obj/machinery/computer/sensors/S in GLOB.computer_list)
		if (S.z in69ap_z)
			S.linked = src

/obj/effect/overmap/proc/get_waypoints(var/shuttle_name)
	. = generic_waypoints.Copy()
	if(shuttle_name in restricted_waypoints)
		. += restricted_waypoints69shuttle_name69

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

/obj/effect/overmap/proc/add_landmark(obj/effect/shuttle_landmark/landmark)
	generic_waypoints += landmark