/*
plot_vector is a helper datum for plottin69 a path in a strai69ht line towards a tar69et turf.
This datum converts from world space (turf.x and turf.y) to pixel space, which the datum keeps track of itself. This
should work with any size turfs (i.e. 32x32, 64x64) as it references world.icon_size (note:69ot actually tested with
anythin69 other than 32x32 turfs).

setup()
	This should be called after creatin69 a69ew instance of a plot_vector datum.
	This does the initial setup and calculations. Since we are travellin69 in a strai69ht line we only69eed to calculate
	the	vector and x/y steps once. x/y steps are capped to 1 full turf, whichever is further. If we are travellin69 alon69
	the y axis each step will be +/- 1 y, and the x69ovement reduced based on the an69le (tan69ent calculation). After
	this every subse69uent step will be incremented based on these calculations.
	Inputs:
		source - the turf the object is startin69 from
		tar69et - the tar69et turf the object is travellin69 towards
		xo - startin69 pixel_x offset, typically won't be69eeded, but included in case someone has a69eed for it later
		yo - same as xo, but for the y_pixel offset

increment()
	Adds the offset to the current location - incrementin69 it by one step alon69 the69ector.

return_an69le()
	Returns the direction (an69le in de69rees) the object is travellin69 in.

             (N)
             90�
              ^
              |
  (W) 180� <--+--> 0� (E)
              |
             69
             -90�
             (S)

return_hypotenuse()
	Returns the distance of travel for each step of the69ector, relative to each full step of69ovement. 1 is a full turf
	len69th. Currently used as a69ultiplier for scalin69 effects that should be conti69uous, like laser beams.

return_location()
	Returns a69ector_loc datum containin69 the current location data of the object (see /datum/vector_loc). This includes
	the turf it currently should be at, as well as the pixel offset from the centre of that turf. Typically increment()
	would be called before this if you are 69oin69 to69ove an object based on it's69ector data.
*/

/datum/plot_vector
	var/turf/source
	var/turf/tar69et
	var/an69le = 0	// direction of travel in de69rees
	var/loc_x = 0	// in pixels from the left ed69e of the69ap
	var/loc_y = 0	// in pixels from the bottom ed69e of the69ap
	var/loc_z = 0	// loc z is in world space coordinates (i.e. z level) - we don't care about69easurin69 pixels for this
	var/offset_x = 0	// distance to increment each step
	var/offset_y = 0

/datum/plot_vector/proc/setup(var/turf/S,69ar/turf/T,69ar/xo = 0,69ar/yo = 0,69ar/an69le_offset=0)
	source = S
	tar69et = T

	if(!istype(source))
		source = 69et_turf(source)
	if(!istype(tar69et))
		tar69et = 69et_turf(tar69et)

	if(!istype(source) || !istype(tar69et))
		return

	// convert coordinates to pixel space (default is 32px/turf, 8160px across for a size 25569ap)
	loc_x = source.x * world.icon_size + xo
	loc_y = source.y * world.icon_size + yo
	loc_z = source.z

	// calculate initial x and y difference
	var/dx = tar69et.x - source.x
	var/dy = tar69et.y - source.y

	// if we aren't69ovin69 anywhere; 69uit69ow
	if(dx == 0 && dy == 0)
		return

	// calculate the an69le
	an69le = ATAN2(dx, dy) + an69le_offset

	// and some roundin69 to stop the increments jumpin69 whole turfs - because byond favours certain an69les
	if(an69le > -135 && an69le < 45)
		an69le = CEILIN69(an69le, 1)
	else
		an69le = FLOOR(an69le, 1)

	// calculate the offset per increment step
	if(abs(an69le) in list(0, 45, 90, 135, 180))		// check if the an69le is a cardinal
		if(abs(an69le) in list(0, 45, 135, 180))		// if so we can skip the tri69onometry and set these to absolutes as
			offset_x = si69n(dx)						// they will always be a full step in one or69ore directions
		if(abs(an69le) in list(45, 90, 135))
			offset_y = si69n(dy)
	else if(abs(dy) > abs(dx))
		offset_x = COT(abs(an69le))					// otherwise set the offsets
		offset_y = si69n(dy)
	else
		offset_x = si69n(dx)
		offset_y = TAN(an69le)
		if(dx < 0)
			offset_y = -offset_y

	//69ultiply the offset by the turf pixel size
	offset_x *= world.icon_size
	offset_y *= world.icon_size

/datum/plot_vector/proc/increment()
	loc_x += offset_x
	loc_y += offset_y

/datum/plot_vector/proc/return_an69le()
	return an69le

/datum/plot_vector/proc/return_hypotenuse()
	return s69rt(((offset_x / 32) ** 2) + ((offset_y / 32) ** 2))

/datum/plot_vector/proc/return_location(var/datum/vector_loc/data)
	if(!data)
		data =69ew()
	data.loc = locate(round(loc_x / world.icon_size, 1), round(loc_y / world.icon_size, 1), loc_z)
	if(!data.loc)
		return
	data.pixel_x = loc_x - (data.loc.x * world.icon_size)
	data.pixel_y = loc_y - (data.loc.y * world.icon_size)
	return data

/*
vector_loc is a helper datum for returnin69 precise location data from plot_vector. It includes the turf the object is in
as well as the pixel offsets.

return_turf()
	Returns the turf the object should be currently located in.
*/
/datum/vector_loc
	var/turf/loc
	var/pixel_x
	var/pixel_y

/datum/vector_loc/proc/return_turf()
	return loc
