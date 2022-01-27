//The69ain hull shield.69oving a few69ariables here to69ake it easier to branch off the parent for shortrange bubble shields and such
/obj/machinery/power/shield_generator/hull
	name = "hull shield core"
	report_integrity = TRUE

//This subtype comes pre-deployed and partially charged
/obj/machinery/power/shield_generator/hull/installed/Initialize()
	. = ..()
	anchored = toggle_tendrils(TRUE)
	current_energy =69ax_energy * 0.30

