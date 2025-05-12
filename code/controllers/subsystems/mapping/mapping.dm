#define DEFAULT_MAP_CONFIG_PATH ""

SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/map_templates = list()
	var/list/teleportlocs = list()
	var/list/ghostteleportlocs = list()

	var/next_map_name

	var/currently_loading_map
	var/list/map_loading_queue = list()
	var/list/loaded_map_names = list() // Keep track of submaps that were or currently are loading

	var/list/all_areas = list()
	var/list/main_ship_areas = list()

	// Lists of numbers corresponding to certain Z-levels
	var/list/playable_z_levels = list() // Places where players are typically allowed to be in; everything excluduing overmap, pulsar, and admin level
	var/list/main_ship_z_levels = list() // Decks of CEV Eris, deep maintenance not included
	var/list/sealed_z_levels = list() // Levels that do NOT allow transit at map edge, e.g. not located in space or otherwise restricted

	var/list/z_level_info_decoded = list() // Contains associative lists with that are configs of individual Z-levels

	var/security_state = /decl/security_state/default // The default security state system to use.

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
	var/pulsar_z
	var/pulsar_size = 20  //Should be an even number, to place the pulsar in the middle
	var/obj/effect/pulsar/pulsar_star

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

	//HOLOMAP
	var/list/holomap_smoosh // List of lists of zlevels to smoosh into single icons
	var/list/holomap_offset_x = list()
	var/list/holomap_offset_y = list()
	var/list/holomap_legend_x = list()
	var/list/holomap_legend_y = list()

	var/static/regex/dmmRegex = new/regex({""(\[a-zA-Z]+)" = \\(((?:.|\n)*?)\\)\n(?!\t)|\\((\\d+),(\\d+),(\\d+)\\) = \\{"(\[a-zA-Z\n]*)"\\}"}, "g")
	var/static/regex/trimQuotesRegex = new/regex({"^\[\\s\n]+"?|"?\[\\s\n]+$|^"|"$"}, "g")
	var/static/regex/trimRegex = new/regex("^\[\\s\n]+|\[\\s\n]+$", "g")
	var/static/list/modelCache = list()
	var/static/space_key
	#ifdef TESTING
	var/static/turfsSkipped
	#endif


/datum/controller/subsystem/mapping/Initialize(start_timeofday)
	var/primary_map_to_load

	if(fexists("config/next_map.txt"))
		primary_map_to_load = file2text("config/next_map.txt")

	if(!istext(primary_map_to_load) || !LAZYLEN(primary_map_to_load))
		primary_map_to_load = "eris_classic"


// Queue main map and proc into implementing other config stuff
// If pulsar is in the config - queue it as well

// queue_map_loading("pulsar")
// build_pulsar()


	queue_map_loading(primary_map_to_load)
	queue_map_loading("technical_level")
	// queue_map_loading("junk_field")

	// queue_map_loading("deepmaint")
	queue_map_loading("asteroid")


	if(!SSmapping.overmap_z)
		build_overmap()
	else
		testing("Overmap already exist in SSmapping for [SSmapping.overmap_z].")

	// load_map_templates()

	// Generate cache of all areas in world. This cache allows world areas to be looked up on a list instead of being searched for EACH time
	for(var/area/A in world)
		GLOB.map_areas += A

	// Do the same for teleport locs
	for(var/area/AR in GLOB.map_areas)
		if(istype(AR, /area/shuttle) ||  istype(AR, /area/wizard_station)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick_area_turf(AR.type, list(/proc/is_station_turf))
		if (picked)
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	teleportlocs = sortAssoc(teleportlocs)


	for(var/area/AR in GLOB.map_areas)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/turret_protected/aisat) || istype(AR, /area/derelict) || istype(AR, /area/shuttle/specops/centcom))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick_area_turf(AR.type, list(/proc/is_station_turf))
		if (picked)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	ghostteleportlocs = sortAssoc(ghostteleportlocs)

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
	if(z_level_info["map_size"] > 1)
		var/num_of_connected_levels = z_level_info["map_size"] - 1
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

	// if(z_level_info["call_proc_on_load"])
	// 	return




/*

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

*/

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT


/datum/controller/subsystem/mapping/proc/set_next_map_to(map_path, map_name)
	if(fexists("config/next_map.txt"))
		fdel("config/next_map.txt")

	next_map_name = map_name
	LIBCALL(RUST_G, "file_write")("[map_path]", "config/next_map.txt")



/datum/controller/subsystem/mapping/proc/load_map_templates()
	for(var/T in subtypesof(/datum/map_template))
		var/datum/map_template/template = T
		if(!(initial(template.mappath))) // If it's missing the actual path its probably a base type or being used for inheritence.
			continue
		template = new T()
		map_templates[template.name] = template
	return TRUE


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
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)

/datum/controller/subsystem/mapping/proc/AreConnectedZLevels(zA, zB)
	return zA == zB || (zB in GetConnectedZlevels(zA))
