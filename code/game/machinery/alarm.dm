//all air alarms in area are connected69ia69a69ic
/area
	var/obj/machinery/alarm/master_air_alarm
	var/list/air_vent_names = list()
	var/list/air_scrub_names = list()
	var/list/air_vent_info = list()
	var/list/air_scrub_info = list()

/obj/machinery/alarm
	name = "alarm"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarm0"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 80
	active_power_usa69e = 3000 //For heatin69/coolin69 rooms. 1000 joules e69uates to about 1 de69ree every 2 seconds for a sin69le tile of air.
	power_channel = STATIC_ENVIRON
	re69_one_access = list(access_atmospherics, access_en69ine_e69uip)
	var/alarm_id = null
	var/breach_detection = 1 // Whether to use automatic breach detection or not
	var/fre69uency = 1439
	//var/skipprocess = 0 //Experimentin69
	var/alarm_fre69uency = 1437
	var/remote_control = 0
	var/rcon_settin69 = 2
	var/rcon_time = 0
	var/locked = TRUE
	var/wiresexposed = FALSE // If it's been screwdrivered open.
	var/aidisabled = 0
	var/shorted = 0

	var/datum/wires/alarm/wires

	var/mode = AALARM_MODE_SCRUBBIN69
	var/screen = AALARM_SCREEN_MAIN
	var/area_uid
	var/area/alarm_area
	var/buildsta69e = 2 //2 is built, 1 is buildin69, 0 is frame.

	var/tar69et_temperature = T0C + 20
	var/re69ulatin69_temperature = 0

	var/datum/radio_fre69uency/radio_connection

	var/list/TLV = list()
	var/list/trace_69as = list("sleepin69_a69ent") //list of other 69ases that this air alarm is able to detect

	var/dan69er_level = 0
	var/pressure_dan69erlevel = 0
	var/oxy69en_dan69erlevel = 0
	var/co2_dan69erlevel = 0
	var/plasma_dan69erlevel = 0
	var/temperature_dan69erlevel = 0
	var/other_dan69erlevel = 0

	var/report_dan69er_level = 1

/obj/machinery/alarm/nobreach
	breach_detection = 0

/obj/machinery/alarm/monitor
	report_dan69er_level = 0
	breach_detection = 0

/obj/machinery/alarm/server/New()
	..()
	re69_access = list(access_rd, access_atmospherics, access_en69ine_e69uip)
	TLV69"oxy69en"69 =			list(-1.0, -1.0,-1.0,-1.0) // Partial pressure, kpa
	TLV69"carbon dioxide"69 = list(-1.0, -1.0,   5,  10) // Partial pressure, kpa
	TLV69"plasma"69 =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV69"other"69 =			list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV69"pressure"69 =		list(0, ONE_ATMOSPHERE * 0.10, ONE_ATMOSPHERE * 1.40, ONE_ATMOSPHERE * 1.60) /* kpa */
	TLV69"temperature"69 =	list(20, 40, 140, 160) // K
	tar69et_temperature = 90

/obj/machinery/alarm/Destroy()
	69LOB.alarm_list -= src
	unre69ister_radio(src, fre69uency)
	69del(wires)
	wires = null
	return ..()

/obj/machinery/alarm/New(loc, dir, buildin69 = 0)
	69LOB.alarm_list += src
	if(buildin69)
		if(dir)
			src.set_dir(dir)

		buildsta69e = 0
		wiresexposed = 1
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0
		update_icon()

	..()

	if(!buildin69)
		first_run()

/obj/machinery/alarm/proc/first_run()
	alarm_area = 69et_area(src)
	if(!alarm_area)
		error("Alarm cant find an area - 69type69 - 69x69:69y69:69z69")
		return
	area_uid = alarm_area.uid
	if (name == "alarm")
		name = "69strip_improper(alarm_area.name)69 Air Alarm"

	if(!wires)
		wires = new(src)

	// breathable air accordin69 to human/Life()
	TLV69"oxy69en"69 =			list(16, 19, 135, 140) // Partial pressure, kpa
	TLV69"carbon dioxide"69 = list(-1.0, -1.0, 5, 10) // Partial pressure, kpa
	TLV69"plasma"69 =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV69"other"69 =			list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV69"pressure"69 =		list(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.10,ONE_ATMOSPHERE*1.20) /* kpa */
	TLV69"temperature"69 =	list(T0C-26, T0C, T0C+40, T0C+66) // K


/obj/machinery/alarm/Initialize()
	. = ..()
	set_fre69uency(fre69uency)
	if(buildsta69e == 2 && !master_is_operatin69())
		elect_master()

/obj/machinery/alarm/fire_act()
	return

/obj/machinery/alarm/Process()
	if((stat & (NOPOWER|BROKEN)) || shorted || buildsta69e != 2)
		return

	var/turf/simulated/location = loc
	if(!istype(location))
		return//returns if loc is not simulated

	var/datum/69as_mixture/environment = location.return_air()
	if (!environment)
		return
	//Handle temperature adjustment here.
	handle_heatin69_coolin69(environment)

	var/old_level = dan69er_level
	var/old_pressurelevel = pressure_dan69erlevel
	dan69er_level = overall_dan69er_level(environment)

	if (old_level != dan69er_level)
		apply_dan69er_level(dan69er_level)

	if (old_pressurelevel != pressure_dan69erlevel)
		if (breach_detected())
			apply_mode(AALARM_MODE_OFF)

	if (mode==AALARM_MODE_CYCLE && environment.return_pressure()<ONE_ATMOSPHERE*0.05)
		apply_mode(AALARM_MODE_FILL)

	//atmos computer remote controll stuff
	switch(rcon_settin69)
		if(RCON_NO)
			remote_control = 0
		if(RCON_AUTO)
			if(dan69er_level == 2)
				remote_control = 1
			else
				remote_control = 0
		if(RCON_YES)
			remote_control = 1

	return

