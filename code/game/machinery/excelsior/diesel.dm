// this 69enerator works with rea69ent instead of sheets.

/obj/machinery/power/port_69en/pacman/diesel
	name = "diesel 69enerator"
	icon = 'icons/obj/machines/excelsior/69enerator.dmi'
	icon_state = "base"
	circuit = /obj/item/electronics/circuitboard/diesel
	max_fuel_volume = 300
	power_69en = 16000 // produces 20% less watts output per power level settin69.
	time_per_fuel_unit = 12

	rea69ent_fla69s = OPENCONTAINER
	use_rea69ents_as_fuel = TRUE

/obj/machinery/power/port_69en/pacman/diesel/update_icon()
	overlays.Cut()
	if(active)
		overlays += "on"
		if(HasFuel())
			overlays += "rotor_workin69"
			overlays += "69max(round(rea69ents.total_volume / rea69ents.maximum_volume, 0.25) * 100, 25)69"
		else
			overlays += "0"
	else
		overlays += "off"
