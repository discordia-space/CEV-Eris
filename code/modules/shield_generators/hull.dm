//The main hull shield. Moving a few variables here to make it easier to branch off the parent for shortrange bubble shields and such
/obj/machinery/power/shipside/shield_generator/hull
	name = "hull shield core"
	report_integrity = TRUE

//This subtype comes pre-deployed and partially charged
/obj/machinery/power/shipside/shield_generator/hull/installed/Initialize()
	. = ..()
	anchored = TRUE
	spawn_tendrils()
	current_energy = max_energy * 0.30

