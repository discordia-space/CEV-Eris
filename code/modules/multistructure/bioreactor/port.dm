

/obj/machinery/multistructure/bioreactor_part/bioport
	name = "biomatter port"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "port"
	layer = LOW_OBJ_LAYER
	density = FALSE


/obj/machinery/multistructure/bioreactor_part/bioport/MouseDrop_T(obj/structure/bioreactor_connector/connector, mob/user as mob)
	if(istype(connector))
		connector.move_on()