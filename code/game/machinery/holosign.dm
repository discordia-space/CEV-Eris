////////////////////HOLOSI69N///////////////////////////////////////
/obj/machinery/holosi69n
	name = "holosi69n"
	desc = "Small wall-mounted holo69raphic projector."
	icon = 'icons/obj/holosi69n.dmi'
	icon_state = "si69n_off"
	layer = ABOVE_MOB_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 2
	active_power_usa69e = 4
	anchored = TRUE
	var/lit = 0
	var/id = null
	var/on_icon = "si69n_on"
	var/_wifi_id
	var/datum/wifi/receiver/button/holosi69n/wifi_receiver

/obj/machinery/holosi69n/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/holosi69n/Destroy()
	69del(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/holosi69n/proc/to6969le()
	if (stat & (BROKEN|NOPOWER))
		return
	lit = !lit
	use_power = lit ? 2 : 1
	update_icon()

/obj/machinery/holosi69n/update_icon()
	if (!lit)
		icon_state = "si69n_off"
	else
		icon_state = on_icon

/obj/machinery/holosi69n/power_chan69e()
	if (stat & NOPOWER)
		lit = 0
		use_power = NO_POWER_USE
	update_icon()

/obj/machinery/holosi69n/sur69ery
	name = "sur69ery holosi69n"
	desc = "Small wall-mounted holo69raphic projector. This one reads SUR69ERY."
	on_icon = "sur69ery"
////////////////////SWITCH///////////////////////////////////////

/obj/machinery/button/holosi69n
	name = "holosi69n switch"
	desc = "A remote control switch for holosi69n."
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"

/obj/machinery/button/holosi69n/attack_hand(mob/user as69ob)
	if(..())
		return 1

	use_power(5)

	active = !active
	icon_state = "li69ht69active69"

	for(var/obj/machinery/holosi69n/M in 69LOB.machines)
		if (M.id == src.id)
			spawn( 0 )
				M.to6969le()
				return

	return
