PROCESSING_SUBSYSTEM_DEF(cwj)
	name = "Cooking with Jane"
	init_order = INIT_ORDER_CWJ
	flags = SS_NO_FIRE

/datum/controller/subsystem/processing/cwj/Initialize(timeofday)
	initialize_cooking_recipes()
	create_catalogs()
	..()

/datum/controller/subsystem/processing/cwj/proc/initialize_cooking_recipes()
	INIT_EMPTY_GLOBLIST(cwj_recipe_dictionary)
	INIT_EMPTY_GLOBLIST(cwj_recipe_list)
	INIT_EMPTY_GLOBLIST(cwj_optional_step_exclusion_dictionary)
	INIT_EMPTY_GLOBLIST(cwj_step_dictionary_ordered)
	INIT_EMPTY_GLOBLIST(cwj_step_dictionary)
	//All combination path datums, save for the default recipes we don't want.
	var/list/recipe_paths = typesof(/datum/cooking_with_jane/recipe)
	recipe_paths -= /datum/cooking_with_jane/recipe
	for (var/path in recipe_paths)
		var/datum/cooking_with_jane/recipe/example_recipe = new path()
		if(!GLOB.cwj_recipe_dictionary[example_recipe.cooking_container])
			GLOB.cwj_recipe_dictionary[example_recipe.cooking_container] = list()
		GLOB.cwj_recipe_dictionary[example_recipe.cooking_container]["[example_recipe.unique_id]"] = example_recipe

		GLOB.cwj_recipe_list += example_recipe

/datum/controller/subsystem/processing/cwj/proc/create_catalogs()
	// Reagents
	for(var/V in GLOB.chemical_reagents_list)
		var/datum/reagent/D = GLOB.chemical_reagents_list[V]
		if(D.appear_in_default_catalog)
			create_catalog_entry(D, CATALOG_REAGENTS)
			create_catalog_entry(D, CATALOG_ALL)
			if(istype(D, /datum/reagent/drink) || istype(D, /datum/reagent/alcohol))
				create_catalog_entry(D, CATALOG_DRINKS)
			else
				create_catalog_entry(D, CATALOG_CHEMISTRY)
	// second run to add decompose results
	for(var/V in GLOB.chemical_reagents_list)
		var/datum/reagent/D = GLOB.chemical_reagents_list[V]
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

	var/datum/catalog/C = GLOB.catalogs[CATALOG_REAGENTS]
	C.associated_template = "catalog_list_reagents.tmpl"
	sortTim(C.entry_list, /proc/cmp_catalog_entry_asc)
	C = GLOB.catalogs[CATALOG_CHEMISTRY]
	C.associated_template = "catalog_list_reagents.tmpl"
	sortTim(C.entry_list, /proc/cmp_catalog_entry_chem)
	C = GLOB.catalogs[CATALOG_DRINKS]
	C.associated_template = "catalog_list_drinks.tmpl"
	sortTim(C.entry_list, /proc/cmp_catalog_entry_asc)
	C = GLOB.catalogs[CATALOG_ALL]
	C.associated_template = "catalog_list_general.tmpl"
	sortTim(C.entry_list, /proc/cmp_catalog_entry_asc)
	createCookingCatalogs()
	return TRUE

/datum/controller/subsystem/processing/cwj/proc/create_catalog_entry(datum/thing, catalog_id)
	if(catalog_id && !GLOB.catalogs[catalog_id])
		GLOB.catalogs[catalog_id] = new /datum/catalog(catalog_id)
	if(!GLOB.all_catalog_entries_by_type[thing.type])
		if(istype(thing, /datum/reagent))
			if(istype(thing, /datum/reagent/drink) || (istype(thing, /datum/reagent/alcohol) && thing.type != /datum/reagent/alcohol))
				GLOB.all_catalog_entries_by_type[thing.type] = new /datum/catalog_entry/drink(thing)
			else
				GLOB.all_catalog_entries_by_type[thing.type] = new /datum/catalog_entry/reagent(thing)
		else if(isatom(thing))
			GLOB.all_catalog_entries_by_type[thing.type] = new /datum/catalog_entry/atom(thing)
		else
			var/list/element = GLOB.catalogs[catalog_id]
			if(!element.len)
				qdel(element)
				GLOB.catalogs.Remove(catalog_id)
				return FALSE
			error("Unsupported type passed to SScwj/proc/create_catalog_entry()")
			return FALSE
		if(catalog_id)
			var/datum/catalog/C = GLOB.catalogs[catalog_id]
			C.add_entry(GLOB.all_catalog_entries_by_type[thing.type])
	else if(catalog_id)
		var/datum/catalog/C = GLOB.catalogs[catalog_id]
		if(!C.entry_list.Find(GLOB.all_catalog_entries_by_type[thing.type]))
			C.add_entry(GLOB.all_catalog_entries_by_type[thing.type])
	return TRUE

/datum/controller/subsystem/processing/cwj/proc/get_catalog_entry(type)
	if(GLOB.all_catalog_entries_by_type[type])
		return GLOB.all_catalog_entries_by_type[type]
