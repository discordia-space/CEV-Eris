#ifdef ZASDBG
/turf/proc/add_ZAS_debug_overlay(overlay_type, overlay_direction)
	var/static/list/appearance_cache
	if(!appearance_cache)
		appearance_cache = new
		var/image/image
		for(var/overlay_icon_state in list(
			"assigned", // Index 1 (aka ZAS_DEBUG_OVERLAY_ZONE_ASSIGNED) in appearance_cache
			"created", // Index 2 (aka ZAS_DEBUG_OVERLAY_ZONE_CREATED), et cetera
			"merged",
			"invalid",
			"mark",
			"fullblock")) // Index 6
			image = image(icon = 'icons/Testing/Zone.dmi', icon_state = overlay_icon_state)
			appearance_cache.Add(image.appearance)

		for(var/block_direction in list(NORTH, SOUTH, WEST, EAST))
			image = image(icon = 'icons/Testing/Zone.dmi', icon_state = "block", dir = block_direction)
			appearance_cache.Add(image.appearance) // Indexes 7 (NORTH) to 10 (EAST)

	ZAS_debug_overlays = list()
	switch(overlay_direction) // If there is a direction, then type must be "block"
		if(null)
			ZAS_debug_overlays += appearance_cache[overlay_type]
		if(NORTH)
			ZAS_debug_overlays += appearance_cache[7]
		if(SOUTH)
			ZAS_debug_overlays += appearance_cache[8]
		if(WEST)
			ZAS_debug_overlays += appearance_cache[9]
		if(EAST)
			ZAS_debug_overlays += appearance_cache[10]

	update_icon()
#endif
