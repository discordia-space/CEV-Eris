GLOBAL_DATUM_INIT(maps_data, /datum/maps_data, new)


/proc/isStationLevel(level)
	return level in GLOB.maps_data.station_levels

/proc/isNotStationLevel(level)
	return !isStationLevel(level)

/proc/isOnStationLevel(atom/A)
	var/turf/T = get_turf(A)
	return T && isStationLevel(T.z)

/proc/isPlayerLevel(level)
	return level in GLOB.maps_data.player_levels

/proc/isOnPlayerLevel(atom/A)
	var/turf/T = get_turf(A)
	return T && isPlayerLevel(T.z)

/proc/isContactLevel(level)
	return level in GLOB.maps_data.player_levels

/proc/isOnContactLevel(atom/A)
	var/turf/T = get_turf(A)
	return T && isContactLevel(T.z)

/proc/isAdminLevel(level)
	return level in GLOB.maps_data.admin_levels

/proc/isNotAdminLevel(level)
	return !isAdminLevel(level)

/proc/isOnAdminLevel(atom/A)
	var/turf/T = get_turf(A)
	return T && isAdminLevel(T.z)

/proc/get_level_name(level)
	return (GLOB.maps_data.names.len >= level && GLOB.maps_data.names[level]) || level

/proc/max_default_z_level()
	return GLOB.maps_data.all_levels.len

/proc/is_on_same_plane_or_station(z1, z2)
	if(z1 == z2)
		return TRUE
	if(isStationLevel(z1) && isStationLevel(z2))
		return TRUE
	return FALSE

ADMIN_VERB_ADD(/client/proc/test_MD, R_DEBUG, null)
/client/proc/test_MD()
	set name = "Check level data"
	set category = "Debug"

	var/turf/T = get_turf(mob)

	to_chat(mob, "<b>We are at [T.z] level.</b>")

	to_chat(mob, "level name is [get_level_name(T.z)]")

	to_chat(mob, "isStationLevel: [isStationLevel(mob.z)]")
	to_chat(mob, "isNotStationLevel: [isNotStationLevel(mob.z)]")
	to_chat(mob, "isOnStationLevel: [isOnStationLevel(mob)]")

	to_chat(mob, "isPlayerLevel: [isPlayerLevel(mob.z)]")
	to_chat(mob, "isOnPlayerLevel: [isOnPlayerLevel(mob)]")

	to_chat(mob, "isAdminLevel: [isAdminLevel(mob.z)]")
	to_chat(mob, "isNotAdminLevel: [isNotAdminLevel(mob.z)]")
	to_chat(mob, "isOnAdminLevel: [isOnAdminLevel(mob)]")

	to_chat(mob, "isAcessableLevel: [GLOB.maps_data.accessable_levels[num2text(mob.z)]]")

	if(GLOB.maps_data.asteroid_levels[num2text(T.z)])
		to_chat(mob, "Asteroid will be generated here")
	else
		to_chat(mob, "This isn't asteroid level")

/datum/maps_data
	var/list/all_levels        = new
	var/list/station_levels    = new // Z-levels the station exists on
	var/list/admin_levels      = new // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/player_levels     = new // Z-levels a character can typically reach
	var/list/contact_levels    = new // Z-levels that can be contacted from the station, for eg announcements
	var/list/sealed_levels	   = new // Z-levels that don't allow random transit at edge
	var/list/asteroid_levels   = new
	var/list/accessable_levels = new
	var/list/empty_levels = null     // Empty Z-levels that may be used for various things
	var/list/names = new
	var/security_state = /decl/security_state/default // The default security state system to use.

	var/list/loadout_blacklist	//list of types of loadout items that will not be pickable

	var/default_spawn = "Aft Cryogenic Storage"

	var/allowed_jobs = list(/datum/job/captain, /datum/job/rd, /datum/job/hop, /datum/job/cmo, /datum/job/chief_engineer, /datum/job/ihc,
						/datum/job/gunserg, /datum/job/inspector, /datum/job/medspec, /datum/job/ihoper,
						/datum/job/doctor, /datum/job/chemist, /datum/job/paramedic, /datum/job/bioengineer,
						/datum/job/technomancer,
						/datum/job/cargo_tech, /datum/job/mining, /datum/job/merchant,
						/datum/job/clubworker, /datum/job/clubmanager, /datum/job/artist,
						/datum/job/chaplain, /datum/job/acolyte, /datum/job/janitor, /datum/job/hydro,
						/datum/job/scientist, /datum/job/roboticist, /datum/job/psychiatrist,
						/datum/job/ai, /datum/job/cyborg,
						/datum/job/assistant

						)

	var/overmap_z
	var/overmap_size = 50 * 4
	var/overmap_event_areas = 40 * 16

	var/emergency_shuttle_docked_message = "The escape pods are now armed. You have approximately %ETD% to board the escape pods."
	var/emergency_shuttle_leaving_dock = "The escape pods have been launched, arriving at rendezvous point in %ETA%."
	var/emergency_shuttle_called_message = "The emergency evacuation procedures are now in effect. Escape pods will be armed in %ETA%"
	var/emergency_shuttle_recall_message = "Emergency evacuation sequence aborted. Return to normal operating conditions."

	var/shuttle_docked_message = "Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETD%."
	var/shuttle_leaving_dock = "Jump initiated, exiting bluespace in %ETA%."
	var/shuttle_called_message = "Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	var/shuttle_recall_message = "Jump sequence aborted, return to normal operating conditions."

	var/list/usable_email_tlds = list("cev_eris.org","eris.scg","eris.net")
	var/path = "eris"

	var/access_modify_region = list(
		ACCESS_REGION_SECURITY = list(access_hos, access_change_ids, access_change_sec),
		ACCESS_REGION_MEDBAY = list(access_cmo, access_change_ids, access_change_medbay),
		ACCESS_REGION_RESEARCH = list(access_rd, access_change_ids, access_change_research),
		ACCESS_REGION_ENGINEERING = list(access_ce, access_change_ids, access_change_engineering),
		ACCESS_REGION_COMMAND = list(access_change_ids),
		ACCESS_REGION_GENERAL = list(access_change_ids,
										access_change_cargo,
										access_change_club,
										access_change_engineering,
										access_change_medbay,
										access_change_nt,
										access_change_research,
										access_change_sec),
		ACCESS_REGION_SUPPLY = list(access_change_ids, access_change_cargo),
		ACCESS_REGION_CHURCH = list(access_nt_preacher, access_change_ids, access_change_nt),
		ACCESS_REGION_CLUB = list(access_change_ids, access_change_club)
	)

	//HOLOMAP
	var/list/holomap_smoosh // List of lists of zlevels to smoosh into single icons
	var/list/holomap_offset_x = list()
	var/list/holomap_offset_y = list()
	var/list/holomap_legend_x = list()
	var/list/holomap_legend_y = list()