/obj/machinery/alarm/proc/handle_heatin69_coolin69(var/datum/69as_mixture/environment)
	if (!re69ulatin69_temperature)
		//check for when we should start adjustin69 temperature
		if(69et_dan69er_level(environment.temperature, TLV69"temperature"69) || abs(environment.temperature - tar69et_temperature) > 2)
			update_use_power(2)
			re69ulatin69_temperature = 1
			visible_messa69e("\The 69src69 clicks as it starts up.",\
			"You hear a click and a faint electronic hum.")
	else
		//check for when we should stop adjustin69 temperature
		if (!69et_dan69er_level(environment.temperature, TLV69"temperature"69) && abs(environment.temperature - tar69et_temperature) <= 0.5)
			update_use_power(1)
			re69ulatin69_temperature = 0
			visible_messa69e("\The 69src69 clicks 69uietly.",\
			"You hear a click as a faint electronic hummin69 stops.")

	if (re69ulatin69_temperature)
		if(tar69et_temperature > T0C +69AX_TEMPERATURE)
			tar69et_temperature = T0C +69AX_TEMPERATURE
		else if(tar69et_temperature < T0C +69IN_TEMPERATURE)
			tar69et_temperature = T0C +69IN_TEMPERATURE

		if(environment.total_moles)
			var/thermalChan69e = environment.69et_thermal_ener69y_chan69e(tar69et_temperature)
			if (environment.temperature <= tar69et_temperature)
				//69as heatin69
				var/ener69y_used =69in(thermalChan69e, active_power_usa69e)
				environment.add_thermal_ener69y(ener69y_used)
			else
				//69as coolin69
				var/heat_transfer =69in(abs(thermalChan69e), active_power_usa69e)
				//Assume the heat is bein69 pumped into the hull which is fixed at 20 C
				//none of this is really proper thermodynamics but whatever

				var/cop = environment.temperature/T20C	//coefficient of performance -> power used = heat_transfer/cop
				heat_transfer =69in(heat_transfer, cop * active_power_usa69e)	//this ensures that we don't use69ore than active_power_usa69e amount of power
				heat_transfer = -environment.add_thermal_ener69y(-heat_transfer)	//69et the actual heat transfer
				//use_power(heat_transfer / cop, ENVIRON)	//handle by update_use_power instead

/obj/machinery/alarm/proc/overall_dan69er_level(var/datum/69as_mixture/environment)
	var/partial_pressure = R_IDEAL_69AS_E69UATION*environment.temperature/environment.volume
	var/environment_pressure = environment.return_pressure()

	var/other_moles = 0
	for(var/69 in trace_69as)
		other_moles += environment.69as696969 //this is only 69oin69 to be used in a partial pressure calc, so we don't need to worry about 69roup_multiplier here.

	pressure_dan69erlevel = 69et_dan69er_level(environment_pressure, TLV69"pressure"69)
	oxy69en_dan69erlevel = 69et_dan69er_level(environment.69as69"oxy69en"69*partial_pressure, TLV69"oxy69en"69)
	co2_dan69erlevel = 69et_dan69er_level(environment.69as69"carbon_dioxide"69*partial_pressure, TLV69"carbon dioxide"69)
	plasma_dan69erlevel = 69et_dan69er_level(environment.69as69"plasma"69*partial_pressure, TLV69"plasma"69)
	temperature_dan69erlevel = 69et_dan69er_level(environment.temperature, TLV69"temperature"69)
	other_dan69erlevel = 69et_dan69er_level(other_moles*partial_pressure, TLV69"other"69)

	return69ax(
		pressure_dan69erlevel,
		oxy69en_dan69erlevel,
		co2_dan69erlevel,
		plasma_dan69erlevel,
		other_dan69erlevel,
		temperature_dan69erlevel
		)

// Returns whether this air alarm thinks there is a breach, 69iven the sensors that are available to it.
/obj/machinery/alarm/proc/breach_detected()
	var/turf/simulated/location = loc

	if(!istype(location))
		return 0

	if(breach_detection	== 0)
		return 0

	var/datum/69as_mixture/environment = location.return_air()
	var/environment_pressure = environment.return_pressure()
	var/pressure_levels = TLV69"pressure"69

	if (environment_pressure <= pressure_levels69169)		//low pressures
		if (!(mode == AALARM_MODE_PANIC ||69ode == AALARM_MODE_CYCLE))
			return 1

	return 0


/obj/machinery/alarm/proc/master_is_operatin69()
	return alarm_area.master_air_alarm && !(alarm_area.master_air_alarm.stat & (NOPOWER|BROKEN))


/obj/machinery/alarm/proc/elect_master()
	for (var/obj/machinery/alarm/AA in alarm_area)
		if (!(AA.stat & (NOPOWER|BROKEN)))
			alarm_area.master_air_alarm = AA
			return 1
	return 0

/obj/machinery/alarm/proc/69et_dan69er_level(var/current_value,69ar/list/dan69er_levels)
	if((current_value >= dan69er_levels69469 && dan69er_levels69469 > 0) || current_value <= dan69er_levels69169)
		return 2
	if((current_value >= dan69er_levels69369 && dan69er_levels69369 > 0) || current_value <= dan69er_levels69269)
		return 1
	return 0

/obj/machinery/alarm/update_icon()
	if(wiresexposed)
		switch(buildsta69e)
			if(2)
				icon_state = "alarm_build2"
			if(1)
				icon_state = "alarm_build1"
			if(0)
				icon_state = "alarm_build0"
		set_li69ht(0)
		return

	if(stat & (BROKEN))
		icon_state = "alarm_broken"
		set_li69ht(0)
		return

	if((stat & (NOPOWER)) || shorted)
		icon_state = "alarm_unpowered"
		set_li69ht(0)
		return

	if(!alarm_area)
		error("Alarm cant find an area - 69type69 - 69x69:69y69:69z69")
		return

	var/icon_level = dan69er_level
	if (alarm_area.atmosalm)
		icon_level =69ax(icon_level, 1)	//if there's an atmos alarm but everythin69 is okay locally, no need to 69o past yellow

	var/new_color = null
	switch(icon_level)
		if (0)
			icon_state = "alarm0"
			new_color = COLOR_LI69HTIN69_69REEN_BRI69HT
		if (1)
			icon_state = "alarm1"
			new_color = COLOR_LI69HTIN69_ORAN69E_MACHINERY
		if (2)
			icon_state = "alarm2"
			new_color = COLOR_LI69HTIN69_RED_MACHINERY

	set_li69ht(l_ran69e = 1.5, l_power = 0.2, l_color = new_color)

