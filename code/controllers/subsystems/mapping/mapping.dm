#define DEFAULT_MAP_CONFIG_PATH ""
#define PULSAR_SIZE 20

SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/next_map_name

	// Keeping track of maps that were or currently are loading
	var/currently_loading_map
	var/list/map_loading_queue = list()
	var/list/loaded_map_names = list()
	// For maps that were queued for loading, but failed to actually load due to some technical issue
	var/list/failed_map_names = list()


	// Stores area references
	var/list/all_areas = list() // Literally every area that was instantiated
	var/list/main_ship_areas = list() // Only areas on the main map Z-levels, mostly used to get locations for events

	// Like above, but stores key-value pairs of area names and area references
	var/list/all_areas_by_name = list()
	var/list/main_ship_areas_by_name = list()

	// Lists of numbers corresponding to certain Z-levels
	var/list/playable_z_levels = list() // Places where players are typically allowed to be in; everything excluduing overmap, pulsar, and admin level
	var/list/main_ship_z_levels = list() // Decks of CEV Eris, deep maintenance not included
	var/list/sealed_z_levels = list() // Levels that do NOT allow transit at map edge, e.g. not located in space or otherwise restricted

	var/list/z_level_info_decoded = list() // Contains associative lists with that are configs of individual Z-levels

	var/security_state = /decl/security_state/default // The default security state system to use.

	var/default_spawn = "Aft Cryogenic Storage"


	var/overmap_z

	var/emergency_shuttle_docked_message = "The escape pods are now armed. You have approximately %ETD% to board the escape pods."
	var/emergency_shuttle_leaving_dock = "The escape pods have been launched, arriving at rendezvous point in %ETA%."
	var/emergency_shuttle_called_message = "The emergency evacuation procedures are now in effect. Escape pods will be armed in %ETA%"
	var/emergency_shuttle_recall_message = "Emergency evacuation sequence aborted. Return to normal operating conditions."

	var/shuttle_docked_message = "Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETD%."
	var/shuttle_leaving_dock = "Jump initiated, exiting bluespace in %ETA%."
	var/shuttle_called_message = "Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	var/shuttle_recall_message = "Jump sequence aborted, return to normal operating conditions."

	var/list/usable_email_tlds = list("cev_eris.hanza","eris.scg","eris.net")
	var/path = "eris"

	// Moved here from a deprecated datum along with code related to mapping
	// Gonna be removed later
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

	var/static/regex/dmmRegex = new/regex({""(\[a-zA-Z]+)" = \\(((?:.|\n)*?)\\)\n(?!\t)|\\((\\d+),(\\d+),(\\d+)\\) = \\{"(\[a-zA-Z\n]*)"\\}"}, "g")
	var/static/regex/trimQuotesRegex = new/regex({"^\[\\s\n]+"?|"?\[\\s\n]+$|^"|"$"}, "g")
	var/static/regex/trimRegex = new/regex("^\[\\s\n]+|\[\\s\n]+$", "g")
	var/static/list/modelCache = list()
	var/static/space_key
	#ifdef TESTING
	var/static/turfsSkipped
	#endif

	// Holds pixel offset lists formatted as "Z-level number as text" = list(pixel_x, pixel_y)
	// these point to the bottom left corner of appropriate Z-level's map on /image/holomap
	// So displaying an object on the holomap is as simple as adding an /image that represents it to
	// holomap.overlays, pixel-shifting it with offsets from this list plus object's local XY coordinates
	// ..that said, account for pixel_x and pixel_y pointing to /image's bottom left corner
	var/list/holomap_offsets_per_z_level = list()
	var/image/holomap

	var/list/allowed_jobs = list() // Job name = job slots as number

	var/cave_ore_count = 0


/datum/controller/subsystem/mapping/Initialize(start_timeofday)
	var/primary_map_to_load

	if(fexists("config/next_map.txt"))
		primary_map_to_load = file2text("config/next_map.txt")

	if(!istext(primary_map_to_load) || !LAZYLEN(primary_map_to_load))
		primary_map_to_load = "eris_classic"

	queue_map_loading(primary_map_to_load)
	generate_holomaps()

	queue_map_loading("technical_level")
	queue_map_loading("overmap")
	queue_map_loading("transit")
	queue_map_loading("asteroid")

	return ..()


