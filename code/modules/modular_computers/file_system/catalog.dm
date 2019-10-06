/*
	important notes
	catalogs are handled in /datum/nano_module, check there
	important procs are:
		browse_catalog_entry()
		browse_catalog()
		refresh_catalog_browsing()

	TODO: add access level that will show more info
*/
/datum
	var/catalog_info_level_one
	var/catalog_info_level_two
	var/catalog_info_level_three
	var/catalog_info_level_four
	var/catalog_info_level_ooc

/atom
	// should this atom have catalog entry
	// this is set to FALSE for not gameplay atoms like areas, landmarks etc
	var/contribute_to_catalog = TRUE
	// this will add atom to can_be_found reagent entry
	// this is set to FALSE for things like beakers and pills 
	var/contribute_to_reagent_catalog = TRUE
	// this will add atom to can_be_found storage item enry
	var/contribute_to_container_catalog = TRUE
	// will create icon asset that will be send to players
	var/create_icon_asset = TRUE

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

/datum/catalog/proc/has_entry(var/datum/catalog_entry/entry)
	if(entry_list.Find(entry))
		return TRUE

/datum/catalog/proc/add_entry(var/datum/catalog_entry/entry)
	entry_list.Add(entry)

/datum/catalog/proc/remove_entry(var/datum/catalog_entry/entry)
	entry_list.Remove(entry)

/datum/catalog/ui_data(mob/user, ui_key = "main", var/search_value)
	var/list/data = list()
	var/list/entries_data = list()
	for(var/datum/catalog_entry/E in entry_list)
		if(!search_value || E.search_value(search_value))
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
	var/list/can_be_found_in = list()

/datum/catalog_entry/New(var/datum/V)
	thing_type = V.type
	catalog_info_level_one = V.catalog_info_level_one
	catalog_info_level_two = V.catalog_info_level_two
	catalog_info_level_three = V.catalog_info_level_three
	catalog_info_level_four = V.catalog_info_level_four
	catalog_info_level_ooc = V.catalog_info_level_ooc
	
/datum/catalog_entry/proc/search_value(var/value)
	if(findtext(title, value))
		return TRUE
	if(findtext(thing_nature, value))
		return TRUE

/datum/catalog_entry/ui_data(mob/user, ui_key = "main")
	var/list/data = list()
	data["id"] = thing_type
	data["thing_nature"] = thing_nature
	
	data["catalog_info_level_one"] = catalog_info_level_one
	data["catalog_info_level_two"] = catalog_info_level_two
	data["catalog_info_level_three"] = catalog_info_level_three
	data["catalog_info_level_four"] = catalog_info_level_four
	data["catalog_info_level_ooc"] = catalog_info_level_ooc

	data["can_be_found_in"] = can_be_found_in.len ? can_be_found_in : null
	return data

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
	var/heating_point
	var/chilling_decompose
	var/chilling_point
	var/color
	var/scannable
	var/overdose
	var/addiction_chance
	var/list/recipe_data
	var/list/result_of_decomposition_in
	var/list/can_be_used_in

/datum/catalog_entry/reagent/search_value(var/value)
	if(..())
		return TRUE
	if(findtext(reagent_type, value))
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

/datum/catalog_entry/proc/add_to_can_be_found(var/atom/A)
	for(var/V in can_be_found_in)
		var/list/L = V
		if(is_associative(L) && L["type"] == A.type)
			return
	can_be_found_in.Add(list(list("type" = A.type)))

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
		var/list/dat = list()
		dat["types"] = list()
		for(var/id in V.heating_products)
			dat["types"] += get_reagent_type_by_id(id)
		heating_decompose = dat
		heating_point = V.heating_point

	if(V.chilling_products && V.chilling_point)
		var/list/dat = list()
		dat["types"] = list()
		for(var/id in V.chilling_products)
			dat["types"] += get_reagent_type_by_id(id)
		chilling_decompose = dat
		chilling_point = V.chilling_point
		
	scannable = V.scannable ? "Yes" : "No"
	overdose = V.overdose ? V.overdose : null
	var/list/recipes = GLOB.chemical_reactions_list_by_result[V.id]
	if(recipes)
		recipe_data = list()
		for(var/datum/chemical_reaction/R in recipes)
			recipe_data += list(R.ui_data())
	var/list/used_in = chemical_reactions_list[V.id]
	if(used_in)
		for(var/datum/chemical_reaction/R in used_in)
			if(R.result)
				add_can_be_used_in(get_reagent_type_by_id(R.result))
	// DESCRIPTION
	description = V.description
	taste = "Has [V.taste_mult > 1 ? "strong" : V.taste_mult < 1 ? "weak" : ""] taste of [V.taste_description]."
	color = "[V.color]"
	if(V.addiction_threshold || V.addiction_chance)
		addiction_chance = "Has [V.addiction_threshold ? "high" : V.addiction_chance <= 10 ? "low" : V.addiction_chance <= 25 ? "moderate" : "high"] addicition chance."

