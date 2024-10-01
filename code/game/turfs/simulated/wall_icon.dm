// Determine which icon state should be used for a corner overlay in a given direction
// Corner overlay can have a maximum of three neigbours: horizontal, vertical, and diagonal
// Diagonal neigbour is only considered when there are both horizontal and vertical neigbours
/proc/get_overlay_connection_type(overlay_direction, list/wall_connections)
	var/horizontal_neighbour
	var/vertical_neighbour
	var/diagonal_neighbour
	switch(overlay_direction)
		if(SOUTH) // Bottom left corner
			horizontal_neighbour = wall_connections[WEST]
			vertical_neighbour = wall_connections[SOUTH]
			diagonal_neighbour = wall_connections[SOUTHWEST]
		if(NORTH) // Top left corner
			horizontal_neighbour = wall_connections[WEST]
			vertical_neighbour = wall_connections[NORTH]
			diagonal_neighbour = wall_connections[NORTHWEST]
		if(EAST) // Top right corner
			horizontal_neighbour = wall_connections[EAST]
			vertical_neighbour = wall_connections[NORTH]
			diagonal_neighbour = wall_connections[NORTHEAST]
		if(WEST) // Bottom right corner
			horizontal_neighbour = wall_connections[EAST]
			vertical_neighbour = wall_connections[SOUTH]
			diagonal_neighbour = wall_connections[SOUTHEAST]

	if(horizontal_neighbour) // We're connected to something to the right or the left
		if(vertical_neighbour) // There is also a wall to the North or to the South from us
			. = diagonal_neighbour ? "full" : "corner" // If surrounded by walls, then connect seamlessly in all directions, instead of creating a visible corner
		else
			. = "horizontal" // Only connect to the right/left neighbour, depending on which corner this is
	else // Same as above, but for top/bottom neighbour
		. = vertical_neighbour ? "vertical" : "unconnected" // If there are no neighbours, then use "unconnected" sprite


// Check in which directions there are connectable walls, so the corner overlays could be created correctly later
/turf/wall/proc/update_connections()
	if(is_using_flat_icon)
		return
	for(var/direction in alldirs)
		var/turf/wall/wall = get_step(src, direction)
		if(istype(wall))
			any_wall_connections[direction] = TRUE
			full_wall_connections[direction] = wall.is_low_wall ? FALSE : TRUE
			// Update neighbour connections as well
			wall.any_wall_connections[turn(direction, 180)] = TRUE
			wall.full_wall_connections[turn(direction, 180)] = is_low_wall ? FALSE : TRUE
			wall.update_icon()
		else
			any_wall_connections[direction] = FALSE
			full_wall_connections[direction] = FALSE


// Reverse of the above. Called when the wall is being deleted, only updates neighbours
// Wall's own connections are irrelevant at this point
/turf/wall/proc/remove_neighbour_connections()
	if(is_using_flat_icon)
		return
	for(var/direction in alldirs)
		if(any_wall_connections[direction])
			var/turf/wall/wall = get_step(src, direction)
			wall.any_wall_connections[turn(direction, 180)] = FALSE
			wall.full_wall_connections[turn(direction, 180)] = FALSE
			wall.update_icon()


