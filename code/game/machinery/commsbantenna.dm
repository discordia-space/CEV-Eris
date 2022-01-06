/obj/machinery/bluespacerelay
	name = "Emergency Bluespace Relay"
	desc = "This sends messages through bluespace! Wow!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bspacerelay"

	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	var/on = TRUE

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
		on = FALSE
	else
		on = TRUE

