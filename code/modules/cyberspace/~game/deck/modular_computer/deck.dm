/obj/item/weapon/computer_hardware/deck
	name = "cyberspace deck"
	desc = "A strange device with port for data jacks."
	
	icon = 'icons/obj/cyberspace/deck.dmi'
	icon_state = "common"
	hardware_size = 1
	power_usage = 100
	origin_tech = list(TECH_BLUESPACE = 2, TECH_DATA = 4)
	price_tag = 100

	var/connection = FALSE
	var/power_usage_idle = 100
	var/power_usage_using = 2 KILOWATTS

	var/list/programs = list()

/obj/item/weapon/computer_hardware/deck/proc/update_power_usage()
	if(!connection)
		power_usage = power_usage_idle
	else
		power_usage = power_usage_using