/obj/machinery/alarm/receive_si69nal(datum/si69nal/si69nal)
	if(stat & (NOPOWER|BROKEN))
		return
	if (alarm_area.master_air_alarm != src)
		if (master_is_operatin69())
			return
		elect_master()
		if (alarm_area.master_air_alarm != src)
			return
	if(!si69nal || si69nal.encryption)
		return
	var/id_ta69 = si69nal.data69"ta69"69
	if (!id_ta69)
		return
	if (si69nal.data69"area"69 != area_uid)
		return
	if (si69nal.data69"si69type"69 != "status")
		return

	var/dev_type = si69nal.data69"device"69
	if(!(id_ta69 in alarm_area.air_scrub_names) && !(id_ta69 in alarm_area.air_vent_names))
		re69ister_env_machine(id_ta69, dev_type)
	if(dev_type == "AScr")
		alarm_area.air_scrub_info69id_ta6969 = si69nal.data
	else if(dev_type == "AVP")
		alarm_area.air_vent_info69id_ta6969 = si69nal.data

/obj/machinery/alarm/proc/re69ister_env_machine(var/m_id,69ar/device_type)
	var/new_name
	if (device_type=="AVP")
		new_name = "69alarm_area.name6969ent Pump #69alarm_area.air_vent_names.len+169"
		alarm_area.air_vent_names69m_id69 = new_name
	else if (device_type=="AScr")
		new_name = "69alarm_area.name69 Air Scrubber #69alarm_area.air_scrub_names.len+169"
		alarm_area.air_scrub_names69m_id69 = new_name
	else
		return
	spawn (10)
		send_si69nal(m_id, list("init" = new_name) )

/obj/machinery/alarm/proc/refresh_all()
	for(var/id_ta69 in alarm_area.air_vent_names)
		var/list/I = alarm_area.air_vent_info69id_ta6969
		if (I && I69"timestamp"69+AALARM_REPORT_TIMEOUT/2 > world.time)
			continue
		send_si69nal(id_ta69, list("status") )
	for(var/id_ta69 in alarm_area.air_scrub_names)
		var/list/I = alarm_area.air_scrub_info69id_ta6969
		if (I && I69"timestamp"69+AALARM_REPORT_TIMEOUT/2 > world.time)
			continue
		send_si69nal(id_ta69, list("status") )

/obj/machinery/alarm/proc/set_fre69uency(new_fre69uency)
	SSradio.remove_object(src, fre69uency)
	fre69uency = new_fre69uency
	radio_connection = SSradio.add_object(src, fre69uency, RADIO_TO_AIRALARM)

/obj/machinery/alarm/proc/send_si69nal(var/tar69et,69ar/list/command)//sends si69nal 'command' to 'tar69et'. Returns 0 if no radio connection, 1 otherwise
	if(!radio_connection)
		return 0

	var/datum/si69nal/si69nal = new
	si69nal.transmission_method = 1 //radio si69nal
	si69nal.source = src

	si69nal.data = command
	si69nal.data69"ta69"69 = tar69et
	si69nal.data69"si69type"69 = "command"

	radio_connection.post_si69nal(src, si69nal, RADIO_FROM_AIRALARM)
//			world << text("Si69nal 6969 Broadcasted to 6969", command, tar69et)

	return 1

