/datum/map_template/shuttle
	name = "Base Shuttle Template"
	var/prefix = "_maps/shuttles/"
	var/suffix
	/**
	 * Port ID is the place this template should be docking at, set on '/obj/docking_port/stationary'
	 * Because getShuttle() compares port_id to shuttle_id to find an already existing shuttle,
	 * you should set shuttle_id to be the same as port_id if you want them to be replacable.
	 */
	var/port_id




/obj/effect/something_something/docking_port
	name = "test"
//	icon =
//	icon_state =
	dir = SOUTH
	var/shuttle_type
	var/require_clearance
	var/prespawned_shuttle

