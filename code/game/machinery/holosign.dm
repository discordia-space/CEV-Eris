////////////////////HOLOSIGN///////////////////////////////////////
/obj/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector."
	icon = 'icons/obj/holosign.dmi'
	icon_state = "sign_off"
	layer = ABOVE_MOB_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	active_power_usage = 4
	anchored = TRUE
	var/lit = 0
	var/id = null
	var/on_icon = "sign_on"
	var/_wifi_id
	var/datum/wifi/receiver/button/holosign/wifi_receiver

/obj/machinery/holosign/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/holosign/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/holosign/proc/toggle()
	if (stat & (BROKEN|NOPOWER))
		set_power_use(NO_POWER_USE)
		return
	lit = !lit
	set_power_use(lit ? ACTIVE_POWER_USE : IDLE_POWER_USE)
	update_icon()

/obj/machinery/holosign/update_icon()
	if (!lit)
		icon_state = "sign_off"
	else
		icon_state = on_icon

/obj/machinery/holosign/power_change()
	if (stat & NOPOWER)
		lit = 0
		set_power_use(NO_POWER_USE)
	update_icon()

/obj/machinery/holosign/surgery
	name = "surgery holosign"
	desc = "Small wall-mounted holographic projector. This one reads SURGERY."
	on_icon = "surgery"
////////////////////SWITCH///////////////////////////////////////

/obj/machinery/button/holosign
	name = "holosign switch"
	desc = "A remote control switch for holosign."
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"

/obj/machinery/button/holosign/attack_hand(mob/user as mob)
	if(..())
		return 1

	use_power(5)

	active = !active
	icon_state = "light[active]"

	for(var/obj/machinery/holosign/M in GLOB.machines)
		if (M.id == src.id)
			spawn( 0 )
				M.toggle()
				return

	return
