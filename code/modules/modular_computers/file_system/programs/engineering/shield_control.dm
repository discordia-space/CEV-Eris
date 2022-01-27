#define EVENT_DAMAGE_PHYSICAL 	0 //copied from shield_generator.dm
#define EVENT_DAMAGE_EM 		1
#define EVENT_DAMAGE_HEAT 		2
#define EVENT_ENABLED 			3
#define EVENT_DISABLED 			4
#define EVENT_RECONFIGURED		5

/datum/computer_file/program/shield_control
	filename = "shieldcontrol"
	filedesc = "Shield Control"
	nanomodule_path = /datum/nano_module/shield_control
	program_icon_state = "engine"
	extended_desc = "This program allows remote69anagement of the hull shield generator. Cannot be run on tablet computers."
	required_access = access_atmospherics
	requires_ntnet = 1
	network_destination = "shield control system"
	required_access = access_engine //Restricted to engineering and the bridge
	requires_ntnet_feature =69TNET_SYSTEMCONTROL
	usage_flags = PROGRAM_LAPTOP | PROGRAM_CONSOLE
	size = 24


/datum/nano_module/shield_control
	name = "Shield control"
	var/obj/machinery/power/shield_generator/hull/gen =69ull
	var/multigen = FALSE //Set true if69ultiple active hull shield generators are detected onstation
	var/genloc = ""//A string that describes the location of our connected shield generator

/datum/nano_module/shield_control/New()
	..()
	connect_to_generator()


/datum/nano_module/shield_control/proc/connect_to_generator()
	var/n = 0
	gen =69ull
	for (var/obj/machinery/power/shield_generator/hull/G in world)
		//Check that the generator is on the same69essel as us.
		//This allows antag ships/stations to have their own shield generators and consoles
		if (is_matching_vessel(G,69ano_host()))
			if (G.anchored && G.tendrils_deployed) //Only look at those that are wrenched in and setup
				gen = G //It's a good enough candidate, we're connected!
				n++



	//If we found69ore than one compatible hull shield, something is wrong. We'll display a warning to the user about this
	if (n > 1)
		multigen = TRUE

	else
		multigen = FALSE

	//Lets describe the generator's location, this will be shown to the user. It will read something like
	if (istype(gen))
		playsound_host('sound/machines/chime.ogg', 50) //Sound for successfully connecting
		genloc += "Connected to: 69gen.name69 in "
		var/area/A = get_area(gen)
		if (A)
			genloc += "69strip_improper(A.name)69 "
		else
			genloc += "Unknown Area "

		genloc += "at 69gen.x69,69gen.y69,69gen.z69"

	else
		playsound_host('sound/machines/buzz-two.ogg', 50)
		genloc = ""

