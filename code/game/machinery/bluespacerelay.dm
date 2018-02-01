/obj/machinery/bluespacerelay
	name = "Emergency Bluespace Relay"
	desc = "This sends messages through bluespace! Wow!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bspacerelay"

	anchored = 1
	density = 1
	use_power = 1
	circuit = /obj/item/weapon/circuitboard/bluespacerelay
	var/on = 1

	idle_power_usage = 15000
	active_power_usage = 15000

/obj/machinery/bluespacerelay/process()

	update_power()

	update_icon()


/obj/machinery/bluespacerelay/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

/obj/machinery/bluespacerelay/proc/update_power()

	if(stat & (BROKEN|NOPOWER|EMPED))
		on = 0
	else
		on = 1

/obj/machinery/bluespacerelay/attackby(var/obj/item/I, var/mob/user as mob)

	var/tool_type = I.get_tool_type(user, list(QUALITY_PRYING, QUALITY_SCREW_DRIVING))
	switch(tool_type)
		if(QUALITY_PRYING)
			if(!panel_open)
				user << SPAN_NOTICE("You cant get to the components of \the [src], remove the cover.")
				return
			if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_PRYING, FAILCHANCE_HARD))
				user << SPAN_NOTICE("You remove the components of \the [src] with [I].")
				dismantle()
				return
		if(QUALITY_SCREW_DRIVING)
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_SCREW_DRIVING, FAILCHANCE_VERY_EASY, instant_finish_tier = 3))
				panel_open = !panel_open
				user << SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch of \the [src] with [I].")
				update_icon()
				return
		if(ABORT_CHECK)
			return

	if(default_part_replacement(user, I))
		return

	..()