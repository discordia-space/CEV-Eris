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
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, loc)
	spark_system.start()
	playsound(loc, "sparks", 50, 1)

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
		if(F.contains_dense_objects(TRUE))
			continue
		floor += F
	if(!length(floor))
		return FALSE
	activate()
	var/turf/simulated/floor/pickfloor = pick(floor)
	if(ispath(drop_type, /obj/structure/closet/crate))
		var/mob/living/carbon/human/dude = locate(/mob/living/carbon/human) in pickfloor
		if(dude)
			dude.damage_through_armor(30)

	return new drop_type(pickfloor)
