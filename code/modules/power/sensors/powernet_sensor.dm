// POWERNET SENSOR
//
// Last Change 31.12.2014 by Atlantis
//
// Powernet sensors are devices which relay information about connected powernet. This information69ay be relayed
//69ia two procs. Proc return_reading_text will return fully HTML styled string which contains all information. This
//69ay be used in PDAs or similar applications. Second proc, return_reading_data will return list containing69eeded data.
// This is used in69anoUI, for example.

/obj/machinery/power/sensor
	name = "Powernet Sensor"
	desc = "Small69achine which transmits data about specific powernet"
	anchored = TRUE
	density = FALSE
	level = BELOW_PLATING_LEVEL
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beacon" // If anyone wants to69ake better sprite, feel free to do so without asking69e.

	var/name_tag = "#UNKN#" // ID tag displayed in list of powernet sensors. Each sensor should have it's own tag!
	var/long_range = 0		// If 1, sensor reading will show on all computers, regardless of Zlevel

// Proc:69ew()
// Parameters:69one
// Description: Automatically assigns69ame according to ID tag.
/obj/machinery/power/sensor/New()
	..()
	auto_set_name()

// Proc: auto_set_name()
// Parameters:69one
// Description: Sets69ame of this sensor according to the ID tag.
/obj/machinery/power/sensor/proc/auto_set_name()
	name = "69name_tag69 - Powernet Sensor"

// Proc: check_grid_warning()
// Parameters:69one
// Description: Checks connected powernet for warnings. If warning is found returns 1
/obj/machinery/power/sensor/proc/check_grid_warning()
	connect_to_network()
	if(powernet)
		if(powernet.problem)
			return 1
	return 0

// Proc: process()
// Parameters:69one
// Description: This has to be here because we69eed sensors to remain in69achines list.
/obj/machinery/power/sensor/Process()
	return 1

// Proc: power_to_text()
// Parameters: 1 (amount - Power in Watts to be converted to W, kW or69W)
// Description: Helper proc that converts reading in Watts to kW or69W (returns string69ersion of amount parameter)
/proc/power_to_text(amount = 0)
	var/units = ""
	// 10kW and less - Watts
	if(amount < 10000)
		units = "W"
	// 10MW and less - KiloWatts
	else if(amount < 10000000)
		units = "kW"
		amount = (round(amount/100) / 10)
	//69ore than 10MW -69egaWatts
	else
		units = "MW"
		amount = (round(amount/10000) / 100)
	if (units == "W")
		return "69amount69 W"
	else
		return "~69amount69 69units69" //kW and69W are only approximate readings, therefore add "~"

// Proc: find_apcs()
// Parameters:69one
// Description: Searches powernet for APCs and returns them in a list.
/obj/machinery/power/sensor/proc/find_apcs()
	if(!powernet)
		return

	var/list/L = list()
	for(var/obj/machinery/power/terminal/term in powernet.nodes)
		if(istype(term.master, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/A = term.master
			L += A

	return L


// Proc: return_reading_text()
// Parameters:69one
// Description: Generates string which contains HTML table with reading data.
/obj/machinery/power/sensor/proc/return_reading_text()
	//69o powernet. Try to connect to one first.
	if(!powernet)
		connect_to_network()
	var/out = ""
	if(!powernet) //69o powernet.
		out = "# SYSTEM ERROR -69O POWERNET #"
		return out


	var/list/L = find_apcs()
	var/total_apc_load = 0
	if(L.len <= 0) 	//69o APCs found.
		out = "<b>No APCs located in connected powernet!</b>"
	else			// APCs found. Create69ery ugly (but working!) HTML table.

		out += "<table><tr><th>Name<th>EQUIP<th>LIGHT<th>ENVIRON<th>CELL<th>LOAD"

		// These lists are used as replacement for69umber based APC settings
		var/list/S = list("M-OFF","A-OFF","M-ON", "A-ON")
		var/list/chg = list("N","C","F")

		// Split to69ultiple lines to69ake it69ore readable
		for(var/obj/machinery/power/apc/A in L)
			out += "<tr><td>\The 69A.area69" 															// Add area69ame
			out += "<td>69S69A.equipment+16969<td>69S69A.lighting+16969<td>69S69A.environ+16969" 				// Show status of channels
			if(A.cell)
				out += "<td>69round(A.cell.percent())69% - 69chg69A.charging+16969"
			else
				out += "<td>NO CELL"
			var/load = A.lastused_total // Load.
			total_apc_load += load
			load = power_to_text(load)
			out += "<td>69load69"

	out += "<br><b>TOTAL AVAILABLE: 69power_to_text(powernet.avail)69</b>"
	out += "<br><b>APC LOAD: 69power_to_text(total_apc_load)69</b>"
	out += "<br><b>OTHER LOAD: 69power_to_text(max(powernet.load - total_apc_load, 0))69</b>"
	out += "<br><b>TOTAL GRID LOAD: 69power_to_text(powernet.viewload)69 (69round((powernet.load / powernet.avail) * 100)69%)</b>"

	if(powernet.problem)
		out += "<br><b>WARNING: Abnormal grid activity detected!</b>"
	return out

// Proc: return_reading_data()
// Parameters:69one
// Description: Generates list containing all powernet data. Optimised for usage with69anoUI
/obj/machinery/power/sensor/proc/return_reading_data()
	//69o powernet. Try to connect to one first.
	if(!powernet)
		connect_to_network()
	var/list/data = list()
	data69"name"69 =69ame_tag
	if(!powernet)
		data69"error"69 = "# SYSTEM ERROR -69O POWERNET #"
		data69"alarm"69 = 0 // Runtime Prevention
		return data

	var/list/L = find_apcs()
	var/total_apc_load = 0
	var/list/APC_data = list()
	if(L.len > 0)
		// These lists are used as replacement for69umber based APC settings
		var/list/S = list("M-OFF","A-OFF","M-ON", "A-ON")
		var/list/chg = list("N","C","F")

		for(var/obj/machinery/power/apc/A in L)
			var/list/APC_entry = list()
			// Channel Statuses
			APC_entry69"s_equipment"69 = S69A.equipment+169
			APC_entry69"s_lighting"69 = S69A.lighting+169
			APC_entry69"s_environment"69 = S69A.environ+169
			// Cell Status
			APC_entry69"cell_charge"69 = A.cell ? round(A.cell.percent()) : "NO CELL"
			APC_entry69"cell_status"69 = A.cell ? chg69A.charging+169 : "N"
			// Other info
			APC_entry69"total_load"69 = power_to_text(A.lastused_total)
			// Hopefully removes those goddamn \improper s which are screwing up the UI
			var/N = A.area.name
			if(findtext(N, "�"))
				N = copytext(N, 3)
			APC_entry69"name"69 =69
			// Add data into69ain list of APC data.
			APC_data += list(APC_entry)
			// Add load of this APC to total APC load calculation
			total_apc_load += A.lastused_total
	data69"apc_data"69 = APC_data
	data69"total_avail"69 = power_to_text(max(powernet.avail, 0))
	data69"total_used_apc"69 = power_to_text(max(total_apc_load, 0))
	data69"total_used_other"69 = power_to_text(max(powernet.viewload - total_apc_load, 0))
	data69"total_used_all"69 = power_to_text(max(powernet.viewload, 0))
	// Prevents runtimes when avail is 0 (division by zero)
	if(powernet.avail)
		data69"load_percentage"69 = round((powernet.viewload / powernet.avail) * 100)
	else
		data69"load_percentage"69 = 100
	data69"alarm"69 = powernet.problem ? 1 : 0
	return data





