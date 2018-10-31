/turf/proc/getDarknessOverlay()
	var/static/image/over_OS_darkness
	if (over_OS_darkness)
		return over_OS_darkness

	over_OS_darkness = image('icons/turf/floors.dmi', "black_open")
	over_OS_darkness.plane = OVER_OPENSPACE_PLANE
	over_OS_darkness.layer = MOB_LAYER

	return over_OS_darkness

/turf/proc/assumeVisualContentsFromTurf(var/turf/T) //tries to imitate the target turf in visual appearance
	icon = T.icon
	icon_state = T.icon_state
	dir = T.dir
	color = T.color
	overlays += T.overlays

	var/image/I
	for (var/obj/O in T)
		if (!O.invisibility) // ignore objects that have any form of invisibility
			I = new(O, dir = O.dir, layer = O.layer)
			I.color = O.color
			I.alpha = O.alpha
			I.blend_mode = O.blend_mode
			I.overlays = O.overlays
			I.underlays = O.underlays
			I.pixel_x = O.pixel_x
			I.pixel_y = O.pixel_y
			I.pixel_w = O.pixel_w
			I.pixel_z = O.pixel_z
			I.transform = O.transform

			I.plane = plane
			overlays += I

/turf/simulated/open/update_icon(var/updateAboveTurf = TRUE)
	if (SSticker.current_state != GAME_STATE_PLAYING)
		return

	overlays.Cut()
	var/turf/below = GetBelow(src)
	if (below)
		if (below.is_space())
			plane = PLANE_SPACE
		else
			plane = OPENSPACE_PLANE

		assumeVisualContentsFromTurf(below)

		overlays += getDarknessOverlay()

		updateFallability()
	else
		ChangeTurf(/turf/space)

	if (updateAboveTurf)
		update_openspace()

/turf/space/update_icon(var/updateAboveTurf = TRUE)
	if (SSticker.current_state < GAME_STATE_PLAYING)
		return

	overlays.Cut()
	var/turf/below = GetBelow(src)
	if (below)
		if (below.is_space())
			plane = PLANE_SPACE
		else
			plane = OPENSPACE_PLANE
			overlays += getDarknessOverlay()

		assumeVisualContentsFromTurf(below)
	else
		icon = initial(icon)
		plane = initial(plane)
		if (!istype(src, /turf/space/transit))
			icon_state = "white"

	if (updateAboveTurf)
		update_openspace()

/hook/roundstart/proc/init_openspace()
	var/turf/T
	for (var/elem in turfs)
		if (istype(elem, /turf/simulated/open) || istype(elem, /turf/space))
			T = elem
			T.update_icon(FALSE)
	return TRUE

/atom/proc/update_openspace()
	var/turf/T = GetAbove(src)
	if (istype(T, /turf/simulated/open) || istype(T, /turf/space))
		T.update_icon()

/turf/Entered(atom/movable/Obj, atom/OldLoc)
	. = ..()
	update_openspace()

/turf/Exited(atom/movable/Obj, atom/OldLoc)
	. = ..()
	update_openspace()
