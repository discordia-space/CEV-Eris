// Used to check if a spot is currently being jammed
// Can be used for telecomms or other stuff ,but right now its used for AI control

SUBSYSTEM_DEF(jamming)
	name = "Jamming"
	init_order = INIT_ORDER_JAMMING
	flags = SS_NO_FIRE
	var/list/datum/component/jamming/active_jammers

/datum/controller/subsystem/jamming/Initialize(start_timeofday)
	active_jammers = new /list(world.maxz)
	for(var/i = 1, i < world.maxz; i++)
		active_jammers[i] = list()
	. = ..()

/datum/controller/subsystem/jamming/proc/IsPositionJammed(turf/location, signalStrength)
	var/distance = 0
	var/radius = 0
	var/turf/tempRef = null
	for(var/datum/component/jamming/jammer as anything in active_jammers[location.z])
		distance = get_dist_euclidian(jammer.owner, location)
		tempRef = get_turf(jammer.owner)
		radius = jammer.radius - abs((tempRef.z - location.z) * jammer.z_reduction)
		// incase its  multi-Z jammer with distance reduction
		if(distance > radius)
			continue
		if((1.1 - distance / radius) * jammer.power > signalStrength)
			return TRUE
	return FALSE

