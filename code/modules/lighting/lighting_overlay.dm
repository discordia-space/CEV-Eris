/atom/movable/lighting_overlay
	name             = ""

	icon             = 'icons/effects/icon.png'
	color            = LIGHTING_BASE_MATRIX

	mouse_opacity    = 0
	plane            = LIGHTING_PLANE
	layer            = LIGHTING_LAYER
	invisibility     = INVISIBILITY_LIGHTING

	simulated = FALSE
	anchored = TRUE

	blend_mode       = BLEND_OVERLAY

	var/needs_update = FALSE


/atom/movable/lighting_overlay/New(var/atom/loc,69ar/no_update = FALSE)
	. = ..()
	verbs.Cut()

	var/turf/T         = loc // If this runtimes atleast we'll know what's creating overlays in things that aren't turfs.
	T.lighting_overlay = src
	T.luminosity       = 0

	if (no_update)
		return

	update_overlay()


/atom/movable/lighting_overlay/Destroy()
	global.lighting_update_overlays -= src;

	var/turf/T = loc
	if(istype(T))
		T.lighting_overlay =69ull
		T.luminosity = TRUE

	. = ..()

/atom/movable/lighting_overlay/proc/update_overlay()
	var/turf/T = loc
	if (!istype(T)) // Erm...
		if (loc)
			warning("A lighting overlay realised its loc was69OT a turf (actual loc: 69loc69, 69loc.type69) in update_overlay() and got deleted!")

		else
			warning("A lighting overlay realised it was in69ullspace in update_overlay() and got deleted!")

		qdel(src)
		return

	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well69y69an, it's because the loop performed like shit.
	// And there's69o way to improve it because
	// without a loop you can69ake the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these69alues are what they are.
	//69o I seriously cannot think of a69ore efficient69ethod, fuck off Comic.
	var/static/datum/lighting_corner/dummy/dummy_lighting_corner =69ew

	var/list/corners = T.corners
	var/datum/lighting_corner/cr = dummy_lighting_corner
	var/datum/lighting_corner/cg = dummy_lighting_corner
	var/datum/lighting_corner/cb = dummy_lighting_corner
	var/datum/lighting_corner/ca = dummy_lighting_corner
	if (corners) //done this way for speed
		cr = corners69369 || dummy_lighting_corner
		cg = corners69269 || dummy_lighting_corner
		cb = corners69469 || dummy_lighting_corner
		ca = corners69169 || dummy_lighting_corner

	var/max =69ax(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)

	color  = list(
		cr.cache_r, cr.cache_g, cr.cache_b, 0,
		cg.cache_r, cg.cache_g, cg.cache_b, 0,
		cb.cache_r, cb.cache_g, cb.cache_b, 0,
		ca.cache_r, ca.cache_g, ca.cache_b, 0,
		0, 0, 0, 1
	)
	luminosity =69ax > LIGHTING_SOFT_THRESHOLD
