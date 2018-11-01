/turf
	var/_initialized_transparency = FALSE
	var/isTransparent = FALSE

/turf/simulated/open
	isTransparent = TRUE
	var/obj/effect/overlay/turfBelowEffectOverlay

/turf/space
	isTransparent = TRUE
	var/obj/effect/overlay/turfBelowEffectOverlay

/turf/proc/getDarknessOverlay()
	var/static/image/I
	if (I)
		return I

	I = image('icons/turf/space.dmi', "white")
	I.plane = OPENSPACE_PLANE
	I.layer = ABOVE_LIGHTING_LAYER
	I.blend_mode = BLEND_MULTIPLY
	I.color = rgb(0,0,0,96)

	return I

/proc/makeAtomMimicTurf(var/atom/A, var/turf/T) //tries to imitate the target turf in visual appearance
	A.icon = T.icon
	A.icon_state = T.icon_state
	A.dir = T.dir
	A.color = T.color
	A.overlays += T.overlays

	var/image/I
	for (var/obj/O in T)
		if (!O.invisibility) // ignore objects that have any form of invisibility
			I = new(O, dir = O.dir, layer = O.layer)
			I.color = O.color
			I.alpha = O.alpha
			I.overlays = O.overlays
			I.underlays = O.underlays
			I.pixel_x = O.pixel_x
			I.pixel_y = O.pixel_y
			I.pixel_w = O.pixel_w
			I.pixel_z = O.pixel_z
			I.transform = O.transform

			I.plane = A.plane
			A.overlays += I

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
	QDEL_NULL(turfBelowEffectOverlay)
	var/turf/below = GetBelow(src)
	if (below)
		turfBelowEffectOverlay = new
		var/obj/effect/overlay/E = turfBelowEffectOverlay
		E.loc = src
		E.plane = OPENSPACE_PLANE
		E.layer = layer + 0.01

		makeAtomMimicTurf(E,below)

		if (below.is_hole)
			plane = PLANE_SPACE
			E.icon = null
			E.icon_state = null
		else
			plane = OPENSPACE_PLANE
			icon = null
			icon_state = null

		E.overlays += getDarknessOverlay()

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
	QDEL_NULL(turfBelowEffectOverlay)
	var/turf/below = GetBelow(src)
	if (below)
		turfBelowEffectOverlay = new
		var/obj/effect/overlay/E = turfBelowEffectOverlay
		E.loc = src
		E.plane = OPENSPACE_PLANE
		E.layer = layer + 0.01

		makeAtomMimicTurf(E,below)

		if (below.is_hole)
			plane = PLANE_SPACE
			E.icon = null
			E.icon_state = null
		else
			plane = OPENSPACE_PLANE
			icon = null
			icon_state = null

		E.overlays += getDarknessOverlay()
	else
		icon = initial(icon)
		plane = initial(plane)
		if(!istype(src, /turf/space/transit))
			icon_state = "white"

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
