/*
	important69otes
	catalogs are handled in /datum/nano_module, check there
	important procs are:
		browse_catalog_entry()
		browse_catalog()
		refresh_catalog_browsing()

	TODO: add access level that will show69ore info
*/

GLOBAL_LIST_EMPTY(catalogs)
GLOBAL_LIST_EMPTY(all_catalog_entries_by_type)

/hook/startup/proc/createCatalogs()
	// Reagents
	for(var/V in GLOB.chemical_reagents_list)
		var/datum/reagent/D = GLOB.chemical_reagents_list69V69
		if(D.appear_in_default_catalog)
			create_catalog_entry(D, CATALOG_REAGENTS)
			create_catalog_entry(D, CATALOG_ALL)
			if(istype(D, /datum/reagent/drink) || istype(D, /datum/reagent/alcohol))
				create_catalog_entry(D, CATALOG_DRINKS)
			else
				create_catalog_entry(D, CATALOG_CHEMISTRY)
	// second run to add decompose results
	for(var/V in GLOB.chemical_reagents_list)
		var/datum/reagent/D = GLOB.chemical_reagents_list69V69
		if(D.heating_products && D.heating_point)
			for(var/id in D.heating_products)
				var/datum/catalog_entry/reagent/E = get_catalog_entry(get_reagent_type_by_id(id))
				if(E)
					E.add_decomposition_from(D.type)

		if(D.chilling_products && D.chilling_point)
			for(var/id in D.chilling_point)
				var/datum/catalog_entry/reagent/E = get_catalog_entry(D.type)
				if(E)
					E.add_decomposition_from(D.type)

	var/datum/catalog/C = GLOB.catalogs69CATALOG_REAGENTS69
	C.associated_template = "catalog_list_reagents.tmpl"
	C.entry_list = sortTim(C.entry_list, /proc/cmp_catalog_entry_asc)
	C = GLOB.catalogs69CATALOG_CHEMISTRY69
	C.associated_template = "catalog_list_reagents.tmpl"
	C.entry_list = sortTim(C.entry_list, /proc/cmp_catalog_entry_chem)
	C = GLOB.catalogs69CATALOG_DRINKS69
	C.associated_template = "catalog_list_drinks.tmpl"
	C.entry_list = sortTim(C.entry_list, /proc/cmp_catalog_entry_asc)
	C = GLOB.catalogs69CATALOG_ALL69
	C.associated_template = "catalog_list_general.tmpl"
	C.entry_list = sortTim(C.entry_list, /proc/cmp_catalog_entry_asc)
	return 1

/proc/create_catalog_entry(var/datum/thing,69ar/catalog_id)
	if(catalog_id && !GLOB.catalogs69catalog_id69)
		GLOB.catalogs69catalog_id69 =69ew /datum/catalog(catalog_id)
	if(!GLOB.all_catalog_entries_by_type69thing.type69)
		if(istype(thing, /datum/reagent))
			if(istype(thing, /datum/reagent/drink) || (istype(thing, /datum/reagent/alcohol) && thing.type != /datum/reagent/alcohol))
				GLOB.all_catalog_entries_by_type69thing.type69 =69ew /datum/catalog_entry/drink(thing)
			else
				GLOB.all_catalog_entries_by_type69thing.type69 =69ew /datum/catalog_entry/reagent(thing)
		else if(istype(thing, /atom))
			GLOB.all_catalog_entries_by_type69thing.type69 =69ew /datum/catalog_entry/atom(thing)
		else
			var/list/element = GLOB.catalogs69catalog_id69
			if(!element.len)
				qdel(element)
				GLOB.catalogs.Remove(catalog_id)
				return FALSE
			error("Unsupported type passed to /proc/create_catalog_entry()")
			return FALSE
		if(catalog_id)
			var/datum/catalog/C = GLOB.catalogs69catalog_id69
			C.add_entry(GLOB.all_catalog_entries_by_type69thing.type69)
	else if(catalog_id)
		var/datum/catalog/C = GLOB.catalogs69catalog_id69
		if(!C.entry_list.Find(GLOB.all_catalog_entries_by_type69thing.type69))
			C.add_entry(GLOB.all_catalog_entries_by_type69thing.type69)
	return TRUE

/proc/get_catalog_entry(var/type)
	if(GLOB.all_catalog_entries_by_type69type69)
		return GLOB.all_catalog_entries_by_type69type69

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

