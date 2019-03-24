//TODO
//redone generator part as power and update biogenerator MS with it
//Make ui for biogenerator console
//Rework all parts to /power/


/datum/multistructure/biogenerator
	structure = list(
		list(/obj/machinery/multistructure/biogenerator_part/generator, /obj/machinery/multistructure/biogenerator_part/console, /obj/machinery/multistructure/biogenerator_part/port)
					)
	var/obj/machinery/multistructure/biogenerator_part/console/screen
	var/obj/machinery/multistructure/biogenerator_part/port/port
	var/obj/machinery/multistructure/biogenerator_part/generator/generator


/datum/multistructure/biogenerator/connect_elements()
	..()
	screen = 		locate() in elements
	port = 			locate() in elements
	generator = 	locate() in elements


/datum/multistructure/biogenerator/Process()
	if(port.tank && port.tank.reagents.remove_reagent("biomatter", 1))
		world << "i'm just eated 1 biomatter for no reason. How about this?"


/obj/machinery/multistructure/biogenerator_part
	name = "biogenerator part"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "biomassconsole1"
	anchored = TRUE
	density = TRUE
	MS_type = /datum/multistructure/biogenerator


//console
/obj/machinery/multistructure/biogenerator_part/console
	name = "biogenerator screens"


//port
/obj/machinery/multistructure/biogenerator_part/port
	name = "biogenerator port"
	density = FALSE
	var/obj/structure/reagent_dispensers/tank


/obj/machinery/multistructure/biogenerator_part/port/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/tool/wrench))
		if(tank)
			tank.anchored = FALSE
			tank = null
		else
			tank = locate(/obj/structure/reagent_dispensers) in get_turf(src)
			if(tank)
				tank.anchored = TRUE



//generator
/obj/machinery/multistructure/biogenerator_part/generator
	name = "biogenerator core"