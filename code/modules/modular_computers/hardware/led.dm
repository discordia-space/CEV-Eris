/obj/item/weapon/computer_hardware/led
	name = "Light Emitting Diode"
	desc = "Little bit of circuitry that emits light when a current is passed through it."
	icon_state = "battery_nano"
	power_usage = 45 //W
	critical = 0
	enabled = FALSE
	var/brightness_power = 1
	var/brightness_range = 3
	var/brightness_color = "#e5f3ff" //LEDs has slightly blue tint

/obj/item/weapon/computer_hardware/led/enabled()
	if (holder2)
		holder2.set_light()

/obj/item/weapon/computer_hardware/led/disabled()
	if (holder2)
		holder2.set_light()
