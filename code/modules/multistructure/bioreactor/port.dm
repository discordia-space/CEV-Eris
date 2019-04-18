

/obj/machinery/multistructure/bioreactor_part/bioport
	name = "biomatter port"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "port"
	layer = LOW_OBJ_LAYER
	density = FALSE


//TEMPORARY
/obj/machinery/multistructure/bioreactor_part/bioport/attack_hand(mob/user)
	if(MS_bioreactor.chamber_solution && MS_bioreactor.is_operational())
		world << "nope"
	else
		MS_bioreactor.toggle_platform_door()