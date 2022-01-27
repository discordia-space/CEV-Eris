/obj/machinery/bluespacerelay
	name = "Emergency Bluespace Relay"
	desc = "This sends69essages through bluespace! Wow!"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "bspacerelay"

	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE
	circuit = /obj/item/electronics/circuitboard/bluespacerelay
	var/on = TRUE

	idle_power_usage = 15000
	active_power_usage = 15000

/obj/machinery/bluespacerelay/Process()

	update_power()

	update_icon()


/obj/machinery/bluespacerelay/update_icon()
	if(on && (icon_state != initial(icon_state)))
		icon_state = initial(icon_state)
	else if(icon_state != "69initial(icon_state)69_off")
		icon_state = "69initial(icon_state)69_off"

/obj/machinery/bluespacerelay/proc/update_power()

	if(stat & (BROKEN|NOPOWER|EMPED))
		on = FALSE
	else
		on = TRUE

/obj/machinery/bluespacerelay/attackby(var/obj/item/I,69ar/mob/user as69ob)

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	..()