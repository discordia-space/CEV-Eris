/obj/machinery/bluespace_beacon

	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "Bluespace Gigabeacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	level = BELOW_PLATING_LEVEL		// underfloor
	layer = LOW_OBJ_LAYER
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 0
	var/obj/item/device/radio/beacon/Beacon

	New()
		..()
		var/turf/T = loc
		Beacon = new /obj/item/device/radio/beacon
		Beacon.invisibility = INVISIBILITY_MAXIMUM
		Beacon.loc = T

		hide(!T.is_plating())

	Destroy()
		if(Beacon)
			qdel(Beacon)
		. = ..()

	// update the invisibility and icon
	hide(var/intact)
		invisibility = intact ? 101 : 0
		updateicon()

	// update the icon_state
	proc/updateicon()
		var/state="floor_beacon"

		if(invisibility)
			icon_state = "[state]f"

		else
			icon_state = "[state]"

	Process()
		if(!Beacon)
			var/turf/T = loc
			Beacon = new /obj/item/device/radio/beacon
			Beacon.invisibility = INVISIBILITY_MAXIMUM
			Beacon.loc = T
		if(Beacon)
			if(Beacon.loc != loc)
				Beacon.loc = loc

		updateicon()


