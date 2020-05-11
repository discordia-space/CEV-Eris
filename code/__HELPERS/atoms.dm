//To be called by things that are potentially many layers deep
//This recurses up the hierarchy until it finds an atom whose parent is a turf
/atom/proc/get_toplevel_atom()
	//This function will return the mob which is holding this holder, or null if it's not held
	//It recurses up the hierarchy out of containers until it reaches a mob, or a turf, or hits the limit
	var/x = 0//As a safety, we'll crawl up a maximum of 10 layers
	var/atom/a = src
	while (x < 10)
		x++
		if (isnull(a))
			return null


		if (istype(a.loc, /turf))
			return a

		a = a.loc

	return null//If we get here, the holder must be buried many layers deep in nested containers, or else is somehow contained in nullspace

/atom/proc/add_overlay(var/overlay)
	ASSERT(overlay)

	if(istext(overlay))
		overlays.Add(image(icon,icon_state = overlay))
	else
		overlays.Add(overlay)

/atom/proc/in_maintenance()
	var/area/A = get_area(src)
	if (A && A.is_maintenance)
		return TRUE
	return FALSE

