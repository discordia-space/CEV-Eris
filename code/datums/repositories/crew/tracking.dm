
#define MAP_SCALAR 1.285 // Value for scaling the locations on maps , depending on the resolution of maps in  the nanoui folder.
// if you update this , also go to crew_monitor_map_content.tmpl and update the division, same for crew_monitor.tmpl and sec_camera_map_content.tmpl
/* Tracking */
/crew_sensor_modifier/tracking/process_crew_data(var/mob/living/carbon/human/H, var/obj/item/clothing/under/C, var/turf/pos, var/list/crew_data)
	if(pos)
		var/area/A = get_area(pos)
		crew_data["area"] = sanitize(A.name)
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
