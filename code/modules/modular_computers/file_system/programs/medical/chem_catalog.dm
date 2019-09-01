/*

*/

/datum/computer_file/program/chem_catalog
	filename = "chemCatalog"
	filedesc = "Chemistry Catalog"
	extended_desc = "Electronic catalog containing all information about chemical reactions and reagents."
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

/datum/nano_module/chem_catalog/New()
	. = ..()
	catalog = GLOB.catalogs[CATALOG_REAGENTS]

/datum/nano_module/chem_catalog/ui_data(mob/user)
	var/list/data = host.initial_data()
	if(selectedEntry)
		data += selectedEntry.ui_data(user)
	else
		data += catalog.ui_data(user)
	return data

/datum/nano_module/chem_catalog/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = ui_data(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "chem_catalog.tmpl", name, 700, 540, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		if(selectedEntry)
			ui.add_template("catalog_entry", selectedEntry.associated_template)
		else
			ui.add_template("catalog", catalog.associated_template)
		ui.open()

/datum/nano_module/chem_catalog/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["clear_active"])
		selectedEntry = null
		return 1

	if(href_list["set_active"])
		var/ID = text2num(href_list["set_active"])
		for(var/datum/computer_file/report/bounty_entry/R in GLOB.all_bounty_entries)
			if(R.uid == ID)
				selectedEntry = R
				break
		return 1

	if(href_list["new_record"])
		selectedEntry = new/datum/computer_file/report/bounty_entry()
		selectedEntry.owner_id_card = usr.GetIdCard()
		return 1

	if(href_list["print_active"])
		if(!selectedEntry)
			return
		print_text(record_to_html(selectedEntry, get_record_access(usr)), usr)
		return 1