/obj/map_data/multiz
	icon_state = "config-green"
	alpha = 255 //This one too important
	invisibility = 101

	var/height = -1     ///< The number of Z-Levels in the map.

// If the height is more than 1, we mark all contained levels as connected.
/obj/map_data/multiz/New()
	ASSERT(height > 1)
	// Due to the offsets of how connections are stored v.s. how z-levels are indexed, some magic number silliness happened.

	var/original_name = name
	var/original_level = z

	for(var/shift in 0 to height-1)
		z_level = original_level + shift
		name = "[original_name] stage [shift + 1]"
		maps_data.registrate(src)
		z_levels |= (1 << (z_level-1))

/obj/map_data/multiz/station
	name = "ERIS"
	is_station_level = TRUE
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE

