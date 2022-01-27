/datum/computer_file/program/crew_manifest
	filename = "crewmanifest"
	filedesc = "Crew69anifest"
	extended_desc = "This program allows access to the69anifest of active crew."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 4
	requires_ntnet = 1
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/crew_manifest
	usage_flags = PROGRAM_ALL

/datum/nano_module/crew_manifest
	name = "Crew69anifest"

/datum/nano_module/crew_manifest/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = host.initial_data()

	data69"crew_manifest"69 = html_crew_manifest(TRUE)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "crew_manifest.tmpl",69ame, 450, 600, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()