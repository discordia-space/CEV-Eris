GLOBAL_LIST_EMPTY(gps_trackers)
GLOBAL_LIST_EMPTY(gps_trackers_by_serial)

/datum/gps_data
	var/prefix = "COM"
	var/serial_number
	var/atom/holder

/datum/gps_data/New(source, new_prefix)
	. = ..()
	if(new_prefix)
		prefix = new_prefix

	holder = source
	serial_number = "69prefix69-69random_id("gps_id",1000,9999)69"
	GLOB.gps_trackers += src
	GLOB.gps_trackers_by_serial69serial_number69 = src

/datum/gps_data/Destroy()
	GLOB.gps_trackers -= src
	GLOB.gps_trackers_by_serial -= serial_number
	return ..()

/datum/gps_data/proc/change_serial(new_serial)
	if(!istext(new_serial))
		return FALSE

	if(GLOB.gps_trackers_by_serial69new_serial69)
		return FALSE

	GLOB.gps_trackers_by_serial -= serial_number
	serial_number = new_serial
	prefix = copytext_char(serial_number, 1, 4)
	GLOB.gps_trackers_by_serial69serial_number69 = src
	return TRUE

// You can override this in subtypes to69ake it check holder cell charge or something like that
/datum/gps_data/proc/is_functioning()
	return TRUE

/datum/gps_data/proc/get_coords()
	if(!is_functioning())
		return null

	var/turf/T = get_turf(holder)
	if (!T)
		return null
	return new /datum/coords(T)

/datum/gps_data/proc/get_coordinates_text(default="")
	var/datum/coords/C = get_coords()
	return C ? C.get_text() : default

/datum/gps_data/proc/get_direction(atom/source = holder, atom/target)
	if (!target)
		return FALSE
	return get_dir(source,target)

/datum/gps_data/proc/get_distance(atom/source = holder, atom/target)
	if (!target)
		return FALSE
	return get_dist(source,target)

/datum/gps_data/proc/get_z_level_diff(atom/source = holder, atom/target)
	if (!target)
		return FALSE
	var/turf/source_loc = get_turf(source)
	var/turf/target_loc = get_turf(target)
	return source_loc.z - target_loc.z

/proc/get_gps_data_by_serial(serial)
	if(!istext(serial))
		return null

	return GLOB.gps_trackers_by_serial69serial69