/datum/catalog/ui_data(mob/user, ui_key = "main",69ar/search_value)
	var/list/data = list()
	var/list/entries_data = list()
	for(var/datum/catalog_entry/E in entry_list)
		if(!search_value || E.search_value(search_value))
			entries_data.Add(list(E.catalog_ui_data(user, ui_key)))
	data69"entries"69 = entries_data
	return data

/datum/catalog_entry
	var/thing_type
	var/image_path	//image path in client cache
	var/title
	var/description
	var/associated_template
	var/thing_nature 	// reagent/weapon/device/etc.

/datum/catalog_entry/New(var/datum/V)
	thing_type =69.type

/datum/catalog_entry/proc/search_value(var/value)
	if(findtext(title,69alue))
		return TRUE
	if(findtext(thing_nature,69alue))
		return TRUE

/datum/catalog_entry/ui_data(mob/user, ui_key = "main")
	var/list/data = list()
	data69"id"69 = thing_type
	data69"thing_nature"69 = thing_nature

	return data

// this used to get ui_data for list
// usually this is shorter ui_data
/datum/catalog_entry/proc/catalog_ui_data(mob/user, ui_key = "main")
	var/list/data = list()
	data69"id"69 = thing_type
	data69"name"69 = title
	data69"thing_nature"69 = thing_nature
	if(image_path)
		data69"image"69 = image_path
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
	var/heating_point
	var/chilling_decompose
	var/chilling_point
	var/color
	var/scannable
	var/overdose
	var/addiction_chance
	var/addiction_threshold
	var/list/recipe_data
	var/list/result_of_decomposition_in
	var/list/can_be_used_in

/datum/catalog_entry/reagent/search_value(var/value)
	if(..())
		return TRUE
	if(findtext(reagent_type,69alue))
		return TRUE

/datum/catalog_entry/reagent/proc/add_decomposition_from(var/reagent_type)
	if(!result_of_decomposition_in)
		result_of_decomposition_in = list()
	for(var/V in result_of_decomposition_in)
		if(V == reagent_type)
			return
	result_of_decomposition_in.Add(reagent_type)

/datum/catalog_entry/reagent/proc/add_can_be_used_in(var/reagent_type)
	if(!can_be_used_in)
		can_be_used_in = list()
	for(var/V in can_be_used_in)
		if(V == reagent_type)
			return
	can_be_used_in.Add(reagent_type)

/datum/catalog_entry/reagent/New(datum/reagent/V)
	if(!istype(V))
		error("wrong usage of 69src.type69")
		qdel(src)
		return
	..()
	// SPECIFICTS
	title =69.name
	thing_nature = "Reagent"
	reagent_type =69.reagent_type
	reagent_state =69.reagent_state == SOLID ? "Solid" :69.reagent_state == LIQUID ? "Liquid" : "Gas"
	metabolism_blood =69.metabolism
	if(V.ingest_met)
		metabolism_stomach =69.ingest_met
	nerve_system_accumulations =69.nerve_system_accumulations
	if(V.heating_products &&69.heating_point)
		var/list/dat = list()
		dat69"types"69 = list()
		for(var/id in69.heating_products)
			dat69"types"69 += get_reagent_type_by_id(id)
		heating_decompose = dat
		heating_point =69.heating_point

	if(V.chilling_products &&69.chilling_point)
		var/list/dat = list()
		dat69"types"69 = list()
		for(var/id in69.chilling_products)
			dat69"types"69 += get_reagent_type_by_id(id)
		chilling_decompose = dat
		chilling_point =69.chilling_point

	scannable =69.scannable
	overdose =69.overdose ?69.overdose :69ull
	var/list/recipes = GLOB.chemical_reactions_list_by_result69V.id69
	if(recipes)
		recipe_data = list()
		for(var/datum/chemical_reaction/R in recipes)
			recipe_data += list(R.ui_data())
	var/list/used_in = GLOB.chemical_reactions_list69V.id69
	if(used_in)
		for(var/datum/chemical_reaction/R in used_in)
			if(R.result)
				add_can_be_used_in(get_reagent_type_by_id(R.result))
	// DESCRIPTION
	description =69.description
	taste = "Has 69V.taste_mult > 1 ? "strong" :69.taste_mult < 1 ? "weak" : ""69 taste of 69V.taste_description69."
	color = "69V.color69"
	if(V.addiction_threshold ||69.addiction_chance)
		addiction_chance =69.addiction_threshold ? "high" :69.addiction_chance <= 10 ? "Low" :69.addiction_chance <= 25 ? "Moderate" : "High"
		addiction_threshold =69.addiction_threshold

