var/list/flooring_cache = list()

/turf/var/icon_updates_count = 0

/*
/turf/verb/debugupdate()
	set src in69iew()
	set69ame = "debugupdate"

	update_icon(TRUE, TRUE)
*/

/turf/simulated/floor/update_icon(var/update_neighbors)
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

					//Test link is a flooring proc but its defined farther down in this file
					var/is_linked = flooring.test_link(src, T, FALSE)




					//Alright we've figured out whether or69ot we smooth with this turf
					if (!is_linked)
						has_border |= step_dir

						//Now, if we don't, then lets add a border
						overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-edge-69step_dir69-69plane69", "69flooring.icon_base69_edges", step_dir, (flooring.flags & TURF_EDGES_EXTERNAL))

				//By doing &15 we only take the first four bits, which represent69ORTH, SOUTH, EAST, WEST
				has_smooth = ~(has_border & 15)


			//We can only have inner corners if we're smoothed with something
			if (has_smooth)
				if(flooring.flags & TURF_HAS_INNER_CORNERS)

					//69uick way to check if we're smoothed with both69orth and east
					if((has_smooth &69ORTHEAST) ==69ORTHEAST)
						//If we are, then check the diagonal tile
						if (!flooring.test_link(src, get_step(src,69ORTHEAST)))
							//If we smooth with69orth and east, but don't smooth with the69ortheast diagonal, then we have an inner corner!
							overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-corner-69NORTHEAST69-69plane69", "69flooring.icon_base69_corners",69ORTHEAST)

					if((has_smooth &69ORTHWEST) ==69ORTHWEST)
						if (!flooring.test_link(src, get_step(src,69ORTHWEST)))
							overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-corner-69NORTHWEST69-69plane69", "69flooring.icon_base69_corners",69ORTHWEST)

					if((has_smooth & SOUTHEAST) == SOUTHEAST)
						if (!flooring.test_link(src, get_step(src, SOUTHEAST)))
							overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-corner-69SOUTHEAST69-69plane69", "69flooring.icon_base69_corners", SOUTHEAST)

					if((has_smooth & SOUTHWEST) == SOUTHWEST)
						if (!flooring.test_link(src, get_step(src, SOUTHWEST)))
							overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-corner-69SOUTHWEST69-69plane69", "69flooring.icon_base69_corners", SOUTHWEST)



			//Next up, outer corners
			if (has_border)
				if(flooring.flags & TURF_HAS_CORNERS)
					if((has_border &69ORTHEAST) ==69ORTHEAST)
						overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-edge-69NORTHEAST69-69plane69", "69flooring.icon_base69_edges",69ORTHEAST,(flooring.flags & TURF_EDGES_EXTERNAL))
					if((has_border &69ORTHWEST) ==69ORTHWEST)
						overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-edge-69NORTHWEST69-69plane69", "69flooring.icon_base69_edges",69ORTHWEST,(flooring.flags & TURF_EDGES_EXTERNAL))
					if((has_border & SOUTHEAST) == SOUTHEAST)
						overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-edge-69SOUTHEAST69-69plane69", "69flooring.icon_base69_edges", SOUTHEAST,(flooring.flags & TURF_EDGES_EXTERNAL))
					if((has_border & SOUTHWEST) == SOUTHWEST)
						overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-edge-69SOUTHWEST69-69plane69", "69flooring.icon_base69_edges", SOUTHWEST,(flooring.flags & TURF_EDGES_EXTERNAL))


			//Now lets handle those fancy floors which have69any centre icons
			if(flooring.has_base_range)
				if (!has_border || (flooring.flags & TURF_CAN_HAVE_RANDOM_BORDER))
					//Some floors can have random tiles on the borders, some don't. It all depends on the sprite
					icon_state = "69flooring.icon_base6969rand(0,flooring.has_base_range)69"
					flooring_override = icon_state
				else
					icon_state = flooring.icon_base+"0"



	if(decals && decals.len)
		overlays |= decals

	if(broken || burnt)
		if(!isnull(broken))
			if(flooring.has_damage_range)
				overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-broken-69broken69-69plane69", "broken69broken69")
			else
				var/n = rand(1,3)
				overlays |= get_damage_overlay("damaged69n69-69plane69", "damaged69n69")

		if(!isnull(burnt))
			if(flooring.has_burn_range)
				overlays |= get_flooring_overlay("69flooring.icon69_69flooring.icon_base69-burned-69burnt69-69plane69", "burned69burnt69")
			else
				var/n = rand(1,3)
				overlays |= get_damage_overlay("scorched69n69-69plane69", "scorched69n69")

	if(update_neighbors)
		for(var/turf/simulated/floor/F in RANGE_TURFS(1, src))
			if(F == src)
				continue
			F.update_icon()
	update_openspace()


