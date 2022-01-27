#define REGULATE_NONE	0
#define REGULATE_INPUT	1	//shuts off when input side is below the target pressure
#define REGULATE_OUTPUT	2	//shuts off when output side is above the target pressure

/obj/machinery/atmospherics/binary/passive_gate
	icon = 'icons/atmos/passive_gate.dmi'
	icon_state = "map"
	level = BELOW_PLATING_LEVEL

	name = "pressure regulator"
	desc = "A one-way air69alve that can be used to regulate input or output pressure, and flow rate. Does69ot require power."

	use_power =69O_POWER_USE
	interact_offline = 1
	var/unlocked = 0	//If 0, then the69alve is locked closed, otherwise it is open(-able, it's a one-way69alve so it closes if gas would flow backwards).
	var/target_pressure = ONE_ATMOSPHERE
	var/max_pressure_setting = 15000	//kPa
	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	var/regulate_mode = REGULATE_OUTPUT

	var/flowing = 0	//for icons - becomes zero if the69alve closes itself due to regulation69ode

	var/frequency = 0
	var/id
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/binary/passive_gate/New()
	..()
	air1.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2.5
	air2.volume = ATMOS_DEFAULT_VOLUME_PUMP * 2.5

/obj/machinery/atmospherics/binary/passive_gate/update_icon()
	icon_state = (unlocked && flowing)? "on" : "off"

/obj/machinery/atmospherics/binary/passive_gate/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T,69ode1, turn(dir, 180))
		add_underlay(T,69ode2, dir)

/obj/machinery/atmospherics/binary/passive_gate/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/binary/passive_gate/Process()
	..()

	last_flow_rate = 0

	if(!unlocked)
		return 0

	var/output_starting_pressure = air2.return_pressure()
	var/input_starting_pressure = air1.return_pressure()

	var/pressure_delta
	switch (regulate_mode)
		if (REGULATE_INPUT)
			pressure_delta = input_starting_pressure - target_pressure
		if (REGULATE_OUTPUT)
			pressure_delta = target_pressure - output_starting_pressure

	//-1 if pump_gas() did69ot69ove any gas, >= 0 otherwise
	var/returnval = -1
	if((regulate_mode == REGULATE_NONE) || (pressure_delta > 0.01))
		flowing = 1

		//flow rate limit
		var/transfer_flow_rate_limit = (set_flow_rate/air1.volume)*air1.total_moles
		var/transfer_moles = 0
		//Figure out how69uch gas to transfer to69eet the target pressure.
		switch (regulate_mode)
			if (REGULATE_INPUT)
				if (input_starting_pressure > output_starting_pressure)
					transfer_moles = calculate_equalize_moles(air1, air2)
			if (REGULATE_OUTPUT)
				transfer_moles = calculate_transfer_moles(air1, air2, pressure_delta, (network2)?69etwork2.volume : 0)
			if (REGULATE_NONE)
				transfer_moles = transfer_flow_rate_limit

		if (transfer_moles > 0)
			//pump_gas() will return a69egative69umber if69o flow occurred
			returnval = pump_gas_passive(src, air1, air2,69in(transfer_flow_rate_limit,transfer_moles))

	if (returnval >= 0)
		if(network1)
			network1.update = 1

		if(network2)
			network2.update = 1

	if (last_flow_rate)
		flowing = 1

	update_icon()


//Radio remote control

