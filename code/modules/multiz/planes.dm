#define PLANES_PER_Z_LEVEL 32

/atom
	var/original_plane = null

/atom/proc/init_plane()	//Set initial original plane
	if(!original_plane)
		original_plane = plane

/atom/proc/set_plane(var/new_plane)	//Changes plane
	original_plane = new_plane
	update_plane()

/proc/calculate_plane(var/z,var/original_plane)
	if(z <= 0 || z_levels.len < z)
		return

	var/datum/level_data/LD = z_levels[z]

	if(LD != null)
		return min(32767,((z-LD.original_level)*PLANES_PER_Z_LEVEL) + original_plane)

/atom/proc/update_plane()	//Updates plane using local z-coordinate
	if(atomFlags & AF_PLANE_UPDATE_HANDLED)
		return
	if(z > 0)
		plane = calculate_plane(z,original_plane)
	else
		plane = ABOVE_HUD_PLANE

/atom/proc/get_relative_plane(var/plane)
	return calculate_plane(z,plane)
