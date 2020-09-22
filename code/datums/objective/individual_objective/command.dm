/datum/individual_objective/beyond
	name = "A Particular Spot"
	req_department = list(DEPARTMENT_COMMAND)
	var/objective_timer = 3 MINUTES//change to 5
	var/obj/effect/overmap/ship/linked
	var/x
	var/y

/datum/individual_objective/beyond/assign()
	..()
	x = rand(2, GLOB.maps_data.overmap_size-1)
	y = rand(2, GLOB.maps_data.overmap_size-1)
	linked = locate(/obj/effect/overmap/ship/eris)
	desc = "Move [linked] to coordenates [x], [y] for [unit2time(objective_timer)]"
	RegisterSignal(linked, COMSIG_SHIP_STILL, .proc/task_completed)

/datum/individual_objective/beyond/task_completed(time, nx, ny)
	if(time >= objective_timer && x == nx && y == ny)
		completed()

/datum/individual_objective/beyond/completed()
	if(completed) return
	UnregisterSignal(linked, COMSIG_SHIP_STILL)
	..()
