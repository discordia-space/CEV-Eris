/proc/get_overlay_connection_type(overlay_direction, list/any_wall_connections)
	var/horizontal_neighbour
	var/vertical_neighbour
	var/diagonal_neighbour
	switch(overlay_direction)
		if(SOUTH) // Bottom left corner
			horizontal_neighbour = any_wall_connections[WEST]
			vertical_neighbour = any_wall_connections[SOUTH]
			diagonal_neighbour = any_wall_connections[SOUTHWEST]
		if(NORTH) // Top left corner
			horizontal_neighbour = any_wall_connections[WEST]
			vertical_neighbour = any_wall_connections[NORTH]
			diagonal_neighbour = any_wall_connections[NORTHWEST]
		if(EAST) // Top right corner
			horizontal_neighbour = any_wall_connections[EAST]
			vertical_neighbour = any_wall_connections[NORTH]
			diagonal_neighbour = any_wall_connections[NORTHEAST]
		if(WEST) // Bottom right corner
			horizontal_neighbour = any_wall_connections[EAST]
			vertical_neighbour = any_wall_connections[SOUTH]
			diagonal_neighbour = any_wall_connections[SOUTHEAST]

	if(horizontal_neighbour)
		if(vertical_neighbour)
			. = diagonal_neighbour ? "full" : "corner"
		else
			. = "horizontal"
	else
		. = vertical_neighbour ? "vertical" : "unconnected"


/turf/wall/update_icon()
	if(flat_icon)
		return
	// We'll be using 4 overlays for each corner instead of an icon_state, which will be empty
	// It is, however, set to a preview image initially, so mappers see a wall instead of a purple square
	icon_state = ""
	cut_overlays()
	var/initial_icon_state = initial(icon_state)
	for(var/overlay_direction in cardinal)
		var/connection_type = get_overlay_connection_type(overlay_direction, any_wall_connections)
		var/overlay_icon_state = "[initial_icon_state]_[connection_type]"
		if((connection_type == "horizontal") && (initial_icon_state == "frontier_wall")) // Snowflake af
			if((overlay_direction == SOUTH) && any_wall_connections[SOUTHWEST])
				overlay_icon_state = "[initial_icon_state]_[connection_type]_right_angle"
			if((overlay_direction == WEST) && any_wall_connections[SOUTHEAST])
				overlay_icon_state = "[initial_icon_state]_[connection_type]_right_angle"

		var/image/image = image(icon, icon_state = overlay_icon_state, dir = overlay_direction)
		add_overlay(image.appearance)

	var/static/list/damage_overlays
	if(!damage_overlays)
		damage_overlays = new
		var/damage_overlay_count = 16
		var/alpha_inc = 256 / damage_overlay_count
		for(var/i = 0; i <= damage_overlay_count; i++)
			var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
			img.blend_mode = BLEND_MULTIPLY
			img.alpha = (i * alpha_inc) - 1
			damage_overlays.Add(img.appearance)

	var/overlay_index = round((1 - health/maxHealth) * LAZYLEN(damage_overlays)) + 1
	if(overlay_index > LAZYLEN(damage_overlays))
		overlay_index = LAZYLEN(damage_overlays)
	overlays += damage_overlays[overlay_index]


/turf/wall/proc/update_connections()
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

/turf/wall/proc/remove_neighbour_connections()
	for(var/direction in alldirs)
		if(any_wall_connections[direction])
			var/turf/wall/wall = get_step(src, direction)
			wall.any_wall_connections[turn(direction, 180)] = FALSE
			wall.full_wall_connections[turn(direction, 180)] = FALSE
			wall.update_icon()
