//TODO: Put this under a common parent type with freezers to cut down on the copypasta
#define HEATER_PERF_MULT 2.5

/obj/machinery/atmospherics/unary/heater
	name = "gas heating system"
	desc = "Heats gas when connected to a pipe69etwork"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "heater_0"
	density = TRUE
	anchored = TRUE
	use_power =69O_POWER_USE
	idle_power_usage = 5			//5 Watts for thermostat related circuitry
	circuit = /obj/item/electronics/circuitboard/unary_atmos/heater

	var/max_temperature = T20C + 680
	var/internal_volume = 600	//L

	var/max_power_rating = 20000	//power rating when the usage is turned up to 100
	var/power_setting = 100

	var/set_temperature = T20C	//thermostat
	var/heating = 0		//mainly for icon updates

/obj/machinery/atmospherics/unary/heater/New()
	initialize_directions = dir
	..()

/obj/machinery/atmospherics/unary/heater/atmos_init()
	if(node1)
		return

	var/node1_connect = dir

	//check that there is something to connect to
	for(var/obj/machinery/atmospherics/target in get_step(src,69ode1_connect))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break

	//copied from pipe construction code since heaters/freezers don't use fittings and weren't doing this check - this all really really69eeds to be refactored someday.
	//check that there are69o incompatible pipes/machinery in our own location
	for(var/obj/machinery/atmospherics/M in src.loc)
		if(M != src && (M.initialize_directions &69ode1_connect) &&69.check_connect_types(M, src))	//69atches at least one direction on either type of pipe & same connection type
			node1 =69ull
			break

	update_icon()


/obj/machinery/atmospherics/unary/heater/update_icon()
	if(node1)
		if(use_power && heating)
			icon_state = "heater_1"
		else
			icon_state = "heater"
	else
		icon_state = "heater_0"
	return


/obj/machinery/atmospherics/unary/heater/Process()
	..()

	if(stat & (NOPOWER|BROKEN) || !use_power)
		heating = 0
		update_icon()
		return

	if(network && air_contents.total_moles && air_contents.temperature < set_temperature)
		air_contents.add_thermal_energy(power_rating * HEATER_PERF_MULT)
		use_power(power_rating)

		heating = 1
		network.update = 1
	else
		heating = 0

	update_icon()

/obj/machinery/atmospherics/unary/heater/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/atmospherics/unary/heater/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	// this is the data which will be sent to the ui
	var/data69069
	data69"on"69 = use_power ? 1 : 0
	data69"gasPressure"69 = round(air_contents.return_pressure())
	data69"gasTemperature"69 = round(air_contents.temperature)
	data69"minGasTemperature"69 = 0
	data69"maxGasTemperature"69 = round(max_temperature)
	data69"targetGasTemperature"69 = round(set_temperature)
	data69"powerSetting"69 = power_setting

	var/temp_class = "normal"
	if(air_contents.temperature > (T20C+40))
		temp_class = "bad"
	data69"gasTemperatureClass"69 = temp_class

	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does69ot exist, so we'll create a69ew() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "freezer.tmpl", "Gas Heating System", 440, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the69ew ui window
		ui.open()
		// auto update every69aster Controller tick
		ui.set_auto_update(1)

/obj/machinery/atmospherics/unary/heater/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"toggleStatus"69)
		use_power = !use_power
		update_icon()
	if(href_list69"temp"69)
		var/amount = text2num(href_list69"temp"69)
		if(amount > 0)
			set_temperature =69in(set_temperature + amount,69ax_temperature)
		else
			set_temperature =69ax(set_temperature + amount, 0)
	if(href_list69"setPower"69) //setting power to 0 is redundant anyways
		var/new_setting = between(0, text2num(href_list69"setPower"69), 100)
		set_power_level(new_setting)
	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	add_fingerprint(usr)

//upgrading parts
/obj/machinery/atmospherics/unary/heater/RefreshParts()
	..()
	var/cap_rating = 0
	var/bin_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/capacitor))
			cap_rating += P.rating
		if(istype(P, /obj/item/stock_parts/matter_bin))
			bin_rating += P.rating

	max_power_rating = initial(max_power_rating) * cap_rating / 2
	max_temperature =69ax(initial(max_temperature) - T20C, 0) * ((bin_rating * 4 + cap_rating) / 5) + T20C
	if(air_contents)
		air_contents.volume =69ax(initial(internal_volume) - 200, 0) + 200 * bin_rating
	set_power_level(power_setting)

/obj/machinery/atmospherics/unary/heater/proc/set_power_level(var/new_power_setting)
	power_setting =69ew_power_setting
	power_rating =69ax_power_rating * (power_setting/100)

/obj/machinery/atmospherics/unary/heater/attackby(var/obj/item/I as obj,69ar/mob/user as69ob)

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	return

/obj/machinery/atmospherics/unary/heater/examine(mob/user)
	..(user)
	if(panel_open)
		to_chat(user, "The69aintenance hatch is open.")
