/turf/simulated/floor/diona
	name = "biomass flooring"
	icon = 'icons/turf/floors.dmi'
	icon_state = "diona"

/turf/simulated/floor/diona/attackby()
	return

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"
	level = 1

/turf/simulated/shuttle/plating/is_plating()
	return 1

/turf/simulated/floor/plating/under
	name = "underplating"
	icon = 'icons/turf/flooring/un.dmi'
	icon_state = "un"
	initial_flooring = /decl/flooring/un
	level = 1
	//style = "underplating"

/turf/simulated/floor/plating/under/update_icon(var/update_neighbors)

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
			icon_state = flooring.icon_base
			if(flooring.has_base_range)
				icon_state = "[icon_state][rand(0,flooring.has_base_range)]"
				flooring_override = icon_state

		// Apply edges, corners, and inner corners.
		overlays.Cut()
		var/has_border = 0
		if(isnull(set_update_icon) && (flooring.flags & TURF_HAS_EDGES))
			for(var/step_dir in cardinal)
				var/turf/simulated/floor/T = get_step(src, step_dir)
				if((!istype(T) || !T.flooring || T.flooring.name != flooring.name) && !istype(T, /turf/simulated/open) && !istype(T, /turf/space))
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
						if((!istype(T) || !T.flooring || T.flooring.name != flooring.name) && !istype(T, /turf/simulated/open) && !istype(T, /turf/space))
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[NORTHEAST]", "[flooring.icon_base]_corners", NORTHEAST)
					if(!(has_border & WEST))
						var/turf/simulated/floor/T = get_step(src, NORTHWEST)
						if((!istype(T) || !T.flooring || T.flooring.name != flooring.name) && !istype(T, /turf/simulated/open) && !istype(T, /turf/space))
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[NORTHWEST]", "[flooring.icon_base]_corners", NORTHWEST)
				if(!(has_border & SOUTH))
					if(!(has_border & EAST))
						var/turf/simulated/floor/T = get_step(src, SOUTHEAST)
						if((!istype(T) || !T.flooring || T.flooring.name != flooring.name) && !istype(T, /turf/simulated/open) && !istype(T, /turf/space))
							overlays |= get_flooring_overlay("[flooring.icon_base]-corner-[SOUTHEAST]", "[flooring.icon_base]_corners", SOUTHEAST)
					if(!(has_border & WEST))
						var/turf/simulated/floor/T = get_step(src, SOUTHWEST)
						if((!istype(T) || !T.flooring || T.flooring.name != flooring.name) && !istype(T, /turf/simulated/open) && !istype(T, /turf/space))
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
		for(var/turf/simulated/floor/F in range(src, 1))
			if(F == src)
				continue
			F.update_icon()
/*
/turf/simulated/floor/plating/under/New()
	..()
	spawn(4)
		if(src)
			update_icon()
			for(var/direction in alldirs)
				if(istype(get_step(src,direction),/turf/simulated/floor))
					var/turf/simulated/floor/FF = get_step(src,direction)
					FF.update_icon() //so siding get updated properly
*/
/turf/simulated/floor/plating/under/Entered(mob/living/M as mob)
	..()
	for(var/obj/structure/catwalk/C in get_turf(src))
		return

	if(!ishuman(M) || !has_gravity(src))
		return
	if(M.m_intent == "run")
		if(prob(75))
			M.adjustBruteLoss(5)
			M.weakened += 3
			M << "<span class='warning'>You tripped over!</span>"
			return

/turf/simulated/shuttle/plating/vox //Skipjack plating
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/simulated/shuttle/floor4/vox //skipjack floors
	name = "skipjack floor"
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD
