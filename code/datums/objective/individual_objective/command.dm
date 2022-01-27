/datum/individual_objective/beyond
	name = "A Particular Spot"
	req_department = list(DEPARTMENT_COMMAND)
	units_requested = 569INUTES
	based_time = TRUE
	var/obj/effect/overmap/ship/linked
	var/x
	var/y
	var/timer


/datum/individual_objective/beyond/can_assign(mob/living/L)
	if(!..())
		return FALSE
	return (locate(/obj/effect/overmap/ship/eris) in GLOB.ships)

/datum/individual_objective/beyond/assign()
	..()
	x = rand(2, GLOB.maps_data.overmap_size-1)
	y = rand(2, GLOB.maps_data.overmap_size-1)
	linked = (locate(/obj/effect/overmap/ship/eris) in GLOB.ships)
	desc = "There is a69ark69ade on your old star chart. You do not remember why you did it but your curiosity wont let you sleep.  \
			Move 69linked69 to coordinates 69x69, 69y69 for 69unit2time(units_requested)69."
	timer = world.time
	RegisterSignal(linked, COMSIG_SHIP_STILL, .proc/task_completed)

/datum/individual_objective/beyond/task_completed(nx, ny, is_still)
	if(!is_still || x != nx || y != ny)
		timer = world.time
		units_completed = 0
	else
		units_completed += abs(world.time - timer)
		timer = world.time
	if(check_for_completion())
		completed()

/datum/individual_objective/beyond/completed()
	if(completed) return
	UnregisterSignal(linked, COMSIG_SHIP_STILL)
	..()
