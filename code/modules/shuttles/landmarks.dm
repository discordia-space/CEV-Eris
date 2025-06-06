//making this separate from /obj/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "Nav Point"
	icon = 'icons/misc/landmarks.dmi'
	icon_state = "shuttle-blue"
	alpha = 120
	anchored = TRUE
	unacidable = 1
	simulated = FALSE
	invisibility = 101

	var/landmark_tag
	//ID of the controller on the shuttle
	var/datum/computer/file/embedded_program/docking/docking_controller

	var/dock_target

	//when the shuttle leaves this landmark, it will leave behind the base area
	//also used to determine if the shuttle can arrive here without obstruction
	var/area/base_area
	//Will also leave this type of turf behind if set.
	var/turf/base_turf


	// If a pilot of some shuttle can potentially choose this landmark as a destination
	// Used for in-transit landmarks and automated shuttles like escape pods
	var/is_valid_destination = TRUE

	// Name of the shuttle this landmark belongs to, if left empty - any shuttle can park on it
	// Used to mark home/origin docking ports and approach vectors for hostile shuttles
	var/shuttle_restricted // = "Mercenary"

	// Makes landmark only reacheable by "exploraion shuttles", which
	// normally includes ship-side faction shuttles and excludes antagonist shuttles
	// Used to make it so raiders can only go mess with the ship
	var/exploration_landmark = FALSE


/obj/effect/shuttle_landmark/Initialize()
	tag = copytext(landmark_tag, 1) //since tags cannot be set at compile time
	base_area = locate(base_area || world.area)
	name = name + " ([x],[y])"
	..()
	return INITIALIZE_HINT_LATELOAD

// /obj/machinery/embedded_controller/radio/airlock/docking_port
// /datum/computer/file/embedded_program/docking

/obj/effect/shuttle_landmark/LateInitialize()
	SSshuttle.register_landmark(src)
	if(docking_controller)
		var/docking_tag = docking_controller
		docking_controller = locate(docking_tag)

/obj/effect/shuttle_landmark/proc/is_valid(var/datum/shuttle/shuttle)
	if(shuttle.current_location == src)
		return FALSE
	for(var/area/A in shuttle.shuttle_area)
		var/list/translation = get_turf_translation(get_turf(shuttle.current_location), get_turf(src), A.contents)
		if(check_collision(translation))
			return FALSE
	return TRUE


/obj/effect/shuttle_landmark/proc/check_collision(var/list/turf_translation)
	for(var/source in turf_translation)
		var/turf/target = turf_translation[source]
		if(!target)
			return TRUE //collides with edge of map
		if(target.loc != base_area)
			return TRUE //collides with another area
		if(target.density)
			return TRUE //dense turf
	return FALSE

/proc/check_collision(area/target_area, list/target_turfs)
	for(var/target_turf in target_turfs)
		var/turf/target = target_turf
		if(!target)
			return TRUE //collides with edge of map
		if(target.loc != target_area)
			return TRUE //collides with another area
		if(target.density)
			return TRUE //dense turf
	return FALSE
