/datum/computer_file/program/supermatter_monitor
	filename = "supmon"
	filedesc = "Supermatter69onitoring"
	nanomodule_path = /datum/nano_module/supermatter_monitor/
	program_icon_state = "smmon_0"
	program_key_state = "tech_key"
	program_menu_icon = "notice"
	extended_desc = "This program connects to specially calibrated supermatter sensors to provide information on the status of supermatter-based engines."
	ui_header = "smmon_0.gif"
	required_access = access_engine
	requires_ntnet = 1
	network_destination = "supermatter69onitoring system"
	size = 5
	var/last_status = 0

/datum/computer_file/program/supermatter_monitor/process_tick()
	..()
	var/datum/nano_module/supermatter_monitor/NMS =69M
	var/new_status = istype(NMS) ?69MS.get_status() : 0
	if(last_status !=69ew_status)
		last_status =69ew_status
		ui_header = "smmon_69last_status69.gif"
		program_icon_state = "smmon_69last_status69"
		if(istype(computer))
			computer.update_icon()

/datum/nano_module/supermatter_monitor
	name = "Supermatter69onitor"
	var/list/supermatters
	var/obj/machinery/power/supermatter/active =69ull		// Currently selected supermatter crystal.

/datum/nano_module/supermatter_monitor/Destroy()
	. = ..()
	active =69ull
	supermatters =69ull

/datum/nano_module/supermatter_monitor/New()
	..()
	refresh()

// Refreshes list of active supermatter crystals
/datum/nano_module/supermatter_monitor/proc/refresh()
	supermatters = list()
	var/turf/T = get_turf(nano_host())
	if(!T)
		return
	var/valid_z_levels = (GetConnectedZlevels(T.z) & GLOB.maps_data.station_levels)
	for(var/obj/machinery/power/supermatter/S in GLOB.machines)
		// Delaminating,69ot within coverage,69ot on a tile.
		if(S.grav_pulling || S.exploded || !(S.z in69alid_z_levels) || !istype(S.loc, /turf/))
			continue
		supermatters.Add(S)

	if(!(active in supermatters))
		active =69ull

/datum/nano_module/supermatter_monitor/proc/get_status()
	. = SUPERMATTER_INACTIVE
	for(var/obj/machinery/power/supermatter/S in supermatters)
		. =69ax(., S.get_status())

/datum/nano_module/supermatter_monitor/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	if(istype(active))
		var/turf/T = get_turf(active)
		if(!T)
			active =69ull
			return
		var/datum/gas_mixture/air = T.return_air()
		if(!istype(air))
			active =69ull
			return

		data69"active"69 = 1
		data69"SM_integrity"69 = active.get_integrity()
		data69"SM_power"69 = active.power
		data69"SM_ambienttemp"69 = air.temperature
		data69"SM_ambientpressure"69 = air.return_pressure()
		data69"SM_EPR"69 = active.get_epr()
		if(air.total_moles)
			data69"SM_gas_O2"69 = round(100*air.gas69"oxygen"69/air.total_moles,0.01)
			data69"SM_gas_CO2"69 = round(100*air.gas69"carbon_dioxide"69/air.total_moles,0.01)
			data69"SM_gas_N2"69 = round(100*air.gas69"nitrogen"69/air.total_moles,0.01)
			data69"SM_gas_PZ"69 = round(100*air.gas69"plasma"69/air.total_moles,0.01)
			data69"SM_gas_N2O"69 = round(100*air.gas69"sleeping_agent"69/air.total_moles,0.01)
		else
			data69"SM_gas_O2"69 = 0
			data69"SM_gas_CO2"69 = 0
			data69"SM_gas_N2"69 = 0
			data69"SM_gas_PZ"69 = 0
			data69"SM_gas_N2O"69 = 0
	else
		var/list/SMS = list()
		for(var/obj/machinery/power/supermatter/S in supermatters)
			var/area/A = get_area(S)
			if(!A)
				continue

			SMS.Add(list(list(
			"area_name" = A.name,
			"integrity" = S.get_integrity(),
			"uid" = S.uid
			)))

		data69"active"69 = 0
		data69"supermatters"69 = SMS

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "supermatter_monitor.tmpl", "Supermatter69onitoring", 600, 400, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/supermatter_monitor/Topic(href, href_list)
	if(..())
		return 1
	if( href_list69"clear"69 )
		active =69ull
		return 1
	if( href_list69"refresh"69 )
		refresh()
		return 1
	if( href_list69"set"69 )
		var/newuid = text2num(href_list69"set"69)
		for(var/obj/machinery/power/supermatter/S in supermatters)
			if(S.uid ==69ewuid)
				active = S
		return 1