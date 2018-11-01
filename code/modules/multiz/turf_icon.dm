/turf
	var/_initialized_transparency = FALSE //used only for roundstard update_icon
	var/isTransparent = FALSE

/turf/simulated/open
	isTransparent = TRUE

/turf/space
	isTransparent = TRUE

/turf/proc/getDarknessOverlay()
	var/static/image/I
	if (I)
		return I

	I = image('icons/turf/space.dmi', "white")
	I.plane = OPENSPACE_PLANE
	I.layer = ABOVE_LIGHTING_LAYER
	I.blend_mode = BLEND_MULTIPLY
	I.color = rgb(0,0,0,128)

	return I

/proc/atomToImage(var/atom/A)
	var/image/I = new(A, dir = A.dir, layer = A.layer)
	I.color = A.color
	I.alpha = A.alpha
	I.overlays = A.overlays
	I.underlays = A.underlays
	I.pixel_x = A.pixel_x
	I.pixel_y = A.pixel_y
	I.pixel_w = A.pixel_w
	I.pixel_z = A.pixel_z
	I.transform = A.transform

	return I

/turf/proc/mimicTurf(var/turf/T, var/mimic_plane = plane, var/objectsOnly = FALSE)
	var/image/I

	if (!objectsOnly)
		I = atomToImage(T)
		I.plane = mimic_plane
		overlays += I

	for (var/obj/O in T)
		if (!O.invisibility) // ignore objects that have any form of invisibility
			I = atomToImage(O)
			I.plane = mimic_plane
			overlays += I

/turf/simulated/open/update_icon(var/roundstart_update = FALSE)
	if (SSticker.current_state != GAME_STATE_PLAYING)
		return

	if (roundstart_update)
		if (_initialized_transparency)
			return
		var/turf/testBelow = GetBelow(src)
		if (testBelow && testBelow.isTransparent && !testBelow._initialized_transparency)
			return //turf below will update this one

	overlays.Cut()
	var/turf/below = GetBelow(src)
	if (below)
		if (below.is_hole)
			plane = PLANE_SPACE
		else
			plane = OPENSPACE_PLANE

		overlays += below.overlays
		mimicTurf(below, OPENSPACE_PLANE, below.is_hole)

		overlays += getDarknessOverlay()

		updateFallability()
	else
		ChangeTurf(/turf/space)

	_initialized_transparency = TRUE
	update_openspace() //propagate update upwards

/turf/space/update_icon(var/roundstart_update = FALSE)
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
	if (below)
		if (below.is_hole)
			plane = PLANE_SPACE
		else
			plane = OPENSPACE_PLANE

		overlays += below.overlays
		mimicTurf(below, OPENSPACE_PLANE, below.is_hole)

		overlays += getDarknessOverlay()

	_initialized_transparency = TRUE
	update_openspace()

/hook/roundstart/proc/init_openspace()
	for (var/turf/T in turfs)
		if (T.isTransparent)
			T.update_icon(TRUE)
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
