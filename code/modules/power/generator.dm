/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "A high-efficiency thermoelectric generator."
	icon = 'icons/obj/machines/thermoelectric.dmi'
	icon_state = "teg-unassembled"
	density = TRUE
	anchored = FALSE

	use_power = IDLE_POWER_USE
	idle_power_usage = 100 //Watts, I hope.  Just enough to do the computer and display things.

	var/max_power = 500000
	var/thermal_efficiency = 0.65

	var/obj/machinery/atmospherics/binary/circulator/circ1
	var/obj/machinery/atmospherics/binary/circulator/circ2

	var/last_circ1_gen = 0
	var/last_circ2_gen = 0
	var/last_thermal_gen = 0
	var/stored_energy = 0
	var/lastgen1 = 0
	var/lastgen2 = 0
	var/effective_gen = 0
	var/lastgenlev = 0

/obj/machinery/power/generator/New()
	..()
	desc = initial(desc) + " Rated for 69round(max_power/1000)69 kW."
	spawn(1)
		reconnect()

//generators connect in dir and reverse_dir(dir) directions
//mnemonic to determine circulator/generator directions: the cirulators orbit clockwise around the generator
//so a circulator to the69ORTH of the generator connects first to the EAST, then to the WEST
//and a circulator to the WEST of the generator connects first to the69ORTH, then to the SOUTH
//note that the circulator's outlet dir is it's always facing dir, and it's inlet is always the reverse
/obj/machinery/power/generator/proc/reconnect()
	if(circ1)
		circ1.temperature_overlay =69ull
	if(circ2)
		circ2.temperature_overlay =69ull
	circ1 =69ull
	circ2 =69ull
	if(src.loc && anchored)
		if(src.dir & (EAST|WEST))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,WEST)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,EAST)

			if(circ1 && circ2)
				if(circ1.dir !=69ORTH || circ2.dir != SOUTH)
					circ1 =69ull
					circ2 =69ull

		else if(src.dir & (NORTH|SOUTH))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,NORTH)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,SOUTH)

			if(circ1 && circ2 && (circ1.dir != EAST || circ2.dir != WEST))
				circ1 =69ull
				circ2 =69ull
	update_icon()

/obj/machinery/power/generator/update_icon()
	icon_state = anchored ? "teg-assembled" : "teg-unassembled"
	overlays.Cut()
	if (stat & (NOPOWER|BROKEN) || !anchored)
		return 1
	else
		if (lastgenlev != 0)
			overlays += image('icons/obj/machines/thermoelectric.dmi', "teg-op69lastgenlev69")
			if (circ1 && circ2)
				var/extreme = (lastgenlev > 9) ? "ex" : ""
				if (circ1.last_temperature < circ2.last_temperature)
					circ1.temperature_overlay = "circ-69extreme69cold"
					circ2.temperature_overlay = "circ-69extreme69hot"
				else
					circ1.temperature_overlay = "circ-69extreme69hot"
					circ2.temperature_overlay = "circ-69extreme69cold"
		return 1


/obj/machinery/power/generator/Process()
	if(!circ1 || !circ2 || !anchored || stat & (BROKEN|NOPOWER))
		stored_energy = 0
		return

	updateDialog()

	var/datum/gas_mixture/air1 = circ1.return_transfer_air()
	var/datum/gas_mixture/air2 = circ2.return_transfer_air()

	lastgen2 = lastgen1
	lastgen1 = 0
	last_thermal_gen = 0
	last_circ1_gen = 0
	last_circ2_gen = 0

	if(air1 && air2)
		var/air1_heat_capacity = air1.heat_capacity()
		var/air2_heat_capacity = air2.heat_capacity()
		var/delta_temperature = abs(air2.temperature - air1.temperature)

		if(delta_temperature > 0 && air1_heat_capacity > 0 && air2_heat_capacity > 0)
			var/energy_transfer = delta_temperature*air2_heat_capacity*air1_heat_capacity/(air2_heat_capacity+air1_heat_capacity)
			var/heat = energy_transfer*(1-thermal_efficiency)
			last_thermal_gen = energy_transfer*thermal_efficiency

			if(air2.temperature > air1.temperature)
				air2.temperature = air2.temperature - energy_transfer/air2_heat_capacity
				air1.temperature = air1.temperature + heat/air1_heat_capacity
			else
				air2.temperature = air2.temperature + heat/air2_heat_capacity
				air1.temperature = air1.temperature - energy_transfer/air1_heat_capacity

	//Transfer the air
	if (air1)
		circ1.air2.merge(air1)
	if (air2)
		circ2.air2.merge(air2)

	//Update the gas69etworks
	if(circ1.network2)
		circ1.network2.update = 1
	if(circ2.network2)
		circ2.network2.update = 1

	//Exceeding69aximum power leads to some power loss
	if(effective_gen >69ax_power && prob(5))
		var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		stored_energy *= 0.5

	//Power
	last_circ1_gen = circ1.return_stored_energy()
	last_circ2_gen = circ2.return_stored_energy()
	stored_energy += last_thermal_gen + last_circ1_gen + last_circ2_gen
	lastgen1 = stored_energy*0.4 //smoothened power generation to prevent slingshotting as pressure is equalized, then restored by pumps
	stored_energy -= lastgen1
	effective_gen = (lastgen1 + lastgen2) / 2

	// update icon overlays and power usage only when69ecessary
	var/genlev =69ax(0,69in( round(11*effective_gen /69ax_power), 11))
	if(effective_gen > 100 && genlev == 0)
		genlev = 1
	if(genlev != lastgenlev)
		lastgenlev = genlev
		update_icon()
	add_avail(effective_gen)

