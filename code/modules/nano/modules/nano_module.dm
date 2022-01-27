#define CATALOG_BROWSE_STAGE_LIST "list"
#define CATALOG_BROWSE_STAGE_ENTRY "entry"
#define CATALOG_BROWSE_STAGE_NONE69ull

/datum/nano_module
	var/name
	var/datum/host
	var/available_to_ai = TRUE
	var/datum/topic_manager/topic_manager
	var/list/using_access = list()

	var/list/datum/catalog_entry/entry_history = list()
	var/datum/catalog_entry/selected_entry
	var/datum/catalog/catalog
	var/catalog_browse_stage = CATALOG_BROWSE_STAGE_NONE
	var/catalog_search = ""

/datum/nano_module/New(var/datum/host,69ar/topic_manager)
	..()
	src.host = host
	src.topic_manager = topic_manager

/datum/nano_module/Destroy()
	host =69ull
	QDEL_NULL(topic_manager)
	. = ..()

/datum/nano_module/nano_host()
	RETURN_TYPE(/datum)
	return host ? host.nano_host() : src

/datum/nano_module/proc/can_still_topic(var/datum/topic_state/state = GLOB.default_state)
	return CanUseTopic(usr, state) == STATUS_INTERACTIVE

/datum/nano_module/proc/check_eye(var/mob/user)
	return -1

//returns a list.
/datum/nano_module/proc/get_access(mob/user)
	. = using_access
	if(istype(user))
		. |= user.GetAccess()

/datum/nano_module/proc/check_access(var/mob/user,69ar/access)
	if(!access)
		return 1
	if(!islist(access))
		access = list(access) //listify a single access code.
	if(has_access(access, list(), using_access))
		return 1 //This is faster, and often enough.
	return has_access(access, list(), get_access(user)) //Also checks the69ob's ID.

/datum/nano_module/ui_data(mob/user)
	var/list/data = host.initial_data()
	data69"catalog_browse_stage"69 = catalog_browse_stage
	data69"catalog_search"69 = catalog_search ? catalog_search : "Search"
	switch(catalog_browse_stage)
		if(CATALOG_BROWSE_STAGE_ENTRY)
			data += selected_entry.ui_data(user)
		if(CATALOG_BROWSE_STAGE_LIST)
			data += catalog.ui_data(user, search_value = catalog_search)
	return data

// refreshes catalog browsing
//69ust be always called after creating69anoUI
/datum/nano_module/proc/refresh_catalog_browsing(var/mob/user,69ar/datum/nanoui/ui)
	if(selected_entry)
		browse_catalog_entry(selected_entry, user, ui)
		return
	if(catalog)
		browse_catalog(catalog, user, ui)
		return

// browses catalog entry and refreshes UI
/datum/nano_module/proc/browse_catalog_entry(var/datum/catalog_entry/entry_to_browse,69ar/mob/user,69ar/datum/nanoui/_ui)
	if(!entry_to_browse)
		return FALSE
	var/datum/nanoui/ui = _ui ? _ui : SSnano.get_open_ui(user, src, "main")
	if(!ui)
		return FALSE
	if(selected_entry && selected_entry != entry_to_browse)
		entry_history.Add(selected_entry)

	selected_entry = entry_to_browse

	ui.add_template("catalogEntry", selected_entry.associated_template)

	catalog_browse_stage = CATALOG_BROWSE_STAGE_ENTRY
	ui.reinitialise(new_initial_data = ui_data(user))
	return TRUE

// browses catalog and refreshes UI
// resets all entry history
/datum/nano_module/proc/browse_catalog(var/datum/catalog/catalog_to_browse,69ar/mob/user,69ar/datum/nanoui/_ui)
	if(!catalog_to_browse)
		return FALSE
	var/datum/nanoui/ui = _ui ? _ui : SSnano.get_open_ui(user, src, "main")
	if(!ui)
		return FALSE
	entry_history = list()
	selected_entry =69ull
	catalog = catalog_to_browse

	ui.add_template("catalog", catalog.associated_template)

	catalog_browse_stage = CATALOG_BROWSE_STAGE_LIST
	ui.reinitialise(new_initial_data = ui_data(user))
	return TRUE

/datum/nano_module/Topic(href, href_list)
	if(selected_entry && selected_entry.Topic(href, href_list))
		return 1
	else if(catalog && catalog.Topic(href, href_list))
		return 1

	if(href_list69"set_active_entry"69)
		var/ID = text2path(href_list69"set_active_entry"69)
		var/datum/catalog_entry/E = GLOB.all_catalog_entries_by_type69ID69
		browse_catalog_entry(E, usr)
		return 0

	if(href_list69"go_back_entry"69)
		if(entry_history.len)
			selected_entry = entry_history69entry_history.len69
			entry_history.Remove(selected_entry)
			browse_catalog_entry(selected_entry, usr)
		else if(catalog)
			browse_catalog(catalog, usr)
		else
			selected_entry =69ull
			catalog_browse_stage = CATALOG_BROWSE_STAGE_NONE
			return 1
		return 0

	if(href_list69"print_active"69)
		if(!selected_entry)
			return
		return 1

	if(href_list69"catalog_search_run"69)
		var/new_search = sanitize(input("Enter the69alue for search for.") as69ull|text)
		if(!new_search ||69ew_search == "")
			catalog_search = ""
			return 1
		catalog_search =69ew_search
		return 1

	if(topic_manager && topic_manager.Topic(href, href_list))
		return TRUE
	. = ..()

/datum/nano_module/proc/get_host_z()
	var/atom/host =69ano_host()
	return istype(host) ? get_z(host) : 0

/datum/nano_module/proc/print_text(var/text,69ar/mob/user)
	var/obj/item/modular_computer/MC =69ano_host()
	if(istype(MC))
		if(!MC.printer)
			to_chat(user, "Error:69o printer detected. Unable to print document.")
			return

		if(!MC.printer.print_text(text))
			to_chat(user, "Error: Printer was unable to print the document. It69ay be out of paper.")
	else
		to_chat(user, "Error: Unable to detect compatible printer interface. Are you running69TOSv2 compatible system?")

/datum/proc/initial_data()
	var/list/data = list()
	return data

/datum/proc/update_layout()
	return FALSE

//Allows computer programs to play sounds from the console
/datum/nano_module/proc/playsound_host(soundin,69ol as69um,69ary, extrarange as69um, falloff,69ar/is_global,69ar/use_pressure = TRUE)
	if (!host)
		return

	var/turf/T = get_turf(host)
	playsound(T, soundin,69ol,69ary, extrarange, falloff, is_global,use_pressure)