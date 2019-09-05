/*

*/
#define CATALOG_BROWSE_STAGE_GREET "greet"
#define CATALOG_BROWSE_STAGE_LIST "list"
#define CATALOG_BROWSE_STAGE_ENTRY "entry"
/datum/computer_file/program/chem_catalog
	filename = "chemCatalog"
	filedesc = "MIRC"
	extended_desc = "Moebious Internal Reagent Catalogue - Electronic catalog containing all information about basic chemical reactions and reagents."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 2
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/chem_catalog
	usage_flags = PROGRAM_ALL


/datum/nano_module/chem_catalog
	name = "Chemistry Catalog"
	var/datum/catalog_entry/reagent/selectedEntry
	var/datum/catalog/catalog
	var/browse_stage = CATALOG_BROWSE_STAGE_GREET
	//for search
	var/search = ""

/datum/nano_module/chem_catalog/New()
	. = ..()
	catalog = GLOB.catalogs[CATALOG_REAGENTS]

/datum/nano_module/chem_catalog/ui_data(mob/user)
	var/list/data = host.initial_data()
	data["browse_stage"] = browse_stage
	data["search"] = search ? search : "Search"
	switch(browse_stage)
		if(CATALOG_BROWSE_STAGE_ENTRY)
			data += selectedEntry.ui_data(user)
		if(CATALOG_BROWSE_STAGE_LIST)
			data += catalog.ui_data(user, search_value = search)
	return data

/datum/nano_module/chem_catalog/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_REINITIALIZE, state = GLOB.default_state)
	var/list/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "chemistry_catalog.tmpl", name, 640, 700, state = state)
		
		if(selectedEntry)
			ui.add_template("catalogEntry", selectedEntry.associated_template)
		ui.add_template("catalog", catalog.associated_template)
		ui.set_initial_data(data)
		ui.auto_update_layout = 1
		ui.open()

/datum/nano_module/chem_catalog/Topic(href, href_list)
	if(..())
		return 1

	if(selectedEntry && selectedEntry.Topic(href, href_list))
		return 1
	else if(catalog.Topic(href, href_list))
		return 1

	if(href_list["clear_active"])
		selectedEntry = null
		browse_stage = CATALOG_BROWSE_STAGE_LIST
		return 1
	
	if(href_list["search"])
		var/new_search = sanitize(input("Enter the value for search for.") as null|text)
		if(!new_search || new_search == "")
			search = ""
			return 1
		search = new_search
		return 1

	if(href_list["set_active"])
		browse_stage = CATALOG_BROWSE_STAGE_ENTRY
		var/ID = text2path(href_list["set_active"])
		selectedEntry = GLOB.all_catalog_entries_by_type[ID]
		var/datum/nanoui/ui = SSnano.get_open_ui(usr, src, "main")
		ui.add_template("catalogEntry", selectedEntry.associated_template)
		ui.reinitialise(new_initial_data = ui_data(usr))
		return 0
	
	if(href_list["greet"])
		browse_stage = CATALOG_BROWSE_STAGE_LIST
		return 1

	if(href_list["print_active"])
		if(!selectedEntry)
			return
		return 1