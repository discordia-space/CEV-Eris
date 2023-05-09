// Used to check if a spot is currently being jammed
// Can be used for telecomms or other stuff ,but right now its used for AI control

SUBSYSTEM_DEF(jamming)
	name = "Jamming"
	init_order = INIT_ORDER_JAMMING
	flags = SS_NO_FIRE
	var/list/active_jammers

/datum/controller/subsystem/jamming/Initialize(start_timeofday)
	active_jammers = new /list(world.maxz)
	for(var/i = 1, i < world.maxz; i++)
		active_jammers[i] = list()
	. = ..()

/datum/controller/subsystem/jamming/proc/IsPositionJammed(turf/location, signalStrength)
	for(var/thing in active_jammers[location.z])
		// blame linters being shit
		var/datum/component/jamming/jammer = thing
		var/distance = get_dist_euclidian(jammer.highest_container, location)
		var/radius = jammer.radius - abs((jammer.highest_container.z - location.z) * jammer.z_reduction)
		// incase its  multi-Z jammer with distance reduction
		if(distance > radius)
			continue
		if((1.1 - distance / radius) * jammer.power > signalStrength)
			return TRUE
	return FALSE

