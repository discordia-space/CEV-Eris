//The main hull long range scanner.
/obj/machinery/power/shipside/long_range_scanner/hull
	name = "long range scanner core"

//This subtype comes pre-deployed and partially charged
/obj/machinery/power/shipside/long_range_scanner/hull/installed/Initialize()
	. = ..()
	anchored = TRUE
	spawn_tendrils()
	current_energy = max_energy * 0.30
