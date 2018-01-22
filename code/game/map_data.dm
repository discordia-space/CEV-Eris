var/datum/maps_data/maps_data = new

/proc/isStationLevel(var/level)
	return level in maps_data.station_levels

/proc/isNotStationLevel(var/level)
	return !isStationLevel(level)

/proc/isOnStationLevel(var/atom/A)
	var/turf/T = get_turf(A)
	return T && isStationLevel(T.z)

/proc/isPlayerLevel(var/level)
	return level in maps_data.player_levels

/proc/isOnPlayerLevel(var/atom/A)
	var/turf/T = get_turf(A)
	return T && isPlayerLevel(T.z)

/proc/isContactLevel(var/level)
	return level in maps_data.player_levels

/proc/isOnContactLevel(var/atom/A)
	var/turf/T = get_turf(A)
	return T && isContactLevel(T.z)

/proc/isAdminLevel(var/level)
	return level in maps_data.admin_levels

/proc/isNotAdminLevel(var/level)
	return !isAdminLevel(level)

/proc/isOnAdminLevel(var/atom/A)
	var/turf/T = get_turf(A)
	return T && isAdminLevel(T.z)

/proc/get_level_name(var/level)
	return (maps_data.names.len >= level && maps_data.names[level]) || level

/proc/max_default_z_level()
	return maps_data.all_levels.len

/proc/is_on_same_plane_or_station(var/z1, var/z2)
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

	mob << "<b>We are at [T.z] level.</b>"

	mob << "level name is [get_level_name(T.z)]"

	mob << "isStationLevel: [isStationLevel(mob.z)]"
	mob << "isNotStationLevel: [isNotStationLevel(mob.z)]"
	mob << "isOnStationLevel: [isOnStationLevel(mob)]"

	mob << "isPlayerLevel: [isPlayerLevel(mob.z)]"
	mob << "isOnPlayerLevel: [isOnPlayerLevel(mob)]"

	mob << "isAdminLevel: [isAdminLevel(mob.z)]"
	mob << "isNotAdminLevel: [isNotAdminLevel(mob.z)]"
	mob << "isOnAdminLevel: [isOnAdminLevel(mob)]"

	mob << "isAcessableLevel: [maps_data.accessable_levels[num2text(mob.z)]]"

	if(maps_data.asteroid_leves[num2text(T.z)])
		mob << "Asteroid will be generated here"
	else
		mob << "This isn't asteroid level"

/datum/maps_data
	var/list/all_levels        = new
	var/list/station_levels    = new
	var/list/admin_levels      = new
	var/list/player_levels     = new
	var/list/contact_levels    = new
	var/list/asteroid_leves    = new
	var/list/accessable_levels = new
	var/list/names = new

/datum/maps_data/proc/registrate(var/obj/map_data/MD)
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
		asteroid_leves += level

	if(MD.is_accessable_level)
		accessable_levels[num2text(level)] = MD.is_accessable_level


/obj/map_data
	name = "Map data"
	var/is_admin_level   = FALSE // Defines which Z-levels which are for admin functionality, for example including such areas as Central Command and the Syndicate Shuttle
	var/is_station_level = FALSE // Defines Z-levels on which the station exists
	var/is_player_level  = FALSE // Defines Z-levels a character can typically reach
	var/is_contact_level = FALSE // Defines Z-levels which, for example, a Code Red announcement may affect
	var/is_accessable_level = TRUE // Prob modifier for random access (space travelling)
	var/generate_asteroid= FALSE
	var/tmp/z_level

/obj/map_data/station
	name = "Station Level"
	is_station_level = TRUE
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE

/obj/map_data/admin
	name = "Admin Level"
	is_admin_level = TRUE
	is_accessable_level = FALSE

/obj/map_data/asteroid
	name = "Asteroid Level"
	is_player_level = TRUE
	is_contact_level = TRUE
	generate_asteroid = TRUE
	is_accessable_level = TRUE

/obj/map_data/New()
	..()
	z_level = z
	maps_data.registrate(src)

