/obj/map_data/multiz
	icon = 'icons/misc/landmarks.dmi'
	icon_state = "config-green"
	alpha = 255 //This one too important
	invisibility = 101
	layer = POINT_LAYER

// If the height is more than 1, we mark all contained levels as connected.
/obj/map_data/New(var/atom/nloc)
	..()
	z_level = nloc.z
	maps_data.registrate(src)

	var/original_name = name
	var/original_level = z_level

	for(var/shift in 1 to height)
		var/z_level_r = original_level + shift - 1
		name = "[original_name] stage [shift]"
		maps_data.registrate(src)

		add_z_level(z_level_r, original_level, height)


/obj/map_data/multiz/station
	name = "ERIS"
	is_station_level = TRUE
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE



/datum/level_data
	var/level = -1
	var/original_level = -1
	var/height = -1

/proc/add_z_level(var/level, var/original, var/height)
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

