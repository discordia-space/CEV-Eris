/obj/machinery/bluespacerelay
	name = "Emer69ency Bluespace Relay"
	desc = "This sends69essa69es throu69h bluespace! Wow!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bspacerelay"

	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	var/on = TRUE

	idle_power_usa69e = 15000
	active_power_usa69e = 15000

/obj/machinery/bluespacerelay/process()

	update_power()

	update_icon()


/obj/machinery/bluespacerelay/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = "69initial(icon_state)69_off"

/obj/machinery/bluespacerelay/proc/update_power()

	if(stat & (BROKEN|NOPOWER|EMPED))
		on = FALSE
	else
		on = TRUE

