GLOBAL_LIST_EMPTY(gps_trackers)
/datum/gps_data
	var/serialNumber
	var/atom/holder

/datum/gps_data/New(var/source)
	.=..()
	holder = source
	serialNumber = random_id("gps_id",10000,99999)
	GLOB.gps_trackers += src

/datum/gps_data/Destroy()
	.=..()
	GLOB.gps_trackers -= src

/datum/gps_data/proc/get_coords()
	var/turf/T = get_turf(holder)
	if (!T)
		return FALSE
	return new /datum/coords(T)

/datum/gps_data/proc/get_direction(var/atom/source = holder, var/atom/target)
	if (!target)
		return FALSE
	return get_dir(source,target)

/datum/gps_data/proc/get_distance(var/atom/source = holder, var/atom/target)
	if (!target)
		return FALSE
	return get_dist(source,target)

/datum/gps_data/proc/get_z_level_diff(var/atom/source = holder, var/atom/target)
	if (!target)
		return FALSE
	var/turf/source_loc = get_turf(source)
	var/turf/target_loc = get_turf(target)
	return source_loc.z - target_loc.z

/proc/get_gps_data_by_serial(var/serial)
	for(var/datum/gps_data/gps in GLOB.gps_trackers)
		if(gps.serialNumber == serial)
			return serial
	return FALSE