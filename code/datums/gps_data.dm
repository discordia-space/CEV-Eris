GLOBAL_LIST_EMPTY(gps_trackers)
GLOBAL_LIST_EMPTY(gps_trackers_by_serial)

/datum/gps_data
	var/prefix
	var/serial_number
	var/atom/holder

/datum/gps_data/New(source, prefix="COM")
	. = ..()
	holder = source
	src.prefix = prefix
	serial_number = "[prefix]-[random_id("gps_id",1000,9999)]"
	GLOB.gps_trackers += src
	GLOB.gps_trackers_by_serial[serial_number] = src

/datum/gps_data/Destroy()
	GLOB.gps_trackers -= src
	GLOB.gps_trackers_by_serial -= serial_number
	return ..()

/datum/gps_data/proc/change_serial(new_serial)
	if(!istext(new_serial))
		return FALSE

	if(GLOB.gps_trackers_by_serial[new_serial])
		return FALSE

	GLOB.gps_trackers_by_serial -= serial_number
	serial_number = new_serial
	prefix = copytext_char(serial_number, 1, 4)
	GLOB.gps_trackers_by_serial[serial_number] = src
	return TRUE

/datum/gps_data/proc/get_coords()
	var/turf/T = get_turf(holder)
	if (!T)
		return null
	return new /datum/coords(T)

/datum/gps_data/proc/get_direction(var/atom/source = holder, var/atom/target)
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

	return GLOB.gps_trackers_by_serial[serial]
