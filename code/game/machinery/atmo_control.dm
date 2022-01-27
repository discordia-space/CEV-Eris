/obj/machinery/air_sensor
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "69sensor1"
	name = "69as Sensor"

	anchored = TRUE
	var/state = 0

	var/id_ta69
	var/fre69uency = 1439

	var/on = TRUE
	var/output = 3
	//Fla69s:
	// 1 for pressure
	// 2 for temperature
	// Output >= 4 includes 69as composition
	// 4 for oxy69en concentration
	// 8 for plasma concentration
	// 16 for nitro69en concentration
	// 32 for carbon dioxide concentration

	var/datum/radio_fre69uency/radio_connection

/obj/machinery/air_sensor/update_icon()
	icon_state = "69sensor69on69"

/obj/machinery/air_sensor/Process()
	if(on)
		var/datum/si69nal/si69nal = new
		si69nal.transmission_method = 1 //radio si69nal
		si69nal.data69"ta69"69 = id_ta69
		si69nal.data69"timestamp"69 = world.time

		var/datum/69as_mixture/air_sample = return_air()

		if(output&1)
			si69nal.data69"pressure"69 = num2text(round(air_sample.return_pressure(),0.1),)
		if(output&2)
			si69nal.data69"temperature"69 = round(air_sample.temperature,0.1)

		if(output>4)
			var/total_moles = air_sample.total_moles
			if(total_moles > 0)
				if(output&4)
					si69nal.data69"oxy69en"69 = round(100*air_sample.69as69"oxy69en"69/total_moles,0.1)
				if(output&8)
					si69nal.data69"plasma"69 = round(100*air_sample.69as69"plasma"69/total_moles,0.1)
				if(output&16)
					si69nal.data69"nitro69en"69 = round(100*air_sample.69as69"nitro69en"69/total_moles,0.1)
				if(output&32)
					si69nal.data69"carbon_dioxide"69 = round(100*air_sample.69as69"carbon_dioxide"69/total_moles,0.1)
			else
				si69nal.data69"oxy69en"69 = 0
				si69nal.data69"plasma"69 = 0
				si69nal.data69"nitro69en"69 = 0
				si69nal.data69"carbon_dioxide"69 = 0
		si69nal.data69"si69type"69="status"
		radio_connection.post_si69nal(src, si69nal, filter = RADIO_ATMOSIA)


/obj/machinery/air_sensor/proc/set_fre69uency(new_fre69uency)
	SSradio.remove_object(src, fre69uency)
	fre69uency = new_fre69uency
	radio_connection = SSradio.add_object(src, fre69uency, RADIO_ATMOSIA)

/obj/machinery/air_sensor/Initialize()
	. = ..()
	set_fre69uency(fre69uency)

obj/machinery/air_sensor/Destroy()
	SSradio.remove_object(src,fre69uency)
	. = ..()

/obj/machinery/computer/69eneral_air_control
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "tank"

	name = "Computer"

	var/fre69uency = 1439
	var/list/sensors = list()

	var/list/sensor_information = list()
	var/datum/radio_fre69uency/radio_connection
	circuit = /obj/item/electronics/circuitboard/air_mana69ement

obj/machinery/computer/69eneral_air_control/Destroy()
	SSradio.remove_object(src, fre69uency)
	. = ..()

/obj/machinery/computer/69eneral_air_control/attack_hand(mob/user)
	if(..(user))
		return
	user << browse(return_text(),"window=computer")
	user.set_machine(src)
	onclose(user, "computer")

/obj/machinery/computer/69eneral_air_control/Process()
	..()
	src.updateUsrDialo69()

/obj/machinery/computer/69eneral_air_control/receive_si69nal(datum/si69nal/si69nal)
	if(!si69nal || si69nal.encryption) return

	var/id_ta69 = si69nal.data69"ta69"69
	if(!id_ta69 || !sensors.Find(id_ta69)) return

	sensor_information69id_ta6969 = si69nal.data

