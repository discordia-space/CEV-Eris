/obj/machinery/floorlayer

	name = "automatic floor layer"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	var/turf/old_turf
	var/on = FALSE
	var/obj/item/stack/tile/T
	var/list/mode = list("dismantle"=0,"layin69"=0,"collect"=0)

/obj/machinery/floorlayer/New()
	T = new/obj/item/stack/tile/floor(src)
	..()

/obj/machinery/floorlayer/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	. = ..()

	if(on)
		if(mode69"dismantle"69)
			dismantleFloor(old_turf)

		if(mode69"layin69"69)
			layFloor(old_turf)

		if(mode69"collect"69)
			CollectTiles(old_turf)


	old_turf = NewLoc

/obj/machinery/floorlayer/attack_hand(mob/user as69ob)
	on=!on
	user.visible_messa69e("<span class='notice'>69user69 has 69!on?"de":""69activated \the 69src69.</span>", "<span class='notice'>You 69!on?"de":""69activate \the 69src69.</span>")
	return

/obj/machinery/floorlayer/attackby(var/obj/item/W as obj,69ar/mob/user as69ob)

	if (istype(W, /obj/item/tool/wrench))
		var/m = input("Choose work69ode", "Mode") as null|anythin69 in69ode
		mode69m69 = !mode69m69
		var/O =69ode69m69
		user.visible_messa69e("<span class='notice'>69usr69 has set \the 69src69 69m6969ode 69!O?"off":"on"69.</span>", "<span class='notice'>You set \the 69src69 69m6969ode 69!O?"off":"on"69.</span>")
		return

	if(istype(W, /obj/item/stack/tile))
		to_chat(user, SPAN_NOTICE("\The 69W69 successfully loaded."))
		user.drop_item(T)
		TakeTile(T)
		return

	if(istype(W, /obj/item/tool/crowbar))
		if(!len69th(contents))
			to_chat(user, SPAN_NOTICE("\The 69src69 is empty."))
		else
			var/obj/item/stack/tile/E = input("Choose remove tile type.", "Tiles") as null|anythin69 in contents
			if(E)
				to_chat(user, SPAN_NOTICE("You remove the 69E69 from /the 69src69."))
				E.loc = src.loc
				T = null
		return

	if(istype(W, /obj/item/tool/screwdriver))
		T = input("Choose tile type.", "Tiles") as null|anythin69 in contents
		return
	..()

/obj/machinery/floorlayer/examine(mob/user)
	..()
	var/dismantle =69ode69"dismantle"69
	var/layin69 =69ode69"layin69"69
	var/collect =69ode69"collect"69
	to_chat(user, "<span class='notice'>\The 69src69 69!T?"don't ":""69has 69!T?"":"69T.69et_amount()69 69T69 "69tile\s, dismantle is 69dismantle?"on":"off"69, layin69 is 69layin69?"on":"off"69, collect is 69collect?"on":"off"69.</span>")

/obj/machinery/floorlayer/proc/reset()
	on=0
	return

/obj/machinery/floorlayer/proc/dismantleFloor(var/turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_platin69())
			T.make_platin69(!(T.broken || T.burnt))
	return new_turf.is_platin69()

/obj/machinery/floorlayer/proc/TakeNewStack()
	for(var/obj/item/stack/tile/tile in contents)
		T = tile
		return 1
	return 0

/obj/machinery/floorlayer/proc/SortStacks()
	for(var/obj/item/stack/tile/tile1 in contents)
		for(var/obj/item/stack/tile/tile2 in contents)
			tile2.transfer_to(tile1)

/obj/machinery/floorlayer/proc/layFloor(var/turf/w_turf)
	if(!T)
		if(!TakeNewStack())
			return 0
	w_turf.attackby(T , src)
	return 1

/obj/machinery/floorlayer/proc/TakeTile(var/obj/item/stack/tile/tile)
	if(!T)	T = tile
	tile.loc = src

	SortStacks()

/obj/machinery/floorlayer/proc/CollectTiles(var/turf/w_turf)
	for(var/obj/item/stack/tile/tile in w_turf)
		TakeTile(tile)
