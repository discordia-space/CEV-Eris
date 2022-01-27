/datum/nano_module/catalog
	name = "Catalog"

/datum/nano_module/catalog/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_REINITIALIZE, state = GLOB.default_state)
	var/list/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "chemistry_catalog.tmpl",69ame, 640, 700, state = state)
		ui.set_initial_data(data)
		refresh_catalog_browsing(user, ui)
		ui.auto_update_layout = 1
		ui.open()

/datum/nano_module/catalog/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"greet"69)
		browse_catalog(GLOB.catalogs69CATALOG_ALL69, usr)
		return 0