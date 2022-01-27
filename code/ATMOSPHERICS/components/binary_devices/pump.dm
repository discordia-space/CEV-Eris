/*
Every cycle, the pump uses the air in air_in to try and69ake air_out the perfect pressure.

node1, air1,69etwork1 correspond to input
node2, air2,69etwork2 correspond to output

Thus, the two69ariables affect pump operation are set in69ew():
	air1.volume
		This is the69olume of gas available to the pump that69ay be transfered to the output
	air2.volume
		Higher quantities of this cause69ore air to be perfected later
			but overall69etwork69olume is also increased as this increases...
*/

/obj/machinery/atmospherics/binary/pump
	icon = 'icons/atmos/pump.dmi'
	icon_state = "map_off"
	level = BELOW_PLATING_LEVEL

	name = "gas pump"
	desc = "A pump"

	var/target_pressure = ONE_ATMOSPHERE

	//var/max_volume_transfer = 10000

	use_power =69O_POWER_USE
	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 7500			//7500 W ~ 10 HP

	var/max_pressure_setting = 15000	//kPa

	var/frequency = 0
	var/id
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/binary/pump/New()
	..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP

/obj/machinery/atmospherics/binary/pump/AltClick(mob/user)
	if(user.incapacitated(INCAPACITATION_ALL) || isghost(user) || !user.IsAdvancedToolUser())
		return FALSE
	if(get_dist(user , src) > 1)
		return FALSE
	target_pressure =69ax_pressure_setting
	visible_message("69user69 sets the 69src69's pressure setting to the69aximum.",
		"You hear a LED panel being tapped and slid upon.", 6)
	investigate_log("had its pressure changed to 69target_pressure69 by 69key_name(user)69", "atmos")
	update_icon()

/obj/machinery/atmospherics/binary/pump/CtrlClick(mob/user)
	if(user.incapacitated(INCAPACITATION_ALL) || isghost(user) || !user.IsAdvancedToolUser())
		return FALSE
	if(get_dist(user , src) > 1)
		return FALSE
	use_power = !use_power
	visible_message("69user69 turns 69use_power ? "on" : "off"69 \the 69src69's69alve.",
	"You hear a69alve being turned.", 6)
	investigate_log("had its power status changed to 69use_power69 by 69key_name(user)69", "atmos")
	update_icon()

/obj/machinery/atmospherics/binary/pump/on
	icon_state = "map_on"
	use_power = IDLE_POWER_USE


/obj/machinery/atmospherics/binary/pump/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "69use_power ? "on" : "off"69"

/obj/machinery/atmospherics/binary/pump/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T,69ode1, turn(dir, -180))
		add_underlay(T,69ode2, dir)

/obj/machinery/atmospherics/binary/pump/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/binary/pump/Process()
	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	var/pressure_delta = target_pressure - air2.return_pressure()

	if(pressure_delta > 0.01 && air1.temperature > 0)
		//Figure out how69uch gas to transfer to69eet the target pressure.
		var/transfer_moles = calculate_transfer_moles(air1, air2, pressure_delta, (network2)?69etwork2.volume : 0)
		power_draw = pump_gas(src, air1, air2, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power(power_draw)

		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	return 1

//Radio remote control

/obj/machinery/atmospherics/binary/pump/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency =69ew_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal =69ew
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AGP",
		"power" = use_power,
		"target_output" = target_pressure,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/binary/pump/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	if(stat & (BROKEN|NOPOWER))
		return

	// this is the data which will be sent to the ui
	var/data69069

	data = list(
		"on" = use_power,
		"pressure_set" = round(target_pressure*100),	//Nano UI can't handle rounded69on-integers, apparently.
		"max_pressure" =69ax_pressure_setting,
		"last_flow_rate" = round(last_flow_rate*10),
		"last_power_draw" = round(last_power_draw),
		"max_power_draw" = power_rating,
	)

	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does69ot exist, so we'll create a69ew() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "gas_pump.tmpl",69ame, 470, 290)
		ui.set_initial_data(data)	// when the ui is first opened this is the data it will use
		ui.open()					// open the69ew ui window
		ui.set_auto_update(1)		// auto update every69aster Controller tick

/obj/machinery/atmospherics/binary/pump/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/binary/pump/receive_signal(datum/signal/signal)
	if(!signal.data69"tag"69 || (signal.data69"tag"69 != id) || (signal.data69"sigtype"69!="command"))
		return 0

	if(signal.data69"power"69)
		if(text2num(signal.data69"power"69))
			use_power = IDLE_POWER_USE
		else
			use_power =69O_POWER_USE
		investigate_log("was 69use_power ? "enabled" : "disabled"69 by a remote signal", "atmos")

	if("power_toggle" in signal.data)
		investigate_log("was 69use_power ? "disabled" : "enabled"69 by a remote signal", "atmos")
		use_power = !use_power

	if(signal.data69"set_output_pressure"69)
		target_pressure = between(
			0,
			text2num(signal.data69"set_output_pressure"69),
			ONE_ATMOSPHERE*50
		)
		investigate_log("had it's pressure changed to 69target_pressure69 by a remote signal", "atmos")

	if(signal.data69"status"69)
		spawn(2)
			broadcast_status()
		return //do69ot update_icon

	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/binary/pump/attack_hand(user as69ob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	usr.set_machine(src)
	ui_interact(user)
	return

/obj/machinery/atmospherics/binary/pump/Topic(href, href_list)
	if(..()) return 1

	if(href_list69"power"69)
		investigate_log("was 69use_power ? "disabled" : "enabled"69 by a 69key_name(usr)69", "atmos")
		use_power = !use_power

	switch(href_list69"set_press"69)
		if ("min")
			target_pressure = 0
		if ("max")
			target_pressure =69ax_pressure_setting
		if ("set")
			var/new_pressure = input(usr, "Enter69ew output pressure (0-69max_pressure_setting69kPa)", "Pressure control", src.target_pressure) as69um
			src.target_pressure = between(0,69ew_pressure,69ax_pressure_setting)
	if(href_list69"set_press"69)
		investigate_log("had it's pressure changed to 69target_pressure69 by 69key_name(usr)69", "atmos")

	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	usr.set_machine(src)
	src.add_fingerprint(usr)

	src.update_icon()

/obj/machinery/atmospherics/binary/pump/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/binary/pump/attackby(var/obj/item/I,69ar/mob/user)
	if(!(QUALITY_BOLT_TURNING in I.tool_qualities))
		return ..()
	if (!(stat &69OPOWER) && use_power)
		to_chat(user, SPAN_WARNING("You cannot unwrench this 69src69, turn it off first."))
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, SPAN_WARNING("You cannot unwrench this 69src69, it too exerted due to internal pressure."))
		add_fingerprint(user)
		return 1
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the 69src69..."))
	if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
		user.visible_message( \
			SPAN_NOTICE("\The 69user69 unfastens \the 69src69."), \
			SPAN_NOTICE("You have unfastened \the 69src69."), \
			"You hear ratchet.")
		investigate_log("was unfastened by 69key_name(user)69", "atmos")
		new /obj/item/pipe(loc,69ake_from=src)
		qdel(src)
