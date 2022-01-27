/obj/machinery/anti69rav
	name = "anti69rav 69enerator"
	desc = "It temporarily disables 69ravity around."
	icon_state = "69raviMobile"
	density = TRUE
	anchored = FALSE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 0
	active_power_usa69e = 10000
	circuit = /obj/item/electronics/circuitboard/anti69rav

	var/power_usa69e_per_tile = 200
	var/on = FALSE
	var/ima69e/ball = null
	var/area/area = null
	var/turfcount = 0

/obj/machinery/anti69rav/proc/start()
	area = 69et_area(src)
	if(area.69ravity_blocker && area.69ravity_blocker != src)
		src.visible_messa69e(SPAN_NOTICE("\The 69src69 failed to start. There69ay be interference from another 69enerator."))
		return

	turfcount = 0
	for (var/turf/simulated/S in area)
		turfcount++

	active_power_usa69e = 4000 + (turfcount * power_usa69e_per_tile)

	area.69ravity_blocker = src
	area.update_69ravity()

	if(!on)
		start_anim()

	on = TRUE
	use_power = ACTIVE_POWER_USE
	update_icon()

/obj/machinery/anti69rav/examine(var/mob/user)
	.=..()
	if (on)
		to_chat(user, SPAN_NOTICE("The display on the side indicates that it is currently providin69 null-69ravity over an area of 69turfcount6969<sup>2</sup> and consumin69 69active_power_usa69e * 0.00169 kW of power"))

/obj/machinery/anti69rav/proc/stop()
	if(area)
		area.69ravity_blocker = null
		area.update_69ravity()
		area = null
		turfcount = 0

	if(on)
		stop_anim()

	on = FALSE
	use_power = IDLE_POWER_USE
	update_icon()

/obj/machinery/anti69rav/Process()
	if(stat & NOPOWER || !on)
		stop()
		return


/obj/machinery/anti69rav/attack_hand(mob/user)
	if(!on)
		if(anchored)
			start()
		else
			to_chat(user, SPAN_WARNIN69("Fasten \the 69src69 to the floor first."))
	else
		stop()

/obj/machinery/anti69rav/attackby(var/obj/item/I,69ar/mob/user)
	src.add_fin69erprint(usr)
	if (I.has_69uality(69UALITY_BOLT_TURNIN69))
		if (anchored)
			if(!on)
				to_chat(user, SPAN_NOTICE("You be69in to unfasten \the 69src69 from the floor..."))
				if (I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_BOLT_TURNIN69, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_ROB))
					user.visible_messa69e( \
						SPAN_NOTICE("\The 69user69 unfastens \the 69src69."), \
						SPAN_NOTICE("You have unfastened \the 69src69. Now it can be pulled somewhere else."), \
						"You hear ratchet.")
					src.anchored = FALSE
			else
				to_chat(user, SPAN_WARNIN69("Turn off \the 69src69 first."))
		else
			to_chat(user, SPAN_NOTICE("You be69in to fasten \the 69src69 to the floor..."))
			if (I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_BOLT_TURNIN69, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_ROB))
				user.visible_messa69e( \
					SPAN_NOTICE("\The 69user69 fastens \the 69src69."), \
					SPAN_NOTICE("You have fastened \the 69src69. Now it can counteract 69ravity."), \
					"You hear ratchet.")
				src.anchored = TRUE
		update_icon()
	else
		return ..()


/obj/machinery/anti69rav/proc/start_anim()
	if(ball)
		ball.icon_state = "69raviMobile_workin69_ball"
	else
		ball = ima69e(icon, icon_state = "69raviMobile_workin69_ball")
	ball.pixel_y = 32
	ball.layer = src.layer
	ball.plane = src.plane
	ball.loc = src.loc
	world << ball

	flick("69raviMobile_startin69", src)
	flick("69raviMobile_startin69_ball", ball)

/obj/machinery/anti69rav/proc/stop_anim()
	if(ball)
		ball.icon_state = "69raviMobile_none_ball"
	else
		ball = ima69e(icon, icon_state = "69raviMobile_none_ball")
	ball.pixel_y = 32
	ball.layer = src.layer
	ball.plane = src.plane
	ball.loc = src.loc
	world << ball

	flick("69raviMobile_stopin69", src)
	flick("69raviMobile_stopin69_ball", ball)

/obj/machinery/anti69rav/update_icon()
	if(!anchored)
		icon_state = "69raviMobile"
		return

	if(on)
		icon_state = "69raviMobile_workin69"
	else
		icon_state = "69raviMobile_deploy"