/datum/controller/subsystem/mapping/proc/MaxZChanged(z_level_info) // Expecting JSON-formatted text string or null
	if(!z_level_info)
		z_level_info = file('maps/json/default.json')
		z_level_info = file2text(z_level_info)
		z_level_info = json_decode(z_level_info)

	var/current_z = world.maxz
	// Build a list of connected Z-levels, if any
	z_level_info["connected_z"] = list(current_z)
	z_level_info["bottom_z"] = current_z
	if(z_level_info["map_size_z"] > 1)
		var/num_of_connected_levels = z_level_info["map_size_z"] - 1
		for(var/downward_offset in 1 to num_of_connected_levels)
			var/z_level_to_check = current_z - downward_offset
			if(z_level_to_check < 1)
				break
			var/list/below_z_json = z_level_info_decoded[z_level_to_check]
			var/list/below_z_connections = below_z_json["connected_z"]
			if(current_z in below_z_connections)
				num_of_connected_levels--
				z_level_info["bottom_z"] = z_level_to_check
				z_level_info["connected_z"] += z_level_to_check
			else
				break

		for(var/upward_offset in 1 to num_of_connected_levels)
			var/z_level_to_check = current_z + upward_offset
			num_of_connected_levels--
			z_level_info["connected_z"] += z_level_to_check

	z_level_info_decoded.Add(list(z_level_info))

	if(z_level_info["is_main_ship_level"])
		main_ship_z_levels += current_z

	if(z_level_info["is_playable_level"])
		playable_z_levels += current_z

	if(z_level_info["is_sealed_level"])
		sealed_z_levels += current_z

	if(z_level_info["add_jobs"] && LAZYLEN(z_level_info["add_jobs"]))
		var/list/job_list = z_level_info["add_jobs"]
		for(var/list/job as anything in job_list)
			var/job_name = job[1]
			var/job_count = job[job_name]
			allowed_jobs[job_name] = job_count


/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT


/datum/controller/subsystem/mapping/proc/set_next_map_to(map_path, map_name)
	if(fexists("config/next_map.txt"))
		fdel("config/next_map.txt")

	next_map_name = map_name
	LIBCALL(RUST_G, "file_write")("[map_path]", "config/next_map.txt")


// Moved two following procs from /datum/maps_data as-is just to be safe
/datum/controller/subsystem/mapping/proc/character_load_path(savefile/S, slot)
	var/original_cd = S.cd
	S.cd = "/"
	. = private_use_legacy_saves(S, slot) ? "/character[slot]" : "/eris/character[slot]"
	S.cd = original_cd // Attempting to make this call as side-effect free as possible

/datum/controller/subsystem/mapping/proc/private_use_legacy_saves(savefile/S, slot)
	if(!S.dir.Find(path)) // If we cannot find the map path folder, load the legacy save
		return TRUE
	S.cd = "/eris" // Finally, if we cannot find the character slot in the map path folder, load the legacy save
	return !S.dir.Find("character[slot]")



/datum/controller/subsystem/mapping/proc/HasAbove(z_level_of_origin)
	if(z_level_of_origin < 1) // Objects at 0,0,0 occasionally call this proc too
		return FALSE

	var/z_level_to_check = z_level_of_origin + 1
	// if(z_level_to_check >= world.maxz) // It's the highest level, nothing can be above it
	// 	return FALSE

	var/list/above_z_json = z_level_info_decoded[z_level_of_origin]
	var/list/above_z_connections = above_z_json["connected_z"]
	if(z_level_to_check in above_z_connections)
		return TRUE
	return FALSE


/datum/controller/subsystem/mapping/proc/HasBelow(z_level_of_origin)
	if(z_level_of_origin < 2)
		return FALSE

	var/z_level_to_check = z_level_of_origin - 1
	var/list/below_z_json = z_level_info_decoded[z_level_of_origin]
	var/list/below_z_connections = below_z_json["connected_z"]
	if(z_level_to_check in below_z_connections)
		return TRUE
	return FALSE


/datum/controller/subsystem/mapping/proc/GetAbove(atom/atom)
	return HasAbove(atom.z) ? get_step(atom, UP) : null


/datum/controller/subsystem/mapping/proc/GetBelow(atom/atom)
	return HasBelow(atom.z) ? get_step(atom, DOWN) : null


/datum/controller/subsystem/mapping/proc/GetConnectedZlevels(z_level_to_check)
	if(z_level_to_check < 1)
		return
	var/list/decoded_json = z_level_info_decoded[z_level_to_check]
	return decoded_json["connected_z"]


/datum/controller/subsystem/mapping/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if(dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)

/datum/controller/subsystem/mapping/proc/AreConnectedZLevels(zA, zB)
	return zA == zB || (zB in GetConnectedZlevels(zA))


// Readable return messages could be useful for manual proc calls
#define MAP_STATUS_READY "Map is fully loaded."
#define MAP_STATUS_LOADING_NOW "Map is currently loading..."
#define MAP_STATUS_LOADING_QUEUED "Map is queued for loading."
#define MAP_STATUS_ADDED_TO_QUEUE "Map is scheduled to load soon."
#define MAP_STATUS_FAILED_TO_LOAD "Map is failed to load, files for requested name are missing."
#define MAP_STATUS_NOT_WANTED_YET "Map with this name was not requested yet."

/datum/controller/subsystem/mapping/proc/check_map_status(map_name, load_if_not_present, delayed_loading)
	if(!map_name || !istext(map_name))
		return "ERROR: No map name given as first argument."

	if(map_name in loaded_map_names)
		return MAP_STATUS_READY

	if(map_name == currently_loading_map)
		return MAP_STATUS_LOADING_NOW

	if(map_name in map_loading_queue)
		return MAP_STATUS_LOADING_QUEUED

	if(map_name in failed_map_names)
		return MAP_STATUS_FAILED_TO_LOAD

	if(load_if_not_present)
		queue_map_loading(map_name, delayed_loading)
		return MAP_STATUS_ADDED_TO_QUEUE
	else
		return MAP_STATUS_NOT_WANTED_YET