/obj/machinery/computer/69eneral_air_control/proc/return_text()
	var/sensor_data
	if(sensors.len)
		for(var/id_ta69 in sensors)
			var/lon69_name = sensors69id_ta6969
			var/list/data = sensor_information69id_ta6969
			var/sensor_part = "<B>69lon69_name69</B>:<BR>"

			if(data)
				if(data69"pressure"69)
					sensor_part += "   <B>Pressure:</B> 69data69"pressure"6969 kPa<BR>"
				if(data69"temperature"69)
					sensor_part += "   <B>Temperature:</B> 69data69"temperature"6969 K<BR>"
				if(data69"oxy69en"69||data69"plasma"69||data69"nitro69en"69||data69"carbon_dioxide"69)
					sensor_part += "   <B>69as Composition :</B>"
					if(data69"oxy69en"69)
						sensor_part += "69data69"oxy69en"6969% O2; "
					if(data69"nitro69en"69)
						sensor_part += "69data69"nitro69en"6969% N; "
					if(data69"carbon_dioxide"69)
						sensor_part += "69data69"carbon_dioxide"6969% CO2; "
					if(data69"plasma"69)
						sensor_part += "69data69"plasma"6969% TX; "
				sensor_part += "<HR>"

			else
				sensor_part = "<FONT color='red'>69lon69_name69 can not be found!</FONT><BR>"

			sensor_data += sensor_part

	else
		sensor_data = "No sensors connected."

	var/output = {"<B>69name69</B><HR>
<B>Sensor Data:</B><HR><HR>69sensor_data69"}

	return output

/obj/machinery/computer/69eneral_air_control/proc/set_fre69uency(new_fre69uency)
	SSradio.remove_object(src, fre69uency)
	fre69uency = new_fre69uency
	radio_connection = SSradio.add_object(src, fre69uency, RADIO_ATMOSIA)

/obj/machinery/computer/69eneral_air_control/Initialize()
	. = ..()
	set_fre69uency(fre69uency)


/obj/machinery/computer/69eneral_air_control/lar69e_tank_control
	icon = 'icons/obj/computer.dmi'

	fre69uency = 1441
	var/input_ta69
	var/output_ta69

	var/list/input_info
	var/list/output_info

	var/input_flow_settin69 = 200
	var/pressure_settin69 = ONE_ATMOSPHERE * 45
	circuit = /obj/item/electronics/circuitboard/air_mana69ement/tank_control


/obj/machinery/computer/69eneral_air_control/lar69e_tank_control/return_text()
	var/output = ..()
	//if(si69nal.data)
	//	input_info = si69nal.data // Attemptin69 to fix intake control -- TLE

	output += "<B>Tank Control System</B><BR><BR>"
	if(input_info)
		var/power = (input_info69"power"69)
		var/volume_rate = round(input_info69"volume_rate"69, 0.1)
		output += "<B>Input</B>: 69power?("Injectin69"):("On Hold")69 <A href='?src=\ref69src69;in_refresh_status=1'>Refresh</A><BR>Flow Rate Limit: 69volume_rate69 L/s<BR>"
		output += "Command: <A href='?src=\ref69src69;in_to6969le_injector=1'>To6969le Power</A> <A href='?src=\ref69src69;in_set_flowrate=1'>Set Flow Rate</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find input port</FONT> <A href='?src=\ref69src69;in_refresh_status=1'>Search</A><BR>"

	output += "Flow Rate Limit: <A href='?src=\ref69src69;adj_input_flow_rate=-100'>-</A> <A href='?src=\ref69src69;adj_input_flow_rate=-10'>-</A> <A href='?src=\ref69src69;adj_input_flow_rate=-1'>-</A> <A href='?src=\ref69src69;adj_input_flow_rate=-0.1'>-</A> 69round(input_flow_settin69, 0.1)69 L/s <A href='?src=\ref69src69;adj_input_flow_rate=0.1'>+</A> <A href='?src=\ref69src69;adj_input_flow_rate=1'>+</A> <A href='?src=\ref69src69;adj_input_flow_rate=10'>+</A> <A href='?src=\ref69src69;adj_input_flow_rate=100'>+</A><BR>"

	output += "<BR>"

	if(output_info)
		var/power = (output_info69"power"69)
		var/output_pressure = output_info69"internal"69
		output += {"<B>Output</B>: 69power?("Open"):("On Hold")69 <A href='?src=\ref69src69;out_refresh_status=1'>Refresh</A><BR>
Max Output Pressure: 69output_pressure69 kPa<BR>"}
		output += "Command: <A href='?src=\ref69src69;out_to6969le_power=1'>To6969le Power</A> <A href='?src=\ref69src69;out_set_pressure=1'>Set Pressure</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find output port</FONT> <A href='?src=\ref69src69;out_refresh_status=1'>Search</A><BR>"

	output += "Max Output Pressure Set: <A href='?src=\ref69src69;adj_pressure=-1000'>-</A> <A href='?src=\ref69src69;adj_pressure=-100'>-</A> <A href='?src=\ref69src69;adj_pressure=-10'>-</A> <A href='?src=\ref69src69;adj_pressure=-1'>-</A> 69pressure_settin6969 kPa <A href='?src=\ref69src69;adj_pressure=1'>+</A> <A href='?src=\ref69src69;adj_pressure=10'>+</A> <A href='?src=\ref69src69;adj_pressure=100'>+</A> <A href='?src=\ref69src69;adj_pressure=1000'>+</A><BR>"

	return output

/obj/machinery/computer/69eneral_air_control/lar69e_tank_control/receive_si69nal(datum/si69nal/si69nal)
	if(!si69nal || si69nal.encryption) return

	var/id_ta69 = si69nal.data69"ta69"69

	if(input_ta69 == id_ta69)
		input_info = si69nal.data
	else if(output_ta69 == id_ta69)
		output_info = si69nal.data
	else
		..(si69nal)

/obj/machinery/computer/69eneral_air_control/lar69e_tank_control/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"adj_pressure"69)
		var/chan69e = text2num(href_list69"adj_pressure"69)
		pressure_settin69 = between(0, pressure_settin69 + chan69e, 50*ONE_ATMOSPHERE)
		spawn(1)
			src.updateUsrDialo69()
		return 1

	if(href_list69"adj_input_flow_rate"69)
		var/chan69e = text2num(href_list69"adj_input_flow_rate"69)
		input_flow_settin69 = between(0, input_flow_settin69 + chan69e, ATMOS_DEFAULT_VOLUME_PUMP + 500) //default flow rate limit for air injectors
		spawn(1)
			src.updateUsrDialo69()
		return 1

	if(!radio_connection)
		return 0
	var/datum/si69nal/si69nal = new
	si69nal.transmission_method = 1 //radio si69nal
	si69nal.source = src
	if(href_list69"in_refresh_status"69)
		input_info = null
		si69nal.data = list ("ta69" = input_ta69, "status" = 1)
		. = 1

	if(href_list69"in_to6969le_injector"69)
		input_info = null
		si69nal.data = list ("ta69" = input_ta69, "power_to6969le" = 1)
		. = 1

	if(href_list69"in_set_flowrate"69)
		input_info = null
		si69nal.data = list ("ta69" = input_ta69, "set_volume_rate" = "69input_flow_settin6969")
		. = 1

	if(href_list69"out_refresh_status"69)
		output_info = null
		si69nal.data = list ("ta69" = output_ta69, "status" = 1)
		. = 1

	if(href_list69"out_to6969le_power"69)
		output_info = null
		si69nal.data = list ("ta69" = output_ta69, "power_to6969le" = 1)
		. = 1

	if(href_list69"out_set_pressure"69)
		output_info = null
		si69nal.data = list ("ta69" = output_ta69, "set_internal_pressure" = "69pressure_settin6969")
		. = 1

	si69nal.data69"si69type"69="command"
	radio_connection.post_si69nal(src, si69nal, filter = RADIO_ATMOSIA)

	spawn(5)
		src.updateUsrDialo69()

/obj/machinery/computer/69eneral_air_control/supermatter_core
	icon = 'icons/obj/computer.dmi'

	fre69uency = 1438
	var/input_ta69
	var/output_ta69

	var/list/input_info
	var/list/output_info

	var/input_flow_settin69 = 700
	var/pressure_settin69 = 100
	circuit = /obj/item/electronics/circuitboard/air_mana69ement/supermatter_core


/obj/machinery/computer/69eneral_air_control/supermatter_core/return_text()
	var/output = ..()
	//if(si69nal.data)
	//	input_info = si69nal.data // Attemptin69 to fix intake control -- TLE

	output += "<B>Core Coolin69 Control System</B><BR><BR>"
	if(input_info)
		var/power = (input_info69"power"69)
		var/volume_rate = round(input_info69"volume_rate"69, 0.1)
		output += "<B>Coolant Input</B>: 69power?("Injectin69"):("On Hold")69 <A href='?src=\ref69src69;in_refresh_status=1'>Refresh</A><BR>Flow Rate Limit: 69volume_rate69 L/s<BR>"
		output += "Command: <A href='?src=\ref69src69;in_to6969le_injector=1'>To6969le Power</A> <A href='?src=\ref69src69;in_set_flowrate=1'>Set Flow Rate</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find input port</FONT> <A href='?src=\ref69src69;in_refresh_status=1'>Search</A><BR>"

	output += "Flow Rate Limit: <A href='?src=\ref69src69;adj_input_flow_rate=-100'>-</A> <A href='?src=\ref69src69;adj_input_flow_rate=-10'>-</A> <A href='?src=\ref69src69;adj_input_flow_rate=-1'>-</A> <A href='?src=\ref69src69;adj_input_flow_rate=-0.1'>-</A> 69round(input_flow_settin69, 0.1)69 L/s <A href='?src=\ref69src69;adj_input_flow_rate=0.1'>+</A> <A href='?src=\ref69src69;adj_input_flow_rate=1'>+</A> <A href='?src=\ref69src69;adj_input_flow_rate=10'>+</A> <A href='?src=\ref69src69;adj_input_flow_rate=100'>+</A><BR>"

	output += "<BR>"

	if(output_info)
		var/power = (output_info69"power"69)
		var/pressure_limit = output_info69"external"69
		output += {"<B>Core Outpump</B>: 69power?("Open"):("On Hold")69 <A href='?src=\ref69src69;out_refresh_status=1'>Refresh</A><BR>
Min Core Pressure: 69pressure_limit69 kPa<BR>"}
		output += "Command: <A href='?src=\ref69src69;out_to6969le_power=1'>To6969le Power</A> <A href='?src=\ref69src69;out_set_pressure=1'>Set Pressure</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find output port</FONT> <A href='?src=\ref69src69;out_refresh_status=1'>Search</A><BR>"

	output += "Min Core Pressure Set: <A href='?src=\ref69src69;adj_pressure=-100'>-</A> <A href='?src=\ref69src69;adj_pressure=-50'>-</A> <A href='?src=\ref69src69;adj_pressure=-10'>-</A> <A href='?src=\ref69src69;adj_pressure=-1'>-</A> 69pressure_settin6969 kPa <A href='?src=\ref69src69;adj_pressure=1'>+</A> <A href='?src=\ref69src69;adj_pressure=10'>+</A> <A href='?src=\ref69src69;adj_pressure=50'>+</A> <A href='?src=\ref69src69;adj_pressure=100'>+</A><BR>"

	return output

/obj/machinery/computer/69eneral_air_control/supermatter_core/receive_si69nal(datum/si69nal/si69nal)
	if(!si69nal || si69nal.encryption) return

	var/id_ta69 = si69nal.data69"ta69"69

	if(input_ta69 == id_ta69)
		input_info = si69nal.data
	else if(output_ta69 == id_ta69)
		output_info = si69nal.data
	else
		..(si69nal)

/obj/machinery/computer/69eneral_air_control/supermatter_core/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"adj_pressure"69)
		var/chan69e = text2num(href_list69"adj_pressure"69)
		pressure_settin69 = between(0, pressure_settin69 + chan69e, 10*ONE_ATMOSPHERE)
		spawn(1)
			src.updateUsrDialo69()
		return 1

	if(href_list69"adj_input_flow_rate"69)
		var/chan69e = text2num(href_list69"adj_input_flow_rate"69)
		input_flow_settin69 = between(0, input_flow_settin69 + chan69e, ATMOS_DEFAULT_VOLUME_PUMP + 500) //default flow rate limit for air injectors
		spawn(1)
			src.updateUsrDialo69()
		return 1

	if(!radio_connection)
		return 0
	var/datum/si69nal/si69nal = new
	si69nal.transmission_method = 1 //radio si69nal
	si69nal.source = src
	if(href_list69"in_refresh_status"69)
		input_info = null
		si69nal.data = list ("ta69" = input_ta69, "status" = 1)
		. = 1

	if(href_list69"in_to6969le_injector"69)
		input_info = null
		si69nal.data = list ("ta69" = input_ta69, "power_to6969le" = 1)
		. = 1

	if(href_list69"in_set_flowrate"69)
		input_info = null
		si69nal.data = list ("ta69" = input_ta69, "set_volume_rate" = "69input_flow_settin6969")
		. = 1

	if(href_list69"out_refresh_status"69)
		output_info = null
		si69nal.data = list ("ta69" = output_ta69, "status" = 1)
		. = 1

	if(href_list69"out_to6969le_power"69)
		output_info = null
		si69nal.data = list ("ta69" = output_ta69, "power_to6969le" = 1)
		. = 1

	if(href_list69"out_set_pressure"69)
		output_info = null
		si69nal.data = list ("ta69" = output_ta69, "set_external_pressure" = "69pressure_settin6969", "checks" = 1)
		. = 1

	si69nal.data69"si69type"69="command"
	radio_connection.post_si69nal(src, si69nal, filter = RADIO_ATMOSIA)

	spawn(5)
		src.updateUsrDialo69()

/obj/machinery/computer/69eneral_air_control/fuel_injection
	icon = 'icons/obj/computer.dmi'
	icon_screen = "alert:0"

	var/device_ta69
	var/list/device_info

	var/automation = 0

	var/cutoff_temperature = 2000
	var/on_temperature = 1200
	circuit = /obj/item/electronics/circuitboard/air_mana69ement/injector_control

/obj/machinery/computer/69eneral_air_control/fuel_injection/Process()
	if(automation)
		if(!radio_connection)
			return 0

		var/injectin69 = 0
		for(var/id_ta69 in sensor_information)
			var/list/data = sensor_information69id_ta6969
			if(data69"temperature"69)
				if(data69"temperature"69 >= cutoff_temperature)
					injectin69 = 0
					break
				if(data69"temperature"69 <= on_temperature)
					injectin69 = 1

		var/datum/si69nal/si69nal = new
		si69nal.transmission_method = 1 //radio si69nal
		si69nal.source = src

		si69nal.data = list(
			"ta69" = device_ta69,
			"power" = injectin69,
			"si69type"="command"
		)

		radio_connection.post_si69nal(src, si69nal, filter = RADIO_ATMOSIA)

	..()

/obj/machinery/computer/69eneral_air_control/fuel_injection/return_text()
	var/output = ..()

	output += "<B>Fuel Injection System</B><BR>"
	if(device_info)
		var/power = device_info69"power"69
		var/volume_rate = device_info69"volume_rate"69
		output += {"Status: 69power?("Injectin69"):("On Hold")69 <A href='?src=\ref69src69;refresh_status=1'>Refresh</A><BR>
Rate: 69volume_rate69 L/sec<BR>"}

		if(automation)
			output += "Automated Fuel Injection: <A href='?src=\ref69src69;to6969le_automation=1'>En69a69ed</A><BR>"
			output += "Injector Controls Locked Out<BR>"
		else
			output += "Automated Fuel Injection: <A href='?src=\ref69src69;to6969le_automation=1'>Disen69a69ed</A><BR>"
			output += "Injector: <A href='?src=\ref69src69;to6969le_injector=1'>To6969le Power</A> <A href='?src=\ref69src69;injection=1'>Inject (1 Cycle)</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find device</FONT> <A href='?src=\ref69src69;refresh_status=1'>Search</A><BR>"

	return output

/obj/machinery/computer/69eneral_air_control/fuel_injection/receive_si69nal(datum/si69nal/si69nal)
	if(!si69nal || si69nal.encryption) return

	var/id_ta69 = si69nal.data69"ta69"69

	if(device_ta69 == id_ta69)
		device_info = si69nal.data
	else
		..(si69nal)

/obj/machinery/computer/69eneral_air_control/fuel_injection/Topic(href, href_list)
	if(..())
		return

	if(href_list69"refresh_status"69)
		device_info = null
		if(!radio_connection)
			return 0

		var/datum/si69nal/si69nal = new
		si69nal.transmission_method = 1 //radio si69nal
		si69nal.source = src
		si69nal.data = list(
			"ta69" = device_ta69,
			"status" = 1,
			"si69type"="command"
		)
		radio_connection.post_si69nal(src, si69nal, filter = RADIO_ATMOSIA)

	if(href_list69"to6969le_automation"69)
		automation = !automation

	if(href_list69"to6969le_injector"69)
		device_info = null
		if(!radio_connection)
			return 0

		var/datum/si69nal/si69nal = new
		si69nal.transmission_method = 1 //radio si69nal
		si69nal.source = src
		si69nal.data = list(
			"ta69" = device_ta69,
			"power_to6969le" = 1,
			"si69type"="command"
		)

		radio_connection.post_si69nal(src, si69nal, filter = RADIO_ATMOSIA)

	if(href_list69"injection"69)
		if(!radio_connection)
			return 0

		var/datum/si69nal/si69nal = new
		si69nal.transmission_method = 1 //radio si69nal
		si69nal.source = src
		si69nal.data = list(
			"ta69" = device_ta69,
			"inject" = 1,
			"si69type"="command"
		)

		radio_connection.post_si69nal(src, si69nal, filter = RADIO_ATMOSIA)




