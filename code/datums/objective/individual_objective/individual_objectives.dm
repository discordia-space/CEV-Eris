
/datum/individual_objetive/casda
	name = "common"

#define OJECTIVE_BEYOND_TIMER 5 MINUTES

/datum/individual_objetive/beyond
	name = "A Particular Spot"
	req_department = DEPARTMENT_COMMAND
	var/x
	var/y


/datum/individual_objetive/beyond/assign()
	..()
	x = rand(2, GLOB.maps_data.overmap_size-1)
	y = rand(2, GLOB.maps_data.overmap_size-1)
	RegisterSignal(owner, COMSIG_SHIP_STILL, .proc/task_completed)

/datum/individual_objetive/beyond/get_description()
	return "Move the ship to coordenates [x], [y] for 5 minutes"

/datum/individual_objetive/beyond/task_completed(nx, ny)
	admin_notice(SPAN_DANGER("esta es x [nx] y esta es y [ny]."))
	if(x == nx && y == ny)
		completed()

/datum/individual_objetive/beyond/completed()
    UnregisterSignal(owner, COMSIG_SHIP_STILL)
    ..()

