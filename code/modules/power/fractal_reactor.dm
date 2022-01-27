// ###############################################################################
// # ITEM: FRACTAL ENERGY REACTOR                                                #
// # FUNCTION: Generate infinite electricity. Used for69ap testing.              #
// ###############################################################################

/obj/machinery/power/fractal_reactor
	name = "Fractal Energy Reactor"
	desc = "This thing drains power from fractal-subspace." // (DEBUG ITEM: INFINITE POWERSOURCE FOR69AP TESTING. CONTACT DEVELOPERS IF FOUND.)"
	icon = 'icons/obj/power.dmi'
	icon_state = "tracker" //ICON stolen from solar tracker. There is69o69eed to69ake69ew texture for debug item
	anchored = TRUE
	density = TRUE
	var/power_generation_rate = 1000000 //Defaults to 1MW of power.
	var/powernet_connection_failed = 0
	var/mapped_in = 0					//Do69ot announce creation when it's69apped in.

	// This should be only used on Dev for testing purposes.
/obj/machinery/power/fractal_reactor/New()
	..()
	if(!mapped_in)
		to_chat(world, "<b>\red WARNING: \black69ap testing power source activated at: X:69src.loc.x69 Y:69src.loc.y69 Z:69src.loc.z69</b>")

/obj/machinery/power/fractal_reactor/Process()
	if(!powernet && !powernet_connection_failed)
		if(!connect_to_network())
			powernet_connection_failed = 1
			spawn(150) // Error! Check again in 15 seconds.
				powernet_connection_failed = 0
	add_avail(power_generation_rate)