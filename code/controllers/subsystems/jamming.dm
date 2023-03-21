// Used to check if a spot is currently being jammed
// Can be used for telecomms or other stuff ,but right now its used for AI control

SUBSYSTEM_DEF(jamming)
	name = "Jamming"
	init_order = INIT_ORDER_JAMMING
	flags = SS_NO_FIRE
	var/datum/component/jamming/active_jammers

/datum/controller/subsystem/jamming/Initialize(start_timeofday)
	active_jammers = new /list(world.maxz)
	for(var/i = 1, i < world.maxz; i++)
		active_jammers[i] = list()
	. = ..()


/datum/controller/subsystem/jamming/proc/IsPositionJammed(turf/location, signalStrength)
	for(var/datum/component/jamming/jammer in active_jammers[location.z])
		var/distance = get_dist(jammer.owner, location)
		if(distance > jammer.radius)
			continue
		if((1.1 - distance / jammer.radius) * jammer.power > signalStrength)
			return TRUE
	return FALSE

