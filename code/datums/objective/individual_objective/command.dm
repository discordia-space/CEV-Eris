#define OJECTIVE_BEYOND_TIMER 1 MINUTES //change it to 5

/datum/individual_objetive/beyond //WORK
	name = "A Particular Spot"
	req_department = DEPARTMENT_COMMAND
	var/obj/effect/overmap/ship/linked
	var/x
	var/y

/datum/individual_objetive/beyond/assign()
	..()
	x = rand(2, GLOB.maps_data.overmap_size-1)
	y = rand(2, GLOB.maps_data.overmap_size-1)
	linked = locate(/obj/effect/overmap/ship/eris)
	desc = "Move the ship [linked] to coordenates [x], [y] for [OJECTIVE_BEYOND_TIMER/(1 MINUTES)]"
	RegisterSignal(linked, COMSIG_SHIP_STILL, .proc/task_completed)

/datum/individual_objetive/beyond/task_completed(time, nx, ny)
	if(time >= OJECTIVE_BEYOND_TIMER && x == nx && y == ny)
		completed()

/datum/individual_objetive/beyond/completed()
	if(completed) return
	UnregisterSignal(linked, COMSIG_SHIP_STILL)
	..()
