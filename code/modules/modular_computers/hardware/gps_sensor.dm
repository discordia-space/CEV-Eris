/obj/item/computer_hardware/gps_sensor
	name = "relay positioning receiver"
	desc = "A module that connects a computer to the ship navigation system, commonly installed in PDAs."
	power_usage = 5 //W
	icon_state = "gps_basic"
	hardware_size = 1
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 2)
	matter_reagents = list("silicon" = 10)
	origin_tech = list(TECH_BLUESPACE = 2)
	usage_flags = PROGRAM_ALL
	var/datum/component/gps/gps

/obj/item/computer_hardware/gps_sensor/Initialize()
	. = ..()
	var/prefix = "MPC"
	if(istype(loc, /obj/item/modular_computer/pda))
		prefix = "PDA"
	else if(istype(loc, /obj/item/modular_computer/tablet))
		prefix = "TAB"

	gps = AddComponent(/datum/component/gps, prefix)
	START_PROCESSING(SSobj, src)

/obj/item/computer_hardware/gps_sensor/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/computer_hardware/gps_sensor/examine(mob/user)
	. = ..()
	to_chat(user, "Serial number is [gps.gpstag]-[gps.serial_number].")

/obj/item/computer_hardware/gps_sensor/proc/get_position_text()
	return "[src.x], [src.y], [src.z]"

/obj/item/computer_hardware/gps_sensor/Process()
	if(!holder2?.enabled || !check_functionality())
		gps.tracking = FALSE
		return
	gps.tracking = TRUE