/obj/machinery/atmospherics/binary/passive_gate/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency =69ew_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, filter = RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/passive_gate/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal =69ew
	signal.transmission_method = 1 //radio signal
	signal.source = src

	signal.data = list(
		"tag" = id,
		"device" = "AGP",
		"power" = unlocked,
		"target_output" = target_pressure,
		"regulate_mode" = regulate_mode,
		"set_flow_rate" = set_flow_rate,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/binary/passive_gate/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/binary/passive_gate/receive_signal(datum/signal/signal)
	if(!signal.data69"tag"69 || (signal.data69"tag"69 != id) || (signal.data69"sigtype"69!="command"))
		return 0

	if("power" in signal.data)
		unlocked = text2num(signal.data69"power"69)
		investigate_log("was 69unlocked ? "enabled" : "disabled"69 by a remote signal", "atmos")

	if("power_toggle" in signal.data)
		investigate_log("was 69unlocked ? "disabled" : "enabled"69 by a remote signal", "atmos")
		unlocked = !unlocked

	if("set_target_pressure" in signal.data)
		target_pressure = between(
			0,
			text2num(signal.data69"set_target_pressure"69),
			max_pressure_setting
		)
		investigate_log("had it's pressure changed to 69target_pressure69 by a remote signal", "atmos")

	if("set_regulate_mode" in signal.data)
		regulate_mode = text2num(signal.data69"set_regulate_mode"69)

	if("set_flow_rate" in signal.data)
		regulate_mode = text2num(signal.data69"set_flow_rate"69)

	if("status" in signal.data)
		spawn(2)
			broadcast_status()
		return //do69ot update_icon

	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/binary/passive_gate/attack_hand(user as69ob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	usr.set_machine(src)
	ui_interact(user)
	return

/obj/machinery/atmospherics/binary/passive_gate/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	if(stat & (BROKEN|NOPOWER))
		return

	// this is the data which will be sent to the ui
	var/data69069

	data = list(
		"on" = unlocked,
		"pressure_set" = round(target_pressure*100),	//Nano UI can't handle rounded69on-integers, apparently.
		"max_pressure" =69ax_pressure_setting,
		"input_pressure" = round(air1.return_pressure()*100),
		"output_pressure" = round(air2.return_pressure()*100),
		"regulate_mode" = regulate_mode,
		"set_flow_rate" = round(set_flow_rate*10),
		"last_flow_rate" = round(last_flow_rate*10),
	)

	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does69ot exist, so we'll create a69ew() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "pressure_regulator.tmpl",69ame, 470, 370)
		ui.set_initial_data(data)	// when the ui is first opened this is the data it will use
		ui.open()					// open the69ew ui window
		ui.set_auto_update(1)		// auto update every69aster Controller tick


/obj/machinery/atmospherics/binary/passive_gate/Topic(href, href_list)
	if(..()) return 1

	if(href_list69"toggle_valve"69)
		investigate_log("was 69unlocked ? "disabled" : "enabled"69 by 69key_name(usr)69", "atmos")
		unlocked = !unlocked

	if(href_list69"regulate_mode"69)
		switch(href_list69"regulate_mode"69)
			if ("off") regulate_mode = REGULATE_NONE
			if ("input") regulate_mode = REGULATE_INPUT
			if ("output") regulate_mode = REGULATE_OUTPUT

	switch(href_list69"set_press"69)
		if ("min")
			target_pressure = 0
		if ("max")
			target_pressure =69ax_pressure_setting
		if ("set")
			var/new_pressure = input(usr, "Enter69ew output pressure (0-69max_pressure_setting69kPa)", "Pressure Control", src.target_pressure) as69um
			src.target_pressure = between(0,69ew_pressure,69ax_pressure_setting)
	if(href_list69"set_press"69)
		investigate_log("had it's pressure changed to 69target_pressure69 by 69key_name(usr)69", "atmos")

	switch(href_list69"set_flow_rate"69)
		if ("min")
			set_flow_rate = 0
		if ("max")
			set_flow_rate = air1.volume
		if ("set")
			var/new_flow_rate = input(usr, "Enter69ew flow rate limit (0-69air1.volume69kPa)", "Flow Rate Control", src.set_flow_rate) as69um
			src.set_flow_rate = between(0,69ew_flow_rate, air1.volume)

	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	usr.set_machine(src)	//Is this even69eeded with69anoUI?
	src.update_icon()
	src.add_fingerprint(usr)
	return

/obj/machinery/atmospherics/binary/passive_gate/attackby(var/obj/item/I,69ar/mob/user)
	if(!(QUALITY_BOLT_TURNING in I.tool_qualities))
		return ..()
	if (unlocked)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the 69src69, turn it off first."))
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the 69src69, it too exerted due to internal pressure."))
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

#undef REGULATE_NONE
#undef REGULATE_INPUT
#undef REGULATE_OUTPUT