/datum/catalog_entry/reagent/catalog_ui_data(mob/user, ui_key = "main")
	var/list/data = ..()
	data["reagent_state"] = reagent_state
	data["reagent_type"] = reagent_type
	return data

/datum/catalog_entry/reagent/ui_data(mob/user, ui_key = "main")
	var/list/data = ..()

	// SPECIFICTS
	data["name"] = title
	data["reagent_type"] = reagent_type
	data["reagent_state"] = reagent_state
	data["metabolism_blood"] = metabolism_blood
	data["metabolism_stomach"] = metabolism_stomach
	data["nsa"] = nerve_system_accumulations
	data["heating_decompose"] = heating_decompose
	data["heating_point"] = heating_point
	data["chilling_decompose"] = chilling_decompose
	data["chilling_point"] = chilling_point
	data["scannable"] = scannable
	data["overdose"] = overdose
	data["result_of_decomposition_in"] = result_of_decomposition_in
	data["can_be_used_in"] = can_be_used_in

	data["recipe_data"] = recipe_data

	// DESCRIPTION
	data["description"] = description
	data["taste"] = taste
	data["color"] = color
	data["addiction_chance"] = addiction_chance 

	return data

/datum/catalog_entry/atom
	associated_template = "catalog_entry_atom.tmpl"

/datum/catalog_entry/atom/New(var/atom/V)
	if(!istype(V))
		error("wrong usage of [src.type]")
		qdel(src)
		return
	..()
	title = V.name
	description = V.desc
	thing_nature = "Atom"
	image_path = getAtomCacheFilename(V)
	

/datum/catalog_entry/atom/ui_data(mob/user, ui_key = "main")
	var/list/data = ..()

	// SPECIFICTS
	data["name"] = title
	data["entry_image_path"] = image_path

	// DESCRIPTION
	data["description"] = description
	data["catalog_info_level_one"] = catalog_info_level_one
	data["catalog_info_level_two"] = catalog_info_level_two
	data["catalog_info_level_three"] = catalog_info_level_three
	data["catalog_info_level_four"] = catalog_info_level_four
	data["catalog_info_level_ooc"] = catalog_info_level_ooc
	data["can_be_found_in"] = can_be_found_in.len ? can_be_found_in : null
	return data


/datum/catalog_entry/drink
	associated_template = "catalog_entry_drink.tmpl"
	var/temperature
	var/nutrition
	var/taste
	var/strength
	var/list/recipe_data

/datum/catalog_entry/drink/search_value(var/value)
	if(..())
		return TRUE
	if(findtext(strength, value))
		return TRUE

/datum/catalog_entry/drink/New(var/datum/reagent/V)
	if(!istype(V))
		error("wrong usage of [src.type]")
		qdel(src)
		return
	..()
	title = V.name
	description = V.description

	taste = "Has [V.taste_mult > 1 ? "strong" : V.taste_mult < 1 ? "weak" : ""] taste of [V.taste_description]."
	if(istype(V, /datum/reagent/drink))
		var/datum/reagent/drink/D = V
		if(D.adj_temp)
			temperature = D.adj_temp > 0 ? "Warm" : "Cold"
		if(D.nutrition)
			nutrition = D.nutrition > 1 ? "High" : "Low"
		thing_nature = "Drink"
		
	else if(istype(V, /datum/reagent/ethanol))
		var/datum/reagent/ethanol/E = V
		if(E.adj_temp)
			temperature = E.adj_temp > 0 ? "Warm" : "Cold"
		if(E.nutriment_factor)
			nutrition = E.nutriment_factor > 1 ? "High" : "Low"
		strength = E.strength <= 15 ? "Light" : E.strength <= 50 ? "Strong" : "Knocking out"
		thing_nature = "Alchohol drink"
	
	var/list/recipes = GLOB.chemical_reactions_list_by_result[V.id]
	if(recipes)
		recipe_data = list()
		for(var/datum/chemical_reaction/R in recipes)
			recipe_data += list(R.ui_data())

/datum/catalog_entry/drink/ui_data(mob/user, ui_key = "main")
	var/list/data = ..()

	// SPECIFICTS
	data["name"] = title
	data["entry_image_path"] = image_path

	data["temperature"] = temperature
	data["nutrition"] = nutrition
	data["taste"] = taste
	data["strength"] = strength
	data["recipe_data"] = recipe_data


	// DESCRIPTION
	data["description"] = description
	data["catalog_info_level_one"] = catalog_info_level_one
	data["catalog_info_level_two"] = catalog_info_level_two
	data["catalog_info_level_three"] = catalog_info_level_three
	data["catalog_info_level_four"] = catalog_info_level_four
	data["catalog_info_level_ooc"] = catalog_info_level_ooc
	data["can_be_found_in"] = can_be_found_in.len ? can_be_found_in : null
	return data