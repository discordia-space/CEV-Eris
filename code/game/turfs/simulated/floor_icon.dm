var/list/flooring_cache = list()

/turf/var/icon_updates_count = 0

/turf/simulated/floor/verb/debug_update()
	set src in view()
	set name = "Debugupdate"
	update_icon(TRUE, TRUE)

/turf/simulated/floor/update_icon(var/update_neighbors, var/debug = FALSE)
	icon_updates_count++
	var/has_smooth = 0 //This is just the has_border bitfield inverted for easier logic
	if(lava) //Wtf why
		return

	if(flooring)
		// Set initial icon and strings.
		name = flooring.name
		desc = flooring.desc
		icon = flooring.icon
		if(!isnull(set_update_icon) && istext(set_update_icon))
			icon_state = set_update_icon
		else if(flooring_override)
			icon_state = flooring_override
		else
			if(overrided_icon_state)
				icon_state = overrided_icon_state
				flooring_override = icon_state
			else
				icon_state = flooring.icon_base


		// Apply edges, corners, and inner corners.
		overlays.Cut()
		var/has_border = 0
		if (!flooring.smooth_nothing)
		//Check if we're actually going to do anything first
			if (isnull(set_update_icon))

				//Check the cardinal turfs
				for(var/step_dir in cardinal)
					var/turf/simulated/floor/T = get_step(src, step_dir)

					var/is_linked = test_link(T)




					//Alright we've figured out whether or not we smooth with this turf
					if (!is_linked)
						has_border |= step_dir

						//Now, if we don't, then lets add a border
						if ((flooring.flags & TURF_EDGES_EXTERNAL))
							var/odir = turn(step_dir, 180)
							var/image/I = get_flooring_overlay("[flooring.icon_base]-ext-edge-[odir]", "[flooring.icon_base]_edges", odir, TRUE)
							overlays |= I
						else
							overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[step_dir]", "[flooring.icon_base]_edges", step_dir)

				//By doing &15 we only take the first four bits, which represent NORTH, SOUTH, EAST, WEST
				has_smooth = ~(has_border & 15)


			//We can only have inner corners if we're smoothed with something
			if (has_smooth)
				if(flooring.flags & TURF_HAS_INNER_CORNERS)

					//Quick way to check if we're smoothed with both north and east
					if((has_smooth & NORTHEAST) == NORTHEAST)
						//If we are, then check the diagonal tile
						if (!test_link(get_step(src, NORTHEAST), debug))
							//If we smooth with north and east, but don't smooth with the northeast diagonal, then we have an inner corner!
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[NORTHEAST]", "[flooring.icon_base]_corners", NORTHEAST)

					if((has_smooth & NORTHWEST) == NORTHWEST)
						if (!test_link(get_step(src, NORTHWEST), debug))
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[NORTHWEST]", "[flooring.icon_base]_corners", NORTHWEST)

					if((has_smooth & SOUTHEAST) == SOUTHEAST)
						if (!test_link(get_step(src, SOUTHEAST), debug))
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHEAST]", "[flooring.icon_base]_corners", SOUTHEAST)

					if((has_smooth & SOUTHWEST) == SOUTHWEST)
						if (!test_link(get_step(src, SOUTHWEST), debug))
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHWEST]", "[flooring.icon_base]_corners", SOUTHWEST)



			//Next up, outer corners
			if (has_border)
				if(flooring.flags & TURF_HAS_CORNERS)
					if((has_border & NORTHEAST) == NORTHEAST)
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[NORTHEAST]", "[flooring.icon_base]_edges", NORTHEAST)
					if((has_border & NORTHWEST) == NORTHWEST)
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[NORTHWEST]", "[flooring.icon_base]_edges", NORTHWEST)
					if((has_border & SOUTHEAST) == SOUTHEAST)
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHEAST]", "[flooring.icon_base]_edges", SOUTHEAST)
					if((has_border & SOUTHWEST) == SOUTHWEST)
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHWEST]", "[flooring.icon_base]_edges", SOUTHWEST)


			//Now lets handle those fancy floors which have many centre icons
			if(flooring.has_base_range)
				if (!has_border)
					//Random icons are only for centre turfs, so we need it to not have borders
					icon_state = "[flooring.icon_base][rand(0,flooring.has_base_range)]"
					flooring_override = icon_state
				else
					icon_state = flooring.icon_base+"0"



	if(decals && decals.len)
		overlays |= decals

	if(broken || burnt)
		if(!isnull(broken))
			if(flooring.has_damage_range)
				overlays |= get_flooring_overlay("[flooring.icon_base]-broken-[broken]", "broken[broken]")
			else
				var/n = rand(1,3)
				overlays |= get_damage_overlay("damaged[n]", "damaged[n]")

		if(!isnull(burnt))
			if(flooring.has_burn_range)
				overlays |= get_flooring_overlay("[flooring.icon_base]-burned-[burnt]", "burned[burnt]")
			else
				var/n = rand(1,3)
				overlays |= get_damage_overlay("scorched[n]", "scorched[n]")

	if(update_neighbors)
		for(var/turf/simulated/floor/F in trange(1, src))
			if(F == src)
				continue
			F.update_icon()
	update_openspace()

//Tests whether this floor/ing will smooth with the specified turf
/turf/simulated/floor/proc/test_link(var/turf/T, var/debug = FALSE)
	//is_wall is true for wall turfs and for floors containing a low wall
	var/is_linked = FALSE
	if(T.is_wall)
		if(flooring.wall_smooth)
			is_linked = TRUE

	//If is_hole is true, then it's space or openspace
	else if(T.is_hole)
		if(flooring.space_smooth)
			is_linked = TRUE

	//If we get here then its a normal floor
	else if (istype(T, /turf/simulated/floor))
		var/turf/simulated/floor/t = T
		if (flooring.floor_smooth || t.flooring.name == flooring.name)
			is_linked = TRUE

	return is_linked


/turf/simulated/floor/proc/get_damage_overlay(var/cache_key, var/icon_base	)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = 'icons/turf/damage_overlays.dmi', icon_state = icon_base)

		I.plane = FLOOR_PLANE
		I.layer = TURF_DECAL_LAYER+0.1
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]


/turf/simulated/floor/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0, var/external = FALSE)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = flooring.icon, icon_state = icon_base, dir = icon_dir)
		I.layer = layer+0.01


		//External overlays will be offsetted out of this tile
		if (external)
			if (icon_dir & NORTH)
				I.pixel_y = -32
			else if (icon_dir & SOUTH)
				I.pixel_y = 32

			if (icon_dir & WEST)
				I.pixel_x = 32
			else if (icon_dir & EAST)
				I.pixel_x = -32

		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]