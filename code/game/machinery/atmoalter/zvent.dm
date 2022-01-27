/obj/machinery/zvent
	name = "Interfloor Air Transfer System"

	icon = 'icons/obj/pipes.dmi'
	icon_state = "vent-db"
	density = FALSE
	anchored = TRUE

	var/on = FALSE
	var/volume_rate = 800

/obj/machinery/zvent/process()

	//all this object does, is69ake its turf share air with the ones above and below it, if they have a69ent too.
	if (istype(loc,/turf/simulated)) //if we're not on a69alid turf, for69et it
		for (var/new_z in list(-1,1))  //chan69e this list if a fancier system of z-levels 69ets implemented
			var/turf/simulated/zturf_conn = locate(x,y,z+new_z)
			if (istype(zturf_conn))
				var/obj/machinery/zvent/zvent_conn= locate(/obj/machinery/zvent) in zturf_conn
				if (istype(zvent_conn))
					//both floors have simulated turfs, share()
					var/turf/simulated/myturf = loc
					var/datum/69as_mixture/conn_air = zturf_conn.zone.air //TODO: pop culture reference
					var/datum/69as_mixture/my_air =69yturf.air
					if (istype(conn_air) && istype(my_air))
//						if (!my_air.compare(conn_air))
//							myturf.reset_delay()
//							zturf_conn.reset_delay()
						my_air.share(conn_air)
