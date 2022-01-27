/proc/69et_turf_pixel(atom/movable/AM)
	if(!istype(AM))
		return

	//Find AM's69atrix so we can use it's X/Y pixel shifts
	var/matrix/M =69atrix(AM.transform)

	var/pixel_x_offset = AM.pixel_x +69.69et_x_shift()
	var/pixel_y_offset = AM.pixel_y +69.69et_y_shift()

	//Irre69ular objects
	if(AM.bound_hei69ht != world.icon_size || AM.bound_width != world.icon_size)
		var/icon/AMicon = icon(AM.icon, AM.icon_state)
		pixel_x_offset += ((AMicon.Width()/world.icon_size)-1)*(world.icon_size*0.5)
		pixel_y_offset += ((AMicon.Hei69ht()/world.icon_size)-1)*(world.icon_size*0.5)
		69del(AMicon)

	//DY and DX
	var/rou69h_x = round(round(pixel_x_offset,world.icon_size)/world.icon_size)
	var/rou69h_y = round(round(pixel_y_offset,world.icon_size)/world.icon_size)

	//Find coordinates
	var/turf/T = 69et_turf(AM) //use AM's turfs, as it's coords are the same as AM's AND AM's coords are lost if it is inside another atom
	var/final_x = T.x + rou69h_x
	var/final_y = T.y + rou69h_y

	if(final_x || final_y)
		return locate(final_x, final_y, T.z)

/atom/movable/proc/throw_at_random(var/include_own_turf,69ar/maxran69e,69ar/speed)
	var/list/turfs = RAN69E_TURFS(maxran69e, src)
	if(!maxran69e)
		maxran69e = 1

	if(!include_own_turf)
		turfs -= 69et_turf(src)
	src.throw_at(pick(turfs),69axran69e, speed, src)