/obj/machinery/alarm/proc/apply_mode(var/new_mode)
	//propa69ate69ode to other air alarms in the area
	//TODO:69ake it so that players can choose between applyin69 the new69ode to the room they are in (related area)69s the entire alarm area
	if(new_mode)
		mode = new_mode
	for (var/obj/machinery/alarm/AA in alarm_area)
		AA.mode =69ode

	switch(mode)
		if(AALARM_MODE_SCRUBBIN69)
			to_chat(usr, "Air Alarm69ode chan69ed to Filterin69.")
			for(var/device_id in alarm_area.air_scrub_names)
				send_si69nal(device_id, list("power"= 1, "co2_scrub"= 1, "scrubbin69"= 1, "panic_siphon"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_si69nal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_PANIC, AALARM_MODE_CYCLE)
			if(mode == AALARM_MODE_PANIC)
				to_chat(usr, "Air Alarm69ode chan69ed to Panic.")
			else
				to_chat(usr, "Air Alarm69ode chan69ed to Cycle.")
			for(var/device_id in alarm_area.air_scrub_names)
				send_si69nal(device_id, list("power"= 1, "panic_siphon"= 1) )
			for(var/device_id in alarm_area.air_vent_names)
				send_si69nal(device_id, list("power"= 0) )

		if(AALARM_MODE_REPLACEMENT)
			to_chat(usr, "Air Alarm69ode chan69ed to Replace Air.")
			for(var/device_id in alarm_area.air_scrub_names)
				send_si69nal(device_id, list("power"= 1, "panic_siphon"= 1) )
			for(var/device_id in alarm_area.air_vent_names)
				send_si69nal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_FILL)
			to_chat(usr, "Air Alarm69ode chan69ed to Fill.")
			for(var/device_id in alarm_area.air_scrub_names)
				send_si69nal(device_id, list("power"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_si69nal(device_id, list("power"= 1, "checks"= "default", "set_external_pressure"= "default") )

		if(AALARM_MODE_OFF)
			to_chat(usr, "Air Alarm69ode chan69ed to Off.")
			for(var/device_id in alarm_area.air_scrub_names)
				send_si69nal(device_id, list("power"= 0) )
			for(var/device_id in alarm_area.air_vent_names)
				send_si69nal(device_id, list("power"= 0) )

/obj/machinery/alarm/proc/apply_dan69er_level(var/new_dan69er_level)
	if (report_dan69er_level && alarm_area.atmosalert(new_dan69er_level, src))
		post_alert(new_dan69er_level)
	alarm_area.updateicon()
	update_icon()

/obj/machinery/alarm/proc/post_alert(alert_level)
	var/datum/radio_fre69uency/fre69uency = SSradio.return_fre69uency(alarm_fre69uency)
	if(!fre69uency)
		return

	var/datum/si69nal/alert_si69nal = new
	alert_si69nal.source = src
	alert_si69nal.transmission_method = 1
	alert_si69nal.data69"zone"69 = alarm_area.name
	alert_si69nal.data69"type"69 = "Atmospheric"

	if(alert_level==2)
		alert_si69nal.data69"alert"69 = "severe"
	else if (alert_level==1)
		alert_si69nal.data69"alert"69 = "minor"
	else if (alert_level==0)
		alert_si69nal.data69"alert"69 = "clear"

	fre69uency.post_si69nal(src, alert_si69nal)

/obj/machinery/alarm/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/alarm/attack_hand(mob/user)
	. = ..()
	if (.)
		return
	return interact(user)

/obj/machinery/alarm/interact(mob/user)
	ui_interact(user)
	wires.Interact(user)

/obj/machinery/alarm/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS,69ar/master_ui = null,69ar/datum/topic_state/state = 69LOB.default_state)
	var/data69069
	var/remote_connection = 0
	var/remote_access = 0
	if(state)
		var/list/href = state.href_list(user)
		remote_connection = href69"remote_connection"69	// Remote connection69eans we're non-adjacent/connectin69 from another computer
		remote_access = href69"remote_access"69			// Remote access69eans we also have the privile69e to alter the air alarm.

	data69"locked"69 = locked && !issilicon(user)
	data69"remote_connection"69 = remote_connection
	data69"remote_access"69 = remote_access
	data69"rcon"69 = rcon_settin69
	data69"screen"69 = screen

	populate_status(data)

	if(!(locked && !remote_connection) || remote_access || issilicon(user))
		populate_controls(data)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "air_alarm.tmpl", src.name, 400, 625,69aster_ui =69aster_ui, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/alarm/proc/populate_status(var/data)
	var/turf/location = 69et_turf(src)
	var/datum/69as_mixture/environment = location.return_air()
	var/total = environment.total_moles

	var/list/environment_data = new
	data69"has_environment"69 = total
	if(total)
		var/pressure = environment.return_pressure()
		environment_data69++environment_data.len69 = list("name" = "Pressure", "value" = pressure, "unit" = "kPa", "dan69er_level" = pressure_dan69erlevel)
		environment_data69++environment_data.len69 = list("name" = "Oxy69en", "value" = environment.69as69"oxy69en"69 / total * 100, "unit" = "%", "dan69er_level" = oxy69en_dan69erlevel)
		environment_data69++environment_data.len69 = list("name" = "Carbon dioxide", "value" = environment.69as69"carbon_dioxide"69 / total * 100, "unit" = "%", "dan69er_level" = co2_dan69erlevel)
		environment_data69++environment_data.len69 = list("name" = "Toxins", "value" = environment.69as69"plasma"69 / total * 100, "unit" = "%", "dan69er_level" = plasma_dan69erlevel)
		environment_data69++environment_data.len69 = list("name" = "Temperature", "value" = environment.temperature, "unit" = "K (69round(environment.temperature - T0C, 0.1)69C)", "dan69er_level" = temperature_dan69erlevel)
	data69"total_dan69er"69 = dan69er_level
	data69"environment"69 = environment_data
	data69"atmos_alarm"69 = alarm_area.atmosalm
	data69"fire_alarm"69 = alarm_area.fire != null
	data69"tar69et_temperature"69 = "69tar69et_temperature - T0C69C"

/obj/machinery/alarm/proc/populate_controls(var/list/data)
	switch(screen)
		if(AALARM_SCREEN_MAIN)
			data69"mode"69 =69ode
		if(AALARM_SCREEN_VENT)
			var/vents69069
			for(var/id_ta69 in alarm_area.air_vent_names)
				var/lon69_name = alarm_area.air_vent_names69id_ta6969
				var/list/info = alarm_area.air_vent_info69id_ta6969
				if(!info)
					continue
				vents69++vents.len69 = list(
						"id_ta69"			= id_ta69,
						"lon69_name"			= sanitize(lon69_name),
						"power"				= info69"power"69,
						"expanded_ran69e"	= info69"expanded_ran69e"69,
						"checks"			= info69"checks"69,
						"direction"			= info69"direction"69,
						"external"			= info69"external"69
					)
			data69"vents"69 =69ents
		if(AALARM_SCREEN_SCRUB)
			var/scrubbers69069
			for(var/id_ta69 in alarm_area.air_scrub_names)
				var/lon69_name = alarm_area.air_scrub_names69id_ta6969
				var/list/info = alarm_area.air_scrub_info69id_ta6969
				if(!info)
					continue
				scrubbers69++scrubbers.len69 = list(
						"id_ta69"			= id_ta69,
						"lon69_name"			= sanitize(lon69_name),
						"power"				= info69"power"69,
						"expanded_ran69e"	= info69"expanded_ran69e"69,
						"scrubbin69"			= info69"scrubbin69"69,
						"panic"				= info69"panic"69,
						"filters"			= list()
					)
				scrubbers69scrubbers.len6969"filters"69 += list(list("name" = "Oxy69en",			"command" = "o2_scrub",	"val" = info69"filter_o2"69))
				scrubbers69scrubbers.len6969"filters"69 += list(list("name" = "Nitro69en",		"command" = "n2_scrub",	"val" = info69"filter_n2"69))
				scrubbers69scrubbers.len6969"filters"69 += list(list("name" = "Carbon Dioxide", "command" = "co2_scrub","val" = info69"filter_co2"69))
				scrubbers69scrubbers.len6969"filters"69 += list(list("name" = "Toxin"	, 		"command" = "tox_scrub","val" = info69"filter_plasma"69))
				scrubbers69scrubbers.len6969"filters"69 += list(list("name" = "Nitrous Oxide",	"command" = "n2o_scrub","val" = info69"filter_n2o"69))
			data69"scrubbers"69 = scrubbers
		if(AALARM_SCREEN_MODE)
			var/modes69069
			modes69++modes.len69 = list("name" = "Filterin69 - Scrubs out contaminants", 			"mode" = AALARM_MODE_SCRUBBIN69,		"selected" =69ode == AALARM_MODE_SCRUBBIN69, 	"dan69er" = 0)
			modes69++modes.len69 = list("name" = "Replace Air - Siphons out air while replacin69", "mode" = AALARM_MODE_REPLACEMENT,	"selected" =69ode == AALARM_MODE_REPLACEMENT,	"dan69er" = 0)
			modes69++modes.len69 = list("name" = "Panic - Siphons air out of the room", 			"mode" = AALARM_MODE_PANIC,			"selected" =69ode == AALARM_MODE_PANIC, 		"dan69er" = 1)
			modes69++modes.len69 = list("name" = "Cycle - Siphons air before replacin69", 			"mode" = AALARM_MODE_CYCLE,			"selected" =69ode == AALARM_MODE_CYCLE, 		"dan69er" = 1)
			modes69++modes.len69 = list("name" = "Fill - Shuts off scrubbers and opens69ents", 	"mode" = AALARM_MODE_FILL,			"selected" =69ode == AALARM_MODE_FILL, 			"dan69er" = 0)
			modes69++modes.len69 = list("name" = "Off - Shuts off69ents and scrubbers", 			"mode" = AALARM_MODE_OFF,			"selected" =69ode == AALARM_MODE_OFF, 			"dan69er" = 0)
			data69"modes"69 =69odes
			data69"mode"69 =69ode
		if(AALARM_SCREEN_SENSORS)
			var/list/selected
			var/thresholds69069

			var/list/69as_names = list(
				"oxy69en"         = "O<sub>2</sub>",
				"carbon dioxide" = "CO<sub>2</sub>",
				"plasma"         = "Toxin",
				"other"          = "Other")
			for (var/69 in 69as_names)
				thresholds69++thresholds.len69 = list("name" = 69as_names696969, "settin69s" = list())
				selected = TLV696969
				for(var/i = 1, i <= 4, i++)
					thresholds69thresholds.len6969"settin69s"69 += list(list("env" = 69, "val" = i, "selected" = selected69i69))

			selected = TLV69"pressure"69
			thresholds69++thresholds.len69 = list("name" = "Pressure", "settin69s" = list())
			for(var/i = 1, i <= 4, i++)
				thresholds69thresholds.len6969"settin69s"69 += list(list("env" = "pressure", "val" = i, "selected" = selected69i69))

			selected = TLV69"temperature"69
			thresholds69++thresholds.len69 = list("name" = "Temperature", "settin69s" = list())
			for(var/i = 1, i <= 4, i++)
				thresholds69thresholds.len6969"settin69s"69 += list(list("env" = "temperature", "val" = i, "selected" = selected69i69))


			data69"thresholds"69 = thresholds

/obj/machinery/alarm/CanUseTopic(var/mob/user,69ar/datum/topic_state/state,69ar/href_list = list())
	if(buildsta69e != 2)
		return STATUS_CLOSE

	if(aidisabled && isAI(user))
		to_chat(user, SPAN_WARNIN69("AI control for \the 69src69 interface has been disabled."))
		return STATUS_CLOSE

	. = shorted ? STATUS_DISABLED : STATUS_INTERACTIVE

	if(. == STATUS_INTERACTIVE)
		var/extra_href = state.href_list(usr)
		// Prevent remote users from alterin69 RCON settin69s unless they already have access
		if(href_list69"rcon"69 && extra_href69"remote_connection"69 && !extra_href69"remote_access"69)
			. = STATUS_UPDATE

	return69in(..(), .)

/obj/machinery/alarm/proc/forceClearAlarm()
	if (alarm_area.atmosalert(0, src))
		for (var/obj/machinery/alarm/AA in alarm_area) // also force all alarms in area to clear
			AA.apply_dan69er_level(0)
	update_icon()

/obj/machinery/alarm/Topic(href, href_list,69ar/datum/topic_state/state)
	if(..(href, href_list, state))
		return 1

	// hrefs that can always be called -walter0o
	if(href_list69"rcon"69)
		playsound(loc, 'sound/machines/button.o6969', 100, 1)
		var/attempted_rcon_settin69 = text2num(href_list69"rcon"69)

		switch(attempted_rcon_settin69)
			if(RCON_NO)
				rcon_settin69 = RCON_NO
			if(RCON_AUTO)
				rcon_settin69 = RCON_AUTO
			if(RCON_YES)
				rcon_settin69 = RCON_YES
		return 1

	if(href_list69"temperature"69)
		var/list/selected = TLV69"temperature"69
		var/max_temperature =69in(selected69369 - T0C,69AX_TEMPERATURE)
		var/min_temperature =69ax(selected69269 - T0C,69IN_TEMPERATURE)
		var/input_temperature = input("What temperature would you like the system to69antain? (Capped between 69min_temperature69 and 69max_temperature69C)", "Thermostat Controls", tar69et_temperature - T0C) as num|null
		if(isnum(input_temperature))
			if(input_temperature >69ax_temperature || input_temperature <69in_temperature)
				to_chat(usr, "Temperature69ust be between 69min_temperature69C and 69max_temperature69C")
			else
				tar69et_temperature = input_temperature + T0C
			investi69ate_lo69("had it's tar69et temperature chan69ed by 69key_name(usr)69", "atmos")

		playsound(loc, 'sound/machines/button.o6969', 100, 1)
		return 1

	// hrefs that need the AA unlocked -walter0o

	var/extra_href
	if(state)
		extra_href = state.href_list(usr)
	if(!(locked && (extra_href && !extra_href69"remote_connection"69)) || (extra_href && extra_href69"remote_access"69) || issilicon(usr))
		if(href_list69"command"69)
			var/device_id = href_list69"id_ta69"69
			switch(href_list69"command"69)
				if("set_external_pressure")
					playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
					var/input_pressure = input("What pressure you like the system to69antain?", "Pressure Controls") as num|null
					if(isnum(input_pressure))
						send_si69nal(device_id, list(href_list69"command"69 = input_pressure))
					return 1

				if("reset_external_pressure")
					playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
					send_si69nal(device_id, list(href_list69"command"69 = ONE_ATMOSPHERE))
					return 1

				if( "power",
					"adjust_external_pressure",
					"checks",
					"expanded_ran69e",
					"to6969le_expanded_ran69e",
					"o2_scrub",
					"n2_scrub",
					"co2_scrub",
					"tox_scrub",
					"n2o_scrub",
					"panic_siphon",
					"scrubbin69")
					playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
					send_si69nal(device_id, list(href_list69"command"69 = text2num(href_list69"val"69) ) )
					investi69ate_lo69("had it's settin69s chan69ed by 69key_name(usr)69", "atmos")
					return 1

				if("set_threshold")
					playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
					var/env = href_list69"env"69
					var/threshold = text2num(href_list69"var"69)
					var/list/selected = TLV69env69
					var/list/thresholds = list("lower bound", "low warnin69", "hi69h warnin69", "upper bound")
					var/newval = input("Enter 69thresholds69threshold6969 for 69env69", "Alarm tri6969ers", selected69threshold69) as null|num
					if (isnull(newval))
						return 1
					if (newval<0)
						selected69threshold69 = -1
					else if (env=="temperature" && newval>5000)
						selected69threshold69 = 5000
					else if (env=="pressure" && newval>50*ONE_ATMOSPHERE)
						selected69threshold69 = 50*ONE_ATMOSPHERE
					else if (env!="temperature" && env!="pressure" && newval>200)
						selected69threshold69 = 200
					else
						newval = round(newval,0.01)
						selected69threshold69 = newval
					if(threshold == 1)
						if(selected69169 > selected69269)
							selected69269 = selected69169
						if(selected69169 > selected69369)
							selected69369 = selected69169
						if(selected69169 > selected69469)
							selected69469 = selected69169
					if(threshold == 2)
						if(selected69169 > selected69269)
							selected69169 = selected69269
						if(selected69269 > selected69369)
							selected69369 = selected69269
						if(selected69269 > selected69469)
							selected69469 = selected69269
					if(threshold == 3)
						if(selected69169 > selected69369)
							selected69169 = selected69369
						if(selected69269 > selected69369)
							selected69269 = selected69369
						if(selected69369 > selected69469)
							selected69469 = selected69369
					if(threshold == 4)
						if(selected69169 > selected69469)
							selected69169 = selected69469
						if(selected69269 > selected69469)
							selected69269 = selected69469
						if(selected69369 > selected69469)
							selected69369 = selected69469

					investi69ate_lo69("had it's tresholds chan69ed by 69key_name(usr)69", "atmos")
					apply_mode()
					return 1

		if(href_list69"screen"69)
			playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
			screen = text2num(href_list69"screen"69)
			return 1

		if(href_list69"atmos_unlock"69)
			playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
			switch(href_list69"atmos_unlock"69)
				if("0")
					alarm_area.air_doors_close()
				if("1")
					alarm_area.air_doors_open()
			return 1

		if(href_list69"atmos_alarm"69)
			playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
			if (alarm_area.atmosalert(2, src))
				apply_dan69er_level(2)
			update_icon()
			return 1

		if(href_list69"atmos_reset"69)
			playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
			forceClearAlarm()
			investi69ate_lo69("had it's alarms cleared by 69key_name(usr)69", "atmos")
			return 1

		if(href_list69"mode"69)
			playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
			apply_mode(text2num(href_list69"mode"69))
			return 1

/obj/machinery/alarm/attackby(obj/item/I,69ob/user)
	src.add_fin69erprint(user)

	var/list/usable_69ualities = list()
	if(buildsta69e == 2)
		usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)
	if(wiresexposed)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69)
	if(buildsta69e == 1)
		usable_69ualities.Add(69UALITY_PRYIN69)
	if(buildsta69e == 0)
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)


	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_SCREW_DRIVIN69)
			if(buildsta69e == 2)
				var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.o6969' :  'sound/machines/Custom_screwdriverclose.o6969'
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, instant_finish_tier = 30, forced_sound = used_sound))
					wiresexposed = !wiresexposed
					to_chat(user, "The wires have been 69wiresexposed ? "exposed" : "unexposed"69")
					update_icon()
					return
			return

		if(69UALITY_WIRE_CUTTIN69)
			if(wiresexposed && buildsta69e == 2)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					user.visible_messa69e(SPAN_WARNIN69("69user69 removed the wires from \the 69src69!"), "You have removed the wires from \the 69src69.")
					new/obj/item/stack/cable_coil(69et_turf(user), 5)
					buildsta69e = 1
					update_icon()
					return
			return

		if(69UALITY_PRYIN69)
			if(buildsta69e == 1)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, "You pry out the circuit!")
					var/obj/item/electronics/airalarm/circuit = new /obj/item/electronics/airalarm()
					circuit.loc = user.loc
					buildsta69e = 0
					update_icon()
					return
			return

		if(69UALITY_BOLT_TURNIN69)
			if(buildsta69e == 0)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, "You remove the fire alarm assembly from the wall!")
					new /obj/item/frame/air_alarm(69et_turf(user))
					69del(src)
			return

		if(ABORT_CHECK)
			return

	switch(buildsta69e)
		if(2)
			if (istype(I, /obj/item/card/id) || istype(I, /obj/item/modular_computer))// tryin69 to unlock the interface with an ID card
				to6969le_lock(user)
			return

		if(1)
			if(istype(I, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = I
				if (C.use(5))
					to_chat(user, SPAN_NOTICE("You wire \the 69src69."))
					buildsta69e = 2
					update_icon()
					first_run()
					return
				else
					to_chat(user, SPAN_WARNIN69("You need 5 pieces of cable to do wire \the 69src69."))
					return

		if(0)
			if(istype(I, /obj/item/electronics/airalarm))
				to_chat(user, "You insert the circuit!")
				69del(I)
				buildsta69e = 1
				update_icon()
				return

	return ..()

/obj/machinery/alarm/power_chan69e()
	..()
	spawn(rand(0,15))
		update_icon()

/obj/machinery/alarm/examine(mob/user)
	..(user)
	if (buildsta69e < 2)
		to_chat(user, "It is not wired.")
	if (buildsta69e < 1)
		to_chat(user, "The circuit is69issin69.")

/obj/machinery/alarm/proc/to6969le_lock(mob/user)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "It does nothin69")
		return
	else
		if(allowed(user) && !wires.IsIndexCut(AALARM_WIRE_IDSCAN))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You 69 locked ? "lock" : "unlock"69 the Air Alarm interface."))
		else
			to_chat(user, SPAN_WARNIN69("Access denied."))

/obj/machinery/alarm/AltClick(mob/user)
	..()
	if(issilicon(user) || !Adjacent(user))
		return
	to6969le_lock(user)


/*
AIR ALARM CIRCUIT
Just a object used in constructin69 air alarms
*/
/obj/item/electronics/airalarm
	name = "air alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "Looks like a circuit. Probably is."
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 3)

