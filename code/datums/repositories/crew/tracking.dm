#define MAP_SCALAR 2.56 // Value for scaling the locations on maps , depending on the resolution of maps in  the nanoui folder.
// To calculate the map scalar , get the map res (old one was 1024) and the new map res (6400)
// divide them and get their ratio (6.25)
// divide the size of a turf/wall sprite (currently 32) by the ratio , (32/6.25 = 5.12)
// divide the new ratio to the ratio of the new mapsize / old mapsize (only if you modified the CSS Sizes in layout_default)

/* Tracking */
/crew_sensor_modifier/tracking/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	if(pos)
		var/area/A = get_area(pos)
		crew_data["area"] = sanitize(A.name)
		crew_data["real_x"] = pos.x
		crew_data["real_y"] = pos.y
		crew_data["x"] = pos.x * MAP_SCALAR
		crew_data["y"] = pos.y * MAP_SCALAR
		crew_data["z"] = pos.z
	return ..()

/* Random */
/crew_sensor_modifier/tracking/jamming
	priority = 5

/crew_sensor_modifier/tracking/jamming/localize/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	return ..(H, C, get_turf(holder), crew_data)

/crew_sensor_modifier/tracking/jamming/random
	var/shift_range = 7
	var/x_shift
	var/y_shift
	var/next_shift_change

/crew_sensor_modifier/tracking/jamming/random/moderate
	shift_range = 14

/crew_sensor_modifier/tracking/jamming/random/major
	shift_range = 21

/crew_sensor_modifier/tracking/jamming/random/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	if(world.time > next_shift_change)
		next_shift_change = world.time + rand(30 SECONDS, 2 MINUTES)
		x_shift = rand(-shift_range, shift_range)
		y_shift = rand(-shift_range, shift_range)
	if(pos)
		var/new_x = CLAMP(pos.x + x_shift, 1, world.maxx)
		var/new_y = CLAMP(pos.y + y_shift, 1, world.maxy)
		pos = locate(new_x, new_y, pos.z)
	return ..(H, C, pos, crew_data)
