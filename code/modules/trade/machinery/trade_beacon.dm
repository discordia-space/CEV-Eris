/obj/machinery/trade_beacon
	icon = 'icons/obj/machines/trade_beacon.dmi'
	icon_state = "beacon"
	anchored = TRUE
	density = TRUE

/obj/machinery/trade_beacon/attackby(obj/item/I, mob/user)
	if(default_deconstruction(I, user))
		return
	return ..()

/obj/machinery/trade_beacon/proc/get_id()
	var/area/A = get_area(src)
	return "[A.name] ([z], [x], [y])"

/obj/machinery/trade_beacon/proc/activate()
	flick("[icon_state]_active", src)

/obj/machinery/trade_beacon/sending
	name = "sending trade beacon"
	icon_state = "beacon_sending"

/obj/machinery/trade_beacon/sending/Initialize()
	. = ..()
	SStrade.beacons_sending += src

/obj/machinery/trade_beacon/sending/Destroy()
	SStrade.beacons_sending -= src
	return ..()

/obj/machinery/trade_beacon/sending/proc/get_objects()
	return range(2, src)

/obj/machinery/trade_beacon/receiving
	name = "receiving trade beacon"

/obj/machinery/trade_beacon/receiving/Initialize()
	. = ..()
	SStrade.beacons_receiving += src

/obj/machinery/trade_beacon/receiving/Destroy()
	SStrade.beacons_receiving -= src
	return ..()

/obj/machinery/trade_beacon/receiving/proc/drop(drop_type)
	var/list/floor = list()
	for(var/turf/simulated/floor/F in block(locate(x - 2, y - 2, z), locate(x + 2, y + 2, z)))
		if(F.contains_dense_objects())
			continue
		floor += F
	if(!length(floor))
		return FALSE
	activate()
	return new drop_type(pick(floor))
