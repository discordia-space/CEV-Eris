///Maximum settable pressure
#define PUMP_MAX_PRESSURE (ONE_ATMOSPHERE * 25)
///Minimum settable pressure
#define PUMP_MIN_PRESSURE (ONE_ATMOSPHERE / 10)
///Defaul pressure, used in the UI to reset the settings
#define PUMP_DEFAULT_PRESSURE (ONE_ATMOSPHERE)
/obj/machinery/portable_atmospherics/powered/pump
	name = "portable air pump"
	icon_state = "psiphon:0"
	density = TRUE
	w_class = ITEM_SIZE_NORMAL

	///Is the machine on?
	var/on = FALSE
	///What direction is the machine pumping (in or out)?
	var/direction_out = FALSE // = PUMP_OUT
	///Player configurable, sets what's the release pressure
	var/target_pressure = ONE_ATMOSPHERE

	var/pressuremin = 0
	var/pressuremax = 10 * ONE_ATMOSPHERE

	volume = 1000

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

/obj/machinery/portable_atmospherics/powered/pump/Initialize()
	. = ..()
	cell = new /obj/item/weapon/cell/medium/high(src)

	var/list/air_mix = StandardAirMix()
	air_contents.adjust_multi("oxygen", air_mix["oxygen"], "nitrogen", air_mix["nitrogen"])

/obj/machinery/portable_atmospherics/powered/pump/Destroy()
	var/turf/T = get_turf(src)
	T.assume_air(air_contents)
	return ..()

/obj/machinery/portable_atmospherics/powered/pump/filled
	start_pressure = 90 * ONE_ATMOSPHERE


/obj/machinery/portable_atmospherics/powered/pump/on_update_icon()
	src.set_overlays(0)

	if(on && cell && cell.charge)
		icon_state = "psiphon:1"
	else
		icon_state = "psiphon:0"

	if(holding)
		add_overlays("siphon-open")

	if(connected_port)
		add_overlays("siphon-connector")

	return

/obj/machinery/portable_atmospherics/powered/pump/process_atmos()
	if(!on || !cell || (cell && !cell.charge))
		return ..()

	var/power_draw = -1 //a

	excited = TRUE

	var/turf/T = get_turf(src)
	var/datum/gas_mixture/sending
	var/datum/gas_mixture/receiving
	if(direction_out) // Hook up the internal pump.
		sending = (holding ? holding.return_air() : air_contents)
		receiving = (holding ? air_contents : T.return_air())
	else
		sending = (holding ? air_contents : T.return_air())
		receiving = (holding ? holding.return_air() : air_contents)

	var/output_starting_pressure = receiving.return_pressure()
	if((target_pressure - output_starting_pressure) < 0.01)
		//No need to pump gas if target is already reached!
		return FALSE

	var/pressure_delta = target_pressure - output_starting_pressure
	var/transfer_moles = (pressure_delta*receiving.volume)/(sending.temperature * R_IDEAL_GAS_EQUATION)
	power_draw = pump_gas(src, receiving, sending, transfer_moles, power_rating)
	// if(power_draw && !holding)
	// 	air_update_turf(FALSE, FALSE) // Update the environment if needed.

	// update power draw here
	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw = max(power_draw, power_losses)
		cell.use(power_draw * CELLRATE)
		last_power_draw = power_draw

	// update_connected_network() // TODO see if it's needed

	//ran out of charge
	if (!cell.charge)
		power_change()
		update_icon()

	return ..()

/obj/machinery/portable_atmospherics/powered/pump/emp_act(severity)
	. = ..()
	// if(. & EMP_PROTECT_SELF)
	// 	return
	if(stat & (BROKEN|NOPOWER)) //!is_operational)
		return
	if(prob(50 / severity))
		on = !on
		if(on)
			SSair.start_processing_machine(src)
	if(prob(100 / severity))
		direction_out = !direction_out //direction = PUMP_OUT
	target_pressure = rand(0, 100 * ONE_ATMOSPHERE)
	update_icon()

/obj/machinery/portable_atmospherics/powered/pump/replace_tank(mob/living/user, close_valve)
	. = ..()
	if(!.)
		return
	if(close_valve)
		if(on)
			on = FALSE
			update_icon()
	else if(on && holding && direction_out)
		investigate_log("[key_name(user)] started a transfer into [holding].", INVESTIGATE_ATMOS)

/obj/machinery/portable_atmospherics/powered/pump/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortablePump", name)
		ui.open()

/obj/machinery/portable_atmospherics/powered/pump/ui_data()
	var/data = list()
	data["on"] = on
	data["direction"] = !direction_out ? TRUE : FALSE
	data["connected"] = connected_port ? TRUE : FALSE
	data["pressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["target_pressure"] = round(target_pressure ? target_pressure : 0)
	data["default_pressure"] = round(PUMP_DEFAULT_PRESSURE)
	data["min_pressure"] = round(PUMP_MIN_PRESSURE)
	data["max_pressure"] = round(PUMP_MAX_PRESSURE)
	data["power_draw"] = round(last_power_draw)
	data["cell_charge"] = cell ? cell.charge : 0
	data["cell_max_charge"] = cell ? cell.maxcharge : 1

	if(holding)
		data["holding"] = list()
		data["holding"]["name"] = holding.name
		var/datum/gas_mixture/holding_mix = holding.return_air()
		data["holding"]["pressure"] = round(holding_mix.return_pressure())
	else
		data["holding"] = null
	return data

/obj/machinery/portable_atmospherics/powered/pump/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			if(on)
				SSair.start_processing_machine(src)
			// if(on && !holding)
				// var/plasma = air_contents.gas[/datum/gas/plasma]
				// var/n2o = air_contents.gas[/datum/gas/nitrous_oxide]
				// if(n2o || plasma)
				// 	message_admins("[ADMIN_LOOKUPFLW(usr)] turned on a pump that contains [n2o ? "N2O" : ""][n2o && plasma ? " & " : ""][plasma ? "Plasma" : ""] at [ADMIN_VERBOSEJMP(src)]")
				// 	log_admin("[key_name(usr)] turned on a pump that contains [n2o ? "N2O" : ""][n2o && plasma ? " & " : ""][plasma ? "Plasma" : ""] at [AREACOORD(src)]")
			if(on && direction_out)
				investigate_log("[key_name(usr)] started a transfer into [holding].", INVESTIGATE_ATMOS)
			. = TRUE
		if("direction")
			direction_out = !direction_out
			. = TRUE
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "reset")
				pressure = PUMP_DEFAULT_PRESSURE
				. = TRUE
			else if(pressure == "min")
				pressure = PUMP_MIN_PRESSURE
				. = TRUE
			else if(pressure == "max")
				pressure = PUMP_MAX_PRESSURE
				. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				target_pressure = clamp(round(pressure), PUMP_MIN_PRESSURE, PUMP_MAX_PRESSURE)
				investigate_log("was set to [target_pressure] kPa by [key_name(usr)].", INVESTIGATE_ATMOS)
		if("eject")
			if(holding)
				replace_tank(usr, FALSE)
				. = TRUE
	update_icon()

