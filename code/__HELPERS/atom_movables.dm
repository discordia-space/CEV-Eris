/*

Lets the turf this atom's *ICON* appears to inhabit
it takes into account:
* Pixel_x/y
* Matrix x/y

NOTE: if your atom has non-standard bounds then this proc
will handle it, but:
* if the bounds are even, then there are an even amount of "middle" turfs, the one to the EAST, NORTH, or BOTH is picked
this may seem bad, but you're atleast as close to the center of the atom as possible, better than byond's default loc being all the way off)
* if the bounds are odd, the true middle turf of the atom is returned

*/

/proc/get_turf_pixel(atom/AM)
	if(!istype(AM))
		return

	//Find AM's matrix so we can use it's X/Y pixel shifts
	var/matrix/M = matrix(AM.transform)

	var/pixel_x_offset = AM.pixel_x + M.get_x_shift()
	var/pixel_y_offset = AM.pixel_y + M.get_y_shift()

	//Irregular objects
	var/icon/AMicon = icon(AM.icon, AM.icon_state)
	var/AMiconheight = AMicon.Height()
	var/AMiconwidth = AMicon.Width()
	if(AMiconheight != world.icon_size || AMiconwidth != world.icon_size)
		pixel_x_offset += ((AMiconwidth/world.icon_size)-1)*(world.icon_size*0.5)
		pixel_y_offset += ((AMiconheight/world.icon_size)-1)*(world.icon_size*0.5)

	//DY and DX
	var/rough_x = round(round(pixel_x_offset,world.icon_size)/world.icon_size)
	var/rough_y = round(round(pixel_y_offset,world.icon_size)/world.icon_size)

	//Find coordinates
	var/turf/T = get_turf(AM) //use AM's turfs, as it's coords are the same as AM's AND AM's coords are lost if it is inside another atom
	if(!T)
		return null
	var/final_x = T.x + rough_x
	var/final_y = T.y + rough_y

	if(final_x || final_y)
		return locate(final_x, final_y, T.z)

/atom/movable/proc/throw_at_random(var/include_own_turf, var/maxrange, var/speed)
	var/list/turfs = RANGE_TURFS(maxrange, src)
	if(!maxrange)
		maxrange = 1

	if(!include_own_turf)
		turfs -= get_turf(src)
	src.throw_at(pick(turfs), maxrange, speed, src)
