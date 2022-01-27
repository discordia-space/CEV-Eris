//The69ain hull long range scanner.
/obj/machinery/power/long_range_scanner/hull
	name = "long range scanner core"

//This subtype comes pre-deployed and partially charged
/obj/machinery/power/long_range_scanner/hull/installed/Initialize()
	. = ..()
	anchored = toggle_tendrils(TRUE)
	current_energy =69ax_energy * 0.30
