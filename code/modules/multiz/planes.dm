#define PLANES_PER_Z_LEVEL 32

/atom/proc/init_plane()	//Set initial original plane
	if(!original_plane)
		original_plane = plane

/atom/proc/set_plane(var/new_plane)	//Changes plane
	original_plane = new_plane
	update_plane()

/proc/calculate_plane(current_z, original_plane)
	if(current_z <= 0 || world.maxz < current_z)
		return

	var/list/decoded_json = SSmapping.z_level_info_decoded[current_z]
	var/lowest_connected_z = decoded_json["bottom_z"]

	var/z_diff = current_z - lowest_connected_z + 1
	var/plane1 = z_diff * PLANES_PER_Z_LEVEL
	var/plane2 = plane1 + original_plane

	return min(32767, plane2)

/atom/proc/update_plane()	//Updates plane using local z-coordinate
	if(z > 0)
		plane = calculate_plane(z,original_plane)
	else
		plane = ABOVE_HUD_PLANE

/atom/proc/get_relative_plane(var/plane)
	return calculate_plane(z,plane)
