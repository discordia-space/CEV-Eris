var/list/flooring_cache = list()

/turf/var/icon_updates_count = 0

/turf/simulated/floor/verb/debug_update()
	set src in view()
	set name = "Debugupdate"
	update_icon(TRUE, TRUE)

/turf/simulated/floor/update_icon(var/update_neighbors, var/debug = FALSE)
	icon_updates_count++
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
					if (debug) world << "Checking dir [dir2text(step_dir)]"
					var/turf/simulated/floor/T = get_step(src, step_dir)
					var/is_linked = FALSE

					//is_wall is true for wall turfs and for floors containing a low wall
					if(T.is_wall)
						if(flooring.wall_smooth)
							if (debug) world << "Linked to wall at [T]"
							is_linked = TRUE

					//If is_hole is true, then it's space or openspace
					else if(T.is_hole)
						if(flooring.space_smooth)
							if (debug) world << "Linked to space at [T]"
							is_linked = TRUE

					//If we get here then its a normal floor
					else if (istype(T) && (flooring.floor_smooth || T.flooring.name == flooring.name))
						if (debug) world << "Linked to floor at [T]"
						is_linked = TRUE


					//Alright we've figured out whether or not we smooth with this turf
					if (!is_linked)
						if (debug) world << "NOT LINKED: Border at [dir2text(step_dir)]"
						has_border |= step_dir

						//Now, if we don't, then lets add a border
						if ((flooring.flags & TURF_EDGES_EXTERNAL))
							var/odir = turn(step_dir, 180)
							var/image/I = get_flooring_overlay("[flooring.icon_base]-ext-edge-[odir]", "[flooring.icon_base]_edges", odir, TRUE)
							overlays |= I
						else
							overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[step_dir]", "[flooring.icon_base]_edges", step_dir)


			//Next up, corners
			if (has_border)

				/*
					Support for combined right-angle edges.
					Commented out for now since i can't find any turf that actually uses these.
					But it may be more efficient for render performance/video memory to use it in future
				*/
				/*
				if (!(flooring.flags & TURF_EDGES_EXTERNAL))
					if((has_border & NORTH) && (has_border & EAST))
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[NORTHEAST]", "[flooring.icon_base]_edges", NORTHEAST)
					if((has_border & NORTH) && (has_border & WEST))
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[NORTHWEST]", "[flooring.icon_base]_edges", NORTHWEST)
					if((has_border & SOUTH) && (has_border & EAST))
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHEAST]", "[flooring.icon_base]_edges", SOUTHEAST)
					if((has_border & SOUTH) && (has_border & WEST))
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHWEST]", "[flooring.icon_base]_edges", SOUTHWEST)
				*/
				if(flooring.flags & TURF_HAS_CORNERS)
					if (debug) world << "Handling corners"
					// As above re: concise numerical way to do this.
					if((has_border & NORTH))
						if((has_border & EAST))
							//var/turf/simulated/floor/T = get_step(src, NORTHEAST)
							//if(!istype(T) || !T.flooring || T.flooring.name != flooring.name)
							if (debug) world << "Added corner [dir2text(NORTHEAST)]"
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[NORTHEAST]", "[flooring.icon_base]_corners", NORTHEAST)
						if((has_border & WEST))
							//var/turf/simulated/floor/T = get_step(src, NORTHWEST)
							//if(!istype(T) || !T.flooring || T.flooring.name != flooring.name)
							if (debug) world << "Added corner [dir2text(NORTHWEST)]"
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[NORTHWEST]", "[flooring.icon_base]_corners", NORTHWEST)
					if((has_border & SOUTH))
						if((has_border & EAST))
							//var/turf/simulated/floor/T = get_step(src, SOUTHEAST)
							//if(!istype(T) || !T.flooring || T.flooring.name != flooring.name)
							if (debug) world << "Added corner [dir2text(SOUTHEAST)]"
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHEAST]", "[flooring.icon_base]_corners", SOUTHEAST)
						if((has_border & WEST))
							//var/turf/simulated/floor/T = get_step(src, SOUTHWEST)
							//if(!istype(T) || !T.flooring || T.flooring.name != flooring.name)
							if (debug) world << "Added corner [dir2text(SOUTHWEST)]"
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHWEST]", "[flooring.icon_base]_corners", SOUTHWEST)


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