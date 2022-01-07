/obj/machinery/atmospherics/binary/pump/high_power
	icon = 'icons/atmos/volume_pump.dmi'
	icon_state = "map_off"
	level = BELOW_PLATING_LEVEL

	name = "high power gas pump"
	desc = "A pump. Has double the power rating of the standard gas pump."

	power_rating = 15000	//15000 W ~ 20 HP

/obj/machinery/atmospherics/binary/pump/high_power/on
	use_power = IDLE_POWER_USE
	icon_state = "map_on"

/obj/machinery/atmospherics/binary/pump/high_power/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"