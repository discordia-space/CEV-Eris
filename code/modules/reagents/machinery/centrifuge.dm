/obj/machinery/centrifuge
	name = "centrifuge"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b"
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	circuit = /obj/item/weapon/circuitboard/centrifuge
	var/obj/item/weapon/reagent_containers/mainBeaker
	var/list/obj/item/weapon/reagent_containers/separationBeakers = list()
	var/workTime = 12 SECONDS
	var/lastActivation = 0
	var/on = FALSE
	var/beakerSlots = 3

/obj/machinery/centrifuge/Initialize(mapload, d)
	. = ..()
	for(var/i = 1 to beakerSlots)
		separationBeakers += new /obj/item/weapon/reagent_containers/glass/beaker(src)

/obj/machinery/centrifuge/Destroy()
	qdel(mainBeaker)
	QDEL_NULL_LIST(separationBeakers)
	return ..()

/obj/machinery/centrifuge/update_icon()
//	if(on)
	if(mainBeaker)
		icon_state = "mixer1b"
	else
		icon_state = "mixer0b"

/obj/machinery/centrifuge/RefreshParts()
	workTime = initial(workTime)
	/*workTime = max(2 SECONDS, workTime / maxPartRating(/obj/item/weapon/stock_parts/manipulator))
	beakerSlots = initial(beakerSlots)
	if(maxPartRating(/obj/item/weapon/stock_parts/manipulator) > 1)
		beakerSlots += (maxPartRating(/obj/item/weapon/stock_parts/manipulator))*/


/obj/machinery/centrifuge/Process()
	..()
	if(stat & NOPOWER)
		return
	if(on)
		if(world.time >= lastActivation + workTime)
			on = FALSE
			mainBeaker.reagents.isHighlyGravitated = FALSE
			mainBeaker.reagents.handle_reactions()
			update_icon()

		mainBeaker.reagents.isHighlyGravitated = TRUE
		mainBeaker.reagents.handle_reactions()
		mainBeaker.separateSolution(separationBeakers, 2, mainBeaker.reagents.get_master_reagent_id())
		

		SSnano.update_uis(src)

/obj/machinery/centrifuge/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return


	if(istype(I, /obj/item/weapon/reagent_containers) && I.is_open_container())
		. = TRUE //no afterattack
		var/obj/item/weapon/reagent_containers/B = I
		if(!user.unEquip(B, src))
			return
		mainBeaker = B
		to_chat(user, SPAN_NOTICE("You add [B] to [src]."))
		updateUsrDialog()
		update_icon()

		on = TRUE
		lastActivation = world.time
		return
	return ..()

/obj/machinery/centrifuge/on_deconstruction()
	on = FALSE
	if(mainBeaker)
		mainBeaker.forceMove(get_turf(src))
		mainBeaker.reagents.isHighlyGravitated = FALSE
		mainBeaker = null
	for(var/obj/item/I in separationBeakers)
		I.forceMove(get_turf(src))
	separationBeakers = list()
	..()


/obj/item/makeshiftCentrifuge
	name = "makeshift centrifuge"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b"
	var/obj/item/weapon/reagent_containers/mainBeaker
	var/list/obj/item/weapon/reagent_containers/separationBeakers = list()
	var/beakerSlots = 2

/obj/item/makeshiftCentrifuge/update_icon()
//	if(on)
	/*if(beaker)
		icon_state = "mixer1b"
	else
		icon_state = "mixer0b"
	*/

/obj/item/makeshiftCentrifuge/Initialize()
	. = ..()
	for(var/i = 1 to beakerSlots)
		separationBeakers += new /obj/item/weapon/reagent_containers/glass/beaker(src)

/obj/item/makeshiftCentrifuge/Destroy()
	QDEL_NULL(mainBeaker)
	return ..()

/obj/item/makeshiftCentrifuge/handle_atom_del(atom/A)
	..()
	if(A == mainBeaker)
		mainBeaker = null
		update_icon()

/obj/item/makeshiftCentrifuge/attack_self(mob/user)
	if(mainBeaker && mainBeaker.reagents.total_volume)
		mainBeaker.reagents.isHighlyGravitated = TRUE
		mainBeaker.reagents.handle_reactions()
		mainBeaker.separateSolution(separationBeakers, 2, mainBeaker.reagents.get_master_reagent_id())
		mainBeaker.reagents.isHighlyGravitated = FALSE
		SSnano.update_uis(src)

/obj/item/makeshiftCentrifuge/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(mainBeaker, usr))
		mainBeaker = null
	else
		return ..()

/obj/item/makeshiftCentrifuge/attackby(obj/item/C, mob/living/user)
	if(istype(C, /obj/item/weapon/reagent_containers) && !mainBeaker && insert_item(C, user))
		to_chat(user, SPAN_NOTICE("You add [C] to [src]."))
		src.mainBeaker = C