/datum/maps_data/proc/character_save_path(slot)
	return "/[path]/character[slot]"

/datum/maps_data/proc/character_load_path(savefile/S, slot)
	var/original_cd = S.cd
	S.cd = "/"
	. = private_use_legacy_saves(S, slot) ? "/character[slot]" : "/[path]/character[slot]"
	S.cd = original_cd // Attempting to make this call as side-effect free as possible

/datum/maps_data/proc/private_use_legacy_saves(savefile/S, slot)
	if(!S.dir.Find(path)) // If we cannot find the map path folder, load the legacy save
		return TRUE
	S.cd = "/[path]" // Finally, if we cannot find the character slot in the map path folder, load the legacy save
	return !S.dir.Find("character[slot]")


/datum/maps_data/proc/registrate(obj/map_data/MD)
	var/level = MD.z_level
	if(level in all_levels)
		WARNING("[level] is already in all_levels list!")
		qdel(MD)
		return

	MD.loc = null
	if(all_levels.len < level)
		all_levels.len = level
		names.len = level
	all_levels[level] = MD
	names[level] = MD.name

	if(MD.is_station_level)
		station_levels += level

	if(MD.is_admin_level)
		admin_levels += level

	if(MD.is_player_level)
		player_levels += level

	if(MD.is_contact_level)
		contact_levels += level

	if(MD.generate_asteroid)
		asteroid_levels += level

	if(MD.is_accessable_level)
		accessable_levels[num2text(level)] = MD.is_accessable_level

	if(MD.is_sealed)
		sealed_levels += level
	//holomaps
	if(MD.holomap_smoosh)
		holomap_smoosh = MD.holomap_smoosh

	if(MD.is_station_level)
		var/max_holo_per_colum_l = MD.height/2 + 0.5
		var/max_holo_per_colum_r = MD.height/2 - 0.5
		var/even_mult = (0.15*level-0.3)*level+0.4
		var/odd_mult = (level-1)/2
		if(ISEVEN(MD.height))
			max_holo_per_colum_l -= 0.5
			max_holo_per_colum_r = max_holo_per_colum_l
			even_mult = (level-1)/2 - 0.5
			odd_mult = level/2 - 0.5
		MD.holomap_legend_x = HOLOMAP_ICON_SIZE - world.maxx - MD.legend_size
		MD.holomap_legend_y = HOLOMAP_ICON_SIZE - world.maxy - MD.legend_size - ERIS_HOLOMAP_CENTER_GUTTER
		if(ISODD(level))
			MD.holomap_offset_x = HOLOMAP_ICON_SIZE - world.maxx - ERIS_HOLOMAP_CENTER_GUTTER - MD.size - MD.legend_size
			if(!odd_mult)
				MD.holomap_offset_y = 0
			else
				MD.holomap_offset_y = ERIS_HOLOMAP_MARGIN_Y(MD.size, max_holo_per_colum_l, 0) + MD.size*odd_mult
		else
			MD.holomap_offset_x = HOLOMAP_ICON_SIZE - world.maxx
			if(!even_mult && max_holo_per_colum_l == max_holo_per_colum_r)
				MD.holomap_offset_y = 0
			else
				MD.holomap_offset_y = ERIS_HOLOMAP_MARGIN_Y(MD.size, max_holo_per_colum_r, 0) + MD.size*even_mult

	// Auto-center the map if needed (Guess based on maxx/maxy)
	if (MD.holomap_offset_x < 0)
		MD.holomap_offset_x = ((HOLOMAP_ICON_SIZE - world.maxx) / 2)
	if (MD.holomap_offset_y < 0)
		MD.holomap_offset_y = ((HOLOMAP_ICON_SIZE - world.maxy) / 2)
	// Assign them to the map lists

	LIST_NUMERIC_SET(holomap_offset_x, level, MD.holomap_offset_x)
	LIST_NUMERIC_SET(holomap_offset_y, level, MD.holomap_offset_y)
	LIST_NUMERIC_SET(holomap_legend_x, level, MD.holomap_legend_x)
	LIST_NUMERIC_SET(holomap_legend_y, level, MD.holomap_legend_y)

