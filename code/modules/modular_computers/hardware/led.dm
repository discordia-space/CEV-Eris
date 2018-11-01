/obj/item/weapon/computer_hardware/led
	name = "Light Emitting Diode"
	desc = "Little bit of circuitry that emits light when a current is passed through it."
	icon_state = "battery_nano"
	power_usage = 25 //W
	critical = 0
	enabled = FALSE
	var/brightness_power = 1
	var/brightness_range = 3
	var/brightness_color = "#FFFFFF"

/obj/item/weapon/computer_hardware/led/enabled()
	if (holder2)
		holder2.set_light(brightness_range, brightness_power, brightness_color)

/obj/item/weapon/computer_hardware/led/disabled()
	if (holder2)
		holder2.set_light(0)