// We'll be using 4 overlays for each corner instead of an icon_state, which will be empty
// It is, however, set to a preview image initially, so mappers see a wall instead of a purple square
/turf/wall/update_icon()
	if(is_using_flat_icon) // This is some ancient wall, leave it alone
		return

	icon_state = ""
	cut_overlays()

	var/static/list/appearance_cache
	if(!appearance_cache)
		appearance_cache = list()

	for(var/overlay_direction in cardinal)
		var/connection_type = get_overlay_connection_type(overlay_direction, any_wall_connections)

		// Fancy walls and low wall overlays use a different icon in some cases
		var/right_angle_override = FALSE
		if((wall_style == "fancy") && (connection_type == "horizontal"))
			if((overlay_direction == SOUTH) && any_wall_connections[SOUTHWEST])
				right_angle_override = TRUE
			else if((overlay_direction == WEST) && any_wall_connections[SOUTHEAST])
				right_angle_override = TRUE

		// WALL SPRITE //
		var/sprite_state = "[wall_type]_[connection_type]"
		if(right_angle_override)
			sprite_state = "[wall_type]_[connection_type]_right_angle"

		var/sprite_id = "[ref(icon)]_[sprite_state]_[overlay_direction]"
		if(appearance_cache[sprite_id] != null)
			add_overlay(appearance_cache[sprite_id])
		else
			var/image/image = image(icon, icon_state = sprite_state, dir = overlay_direction)
			appearance_cache[sprite_id] = image.appearance
			add_overlay(appearance_cache[sprite_id])

		// WINDOW SPRITE //
		if(window_type) // Glass on top of the low wall, if any
			sprite_state = "[window_type]_[connection_type]"
			sprite_id = "[ref(icon)]_[sprite_state]_[overlay_direction]"
			if(appearance_cache[sprite_id] != null)
				add_overlay(appearance_cache[sprite_id])
			else
				var/image/image = image(icon, icon_state = sprite_state, dir = overlay_direction, layer = ABOVE_OBJ_LAYER)
				image.alpha = window_alpha
				appearance_cache[sprite_id] = image.appearance
				add_overlay(appearance_cache[sprite_id])

		// LOW WALL OVERLAY //
		if(is_low_wall)
			sprite_state = "[wall_type]_over_[connection_type]"
			var/add_extra_overlay
			if(wall_style == "fancy") // Fancy overlays that are always present
				add_extra_overlay = TRUE
				if(right_angle_override) // Use an alternative sprite when connecting to a corner
					sprite_state = "[wall_type]_over_[connection_type]_right_angle"

			else if(wall_style == "default") // Minimalistic overlays that connect regular and low walls
				var/full_wall_connection_type = get_overlay_connection_type(overlay_direction, full_wall_connections)
				if(full_wall_connection_type == connection_type)
					add_extra_overlay = TRUE
					sprite_state = "[wall_type]_over_[full_wall_connection_type]"

			if(add_extra_overlay)
				sprite_id = "[ref(icon)]_[sprite_state]_[overlay_direction]"
				if(appearance_cache[sprite_id] != null)
					add_overlay(appearance_cache[sprite_id])
				else
					var/image/image = image(icon, icon_state = sprite_state, dir = overlay_direction, layer = ABOVE_WINDOW_LAYER)
					appearance_cache[sprite_id] = image.appearance
					add_overlay(appearance_cache[sprite_id])

	// DAMAGE OVERLAY //
	if(!is_low_wall)
		var/static/list/damage_overlays
		if(!damage_overlays)
			damage_overlays = new
			var/damage_overlay_count = 16
			var/alpha_inc = 256 / damage_overlay_count
			for(var/i = 0; i <= damage_overlay_count; i++)
				var/image/image = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
				image.blend_mode = BLEND_MULTIPLY
				image.alpha = (i * alpha_inc) - 1
				damage_overlays.Add(image.appearance)

		var/damage_overlay_index = round((1 - health / max_health) * LAZYLEN(damage_overlays)) + 1
		if(damage_overlay_index > LAZYLEN(damage_overlays))
			damage_overlay_index = LAZYLEN(damage_overlays)
		overlays += damage_overlays[damage_overlay_index]

	// DISASSEMBLY OVERLAY //
	if(!isnull(deconstruction_steps_left))
		var/deconstruction_steps_total = is_reinforced ? 5 : 1
		if(deconstruction_steps_left < deconstruction_steps_total) // Wall is partially taken apart
			var/static/construction_overlay_placeholder
			if(!construction_overlay_placeholder)
				var/image/image = image('icons/turf/wall_masks.dmi', "reinf_construct-3")
				construction_overlay_placeholder = image.appearance
			overlays += construction_overlay_placeholder

	#ifdef ZASDBG
	for(var/ZAS_overlay in ZAS_debug_overlays)
		overlays += ZAS_overlay
	#endif
