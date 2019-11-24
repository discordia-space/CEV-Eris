GLOBAL_LIST_EMPTY(teleblockers)

/obj/machinery/teleblocker
	name = "bluespace interference device"
	desc = "A device which interferes with bluespace teleportation in a specifiable area."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bus"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 60
	active_power_usage = 1000	//1 kW
	var/target_area = null
	var/possible_areas = list("Command" = /area/eris/command,
							"Security" = /area/eris/security,
							"Medical" = /area/eris/medical,
							"Science" = /area/eris/rnd,
							"Engineering" = /area/eris/engineering,
							"\improper Guild" = /area/eris/quartermaster,
							"\improper Chapel" = /area/eris/neotheology)

/obj/machinery/teleblocker/proc/can_teleport(turf/start, turf/dest)
	if(!target_area || stat)
		return TRUE
	return !istype(get_area(start), possible_areas[target_area]) && !istype(get_area(dest), possible_areas[target_area])

/obj/machinery/teleblocker/Initialize()
	. = ..()
	//Add ourselves to the global list
	GLOB.teleblockers += src
	update_visuals()

/obj/machinery/teleblocker/attack_hand(user as mob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(stat)
		return
	if(input("Would you like to change the affected area?") in list("Yes", "No") == "No")
		return
	target_area = input("Select area to prevent teleportation in:", "Item Mode Select","") as null|anything in possible_areas
	if(!target_area)
		to_chat(user, "You disable \the [name].")
		update_use_power(1)
	else
		to_chat(user, "You set \the [name] to prevent teleportation at \the [target_area]")
		update_use_power(2)

/obj/machinery/teleblocker/emp_act()
	. = ..()
	update_visuals()

/obj/machinery/teleblocker/proc/update_visuals()
	update_icon()
	if(use_power == 2 && !stat)
		set_light(1, 2, "#00B0B0")
	else
		set_light(0)

/obj/machinery/teleblocker/update_icon()
	if(stat || !target_area)
		icon_state = "[initial(icon_state)]_off"
	else
		icon_state = initial(icon_state)

/obj/machinery/teleblocker/update_use_power(var/new_use_power)
	. = ..()
	update_visuals()

/obj/machinery/teleblocker/examine(mob/user)
	. = ..()
	if(target_area)
		to_chat(user, "It is currently interfering with teleportation at \the [target_area]")
	else
		to_chat(user, "It is currently turned off.")

/obj/machinery/teleblocker/security
	use_power = 2
	target_area = "Security"

/obj/machinery/teleblocker/command
	use_power = 2
	target_area = "Command"