/datum/catalog_entry/reagent/catalog_ui_data(mob/user, ui_key = "main")
	var/list/data = ..()
	data69"reagent_state"69 = reagent_state
	data69"reagent_type"69 = reagent_type
	return data

/datum/catalog_entry/reagent/ui_data(mob/user, ui_key = "main")
	var/list/data = ..()

	// SPECIFICTS
	data69"name"69 = title
	data69"reagent_type"69 = reagent_type
	data69"reagent_state"69 = reagent_state
	data69"metabolism_blood"69 =69etabolism_blood
	data69"metabolism_stomach"69 =69etabolism_stomach
	data69"nsa"69 =69erve_system_accumulations
	data69"heating_decompose"69 = heating_decompose
	data69"heating_point"69 = heating_point
	data69"chilling_decompose"69 = chilling_decompose
	data69"chilling_point"69 = chilling_point
	data69"scannable"69 = scannable
	data69"overdose"69 = overdose
	data69"result_of_decomposition_in"69 = result_of_decomposition_in
	data69"can_be_used_in"69 = can_be_used_in

	data69"recipe_data"69 = recipe_data

	// DESCRIPTION
	data69"description"69 = description
	data69"taste"69 = taste
	data69"color"69 = color
	data69"addiction_chance"69 = addiction_chance
	data69"addiction_threshold"69 = addiction_threshold

	return data

/datum/catalog_entry/atom
	associated_template = "catalog_entry_atom.tmpl"

/datum/catalog_entry/atom/New(var/atom/V)
	if(!istype(V))
		error("wrong usage of 69src.type69")
		qdel(src)
		return
	..()
	title =69.name
	description =69.desc
	thing_nature = "Atom"
	image_path = getAtomCacheFilename(V)


/datum/catalog_entry/atom/ui_data(mob/user, ui_key = "main")
	var/list/data = ..()

	// SPECIFICTS
	data69"name"69 = title
	data69"entry_image_path"69 = image_path

	// DESCRIPTION
	data69"description"69 = description
	return data


/datum/catalog_entry/drink
	associated_template = "catalog_entry_drink.tmpl"
	var/temperature
	var/nutrition
	var/taste
	var/strength
	var/list/recipe_data
	var/list/taste_tag

/datum/catalog_entry/drink/search_value(var/value)
	if(..())
		return TRUE
	if(findtext(strength,69alue))
		return TRUE
	for(var/i in taste_tag)
		if(findtext(i,69alue))
			return TRUE

/datum/catalog_entry/drink/New(var/datum/reagent/V)
	if(!istype(V))
		error("wrong usage of 69src.type69")
		qdel(src)
		return
	..()
	title =69.name
	description =69.description

	taste = "Has 69V.taste_mult > 1 ? "strong" :69.taste_mult < 1 ? "weak" : ""69 taste of 69V.taste_description69."
	if(istype(V, /datum/reagent/drink))
		var/datum/reagent/drink/D =69
		if(D.adj_temp)
			temperature = D.adj_temp > 0 ? "Warm" : "Cold"
		if(D.nutrition)
			nutrition = D.nutrition > 1 ? "High" : "Low"
		thing_nature = "Drink"

	else if(istype(V, /datum/reagent/alcohol))
		var/datum/reagent/alcohol/E =69
		if(E.adj_temp)
			temperature = E.adj_temp > 0 ? "Warm" : "Cold"
		if(E.nutriment_factor)
			nutrition = E.nutriment_factor > 1 ? "High" : "Low"
		strength = E.strength <= 15 ? "Light" : E.strength <= 50 ? "Strong" : "Knocking out"
		thing_nature = "Alcohol drink"
		if(E.taste_tag.len)
			taste_tag = list()
			for(var/tastes in E.taste_tag)
				taste_tag += tastes
	var/list/recipes = GLOB.chemical_reactions_list_by_result69V.id69
	if(recipes)
		recipe_data = list()
		for(var/datum/chemical_reaction/R in recipes)
			recipe_data += list(R.ui_data())

/datum/catalog_entry/drink/ui_data(mob/user, ui_key = "main")
	var/list/data = ..()

	// SPECIFICTS
	data69"name"69 = title
	data69"entry_image_path"69 = image_path

	data69"temperature"69 = temperature
	data69"nutrition"69 =69utrition
	data69"taste"69 = taste
	data69"strength"69 = strength
	data69"recipe_data"69 = recipe_data
	data69"taste_tag"69 = taste_tag


	// DESCRIPTION
	data69"description"69 = description
	return data