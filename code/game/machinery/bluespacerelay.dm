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

/obj/machinery/bluespacerelay/Process()

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

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	..()