var/list/flooring_cache = list()

/turf/simulated/floor/verb/debug_update()
	set src in view()
	set name = "Debug update"
	update_icon(1,1)

/turf/simulated/floor/verb/debug_cut()
	set src in view()
	set name = "Debug Cutoverlays"
	overlays.Cut()

/turf/simulated/floor/verb/debug_grass()
	set src in view()
	set name = "Debug Grass"

	var/d = input(usr, "Enter dir", "dir", NORTH)
	var/xo = input(usr, "X offset", "X offset", 16)
	var/yo = input(usr, "Y offset", "Y offset", 16)
	var/image/I = image(icon = 'icons/turf/flooring/grass.dmi', icon_state = "grass_edges", dir = d)
	I.layer = 4


	I.pixel_x = xo
	I.pixel_y = yo

	overlays += I

/turf/simulated/floor/update_icon(var/update_neighbors, var/debug = FALSE)

	if(lava)
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
				if(flooring.has_base_range)
					icon_state = "[icon_state][rand(0,flooring.has_base_range)]"
					flooring_override = icon_state


		// Apply edges, corners, and inner corners.
		overlays.Cut()
		var/has_border = 0
		if (debug) world << "About to start checking neighbors [set_update_icon]"
		if(flooring.flags & SMOOTH_ONLY_WITH_ITSELF) // for carpets and stuff like that
			if (debug) world << "Selfsmooth"
			if(isnull(set_update_icon) && (flooring.flags & TURF_HAS_EDGES))
				if (debug) world << "Has Edges. Now checking dirs"
				for(var/step_dir in cardinal)
					var/turf/simulated/floor/T = get_step(src, step_dir)
					if(!istype(T) || !T.flooring || T.flooring.name != flooring.name)
						if (debug) world << "Found a border: [T] [dir2text(step_dir)]"
						has_border |= step_dir
						if ((flooring.flags & TURF_EDGES_EXTERNAL) && istype(T) && T.flooring)

							var/odir = turn(step_dir, 180)
							world << "Now applying external border: [dir2text(odir)]"
							var/image/I = get_flooring_overlay("[flooring.icon_base]-ext-edge-[odir]", "[flooring.icon_base]_edges", odir, TRUE)
							world << "External icon with direction [dir2text(I.dir)] [I.dir]  \ref[src]"
							world << "Pixel XY [I.pixel_x], [I.pixel_y]"
							overlays |= I
						else
							overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[step_dir]", "[flooring.icon_base]_edges", step_dir)

				//if (debug)
					//for(var/i in overlays)
						//world << json_encode(i:vars)

				if ((flooring.flags & TURF_USE0ICON) && has_border)
					icon_state = flooring.icon_base+"0"


				if (!(flooring.flags & TURF_EDGES_EXTERNAL))
					// There has to be a concise numerical way to do this but I am too noob.
					if((has_border & NORTH) && (has_border & EAST))
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[NORTHEAST]", "[flooring.icon_base]_edges", NORTHEAST)
					if((has_border & NORTH) && (has_border & WEST))
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[NORTHWEST]", "[flooring.icon_base]_edges", NORTHWEST)
					if((has_border & SOUTH) && (has_border & EAST))
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHEAST]", "[flooring.icon_base]_edges", SOUTHEAST)
					if((has_border & SOUTH) && (has_border & WEST))
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHWEST]", "[flooring.icon_base]_edges", SOUTHWEST)

				if(flooring.flags & TURF_HAS_CORNERS)
					// As above re: concise numerical way to do this.
					if(!(has_border & NORTH))
						if(!(has_border & EAST))
							var/turf/simulated/floor/T = get_step(src, NORTHEAST)
							if(!istype(T) || !T.flooring || T.flooring.name != flooring.name)
								overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[NORTHEAST]", "[flooring.icon_base]_corners", NORTHEAST)
						if(!(has_border & WEST))
							var/turf/simulated/floor/T = get_step(src, NORTHWEST)
							if(!istype(T) || !T.flooring || T.flooring.name != flooring.name)
								overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[NORTHWEST]", "[flooring.icon_base]_corners", NORTHWEST)
					if(!(has_border & SOUTH))
						if(!(has_border & EAST))
							var/turf/simulated/floor/T = get_step(src, SOUTHEAST)
							if(!istype(T) || !T.flooring || T.flooring.name != flooring.name)
								overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHEAST]", "[flooring.icon_base]_corners", SOUTHEAST)
						if(!(has_border & WEST))
							var/turf/simulated/floor/T = get_step(src, SOUTHWEST)
							if(!istype(T) || !T.flooring || T.flooring.name != flooring.name)
								overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHWEST]", "[flooring.icon_base]_corners", SOUTHWEST)

		else
			if(isnull(set_update_icon) && (flooring.flags & TURF_HAS_EDGES))
				for(var/step_dir in cardinal)
					var/turf/T = get_step(src, step_dir)
					if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
						has_border |= step_dir
						overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[step_dir]", "[flooring.icon_base]_edges", step_dir)
				if ((flooring.flags & TURF_USE0ICON) && has_border)
					icon_state = flooring.icon_base+"0"

				// There has to be a concise numerical way to do this but I am too noob.
				if((has_border & NORTH) && (has_border & EAST))
					overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[NORTHEAST]", "[flooring.icon_base]_edges", NORTHEAST)
				if((has_border & NORTH) && (has_border & WEST))
					overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[NORTHWEST]", "[flooring.icon_base]_edges", NORTHWEST)
				if((has_border & SOUTH) && (has_border & EAST))
					overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHEAST]", "[flooring.icon_base]_edges", SOUTHEAST)
				if((has_border & SOUTH) && (has_border & WEST))
					overlays |= get_flooring_overlay("[flooring.icon_base]-edge-[SOUTHWEST]", "[flooring.icon_base]_edges", SOUTHWEST)

				if(flooring.flags & TURF_HAS_CORNERS)
					// As above re: concise numerical way to do this.
					if(!(has_border & NORTH))
						if(!(has_border & EAST))
							var/turf/simulated/floor/T = get_step(src, NORTHEAST)
							if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
								overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[NORTHEAST]", "[flooring.icon_base]_corners", NORTHEAST)
						if(!(has_border & WEST))
							var/turf/simulated/floor/T = get_step(src, NORTHWEST)
							if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
								overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[NORTHWEST]", "[flooring.icon_base]_corners", NORTHWEST)
					if(!(has_border & SOUTH))
						if(!(has_border & EAST))
							var/turf/simulated/floor/T = get_step(src, SOUTHEAST)
							if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
								overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHEAST]", "[flooring.icon_base]_corners", SOUTHEAST)
						if(!(has_border & WEST))
							var/turf/simulated/floor/T = get_step(src, SOUTHWEST)
							if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
								overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHWEST]", "[flooring.icon_base]_corners", SOUTHWEST)

	if(decals && decals.len)
		overlays |= decals

	if(is_plating() && !(isnull(broken) && isnull(burnt))) //temp, todo
		icon = 'icons/turf/flooring/plating.dmi'
		icon_state = "dmg[rand(1,4)]"
	else if(flooring)
		if(!isnull(broken) && (flooring.flags & TURF_CAN_BREAK))
			overlays |= get_flooring_overlay("[flooring.icon_base]-broken-[broken]", "broken[broken]")
		if(!isnull(burnt) && (flooring.flags & TURF_CAN_BURN))
			overlays |= get_flooring_overlay("[flooring.icon_base]-burned-[burnt]", "burned[burnt]")

	if(update_neighbors)
		for(var/turf/simulated/floor/F in trange(1, src))
			if(F == src)
				continue
			F.update_icon()
	update_openspace()

/turf/simulated/floor/proc/get_flooring_overlay(var/cache_key, var/icon_base, var/icon_dir = 0, var/external = FALSE)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = flooring.icon, icon_state = icon_base, dir = icon_dir)
		I.layer = layer+0.01


		//External overlays will be offsetted out of this tile
		if (external)
			world << "External icon with direction [dir2text(icon_dir)] [icon_dir]"
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