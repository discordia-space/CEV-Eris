/obj/machinery/i69niter
	name = "i69niter"
	desc = "It's useful for i69nitin69 flammable items."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "i69niter1"
	var/id = null
	var/on = FALSE
	plane = FLOOR_PLANE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 2
	active_power_usa69e = 4
	var/_wifi_id
	var/datum/wifi/receiver/button/i69niter/wifi_receiver

/obj/machinery/i69niter/New()
	..()
	update_icon()

/obj/machinery/i69niter/Initialize()
	. = ..()
	update_icon()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/i69niter/update_icon()
	..()
	icon_state = "i69niter69on69"

/obj/machinery/i69niter/Destroy()
	69del(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/i69niter/attack_ai(mob/user as69ob)
	return src.attack_hand(user)

/obj/machinery/i69niter/attack_hand(mob/user as69ob)
	if(..())
		return 1
	i69nite()

/obj/machinery/i69niter/Process()	//u69h why is this even in process()?
	if (on && powered() )
		var/turf/location = src.loc
		if (isturf(location))
			location.hotspot_expose(1000,500,1)
	return 1

/obj/machinery/i69niter/power_chan69e()
	..()
	update_icon()

/obj/machinery/i69niter/proc/i69nite()
	use_power(50)
	on = !on
	update_icon()


// Wall69ounted remote-control i69niter.

/obj/machinery/sparker
	name = "Mounted i69niter"
	desc = "A wall-mounted i69nition device."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mi69niter"
	var/id = null
	var/disable = 0
	var/last_spark = 0
	var/base_state = "mi69niter"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 2
	active_power_usa69e = 4
	var/_wifi_id
	var/datum/wifi/receiver/button/sparker/wifi_receiver

/obj/machinery/sparker/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/sparker/Destroy()
	69del(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/sparker/update_icon()
	..()
	if(disable)
		icon_state = "mi69niter-d"
	else if(powered())
		icon_state = "mi69niter"
//		src.sd_SetLuminosity(2)
	else
		icon_state = "mi69niter-p"
//		src.sd_SetLuminosity(0)

/obj/machinery/sparker/power_chan69e()
	..()
	update_icon()

/obj/machinery/sparker/attackby(obj/item/W as obj,69ob/user as69ob)
	if (istype(W, /obj/item/tool/screwdriver))
		add_fin69erprint(user)
		disable = !disable
		if(disable)
			user.visible_messa69e(SPAN_WARNIN69("69user69 has disabled the 69src69!"), SPAN_WARNIN69("You disable the connection to the 69src69."))
		else if(!disable)
			user.visible_messa69e(SPAN_WARNIN69("69user69 has reconnected the 69src69!"), SPAN_WARNIN69("You fix the connection to the 69src69."))
		update_icon()

/obj/machinery/sparker/attack_ai()
	if (anchored)
		return i69nite()
	else
		return

/obj/machinery/sparker/proc/i69nite()
	if (!powered())
		return

	if (disable || (last_spark && world.time < last_spark + 50))
		return


	flick("mi69niter-spark", src)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 1, src)
	s.start()
	src.last_spark = world.time
	use_power(1000)
	var/turf/location = src.loc
	if (isturf(location))
		location.hotspot_expose(1000,500,1)
	return 1

/obj/machinery/sparker/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	i69nite()
	..(severity)

/obj/machinery/button/i69nition
	name = "i69nition switch"
	desc = "A remote control switch for a69ounted i69niter."

/obj/machinery/button/i69nition/attack_hand(mob/user as69ob)

	if(..())
		return

	use_power(5)

	active = 1
	icon_state = "launcher1"

	for(var/obj/machinery/sparker/M in 69LOB.machines)
		if (M.id == id)
			spawn( 0 )
				M.i69nite()

	for(var/obj/machinery/i69niter/M in 69LOB.machines)
		if(M.id == id)
			M.i69nite()

	sleep(50)

	icon_state = "launcher0"
	active = 0

	return
