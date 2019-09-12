
/obj/item/weapon/computer_hardware/gps_sensor
	name = "gps sensor"
	desc = "GPS sensors are receivers with antenna that use a ship navigation system."
	power_usage = 5 //W
	critical = 0
	icon_state = "gps_basic"
	hardware_size = 1
	origin_tech = list(TECH_BLUESPACE = 2)
	usage_flags = PROGRAM_ALL
	var/datum/gps_data/gps

/obj/item/weapon/computer_hardware/gps_sensor/Initialize()
	.=..()
	gps = new /datum/gps_data(src)

/obj/item/weapon/computer_hardware/gps_sensor/Destroy()
	QDEL_NULL(gps)
	return ..()

/obj/item/weapon/computer_hardware/gps_sensor/examine(mob/user)
	..()
	to_chat(user, "Serial number is [gps.serialNumber].")

/obj/item/weapon/computer_hardware/gps_sensor/check_functionality()
	if (!gps || !gps.serialNumber )
		return FALSE
	return ..()

/obj/item/weapon/computer_hardware/gps_sensor/proc/get_position_text()
	var/text
	if(!check_functionality())
		text = "<span class='average'>ERROR:Unable to recive GPS location.</span>"
		return text
	var/datum/coords/C = gps.get_coords()
	var/area/A = get_area(src)
	text = "[C.x_pos]:[C.y_pos]:[C.z_pos] - [strip_improper(A.name)]"
	return text