/datum/maps_data/proc/get_empty_zlevel()
	if(empty_levels == null)
		world.incrementMaxZ()
		empty_levels = list(world.maxz)

		add_z_level(world.maxz, world.maxz, 1)

	return pick(empty_levels)

/datum/level_data
	var/level = -1
	var/original_level = -1
	var/height = -1

/proc/add_z_level(level, original, height)
	var/datum/level_data/ldata = new
	ldata.level = level
	ldata.original_level = original
	ldata.height = height

	if(level > z_levels.len)
		z_levels.len = level
		z_levels[level] = ldata
	else
		if(z_levels[level] == null)
			z_levels[level] = ldata



/obj/map_data
	name = "Map data"

	icon = 'icons/misc/landmarks.dmi'
	icon_state = "config-green"
	alpha = 255 //This one too important
	invisibility = 101
	layer = POINT_LAYER

	var/is_admin_level   = FALSE // Defines which Z-levels which are for admin functionality, for example including such areas as Central Command and the Syndicate Shuttle
	var/is_station_level = FALSE // Defines Z-levels on which the station exists
	var/is_player_level  = FALSE // Defines Z-levels a character can typically reach
	var/is_contact_level = FALSE // Defines Z-levels which, for example, a Code Red announcement may affect
	var/is_accessable_level = TRUE // Prob modifier for random access (space travelling)
	var/generate_asteroid= FALSE
	var/is_sealed = FALSE //No transit at map edge
	var/custom_z_names = FALSE //Whether a custom name or a simple number would be displayed at GPS beacons
	var/tmp/z_level
	var/height = -1	///< The number of Z-Levels in the map.

	// Holomaps
	var/holomap_offset_x = -1	// Number of pixels to offset the map right (for centering) for this z
	var/holomap_offset_y = -1	// Number of pixels to offset the map up (for centering) for this z
	var/holomap_legend_x = 96	// x position of the holomap legend for this z
	var/holomap_legend_y = 96	// y position of the holomap legend for this z
	var/size = ERIS_MAP_SIZE
	var/legend_size = 32
	var/list/holomap_smoosh

// If the height is more than 1, we mark all contained levels as connected.
/obj/map_data/New(atom/nloc)
	..()
	z_level = nloc.z

	if(height <= 0)
		CRASH("Map data height not set. ([name], [z_level])")

	var/original_name = name
	var/original_level = z_level

	for(var/shift in 1 to height)
		var/z_level_r = original_level + shift - 1
		z_level = z_level_r
		name = "[original_name] stage [shift]"
		GLOB.maps_data.registrate(src)

		add_z_level(z_level_r, original_level, height)

/obj/map_data/proc/custom_z_name(z_level)
	return z_level

/obj/map_data/eris
	name = "Eris"
	is_station_level = TRUE
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE
	custom_z_names = TRUE
	height = 5
	holomap_offset_x = -1	// Number of pixels to offset the map right (for centering) for this z
	holomap_offset_y = -1	// Number of pixels to offset the map up (for centering) for this z
	holomap_legend_x = 200	// x position of the holomap legend for this z
	holomap_legend_y = 200	// y position of the holomap legend for this z
	holomap_smoosh = list(list(1,2,3,4,5))

/obj/map_data/eris/custom_z_name(z_level)
	return "Deck [height - z_level + 1]"

/obj/map_data/admin
	name = "Admin Level"
	is_admin_level = TRUE
	is_accessable_level = FALSE
	height = 1

/obj/map_data/asteroid
	name = "Asteroid Level"
	is_player_level = TRUE
	is_contact_level = TRUE
	generate_asteroid = TRUE
	is_accessable_level = TRUE
	custom_z_names = TRUE
	height = 1

/obj/map_data/asteroid/custom_z_name(z_level)
	return "Asteroid [z_level]"
