/turf
	var/_initialized_transparency = FALSE //used only for roundstard update_icon
	var/isTransparent = FALSE

	var/image/DARKOVER = null

/turf/simulated/open
	isTransparent = TRUE

/turf/space
	isTransparent = TRUE

/turf/proc/getDarknessOverlay()
	var/image/I
	/*if (I)
		DARKOVER = I
		return I*/

	I = image('icons/turf/space.dmi', "white")
	I.plane = calculate_plane(z,OVER_OPENSPACE_PLANE)
	I.layer = ABOVE_LIGHTING_LAYER
	I.blend_mode = BLEND_MULTIPLY
	I.color = rgb(0,0,0,110)

	DARKOVER = I
	return I

/turf/simulated/open/update_icon(var/update_neighbors, var/roundstart_update = FALSE)
	if (SSticker.current_state != GAME_STATE_PLAYING)
		return

	if (roundstart_update)
		if (_initialized_transparency)
			return
		var/turf/testBelow = GetBelow(src)
		if (testBelow && testBelow.isTransparent && !testBelow._initialized_transparency)
			return //turf below will update this one

	overlays.Cut()

	vis_contents.Cut()
	vis_contents.Add(GetBelow(src))

	overlays += getDarknessOverlay()

	updateFallability()

	_initialized_transparency = TRUE
	update_openspace() //propagate update upwards

/turf/space/update_icon(var/update_neighbors, var/roundstart_update = FALSE)
	if (SSticker.current_state < GAME_STATE_PLAYING)
		return

	if (roundstart_update)
		if (_initialized_transparency)
			return
		var/turf/testBelow = GetBelow(src)
		if (testBelow && testBelow.isTransparent && !testBelow._initialized_transparency)
			return //turf below will update this one

	overlays.Cut()
	var/turf/below = GetBelow(src)
	if (istype(below, /turf/simulated/open))
		ChangeTurf(/turf/simulated/open)
		return

	if (below)
		vis_contents.Cut()
		vis_contents.Add(below)

		overlays += getDarknessOverlay()

	_initialized_transparency = TRUE
	update_openspace()

/hook/roundstart/proc/init_openspace()
	for (var/turf/T in turfs)
		if (T.isTransparent)
			T.update_icon(roundstart_update=TRUE)
	return TRUE

/atom/proc/update_openspace()
	var/turf/T = GetAbove(src)
	if (T && T.isTransparent)
		T.update_icon()

/turf/Entered(atom/movable/Obj, atom/OldLoc)
	. = ..()
	update_openspace()

/turf/Exited(atom/movable/Obj, atom/OldLoc)
	. = ..()
	update_openspace()
