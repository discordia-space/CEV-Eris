#define ENTRY_TYPE_REAGENT "reagent"

#define CATALOG_REAGENTS "reagents"


GLOBAL_LIST_EMPTY(catalogs)
GLOBAL_LIST_EMPTY(all_catalog_entries_by_type)

/proc/create_catalog_entry(var/datum/thing, var/catalog_id)
	if(catalog_id && !GLOB.catalogs[catalog_id])
		GLOB.catalogs[catalog_id] = new /datum/catalog(catalog_id)
	if(!all_catalog_entries_by_type[type])
		if(istype(thing, /datum/reagent))
			all_catalog_entries_by_type[type] = new /datum/catalog_entry/reagent(thing)
		else if(istype(thing, /atom))
			all_catalog_entries_by_type[type] = new /datum/catalog_entry/atom(thing)
		else
			if(!GLOB.catalogs[catalog_id].len)
				qdel(GLOB.catalogs[catalog_id])
				GLOB.catalogs.Remove(catalog_id)
				return FALSE
			crash_with("Unsupported type passed to /proc/create_catalog_entry()")
			return FALSE
		if(catalog_id)
			var/datum/catalog/C = GLOB.catalogs[catalog_id]
			C.add
	return TRUE

/datum/catalog
	var/id
	var/list/datum/catalog_entry/entry_list = list()

/datum/catalog/add_entry(var/datum/catalog_entry/E)
	entry_list += E

// accespts either type or datum
/datum/catalog/get_entry(var/datum/thing)
	for(var/datum/catalog_entry/E in entry_list)
		if(E.thing_type == ispath(thing) ? thing : thing.type)
			return E

/datum/catalog/New(var/_id)
	. = ..()
	id = _id

/datum/catalog/ui_data(mob/user, ui_key = "main")
	var/list/data = list()
	if(specific_entry)
		var/datum/catalog_entry/E = get_entry(thing)
		if(!E)
			crash_with("Entry not found.")
		data += E.ui_data()
	else
		var/list/entry_list = list()
		for(var/datum/catalog_entry/E in entry_list)
			entry_list.Add(list(E.ui_data()))
		data += entry_list
	return data

/datum/catalog_entry
	var/thing_type
	var/image_path	//image path in client cache
	var/title
	var/description
	var/associated_template
	var/thing_nature 	// reagent/weapon/device/etc.

/datum/catalog_entry/New(var/datum/V)
	thing_type = V.type

/datum/catalog_entry/reagent
	var/datum/reagent/reagent

/datum/catalog_entry/reagent/New(var/datum/reagent/V)
	if(!istype(V))
		crash_with("wrong usage of [src.type]")
		qdel(src)
		return
	reagent = V
	title = reagent.name
	description = reagent.description
	thing_nature = "Reagent"
	..()
	

/datum/catalog_entry/reagent/ui_data(mob/user, ui_key = "main")
	var/list/data = list()

	data["type"] = ENTRY_TYPE_REAGENT
	data["title"] = reagent.name
	data["description"] = reagent.description
	data["taste"] = "Has [reagent.taste_mult > 1 ? "strong" : reagent.taste_mult < 1 ? "weak" : ""] taste of [reagent.taste_description]."
	data["reagent_state"] = reagent.reagent_state == SOLID ? "Solid at room temperature" : reagent.reagent_state == LIQUID ? "Liquid at room temperature" : "Gas"
	data["metabolism"] = "Metabolises in blood at [reagent.metabolism]."
	if(ingest_met)
		data["metabolism"] += "<br>In stomach at [reagent.ingest_met]."

	return data

/datum/catalog_entry/atom
	var/atom/atom

/datum/catalog_entry/reagent/New(var/atom/V)
	if(!istype(V))
		crash_with("wrong usage of [src.type]")
		qdel(src)
		return
	atom = V
	..()