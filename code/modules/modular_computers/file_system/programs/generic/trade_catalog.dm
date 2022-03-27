/datum/computer_file/program/trade_catalog
	filename = "trade_catalog"
	filedesc = "Aster's Trade Catalog"
	extended_desc = "Electronic handbook containing inventory information about discovered trade beacons."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 2
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/trade_catalog
	usage_flags = PROGRAM_ALL

/datum/nano_module/trade_catalog
	name = "Trade Catalog"

/datum/nano_module/drink_catalog/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_REINITIALIZE, state = GLOB.default_state)
	var/list/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "trade_catalog.tmpl", name, 640, 700, state = state)
        ui.set_auto_update(TRUE)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/drink_catalog/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["greet"])
		//browse_catalog(GLOB.catalogs[CATALOG_DRINKS], usr)
		return FALSE