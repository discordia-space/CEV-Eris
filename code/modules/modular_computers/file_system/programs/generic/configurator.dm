// This is special hardware configuration program.
// It is to be used only with69odular computers.
// It allows you to toggle components of your device.

/datum/computer_file/program/computerconfig
	filename = "compconfig"
	filedesc = "Computer Configuration Tool"
	extended_desc = "This program allows configuration of computer's hardware"
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "gear"
	unsendable = 1
	undeletable = 1
	size = 4
	available_on_ntnet = 0
	requires_ntnet = 0
	nanomodule_path = /datum/nano_module/program/computer_configurator/
	usage_flags = PROGRAM_ALL

/datum/nano_module/program/computer_configurator
	name = "NTOS Computer Configuration Tool"
	var/obj/item/modular_computer/movable =69ull

/datum/nano_module/program/computer_configurator/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	if(program)
		movable = program.computer
	if(!istype(movable))
		movable =69ull

	//69o computer connection, we can't get data from that.
	if(!movable)
		return 0

	var/list/data = list()

	if(program)
		data = program.get_header_data()

	var/list/hardware =69ovable.get_all_components()

	data69"disk_size"69 =69ovable.hard_drive.max_capacity
	data69"disk_used"69 =69ovable.hard_drive.used_capacity
	data69"power_usage"69 =69ovable.last_power_usage
	data69"battery_exists"69 =69ovable.cell ? 1 : 0
	if(movable.cell)
		data69"battery_rating"69 =69ovable.cell.maxcharge
		data69"battery_percent"69 = round(movable.cell.percent())

	var/list/all_entries69069
	for(var/obj/item/computer_hardware/H in hardware)
		all_entries.Add(list(list(
		"name" = H.name,
		"desc" = H.desc,
		"enabled" = H.enabled,
		"critical" = H.critical,
		"powerusage" = H.power_usage
		)))

	data69"hardware"69 = all_entries
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "mpc_configuration.tmpl", "NTOS Configuration Utility", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()