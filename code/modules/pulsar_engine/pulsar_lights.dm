/obj/effect/effect/light/pulsar
	name = "pulsar light"

/obj/effect/effect/light/pulsar/New(var/newloc)
	// Default initialization
	..(newloc, 1, 1, PULSAR_COLOR, FALSE)
	// Register to signal that updates all pulsar lights
	RegisterSignal(src, COMSIG_PULSAR_LIGHTS, .proc/update_pulsar_light)

/obj/effect/effect/light/pulsar/Destroy()
	UnregisterSignal(src, COMSIG_PULSAR_LIGHTS)
	..()

/obj/effect/effect/light/pulsar/proc/update_pulsar_light(intensity)
	log_world("Update with intensity: [intensity]")
	// Increase both radius and brightness
	set_light(intensity, intensity, PULSAR_COLOR)
