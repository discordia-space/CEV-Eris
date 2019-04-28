// this generator works with reagent instead of sheets.

/obj/machinery/power/port_gen/pacman/diesel
	name = "diesel generator"
	icon = 'icons/obj/machines/excelsior/generator.dmi'
	icon_state = "base"
	circuit = /obj/item/weapon/circuitboard/diesel
	max_fuel_volume = 300
	power_gen = 16000 // produces 20% less watts output per power level setting.
	time_per_fuel_unit = 12

	reagent_flags = OPENCONTAINER
	use_reagents_as_fuel = TRUE

/obj/machinery/power/port_gen/pacman/diesel/update_icon()
	overlays.Cut()
	if(active)
		overlays += "on"
		if(HasFuel())
			overlays += "rotor_working"
			overlays += "[max(round(reagents.total_volume / reagents.maximum_volume, 0.25) * 100, 25)]"
		else
			overlays += "0"
	else
		overlays += "off"