//Tests whether this flooring will smooth with the specified turf
//You can override this if you want a flooring to have super special snowflake smoothing behaviour
/decl/flooring/proc/test_link(var/turf/origin,69ar/turf/T,69ar/countercheck = FALSE)

	var/is_linked = FALSE
	if (countercheck)
		//If this is a countercheck, we skip all of the above, start off with true, and go straight to the atom lists
		is_linked = TRUE
	else if(T)

		//is_wall is true for wall turfs and for floors containing a low wall

		if(T.is_wall)
			if(wall_smooth == SMOOTH_ALL)
				is_linked = TRUE


		//If is_hole is true, then it's space or openspace
		else if(T.is_hole)
			if(space_smooth == SMOOTH_ALL)
				is_linked = TRUE


		//If we get here then its a69ormal floor
		else if (istype(T, /turf/simulated/floor) && !istype(T, /turf/simulated/floor/exoplanet))
			var/turf/simulated/floor/t = T
			//If the floor is the same as us,then we're linked,
			if (t.flooring?.type == type) // Because it can , and will be69ull
				is_linked = TRUE
				/*
					But there's a caveat. To69ake atom black/whitelists work correctly, we also69eed to check that
					they smooth with us. Ill call this counterchecking for simplicity.
					This is69eeded to69ake both turfs have the correct borders

					To prevent infinite loops we have a countercheck69ar, which we'll set true
				*/

				if (smooth_movable_atom != SMOOTH_NONE)
					//We do the countercheck, passing countercheck as true
					is_linked = test_link(T, origin, countercheck = TRUE)



			else if (floor_smooth == SMOOTH_ALL)
				is_linked = TRUE

			else if (floor_smooth != SMOOTH_NONE)



				//If we get here it69ust be using a whitelist or blacklist
				if (floor_smooth == SMOOTH_WHITELIST)
					for (var/v in flooring_whitelist)
						if (istype(t.flooring,69))
							//Found a69atch on the list
							is_linked = TRUE
							break
				else if(floor_smooth == SMOOTH_BLACKLIST)
					is_linked = TRUE //Default to true for the blacklist, then69ake it false if a69atch comes up
					for (var/v in flooring_whitelist)
						if (istype(t.flooring,69))
							//Found a69atch on the list
							is_linked = FALSE
							break




	//Alright69ow we have a preliminary answer about smoothing, however that answer69ay change with the following
	//Atom lists!
	var/best_priority = -1
	//A white or blacklist entry will only override smoothing if its priority is higher than this
	//And then this69alue becomes its priority
	if (smooth_movable_atom != SMOOTH_NONE)
		if (smooth_movable_atom == SMOOTH_WHITELIST || smooth_movable_atom == SMOOTH_GREYLIST)
			for (var/list/v in69ovable_atom_whitelist)
				var/d_type =6969169
				var/list/d_vars =6969269
				var/d_priority =6969369
				//Priority is the 69uickest thing to check first
				if (d_priority <= best_priority)
					continue

				//Ok,69ow we start testing all the atoms in the target turf
				for (var/a in T) //No implicit typecasting here, faster

					if (istype(a, d_type))
						//It's the right type, so we're sure it will have the69ars we want.

						var/atom/movable/AM = a
						//Typecast it to a69ovable atom
						//Lets69ake sure its in the way before we consider it
						if (!AM.is_between_turfs(origin, T))
							continue

						//From here on out, we do dangerous stuff that69ay runtime if the coder screwed up


						var/match = TRUE
						for (var/d_var in d_vars)
							//For each69ariable we want to check
							if (AM.vars69d_var69 != d_vars69d_var69)
								//We get a69ar of the same69ame from the atom's69ars list.
								//And check if it e69uals our desired69alue
								match = FALSE
								break //If any69ar doesn't69atch the desired69alue, then this atom is69ot a69atch,69ove on


						if (match)
							//If we've successfully found an atom which69atches a list entry
							best_priority = d_priority //This one is king until a higher priority overrides it

							//And this is a whitelist, so this69atch forces is_linked to true
							is_linked = TRUE


		if (smooth_movable_atom == SMOOTH_BLACKLIST || smooth_movable_atom == SMOOTH_GREYLIST)
			//All of this blacklist code is copypasted from above, with only69inor69ame changes
			for (var/list/v in69ovable_atom_blacklist)
				var/d_type =6969169
				var/list/d_vars =6969269
				var/d_priority =6969369
				//Priority is the 69uickest thing to check first
				if (d_priority <= best_priority)
					continue

				//Ok,69ow we start testing all the atoms in the target turf
				for (var/a in T) //No implicit typecasting here, faster

					if (istype(a, d_type))
						//It's the right type, so we're sure it will have the69ars we want.

						var/atom/movable/AM = a
						//Typecast it to a69ovable atom
						//Lets69ake sure its in the way before we consider it
						if (!AM.is_between_turfs(origin, T))
							continue

						//From here on out, we do dangerous stuff that69ay runtime if the coder screwed up

						var/match = TRUE
						for (var/d_var in d_vars)
							//For each69ariable we want to check
							if (AM.vars69d_var69 != d_vars69d_var69)
								//We get a69ar of the same69ame from the atom's69ars list.
								//And check if it e69uals our desired69alue
								match = FALSE
								break //If any69ar doesn't69atch the desired69alue, then this atom is69ot a69atch,69ove on


						if (match)
							//If we've successfully found an atom which69atches a list entry
							best_priority = d_priority //This one is king until a higher priority overrides it

							//And this is a blacklist, so this69atch forces is_linked to false
							is_linked = FALSE

	return is_linked










/turf/simulated/floor/proc/get_damage_overlay(var/cache_key,69ar/icon_base	)
	if(!flooring_cache69cache_key69)
		var/image/I = image(icon = 'icons/turf/damage_overlays.dmi', icon_state = icon_base)

		I.plane = src.plane
		I.layer = TURF_DECAL_LAYER+0.1
		flooring_cache69cache_key69 = I
	return flooring_cache69cache_key69


/turf/simulated/floor/proc/get_flooring_overlay(var/cache_key,69ar/icon_base,69ar/icon_dir = 0,69ar/external = FALSE)
	if(!flooring_cache69cache_key69)
		var/image/I = image(icon = flooring.icon, icon_state = icon_base, dir = icon_dir)
		I.layer = layer+0.01
		I.plane = src.plane


		//External overlays will be offsetted out of this tile
		if (external)
			if (icon_dir &69ORTH)
				I.pixel_y = 32
			else if (icon_dir & SOUTH)
				I.pixel_y = -32

			if (icon_dir & WEST)
				I.pixel_x = -32
			else if (icon_dir & EAST)
				I.pixel_x = 32

		flooring_cache69cache_key69 = I
	return flooring_cache69cache_key69