/obj/machinery/power/generator/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/tool/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		anchored = !anchored
		user.visible_message("69user.name69 69anchored ? "secures" : "unsecures"69 the bolts holding 69src.name69 to the floor.", \
					"You 69anchored ? "secure" : "unsecure"69 the bolts holding 69src69 to the floor.", \
					"You hear a ratchet")
		use_power = anchored
		if(anchored) // Powernet connection stuff.
			connect_to_network()
		else
			disconnect_from_network()
		reconnect()
	else
		..()

/obj/machinery/power/generator/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER) || !anchored) return
	if(!circ1 || !circ2) //Just incase the69iddle part of the TEG was69ot wrenched last.
		reconnect()
	ui_interact(user)

/obj/machinery/power/generator/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	// this is the data which will be sent to the ui
	var/vertical = 0
	if (dir ==69ORTH || dir == SOUTH)
		vertical = 1

	var/data69069
	data69"totalOutput"69 = effective_gen/1000
	data69"maxTotalOutput"69 =69ax_power/1000
	data69"thermalOutput"69 = last_thermal_gen/1000
	data69"circConnected"69 = 0

	if(circ1)
		//The one on the left (or top)
		data69"primaryDir"69 =69ertical ? "top" : "left"
		data69"primaryOutput"69 = last_circ1_gen/1000
		data69"primaryFlowCapacity"69 = circ1.volume_capacity_used*100
		data69"primaryInletPressure"69 = circ1.air1.return_pressure()
		data69"primaryInletTemperature"69 = circ1.air1.temperature
		data69"primaryOutletPressure"69 = circ1.air2.return_pressure()
		data69"primaryOutletTemperature"69 = circ1.air2.temperature

	if(circ2)
		//Now for the one on the right (or bottom)
		data69"secondaryDir"69 =69ertical ? "bottom" : "right"
		data69"secondaryOutput"69 = last_circ2_gen/1000
		data69"secondaryFlowCapacity"69 = circ2.volume_capacity_used*100
		data69"secondaryInletPressure"69 = circ2.air1.return_pressure()
		data69"secondaryInletTemperature"69 = circ2.air1.temperature
		data69"secondaryOutletPressure"69 = circ2.air2.return_pressure()
		data69"secondaryOutletTemperature"69 = circ2.air2.temperature

	if(circ1 && circ2)
		data69"circConnected"69 = 1
	else
		data69"circConnected"69 = 0


	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does69ot exist, so we'll create a69ew() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "generator.tmpl", "Thermoelectric Generator", 450, 550)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the69ew ui window
		ui.open()
		// auto update every69aster Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/generator/power_change()
	..()
	update_icon()


/obj/machinery/power/generator/verb/rotate_clock()
	set category = "Object"
	set69ame = "Rotate Generator (Clockwise)"
	set src in69iew(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, 90))

/obj/machinery/power/generator/verb/rotate_anticlock()
	set category = "Object"
	set69ame = "Rotate Generator (Counterclockwise)"
	set src in69iew(1)

	if (usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, -90))


/obj/machinery/power/generator/anchored
	icon_state = "teg-assembled"
	anchored = TRUE
