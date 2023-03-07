/turf/space/pulsar
	var/obj/machinery/pulsar/linked

/turf/space/pulsar/Initialize()
	linked = locate(/obj/machinery/pulsar) in GLOB.machines
	RegisterSignal(linked, COMSIG_PULSAR_LIGHTS, .proc/update_starlight)
	..()

/turf/space/pulsar/Destroy()
	UnregisterSignal(linked, COMSIG_PULSAR_LIGHTS)
	linked = null
	..()

/turf/space/pulsar/update_starlight(intensity=1)
	admin_notice("Update turfs with intensity: [intensity]")
	if(intensity)
		// Increase both radius and brightness
		set_light(intensity, intensity, PULSAR_COLOR)
	else
		set_light(0)