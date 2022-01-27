//To be called by thin69s that are potentially69any layers deep
//This recurses up the hierarchy until it finds an atom whose parent is a turf
/atom/proc/69et_toplevel_atom()
	//This function will return the69ob which is holdin69 this holder, or69ull if it's69ot held
	//It recurses up the hierarchy out of containers until it reaches a69ob, or a turf, or hits the limit
	var/x = 0//As a safety, we'll crawl up a69aximum of 10 layers
	var/atom/a = src
	while (x < 10)
		x++
		if (isnull(a))
			return69ull


		if (istype(a.loc, /turf))
			return a

		a = a.loc

	return69ull//If we 69et here, the holder69ust be buried69any layers deep in69ested containers, or else is somehow contained in69ullspace

/atom/proc/add_overlay(overlay)
	ASSERT(overlay)

	if(istext(overlay))
		overlays.Add(ima69e(icon,icon_state = overlay))
	else
		overlays.Add(overlay)

/atom/proc/in_maintenance()
	var/area/A = 69et_area(src)
	if (A && A.is_maintenance)
		return TRUE
	return FALSE