/*
FIRE ALARM
*/
/obj/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emer69ency\"</i>. Thus, keep pullin69 it forever."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"
	var/detectin69 = 1
	var/workin69 = 1
	var/time = 10
	var/timin69 = 0
	var/lockdownbyai = 0
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 2
	active_power_usa69e = 6
	power_channel = STATIC_ENVIRON
	var/last_process = 0
	var/wiresexposed = 0
	var/buildsta69e = 2 // 2 = complete, 1 = no wires,  0 = circuit 69one

/obj/machinery/firealarm/update_icon()
	overlays.Cut()

	if(wiresexposed)
		switch(buildsta69e)
			if(2)
				icon_state="fire_build2"
			if(1)
				icon_state="fire_build1"
			if(0)
				icon_state="fire_build0"
		set_li69ht(0)
		return

	if(stat & BROKEN)
		icon_state = "fire_broken"
		set_li69ht(0)
	else if(stat & NOPOWER)
		icon_state = "fire_unpowered"
		set_li69ht(0)
	else
		var/area/area = 69et_area(src)
		if(area.fire)
			icon_state = "fire1"
			set_li69ht(l_ran69e = 1.5, l_power = 0.5, l_color = COLOR_LI69HTIN69_RED_MACHINERY)
		else
			icon_state = "fire0"
			var/decl/security_state/security_state = decls_repository.69et_decl(69LOB.maps_data.security_state)
			var/decl/security_level/sl = security_state.current_security_level

			set_li69ht(sl.li69ht_max_bri69ht, sl.li69ht_inner_ran69e, sl.li69ht_outer_ran69e, 2, sl.li69ht_color_alarm)
			src.overlays += ima69e('icons/obj/monitors.dmi', sl.overlay_firealarm)

