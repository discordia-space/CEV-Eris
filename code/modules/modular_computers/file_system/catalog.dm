#define ENTRY_TYPE_REAGENT "reagent"

#define CATALOG_REAGENTS "reagents"


GLOBAL_LIST_EMPTY(catalogs)
GLOBAL_LIST_EMPTY(all_catalog_entries_by_type)

/hook/startup/proc/createCatalogs()
	// Reagents
	for(var/V in chemical_reagents_list)
		var/datum/reagent/D = chemical_reagents_list[V]
		if(D.appear_in_default_catalog)
			create_catalog_entry(D, CATALOG_REAGENTS)
	var/datum/catalog/C = GLOB.catalogs[CATALOG_REAGENTS]
	C.associated_template = "catalog_list_reagents.tmpl"
	return 1

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
			error("Unsupported type passed to /proc/create_catalog_entry()")
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

/datum/catalog/ui_data(mob/user, ui_key = "main", var/search_value)
	var/list/data = list()
	var/list/entries_data = list()
	for(var/datum/catalog_entry/E in entry_list)
		if(!search_value || findtext(E.title, search_value))
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
	associated_template = "catalog_entry_reagent.tmpl"
	var/reagent_type
	var/reagent_state
	var/metabolism_blood
	var/metabolism_stomach
	var/taste
	var/nerve_system_accumulations
	var/heating_decompose
	var/chilling_decompose
	var/color
	var/scannable
	var/overdose
	var/addiction_chance
	var/blood_affect_description
	var/ingested_description
	var/touched_description
	var/overdose_description
	var/withdrawal_description
	var/other_effect_description
	var/list/recipe_data
	var/list/can_be_found_in

/datum/catalog_entry/reagent/New(var/datum/reagent/V)
	if(!istype(V))
		error("wrong usage of [src.type]")
		qdel(src)
		return
	..()
	// SPECIFICTS
	title = V.name
	thing_nature = "Reagent"
	reagent_type = V.reagent_type
	reagent_state = V.reagent_state == SOLID ? "Solid" : V.reagent_state == LIQUID ? "Liquid" : "Gas"
	metabolism_blood = V.metabolism
	if(V.ingest_met)
		metabolism_stomach = V.ingest_met
	nerve_system_accumulations = V.nerve_system_accumulations
	if(V.heating_products && V.heating_point)
		heating_decompose = "Into "
		var/amount = 1
		for(var/id in V.heating_products)
			heating_decompose += "[get_reagent_name_by_id(id)]"
			if(V.heating_products.len > amount)
				heating_decompose += "/"
			amount++
		heating_decompose += " at [V.heating_point]k."
	if(V.chilling_products && V.chilling_point)
		chilling_decompose = "Into "
		var/amount = 1
		for(var/id in V.chilling_products)
			chilling_decompose += "[get_reagent_name_by_id(id)]"
			if(V.chilling_products.len > amount)
				chilling_decompose += "/"
			amount++
		chilling_decompose += " at [V.chilling_point]k."
		
	scannable = V.scannable ? "Yes" : "No"
	overdose = V.overdose ? V.overdose : null
	var/list/recipes = GLOB.chemical_reactions_list_by_result[V.id]
	if(recipes)
		recipe_data = list()
		for(var/datum/chemical_reaction/R in recipes)
			recipe_data += list(R.ui_data())
	// DESCRIPTION
	description = V.description
	taste = "Has [V.taste_mult > 1 ? "strong" : V.taste_mult < 1 ? "weak" : ""] taste of [V.taste_description]."
	color = "[V.color]"
	if(V.addiction_threshold || V.addiction_chance)
		addiction_chance = "Has [V.addiction_threshold ? "high" : V.addiction_chance <= 10 ? "low" : V.addiction_chance <= 25 ? "moderate" : "high"] addicition chance."
	blood_affect_description = V.blood_affect_description
	ingested_description = V.ingested_description
	touched_description = V.touched_description
	if(V.overdose && !V.overdose_description)
		error("Reagent has overdose but no description, fix dat.")
	overdose_description = V.overdose_description
	withdrawal_description = V.withdrawal_description
	other_effect_description = V.other_effect_description
	

/datum/catalog_entry/reagent/catalog_ui_data(mob/user, ui_key = "main")
	var/list/data = ..()
	data["reagent_state"] = reagent_state
	data["reagent_type"] = reagent_type
	return data

/datum/catalog_entry/reagent/ui_data(mob/user, ui_key = "main")
	var/list/data = list()

	// SPECIFICTS
	data["name"] = title
	data["reagent_type"] = reagent_type
	data["reagent_state"] = reagent_state
	data["metabolism_blood"] = metabolism_blood
	data["metabolism_stomach"] = metabolism_stomach
	data["nsa"] = nerve_system_accumulations
	data["heating_decompose"] = heating_decompose
	data["chilling_decompose"] = chilling_decompose
	data["scannable"] = scannable
	data["overdose"] = overdose

	data["recipe_data"] = recipe_data

	// DESCRIPTION
	data["description"] = description
	data["taste"] = taste
	data["color"] = color
	data["addiction_chance"] = addiction_chance 
	data["blood_affect_description"] = blood_affect_description
	data["ingested_description"] = ingested_description
	data["touched_description"] = touched_description
	data["overdose_description"] = overdose_description
	data["withdrawal_description"] = withdrawal_description
	data["other_effect_description"] = other_effect_description
	return data

/datum/catalog_entry/atom

/datum/catalog_entry/atom/New(var/atom/V)
	if(!istype(V))
		error("wrong usage of [src.type]")
		qdel(src)
		return
	title = V.name
	description = V.desc
	..()