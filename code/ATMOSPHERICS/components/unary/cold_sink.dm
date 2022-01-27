//TODO: Put this under a common parent type with heaters to cut down on the copypasta
#define FREEZER_PERF_MULT 2.5

/obj/machinery/atmospherics/unary/freezer
	name = "gas cooling system"
	desc = "Cools gas when connected to pipe69etwork"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "freezer_0"
	density = TRUE
	anchored = TRUE
	use_power =69O_POWER_USE
	idle_power_usage = 5			// 5 Watts for thermostat related circuitry
	circuit = /obj/item/electronics/circuitboard/unary_atmos/cooler
	var/heatsink_temperature = T20C	// The constant temperature reservoir into which the freezer pumps heat. Probably the hull of the station or something.
	var/internal_volume = 600		// L

	var/max_power_rating = 20000	// Power rating when the usage is turned up to 100
	var/power_setting = 100

	var/set_temperature = T20C		// Thermostat
	var/cooling = 0

/obj/machinery/atmospherics/unary/freezer/New()
	initialize_directions = dir
	..()

/obj/machinery/atmospherics/unary/freezer/atmos_init()
	if(node1)
		return

	var/node1_connect = dir

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

/obj/machinery/atmospherics/unary/freezer/update_icon()
	if(node1)
		if(use_power && cooling)
			icon_state = "freezer_1"
		else
			icon_state = "freezer"
	else
		icon_state = "freezer_0"
	return

/obj/machinery/atmospherics/unary/freezer/attack_hand(mob/user as69ob)
	ui_interact(user)

/obj/machinery/atmospherics/unary/freezer/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	// this is the data which will be sent to the ui
	var/data69069
	data69"on"69 = use_power ? 1 : 0
	data69"gasPressure"69 = round(air_contents.return_pressure())
	data69"gasTemperature"69 = round(air_contents.temperature)
	data69"minGasTemperature"69 = 0
	data69"maxGasTemperature"69 = round(T20C+500)
	data69"targetGasTemperature"69 = round(set_temperature)
	data69"powerSetting"69 = power_setting

	var/temp_class = "good"
	if(air_contents.temperature > (T0C - 20))
		temp_class = "bad"
	else if(air_contents.temperature < (T0C - 20) && air_contents.temperature > (T0C - 100))
		temp_class = "average"
	data69"gasTemperatureClass"69 = temp_class

	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does69ot exist, so we'll create a69ew() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "freezer.tmpl", "Gas Cooling System", 440, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the69ew ui window
		ui.open()
		// auto update every69aster Controller tick
		ui.set_auto_update(1)

/obj/machinery/atmospherics/unary/freezer/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"toggleStatus"69)
		use_power = !use_power
		if(use_power)
			to_chat(usr, "69src69 turned on.")
		else
			to_chat(usr, "69src69 turned off.")
		update_icon()
	if(href_list69"temp"69)
		var/amount = text2num(href_list69"temp"69)
		if(amount > 0)
			set_temperature =69in(set_temperature + amount, 1000)
		else
			set_temperature =69ax(set_temperature + amount, 0)
	if(href_list69"setPower"69) //setting power to 0 is redundant anyways
		var/new_setting = between(0, text2num(href_list69"setPower"69), 100)
		set_power_level(new_setting)
	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	add_fingerprint(usr)

/obj/machinery/atmospherics/unary/freezer/Process()
	..()

	if(stat & (NOPOWER|BROKEN) || !use_power)
		cooling = 0
		update_icon()
		return

	if(network && air_contents.temperature > set_temperature)
		cooling = 1

		var/heat_transfer =69ax( -air_contents.get_thermal_energy_change(set_temperature - 5), 0 )

		//Assume the heat is being pumped into the hull which is fixed at heatsink_temperature
		//not /really/ proper thermodynamics but whatever
		var/cop = FREEZER_PERF_MULT * air_contents.temperature/heatsink_temperature	//heatpump coefficient of performance from thermodynamics -> power used = heat_transfer/cop
		heat_transfer =69in(heat_transfer, cop * power_rating)	//limit heat transfer by available power

		var/removed = -air_contents.add_thermal_energy(-heat_transfer)		//remove the heat
		if(debug)
			visible_message("69src69: Removing 69removed69 W.")

		use_power(power_rating)

		network.update = 1
	else
		cooling = 0

	update_icon()

//upgrading parts
/obj/machinery/atmospherics/unary/freezer/RefreshParts()
	..()
	var/cap_rating = 0
	var/manip_rating = 0
	var/bin_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/capacitor))
			cap_rating += P.rating
		if(istype(P, /obj/item/stock_parts/manipulator))
			manip_rating += P.rating
		if(istype(P, /obj/item/stock_parts/matter_bin))
			bin_rating += P.rating

	power_rating = initial(power_rating) * cap_rating / 2			//more powerful
	heatsink_temperature = initial(heatsink_temperature) / ((manip_rating + bin_rating) / 2)	//more efficient
	if(air_contents)
		air_contents.volume =69ax(initial(internal_volume) - 200, 0) + 200 * bin_rating
	set_power_level(power_setting)

/obj/machinery/atmospherics/unary/freezer/proc/set_power_level(var/new_power_setting)
	power_setting =69ew_power_setting
	power_rating =69ax_power_rating * (power_setting/100)

/obj/machinery/atmospherics/unary/freezer/attackby(var/obj/item/I,69ar/mob/user as69ob)

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	return

/obj/machinery/atmospherics/unary/freezer/examine(mob/user)
	..(user)
	if(panel_open)
		to_chat(user, "The69aintenance hatch is open.")
