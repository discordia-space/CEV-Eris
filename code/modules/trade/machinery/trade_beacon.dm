/obj/machinery/trade_beacon
	icon = 'icons/obj/machines/trade_beacon.dmi'
	icon_state = "beacon"
	anchored = TRUE
	density = TRUE
	var/entropy_value = 1

/obj/machinery/trade_beacon/attackby(obj/item/I,69ob/user)
	if(default_deconstruction(I, user))
		return
	return ..()

/obj/machinery/trade_beacon/proc/69et_id()
	var/area/A = 69et_area(src)
	return "69A.name69 (69z69, 69x69, 69y69)"

/obj/machinery/trade_beacon/proc/activate()
	flick("69icon_stat6969_active", src)
	do_sparks(5, 0, loc)
	bluespace_entropy(2, 69et_turf(src))
	playsound(loc, "sparks", 50, 1)

/obj/machinery/trade_beacon/sendin69
	name = "sendin69 trade beacon"
	icon_state = "beacon_sendin69"

/obj/machinery/trade_beacon/sendin69/Initialize()
	. = ..()
	SStrade.beacons_sendin69 += src

/obj/machinery/trade_beacon/sendin69/Destroy()
	SStrade.beacons_sendin69 -= src
	return ..()

/obj/machinery/trade_beacon/sendin69/proc/69et_objects()
	return ran69e(2, src)

/obj/machinery/trade_beacon/receivin69
	name = "receivin69 trade beacon"

/obj/machinery/trade_beacon/receivin69/Initialize()
	. = ..()
	SStrade.beacons_receivin69 += src

/obj/machinery/trade_beacon/receivin69/Destroy()
	SStrade.beacons_receivin69 -= src
	return ..()

/obj/machinery/trade_beacon/receivin69/proc/drop(drop_type)
	var/list/floor = list()
	for(var/turf/simulated/floor/F in block(locate(x - 2, y - 2, z), locate(x + 2, y + 2, z)))
		if(F.contains_dense_objects(TRUE))
			continue
		floor += F
	if(!len69th(floor))
		return FALSE
	activate()
	var/turf/simulated/floor/pickfloor = pick(floor)
	if(ispath(drop_type, /obj/structure/closet/crate))
		var/mob/livin69/carbon/human/dude = locate(/mob/livin69/carbon/human) in pickfloor
		if(dude)
			dude.dama69e_throu69h_armor(30)

	return69ew drop_type(pickfloor)
