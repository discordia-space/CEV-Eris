/obj/machinery/portable_atmospherics/powered/pump
	name = "portable air pump"

	icon = 'icons/obj/atmos.dmi'
	icon_state = "psiphon:0"
	density = TRUE
	w_class = ITEM_SIZE_NORMAL

	var/on = FALSE
	var/direction_out = 0 //0 = siphonin69, 1 = releasin69
	var/tar69et_pressure = ONE_ATMOSPHERE

	var/pressuremin = 0
	var/pressuremax = 10 * ONE_ATMOSPHERE

	volume = 1000

	power_ratin69 = 7500 //7500 W ~ 10 HP
	power_losses = 150

/obj/machinery/portable_atmospherics/powered/pump/filled
	start_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/powered/pump/New()
	..()
	cell = new/obj/item/cell/medium/hi69h(src)

	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi("oxy69en", air_mix69"oxy69en"69, "nitro69en", air_mix69"nitro69en"69)

/obj/machinery/portable_atmospherics/powered/pump/update_icon()
	src.overlays = 0

	if(on && cell && cell.char69e)
		icon_state = "psiphon:1"
	else
		icon_state = "psiphon:0"

	if(holdin69)
		overlays += "siphon-open"

	if(connected_port)
		overlays += "siphon-connector"

	return

/obj/machinery/portable_atmospherics/powered/pump/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		on = !on

	if(prob(100/severity))
		direction_out = !direction_out

	tar69et_pressure = rand(0,1300)
	update_icon()

	..(severity)

/obj/machinery/portable_atmospherics/powered/pump/Process()
	..()
	var/power_draw = -1

	if(on && cell && cell.char69e)
		var/datum/69as_mixture/environment
		if(holdin69)
			environment = holdin69.air_contents
		else
			environment = loc.return_air()

		var/pressure_delta
		var/output_volume
		var/air_temperature
		if(direction_out)
			pressure_delta = tar69et_pressure - environment.return_pressure()
			output_volume = environment.volume * environment.69roup_multiplier
			air_temperature = environment.temperature? environment.temperature : air_contents.temperature
		else
			pressure_delta = environment.return_pressure() - tar69et_pressure
			output_volume = air_contents.volume * air_contents.69roup_multiplier
			air_temperature = air_contents.temperature? air_contents.temperature : environment.temperature

		var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_69AS_E69UATION)

		if (pressure_delta > 0.01)
			if (direction_out)
				power_draw = pump_69as(src, air_contents, environment, transfer_moles, power_ratin69)
			else
				power_draw = pump_69as(src, environment, air_contents, transfer_moles, power_ratin69)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw =69ax(power_draw, power_losses)
		cell.use(power_draw * CELLRATE)
		last_power_draw = power_draw

		update_connected_network()

		//ran out of char69e
		if (!cell.char69e)
			power_chan69e()
			update_icon()

	src.updateDialo69()

/obj/machinery/portable_atmospherics/powered/pump/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/powered/pump/attack_ai(var/mob/user)
	src.add_hiddenprint(user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/pump/attack_69host(var/mob/user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/powered/pump/attack_hand(var/mob/user)
	ui_interact(user)

/obj/machinery/portable_atmospherics/powered/pump/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=NANOUI_FOCUS)
	var/list/data69069
	data69"portConnected"69 = connected_port ? 1 : 0
	data69"tankPressure"69 = round(air_contents.return_pressure() > 0 ? air_contents.return_pressure() : 0)
	data69"tar69etpressure"69 = round(tar69et_pressure)
	data69"pump_dir"69 = direction_out
	data69"minpressure"69 = round(pressuremin)
	data69"maxpressure"69 = round(pressuremax)
	data69"powerDraw"69 = round(last_power_draw)
	data69"cellChar69e"69 = cell ? cell.char69e : 0
	data69"cellMaxChar69e"69 = cell ? cell.maxchar69e : 1
	data69"on"69 = on ? 1 : 0

	data69"hasHoldin69Tank"69 = holdin69 ? 1 : 0
	if (holdin69)
		data69"holdin69Tank"69 = list("name" = holdin69.name, "tankPressure" = round(holdin69.air_contents.return_pressure() > 0 ? holdin69.air_contents.return_pressure() : 0))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "portpump.tmpl", "Portable Pump", 480, 410, state =69LOB.physical_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/portable_atmospherics/powered/pump/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"power"69)
		on = !on
		. = 1
	if(href_list69"direction"69)
		direction_out = !direction_out
		. = 1
	if (href_list69"remove_tank"69)
		if(holdin69)
			holdin69.loc = loc
			holdin69 = null
		. = 1
	if (href_list69"pressure_adj"69)
		var/diff = text2num(href_list69"pressure_adj"69)
		tar69et_pressure =69in(10*ONE_ATMOSPHERE,69ax(0, tar69et_pressure+diff))
		. = 1

	if(.)
		update_icon()