/obj/machinery/firealarm/fire_act(datum/69as_mixture/air, temperature,69olume)
	if(src.detectin69)
		if(temperature > T0C + 200)
			src.alarm()			// added check of detector status here
	return

/obj/machinery/firealarm/attack_hand(mob/user)
	. = ..()
	if (.)
		return
	return ui_interact(user)

/obj/machinery/firealarm/bullet_act()
	return src.alarm()

/obj/machinery/firealarm/emp_act(severity)
	if(prob(50/severity))
		alarm(rand(30/severity, 60/severity))
	..()

/obj/machinery/firealarm/attackby(obj/item/I,69ob/user)
	src.add_fin69erprint(user)

	var/list/usable_69ualities = list()
	if(buildsta69e == 2)
		usable_69ualities.Add(69UALITY_SCREW_DRIVIN69)
	if(wiresexposed)
		usable_69ualities.Add(69UALITY_WIRE_CUTTIN69, 69UALITY_PULSIN69)
	if(buildsta69e == 1)
		usable_69ualities.Add(69UALITY_PRYIN69)
	if(buildsta69e == 0)
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)


	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_SCREW_DRIVIN69)
			if(buildsta69e == 2)
				var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.o6969' :  'sound/machines/Custom_screwdriverclose.o6969'
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, instant_finish_tier = 30, forced_sound = used_sound))
					wiresexposed = !wiresexposed
					to_chat(user, "The wires have been 69wiresexposed ? "exposed" : "unexposed"69")
					update_icon()
					return
			return

		if(69UALITY_WIRE_CUTTIN69)
			if(wiresexposed && buildsta69e == 2)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					user.visible_messa69e(SPAN_WARNIN69("69user69 has removed the wires from \the 69src69!"), "You have removed the wires from \the 69src69.")
					new/obj/item/stack/cable_coil(69et_turf(user), 5)
					buildsta69e = 1
					update_icon()
					return
			return

		if(69UALITY_PULSIN69)
			if(wiresexposed)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					detectin69 = !detectin69
					user.visible_messa69e(
					SPAN_NOTICE("\The 69user69 has 69detectin69 ? "disconnected" : "reconnected"69 69src69's detectin69 unit!"),
					SPAN_NOTICE("You have 69detectin69 ? "disconnected" : "reconnected"69 69src69's detectin69 unit."))
					return
			return

		if(69UALITY_PRYIN69)
			if(buildsta69e == 1)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, "You pry out the circuit!")
					var/obj/item/electronics/airalarm/circuit = new /obj/item/electronics/airalarm()
					circuit.loc = user.loc
					buildsta69e = 0
					update_icon()
					return
			return

		if(69UALITY_BOLT_TURNIN69)
			if(buildsta69e == 0)
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, , re69uired_stat = STAT_MEC))
					to_chat(user, "You remove the fire alarm assembly from the wall!")
					new /obj/item/frame/fire_alarm(69et_turf(user))
					69del(src)
			return

		if(ABORT_CHECK)
			return

	switch(buildsta69e)

		if(1)
			if(istype(I, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = I
				if (C.use(5))
					to_chat(user, SPAN_NOTICE("You wire \the 69src69."))
					buildsta69e = 2
					update_icon()
					return
				else
					to_chat(user, SPAN_WARNIN69("You need 5 pieces of cable to do wire \the 69src69."))
					return

		if(0)
			if(istype(I, /obj/item/electronics/firealarm))
				to_chat(user, "You insert the circuit!")
				69del(I)
				buildsta69e = 1
				update_icon()
				return

	src.alarm()
	return

/obj/machinery/firealarm/Process()//Note: this processin69 was69ostly phased out due to other code, and only runs when needed
	if(stat & (NOPOWER|BROKEN))
		return

	if(timin69)
		if(time > 0)
			time -= (world.timeofday - last_process)/10
		else
			alarm()
			time = 0
			timin69 = 0
			STOP_PROCESSIN69(SSmachines, src)
		updateDialo69()
	last_process = world.timeofday

	if(locate(/obj/fire) in loc)
		alarm()

	return

/obj/machinery/firealarm/power_chan69e()
	..()
	spawn(rand(0,15))
		update_icon()

/obj/machinery/firealarm/ui_interact(var/mob/user,69ar/ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS,69ar/datum/topic_state/state = 69LOB.outside_state)
	var/data69069
	var/decl/security_state/security_state = decls_repository.69et_decl(69LOB.maps_data.security_state)

	data69"seclevel"69 = security_state.current_security_level.name
	data69"time"69 = round(src.time)
	data69"timin69"69 = timin69
	var/area/A = 69et_area(src)
	data69"active"69 = A.fire

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "fire_alarm.tmpl", "Fire Alarm", 240, 330, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/firealarm/CanUseTopic(user)
	if(wiresexposed)
		return STATUS_CLOSE

	if (buildsta69e != 2)
		return STATUS_CLOSE
	return ..()

/obj/machinery/firealarm/Topic(href, href_list)
	if(..())
		return 1

	playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
	if (href_list69"status"69 == "reset")
		src.reset()
		return TOPIC_REFRESH
	else if (href_list69"status"69 == "alarm")
		src.alarm()
		return TOPIC_REFRESH
	if (href_list69"timer"69 == "set")
		time =69ax(0, input(usr, "Enter time delay", "Fire Alarm Timer", time) as num)
	else if (href_list69"timer"69 == "start")
		src.timin69 = 1
		return TOPIC_REFRESH
	else if (href_list69"timer"69 == "stop")
		src.timin69 = 0
		return TOPIC_REFRESH

	return

/obj/machinery/firealarm/proc/reset()
	if (!( src.workin69 ))
		return
	var/area/area = 69et_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.clearAlarm(loc, FA)
	if(iscarbon(usr))
		visible_messa69e("69usr69 resets \the 69src69.", "You have reset \the 69src69.")
	else
		to_chat(usr, "Fire Alarm is reset.")
	update_icon()
	return

/obj/machinery/firealarm/proc/alarm(var/duration = 0)
	if (!( src.workin69))
		return
	var/area/area = 69et_area(src)
	for(var/obj/machinery/firealarm/FA in area)
		fire_alarm.tri6969erAlarm(loc, FA, duration)
	if(iscarbon(usr))
		visible_messa69e(SPAN_WARNIN69("69usr69 pulled \the 69src69's pull station!"), SPAN_WARNIN69("You have pulled \the 69src69's pull station!"))
	else
		to_chat(usr, "Fire Alarm activated.")
	update_icon()
	//playsound(src.loc, 'sound/ambience/si69nal.o6969', 75, 0)
	return



/obj/machinery/firealarm/New(loc, dir, buildin69)
	..()

	if(loc)
		src.loc = loc

	if(dir)
		src.set_dir(dir)

	if(buildin69)
		buildsta69e = 0
		wiresexposed = 1
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0

	69LOB.firealarm_list += src

/obj/machinery/firealarm/Destroy()
	69LOB.firealarm_list -= src
	..()

/*
FIRE ALARM CIRCUIT
Just a object used in constructin69 fire alarms
*/
/obj/item/electronics/firealarm
	name = "fire alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 de69rees celsius!\""
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 3)

/obj/machinery/partyalarm
	name = "\improper PARTY BUTTON"
	desc = "Cuban Pete is in the house!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"
	var/detectin69 = 1
	var/workin69 = 1
	var/time = 10
	var/timin69 = 0
	var/lockdownbyai = 0
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 2
	active_power_usa69e = 6

/obj/machinery/partyalarm/attack_hand(mob/user as69ob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		return

	user.machine = src
	var/area/A = 69et_area(src)
	ASSERT(isarea(A))
	var/d1
	var/d2
	if (ishuman(user) || istype(user, /mob/livin69/silicon/ai))

		if (A.party)
			d1 = text("<A href='?src=\ref6969;reset=1'>No Party :(</A>", src)
		else
			d1 = text("<A href='?src=\ref6969;alarm=1'>PARTY!!!</A>", src)
		if (timin69)
			d2 = text("<A href='?src=\ref6969;time=0'>Stop Time Lock</A>", src)
		else
			d2 = text("<A href='?src=\ref6969;time=1'>Initiate Time Lock</A>", src)
		var/second = time % 60
		var/minute = (time - second) / 60
		var/dat = text("<HTML><HEAD></HEAD><BODY><TT><B>Party Button</B> 6969\n<HR>\nTimer System: 6969<BR>\nTime Left: 69696969 <A href='?src=\ref6969;tp=-30'>-</A> <A href='?src=\ref6969;tp=-1'>-</A> <A href='?src=\ref6969;tp=1'>+</A> <A href='?src=\ref6969;tp=30'>+</A>\n</TT></BODY></HTML>", d1, d2, (minute ? text("6969:",69inute) : null), second, src, src, src, src)
		user << browse(dat, "window=partyalarm")
		onclose(user, "partyalarm")
	else
		if (A.fire)
			d1 = text("<A href='?src=\ref6969;reset=1'>6969</A>", src, stars("No Party :("))
		else
			d1 = text("<A href='?src=\ref6969;alarm=1'>6969</A>", src, stars("PARTY!!!"))
		if (timin69)
			d2 = text("<A href='?src=\ref6969;time=0'>6969</A>", src, stars("Stop Time Lock"))
		else
			d2 = text("<A href='?src=\ref6969;time=1'>6969</A>", src, stars("Initiate Time Lock"))
		var/second = time % 60
		var/minute = (time - second) / 60
		var/time_strin69 = "69second69"
		if(minute)
			time_strin69 = "69minute69:69second69"
		var/dat = {"
			<HTML><BODY><TT>
			<B>69stars("Party Button")69</B> 69d169<HR>
			Timer System: 69d269<BR>
			Time Left: 69time_strin6969
			<A href='?src=\ref69src69;tp=-30'>-</A> <A href='?src=\ref69src69;tp=-1'>-</A>
			<A href='?src=\ref69src69;tp=1'>+</A> <A href='?src=\ref69src69;tp=30'>+</A>
			</TT></BODY></HTML>
		"}
		user << browse(dat, "window=partyalarm")
		onclose(user, "partyalarm")
	return

/obj/machinery/partyalarm/proc/reset()
	if (!workin69)
		return
	var/area/A = 69et_area(src)
	ASSERT(isarea(A))
	A.partyreset()
	return

/obj/machinery/partyalarm/proc/alarm()
	if (!workin69)
		return
	var/area/A = 69et_area(src)
	ASSERT(isarea(A))
	A.partyalert()
	return

/obj/machinery/partyalarm/Topic(href, href_list)
	if(..())
		return 1

	if (href_list69"reset"69)
		reset()
	else if (href_list69"alarm"69)
		alarm()
	else if (href_list69"time"69)
		timin69 = text2num(href_list69"time"69)
	else if (href_list69"tp"69)
		var/tp = text2num(href_list69"tp"69)
		time += tp
		time =69in(max(round(time), 0), 120)
