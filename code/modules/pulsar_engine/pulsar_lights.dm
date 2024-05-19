/turf/space/pulsar
	var/obj/machinery/pulsar/linked

/turf/space/pulsar/Initialize()
	linked = locate(/obj/machinery/pulsar) in GLOB.machines
	RegisterSignal(linked, COMSIG_PULSAR_LIGHTS, PROC_REF(update_starlight))
	..()

/turf/space/pulsar/Destroy()
	UnregisterSignal(linked, COMSIG_PULSAR_LIGHTS)
	linked = null
	..()

/turf/space/pulsar/update_starlight(intensity=1)
	if(intensity)
		// Increase both radius and brightness
		set_light(intensity, intensity, PULSAR_COLOR)
	else
		set_light(0)