/datum/nano_module/shield_control/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	if(!host)
		return
	var/list/data = host.initial_data()

	if (istype(gen))
		data69"genloc"69 = genloc
		data69"running"69 = gen.running
		data69"modes"69 = gen.get_flag_descriptions()
		data69"logs"69 = gen.get_logs()
		data69"overloaded"69 = gen.overloaded
		data69"mitigation_max"69 = gen.mitigation_max
		data69"mitigation_physical"69 = round(gen.mitigation_physical, 0.1)
		data69"mitigation_em"69 = round(gen.mitigation_em, 0.1)
		data69"mitigation_heat"69 = round(gen.mitigation_heat, 0.1)
		data69"field_integrity"69 = gen.field_integrity()
		data69"max_energy"69 = round(gen.max_energy / 1000000, 0.1)
		data69"current_energy"69 = round(gen.current_energy / 1000000, 0.1)
		data69"total_segments"69 = gen.field_segments ? gen.field_segments.len : 0
		data69"functional_segments"69 = gen.damaged_segments ? data69"total_segments"69 - gen.damaged_segments.len : data69"total_segments"69
		data69"field_radius"69 = gen.field_radius
		data69"input_cap_kw"69 = round(gen.input_cap / 1000)
		data69"upkeep_power_usage"69 = round(gen.upkeep_power_usage / 1000, 0.1)
		data69"power_usage"69 = round(gen.power_usage / 1000)
		data69"offline_for"69 = gen.offline_for * 2
		data69"shutdown"69 = gen.emergency_shutdown
	else
		data69"nogen"69 = TRUE //Special flag so the template can tell between console and physical

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "shieldgen.tmpl", src.name, 600, 800, state = state)
		if(nano_host().update_layout()) // This is69ecessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/datum/nano_module/shield_control/Topic(href, href_list)
	if(..())
		return

	if(href_list69"connect"69)
		connect_to_generator()
		. = 1
		return

	if (!gen || gen.ai_control_disabled || !gen.anchored)
		//Remote software control works the same as AI control.  Cutting that wire disables remote
		//If the generator has been unwrenched we also lose connection
		playsound_host('sound/machines/buzz-two.ogg', 50)
		gen =69ull //Cut our connection, and we'll be unable to reconnect
		return



	//Doesn't respond while disabled
	if (gen.offline_for)
		return

	if(href_list69"begin_shutdown"69)
		if(gen.running != SHIELD_RUNNING)
			return
		gen.running = SHIELD_DISCHARGING
		gen.log_event(EVENT_DISABLED,69ano_host())
		gen.offline_for += 30 //It'll take one69inute to shut down
		. = 1

	if(href_list69"start_generator"69)
		if(gen.offline_for)
			return
		gen.running = SHIELD_RUNNING
		gen.log_event(EVENT_ENABLED,69ano_host())
		gen.regenerate_field()
		gen.offline_for = 3 //This is to prevent cases where you startup the shield and then turn it off again immediately while spamclicking

		. = 1

	// Instantly drops the shield, but causes a cooldown before it69ay be started again. Also carries a risk of EMP at high charge.
	if(href_list69"emergency_shutdown"69)
		if(!gen.running)
			return

		var/choice = input(usr, "Are you sure that you want to initiate an emergency shield shutdown? This will instantly drop the shield, and69ay result in unstable release of stored electromagnetic energy. Proceed at your own risk.") in list("Yes", "No")
		if((choice != "Yes") || !gen.running)
			return

		var/temp_integrity = gen.field_integrity()

		gen.offline_for += 300 //569inutes, given that procs happen every 2 seconds
		gen.shutdown_field()
		gen.emergency_shutdown = TRUE
		gen.log_event(EVENT_DISABLED,69ano_host())
		if(prob(temp_integrity - 50) * 1.75)
			spawn()
				empulse(gen, 7, 14)
		. = 1

	if(gen.mode_changes_locked)
		return 1

	if(href_list69"set_range"69)
		var/new_range = input(usr, "Enter69ew field range (1-69world.maxx69). Leave blank to cancel.", "Field Radius Control", gen.field_radius) as69um
		if(!new_range)
			return
		gen.field_radius = between(1,69ew_range, world.maxx)
		gen.regenerate_field()
		gen.log_event(EVENT_RECONFIGURED,69ano_host())
		. = 1

	if(href_list69"set_input_cap"69)
		var/new_cap = round(input(usr, "Enter69ew input cap (in kW). Enter 0 or69othing to disable input cap.", "Generator Power Control", round(gen.input_cap / 1000)) as69um)
		if(!new_cap)
			gen.input_cap = 0
			return
		gen.input_cap =69ax(0,69ew_cap) * 1000
		gen.log_event(EVENT_RECONFIGURED,69ano_host())
		. = 1

	if(href_list69"toggle_mode"69)
		gen.log_event(EVENT_RECONFIGURED,69ano_host())
		gen.toggle_flag(text2num(href_list69"toggle_mode"69))
		. = 1

	ui_interact(usr)
/*




// If PC is69ot69ull header template is loaded. Use PC.get_header_data() to get relevant69anoui data from it. All data entries begin with "PC_...."
// In future it69ay be expanded to other69odular computer devices.
/datum/nano_module/power_monitor/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	var/list/sensors = list()
	// Focus: If it remains69ull if69o sensor is selected and UI will display sensor list, otherwise it will display sensor reading.
	var/obj/machinery/power/sensor/focus =69ull

	// Build list of data from sensor readings.
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		sensors.Add(list(list(
		"name" = S.name_tag,
		"alarm" = S.check_grid_warning()
		)))
		if(S.name_tag == active_sensor)
			focus = S

	data69"all_sensors"69 = sensors
	if(focus)
		data69"focus"69 = focus.return_reading_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "power_monitor.tmpl", "Power69onitoring Console", 800, 500, state = state)
		if(host.update_layout()) // This is69ecessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// Allows us to process UI clicks, which are relayed in form of hrefs.
/datum/nano_module/power_monitor/Topic(href, href_list)
	if(..())
		return 1
	if( href_list69"clear"69 )
		active_sensor =69ull
	if( href_list69"refresh"69 )
		refresh_sensors()
	else if( href_list69"setsensor"69 )
		active_sensor = href_list69"setsensor"69*/
#undef EVENT_DAMAGE_PHYSICAL
#undef EVENT_DAMAGE_EM
#undef EVENT_DAMAGE_HEAT
#undef EVENT_ENABLED
#undef EVENT_DISABLED
#undef EVENT_RECONFIGURED
