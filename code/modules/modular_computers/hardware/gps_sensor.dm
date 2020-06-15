
/obj/item/weapon/computer_hardware/gps_sensor
	name = "relay positioning receiver"
	desc = "A module that connects a computer to the ship navigation system, commonly installed in PDAs."
	power_usage = 5 //W
	icon_state = "gps_basic"
	hardware_size = 1
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 2)
	matter_reagents = list("silicon" = 10)
	origin_tech = list(TECH_BLUESPACE = 2)
	usage_flags = PROGRAM_ALL
	var/datum/gps_data/gps

/obj/item/weapon/computer_hardware/gps_sensor/Initialize()
	. = ..()
	gps = new /datum/gps_data(src, prefix="PDA")

/obj/item/weapon/computer_hardware/gps_sensor/Destroy()
	QDEL_NULL(gps)
	return ..()

/obj/item/weapon/computer_hardware/gps_sensor/examine(mob/user)
	..()
	to_chat(user, "Serial number is [gps.serial_number].")

/obj/item/weapon/computer_hardware/gps_sensor/check_functionality()
	if (!gps || !gps.serial_number)
		return FALSE
	return ..()

/obj/item/weapon/computer_hardware/gps_sensor/proc/get_position_text()
	var/text
	if(check_functionality())
		text = gps.get_coordinates_text()

	if(!text)
		return "<span class='average'>ERROR: Unable to reach positioning system relays.</span>"
	return text