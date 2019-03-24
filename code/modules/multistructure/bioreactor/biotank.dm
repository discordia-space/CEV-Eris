

/obj/machinery/multistructure/bioreactor_part/biotank
	name = "biomatter tank"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "tank"
	var/max_capacity = 1000
	var/obj/structure/bioreactor_connector/connector
	var/connector_down = FALSE
	var/obj/canister


/obj/machinery/multistructure/bioreactor_part/biotank/Initialize()
	..()
	create_reagents(max_capacity)


/obj/machinery/multistructure/bioreactor_part/biotank/Process()
	if(!MS)
		return
	if(canister && connector && connector.pipes)
		reagents.trans_to_holder(canister.reagents, 10)


/obj/machinery/multistructure/bioreactor_part/biotank/proc/take_amount(var/amount)
	reagents.add_reagent("biomatter", amount)



/obj/machinery/multistructure/bioreactor_part/biotank/proc/set_canister(obj/target_tank)
	target_tank.anchored = TRUE
	canister = target_tank


/obj/machinery/multistructure/bioreactor_part/biotank/proc/unset_canister(obj/target_tank)
	target_tank.anchored = FALSE
	canister = null


/obj/machinery/multistructure/bioreactor_part/biotank/proc/make_connector()
	connector = new(loc)
	connector.MS_bioreactor = MS_bioreactor


/obj/structure/bioreactor_connector
	name = "biomatter connector"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "connector"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_OBJ_LAYER
	var/datum/multistructure/bioreactor/MS_bioreactor
	var/down = FALSE
	var/pipes = FALSE
	var/init_y
	var/pixel_step = 20


/obj/structure/bioreactor_connector/Initialize()
	. = ..()
	init_y = pixel_y


/obj/structure/bioreactor_connector/update_icon()
	overlays.Cut()
	if(pipes)
		overlays += "connector-pipes"
		var/image/P = image(icon = src.icon, icon_state = "main_pipe", pixel_y = src.pixel_y-8)
		overlays += P


/obj/structure/bioreactor_connector/proc/move_on()
	if(!pipes)
		//let's detect any object with reagents
		var/obj/canister
		for(var/obj/O in get_turf(MS_bioreactor.output_port))
			if(O.reagents)
				canister = O
				break
		if(!down)
			down = TRUE
			MS_bioreactor.biotank.set_canister(canister)
			animate(src, pixel_y = pixel_y-pixel_step, time = 8, easing = CUBIC_EASING)
		else
			down = FALSE
			MS_bioreactor.biotank.unset_canister(canister)
			animate(src, pixel_y = init_y, time = 8, easing = CUBIC_EASING)


/obj/structure/bioreactor_connector/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/tool/wrench))
		if(down && pixel_y == init_y-pixel_step && MS_bioreactor.biotank.canister)
			pipes = !pipes
			update_icon()