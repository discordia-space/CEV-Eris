//The main hull shield. Moving a few variables here to make it easier to branch off the parent for shortrange bubble shields and such
/obj/machinery/power/shield_generator/hull
	name = "hull shield core"
	report_integrity = TRUE

//This subtype comes pre-deployed and partially charged
/obj/machinery/power/shield_generator/hull/installed/Initialize()
	. = ..()
	anchored = toggle_tendrils(TRUE)
	current_energy = max_energy * 0.30

