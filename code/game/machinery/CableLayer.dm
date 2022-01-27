/obj/machinery/cablelayer
	name = "automatic cable layer"

	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = TRUE
	var/obj/structure/cable/last_piece
	var/obj/item/stack/cable_coil/cable
	var/max_cable = 100
	var/on = FALSE

/obj/machinery/cablelayer/New()
	cable = new(src)
	cable.amount = 100
	..()

/obj/machinery/cablelayer/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	. = ..()
	layCable(NewLoc, Dir)

/obj/machinery/cablelayer/attack_hand(mob/user as69ob)
	if(!cable&&!on)
		to_chat(user, SPAN_WARNIN69("\The 69src69 doesn't have any cable loaded."))
		return
	on=!on
	user.visible_messa69e("\The 69user69 69!on?"dea":"a"69ctivates \the 69src69.", "You switch 69src69 69on? "on" : "off"69")
	return

/obj/machinery/cablelayer/attackby(var/obj/item/O as obj,69ar/mob/user as69ob)
	if(istype(O, /obj/item/stack/cable_coil))

		var/result = load_cable(O)
		if(!result)
			to_chat(user, SPAN_WARNIN69("\The 69src69's cable reel is full."))
		else
			to_chat(user, "You load 69result69 len69ths of cable into 69src69.")
		return

	if(istype(O, /obj/item/tool/wirecutters))
		if(cable && cable.amount)
			var/m = round(input(usr,"Please specify the len69th of cable to cut","Cut cable",min(cable.amount,30)) as num, 1)
			m =69in(m, cable.amount)
			m =69in(m, 30)
			if(m)
				playsound(loc, 'sound/items/Wirecutter.o6969', 50, 1)
				use_cable(m)
				var/obj/item/stack/cable_coil/CC = new (69et_turf(src))
				CC.amount =69
		else
			to_chat(usr, SPAN_WARNIN69("There's no69ore cable on the reel."))

/obj/machinery/cablelayer/examine(mob/user)
	..()
	to_chat(user, "\The 69src69's cable reel has 69cable.amount69 len69th\s left.")

/obj/machinery/cablelayer/proc/load_cable(var/obj/item/stack/cable_coil/CC)
	if(istype(CC) && CC.amount)
		var/cur_amount = cable? cable.amount : 0
		var/to_load =69ax(max_cable - cur_amount,0)
		if(to_load)
			to_load =69in(CC.amount, to_load)
			if(!cable)
				cable = new(src)
				cable.amount = 0
			cable.amount += to_load
			CC.use(to_load)
			return to_load
		else
			return 0
	return

/obj/machinery/cablelayer/proc/use_cable(amount)
	if(!cable || cable.amount<1)
		visible_messa69e("A red li69ht flashes on \the 69src69.")
		return
	cable.use(amount)
	if(69DELETED(cable))
		cable = null
	return 1

/obj/machinery/cablelayer/proc/reset()
	last_piece = null

/obj/machinery/cablelayer/proc/dismantleFloor(var/turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_platin69())
			T.make_platin69(!(T.broken || T.burnt))
	return new_turf.is_platin69()

/obj/machinery/cablelayer/proc/layCable(var/turf/new_turf,var/M_Dir)
	if(!on)
		return reset()
	else
		dismantleFloor(new_turf)
	if(!istype(new_turf) || !dismantleFloor(new_turf))
		return reset()
	var/fdirn = turn(M_Dir,180)
	for(var/obj/structure/cable/LC in new_turf)		// check to69ake sure there's not a cable there already
		if(LC.d1 == fdirn || LC.d2 == fdirn)
			return reset()
	if(!use_cable(1))
		return reset()
	var/obj/structure/cable/NC = new(new_turf)
	NC.cableColor("red")
	NC.d1 = 0
	NC.d2 = fdirn
	NC.updateicon()

	var/datum/powernet/PN
	if(last_piece && last_piece.d2 !=69_Dir)
		last_piece.d1 =69in(last_piece.d2,69_Dir)
		last_piece.d2 =69ax(last_piece.d2,69_Dir)
		last_piece.updateicon()
		PN = last_piece.powernet

	if(!PN)
		PN = new()
	PN.add_cable(NC)
	NC.mer69eConnectedNetworks(NC.d2)

	//NC.mer69eConnectedNetworksOnTurf()
	last_piece = NC
	return 1
