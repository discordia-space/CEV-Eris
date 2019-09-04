#define ENTRY_TYPE_REAGENT "reagent"

#define CATALOG_REAGENTS "reagents"


GLOBAL_LIST_EMPTY(catalogs)
GLOBAL_LIST_EMPTY(all_catalog_entries_by_type)

/proc/create_catalog_entry(var/datum/thing, var/catalog_id)
	if(catalog_id && !GLOB.catalogs[catalog_id])
		GLOB.catalogs[catalog_id] = new /datum/catalog(catalog_id)
	if(!GLOB.all_catalog_entries_by_type[thing.type])
		if(istype(thing, /datum/reagent))
			GLOB.all_catalog_entries_by_type[thing.type] = new /datum/catalog_entry/reagent(thing)
		else if(istype(thing, /atom))
			GLOB.all_catalog_entries_by_type[thing.type] = new /datum/catalog_entry/atom(thing)
		else
			if(!GLOB.catalogs[catalog_id].len)
				qdel(GLOB.catalogs[catalog_id])
				GLOB.catalogs.Remove(catalog_id)
				return FALSE
			crash_with("Unsupported type passed to /proc/create_catalog_entry()")
			return FALSE
		if(catalog_id)
			var/datum/catalog/C = GLOB.catalogs[catalog_id]
			C.add_entry(GLOB.all_catalog_entries_by_type[thing.type])
	return TRUE

/datum/catalog
	var/id
	var/list/datum/catalog_entry/entry_list = list()
	var/associated_template

/datum/catalog/New(var/_id)
	. = ..()
	id = _id

// accespts either type or datum
/datum/catalog/proc/get_entry(var/datum/thing)
	for(var/datum/catalog_entry/E in entry_list)
		if(E.thing_type == ispath(thing) ? thing : thing.type)
			return E

/datum/catalog/proc/add_entry(var/datum/catalog_entry/entry)
	entry_list.Add(entry)

/datum/catalog/proc/remove_entry(var/datum/catalog_entry/entry)
	entry_list.Remove(entry)

/datum/catalog/ui_data(mob/user, ui_key = "main")
	var/list/data = list()
	var/list/entries_data = list()
	for(var/datum/catalog_entry/E in entry_list)
		entries_data.Add(list(E.catalog_ui_data(user, ui_key)))
	data["entries"] = entries_data
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

// this used to get ui_data for list
// usually this is shorter ui_data
/datum/catalog_entry/proc/catalog_ui_data(mob/user, ui_key = "main")
	var/list/data = list()
	data["id"] = thing_type
	data["name"] = title
	data["thing_nature"] = thing_nature
	if(image_path)
		data["image"] = image_path
	return data

/datum/catalog_entry/reagent
	var/datum/reagent/reagent
	associated_template = "catalog_entry_reagent.tmpl"

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

/datum/catalog_entry/reagent/catalog_ui_data(mob/user, ui_key = "main")
	var/list/data = ..()
	data["reagent_state"] = reagent.reagent_state == SOLID ? "Solid" : reagent.reagent_state == LIQUID ? "Liquid" : "Gas"
	data["reagent_type"] = "Toxin"
	return data

/datum/catalog_entry/reagent/ui_data(mob/user, ui_key = "main")
	var/list/data = list()

	data["name"] = reagent.name
	data["description"] = reagent.description
	data["reagent_type"] = "Toxin"
	data["taste"] = "Has [reagent.taste_mult > 1 ? "strong" : reagent.taste_mult < 1 ? "weak" : ""] taste of [reagent.taste_description]."
	data["reagent_state"] = reagent.reagent_state == SOLID ? "Solid at room temperature" : reagent.reagent_state == LIQUID ? "Liquid at room temperature" : "Gas"
	data["metabolism_blood"] = reagent.metabolism
	if(reagent.ingest_met)
		data["metabolism_stomach"] += reagent.ingest_met
	return data

/datum/catalog_entry/atom
	var/atom/atom

/datum/catalog_entry/atom/New(var/atom/V)
	if(!istype(V))
		crash_with("wrong usage of [src.type]")
		qdel(src)
		return
	atom = V
	title = atom.name
	description = atom.desc
	..()