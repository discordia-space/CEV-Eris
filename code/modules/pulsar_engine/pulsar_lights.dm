/turf/space/pulsar
	var/obj/machinery/pulsar/linked

/turf/space/pulsar/New()
	testing("HONK")
	var/list/turfs = get_area_turfs(/area/outpost/pulsar)
	testing("---- Detected turfs: [turfs.len]")
	linked = locate(/obj/machinery/pulsar) in get_area_turfs(/area/outpost/pulsar)
	testing("---- Linked: [linked]")
	RegisterSignal(linked, COMSIG_PULSAR_LIGHTS, .proc/update_starlight)
	..()

/turf/space/pulsar/Destroy()
	UnregisterSignal(linked, COMSIG_PULSAR_LIGHTS)
	linked = null
	..()

/turf/space/pulsar/update_starlight(intensity=1)
	admin_notice("Update turfs with intensity: [intensity]")
	if(intensity && (locate(/turf/simulated) in RANGE_TURFS(1, src)))
		// Increase both radius and brightness
		set_light(intensity, intensity, PULSAR_COLOR)
	else
		set_light(0)