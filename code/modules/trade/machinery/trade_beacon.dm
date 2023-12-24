/obj/machinery/trade_beacon
	icon = 'icons/obj/machines/trade_beacon.dmi'
	icon_state = "beacon"
	anchored = TRUE
	density = TRUE
	var/entropy_value = 2

/obj/machinery/trade_beacon/attackby(obj/item/I, mob/user)
	if(default_deconstruction(I, user))
		return
	return ..()

/obj/machinery/trade_beacon/proc/get_id()
	var/area/A = get_area(src)
	return "[A.name] ([z], [x], [y])"

/obj/machinery/trade_beacon/proc/activate()
	flick("[icon_state]_active", src)
	do_sparks(5, 0, loc)
	bluespace_entropy(entropy_value, get_turf(src))
	playsound(loc, "sparks", 50, 1)

/obj/machinery/trade_beacon/sending
	name = "sending trade beacon"
	icon_state = "beacon_sending"
	circuit = /obj/item/electronics/circuitboard/trade_beacon/sending
	var/export_cooldown = 180 SECONDS
	var/export_timer_start

/obj/machinery/trade_beacon/sending/Initialize()
	. = ..()
	SStrade.beacons_sending += src

/obj/machinery/trade_beacon/sending/Destroy()
	SStrade.beacons_sending -= src
	return ..()

/obj/machinery/trade_beacon/sending/proc/get_objects()
	var/list/objects = range(2, src) - src		// So the beacon won't send itself in the list of objects
	return objects

/obj/machinery/trade_beacon/sending/proc/start_export()
	if(!export_timer_start)
		activate()
		export_timer_start = world.time
		addtimer(CALLBACK(src, PROC_REF(reset_export_timer)), export_cooldown, TIMER_STOPPABLE)

/obj/machinery/trade_beacon/sending/proc/reset_export_timer()
	activate()
	export_timer_start = null

/obj/machinery/trade_beacon/receiving
	name = "receiving trade beacon"
	circuit = /obj/item/electronics/circuitboard/trade_beacon/receiving

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
	if(ispath(drop_type, /obj/structure/closet))
		var/mob/living/carbon/human/dude = locate(/mob/living/carbon/human) in pickfloor
		if(dude)
			dude.damage_through_armor(list(ARMOR_BLUNT=list(DELEM(BRUTE,45))), BP_CHEST, src, 1, 1, FALSE)

	return new drop_type(pickfloor)
