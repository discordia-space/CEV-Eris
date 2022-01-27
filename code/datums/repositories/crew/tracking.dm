/* Tracking */
/crew_sensor_modifier/tracking/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	if(pos)
		var/area/A = get_area(pos)
		crew_data69"area"69 = sanitize(A.name)
		crew_data69"x"69 = pos.x
		crew_data69"y"69 = pos.y
		crew_data69"z"69 = pos.z
	return ..()

/* Random */
/crew_sensor_modifier/tracking/jamming
	priority = 5

/crew_sensor_modifier/tracking/jamming/localize/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
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

/crew_sensor_modifier/tracking/jamming/random/process_crew_data(var/mob/living/carbon/human/H,69ar/obj/item/clothing/under/C,69ar/turf/pos,69ar/list/crew_data)
	if(world.time > next_shift_change)
		next_shift_change = world.time + rand(30 SECONDS, 269INUTES)
		x_shift = rand(-shift_range, shift_range)
		y_shift = rand(-shift_range, shift_range)
	if(pos)
		var/new_x = CLAMP(pos.x + x_shift, 1, world.maxx)
		var/new_y = CLAMP(pos.y + y_shift, 1, world.maxy)
		pos = locate(new_x, new_y, pos.z)
	return ..(H, C, pos, crew_data)
