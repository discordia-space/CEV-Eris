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


//Would return false if there is tile with density=1 on line. True otherwise.
/proc/bresenhem_line_check(var/atom/start, var/atom/end)
	//thanks, stackoverflow
	var/turf/start_turf = get_turf(start)
	var/turf/target_turf = get_turf(end)

	if(start_turf.z != target_turf.z)
		return FALSE
	if(end.density)
		return FALSE

	var/x = start_turf.x
	var/y = start_turf.y
	var/z = start_turf.z
	var/w = target_turf.x - start_turf.x
	var/h = target_turf.y - start_turf.y
	var/w_abs = abs(w)
	var/h_abs = abs(h)
	var/longest = 0
	var/shortest = 0
	var/dx1 = 0
	var/dx2 = 0
	var/dy1 = 0
	var/dy2 = 0

	if(w!=0)
		if(w>0)
			dx1=1
			dx2=1
		else
			dx1=-1
			dx2=-1
	if(h!=0)
		if(h>0)
			dy1=1
			dy2=1
		else
			dy1=-1
			dy2=-1

	if(w_abs<=h_abs)
		longest = h_abs
		shortest = w_abs
		dx2=0
	else
		shortest = h_abs
		longest = w_abs
		dy2=0

	var/num = longest>>1
	for(var/i=0; i<longest; i++)
		var/turf/to_check = locate(x,y,z)
		if(to_check.density)
			return FALSE
		num += shortest
		if(num >= longest)
			num -= longest
			x += dx1
			y += dy1
		else
			x += dx2
			y += dy2
	return TRUE
