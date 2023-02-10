/datum/computer_file/program/cook_catalog
	filename = "cook_catalog"
	filedesc = "VIKA"
	extended_desc = "Lonestar (and Soteria) Presents: Victoria's Incredible Kitchen Assistant - an AI-generated electronic catalog for cooking."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 2
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/cook_catalog
	usage_flags = PROGRAM_ALL

/datum/nano_module/cook_catalog
	name = "Lonestar (and Soteria) Presents: Victoria's Incredible Kitchen Assistant"

/datum/nano_module/cook_catalog/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = nano_ui_data(user)

	var/datum/asset/cooking_icons = get_asset_datum(/datum/asset/simple/cooking_icons)
	if (cooking_icons.send(user.client))
		user.client.browse_queue_flush() // stall loading nanoui until assets actualy gets sent

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "cooking_catalog.tmpl", name, 640, 700, state = state)
		ui.set_initial_data(data)
		refresh_catalog_browsing(user, ui)
		ui.auto_update_layout = 1
		ui.open()

/datum/nano_module/cook_catalog/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["greet"])
		browse_catalog(GLOB.catalogs[CATALOG_COOKING], usr)
		return 0
//===================================================================================
/proc/createCookingCatalogs()
	for(var/datum/cooking_with_jane/recipe/our_recipe in GLOB.cwj_recipe_list)
		if(our_recipe.appear_in_default_catalog)
			create_cooking_catalog_entry(our_recipe)

	//Do a sort
	var/datum/catalog/C = GLOB.catalogs[CATALOG_COOKING]
	C.associated_template = "catalog_list_cooking.tmpl"
	C.entry_list = sortTim(C.entry_list, /proc/cmp_catalog_entry_cook)

//Because I want it to be EXTREMELY ORGANIZED.
/proc/cmp_catalog_entry_cook(datum/catalog_entry/cooking/a, datum/catalog_entry/cooking/b)
	//name - name
	if(a.title != b.title)
		return cmp_catalog_entry_asc(a, b)

	//if product name is same, sort by product count
	else if(a.recipe.product_name && b.recipe.product_name && a.recipe.product_name == b.recipe.product_name && a.recipe.product_count != b.recipe.product_count)
		return cmp_numeric_asc(b.recipe.product_count, a.recipe.product_count)

	//product name - product name
	else if(a.recipe.product_name && b.recipe.product_name && a.recipe.product_name != b.recipe.product_name)
		return sorttext(b.recipe.product_name, a.recipe.product_name)

	//if reagent name is same, sort by reagent_amount
	else if(a.recipe.reagent_name && b.recipe.reagent_name && a.recipe.reagent_name == b.recipe.reagent_name && a.recipe.reagent_amount != b.recipe.reagent_amount)
		return cmp_numeric_asc(b.recipe.reagent_amount, a.recipe.reagent_amount)

	//reagent name - reagent name
	else if(a.recipe.reagent_name && b.recipe.reagent_name && a.recipe.reagent_name != b.recipe.reagent_name)
		return sorttext(b.recipe.reagent_name, a.recipe.reagent_name)

	//product name - reagent name
	else if(a.recipe.product_name && b.recipe.reagent_name && a.recipe.product_name != b.recipe.reagent_name)
		return sorttext(b.recipe.reagent_name, a.recipe.product_name)

	//reagent name - product name
	else if(a.recipe.reagent_name && b.recipe.product_name && a.recipe.reagent_name != b.recipe.product_name)
		return sorttext(b.recipe.product_name, a.recipe.reagent_name)

	return cmp_catalog_entry_asc(a, b)

/proc/create_cooking_catalog_entry(var/datum/cooking_with_jane/recipe/our_recipe)
	var/catalog_id = CATALOG_COOKING
	if(!GLOB.catalogs[catalog_id])
		GLOB.catalogs[catalog_id] = new /datum/catalog(catalog_id)

	if(!GLOB.all_catalog_entries_by_type[our_recipe.type])
		GLOB.all_catalog_entries_by_type[our_recipe.type] = new /datum/catalog_entry/cooking(our_recipe)
	else
		CRASH("/proc/create_cooking_catalog_entry() - Duplicate type passed- [our_recipe.type]")

	var/datum/catalog/C = GLOB.catalogs[catalog_id]
	C.add_entry(GLOB.all_catalog_entries_by_type[our_recipe.type])

/datum/catalog_entry/cooking
	associated_template = "catalog_entry_cooking.tmpl"
	var/datum/cooking_with_jane/recipe/recipe

/datum/catalog_entry/cooking/New(var/datum/cooking_with_jane/recipe/our_recipe)
	thing_type = our_recipe.type
	title = our_recipe.name
	recipe = our_recipe

/datum/catalog_entry/cooking/catalog_ui_data(mob/user, ui_key = "main")
	var/list/data = ..()
	data["name"] = recipe.name
	data["id"] = recipe.type
	data["icon"] = SSassets.transport.get_asset_url(sanitizeFileName(recipe.icon_image_file))
	data["product_is_reagent"] = 0
	if(recipe.product_name)
		data["product_name"] = recipe.product_name
		data["product_count"] = recipe.product_count
		if(recipe.reagent_name)
			data["byproduct_name"] = recipe.reagent_name
			data["byproduct_count"] = recipe.reagent_amount
		else
			data["byproduct_name"] = "None"
			data["byproduct_count"] = 0
	else if(recipe.reagent_name)
		data["product_name"] = recipe.reagent_name
		data["product_count"] = recipe.reagent_amount
		data["byproduct_name"] = "None"
		data["byproduct_count"] = 0
		data["product_is_reagent"] = 1
	else
		data["product_name"] = "ERROR"
		data["product_count"] = 0
		data["byproduct_name"] = "None"
		data["byproduct_count"] = 0
	return data


/datum/catalog_entry/cooking/nano_ui_data(mob/user, ui_key = "main")
	var/list/data = ..()
	data["name"] = recipe.name
	data["id"] = recipe.type

	var/url = SSassets.transport.get_asset_url(sanitizeFileName(recipe.icon_image_file))
	#ifdef CWJ_DEBUG
	log_debug("Retrieved [url] for [recipe.icon_image_file]")
	#endif

	data["icon"] = url
	data["product_is_reagent"] = 0
	if(recipe.product_name)
		data["product_name"] = recipe.product_name
		data["product_count"] = recipe.product_count
		if(recipe.reagent_name)
			data["byproduct_name"] = recipe.reagent_name
			data["byproduct_count"] = recipe.reagent_amount
		else
			data["byproduct_name"] = "None"
			data["byproduct_count"] = 0
	else if(recipe.reagent_name)
		data["product_name"] = recipe.reagent_name
		data["product_count"] = recipe.reagent_amount
		data["byproduct_name"] = "None"
		data["byproduct_count"] = 0
		data["product_is_reagent"] = 1
	else
		data["product_name"] = "ERROR"
		data["product_count"] = 0
		data["byproduct_name"] = "None"
		data["byproduct_count"] = 0

	data["description"] = recipe.description
	data["recipe_guide"] = recipe.recipe_guide

	switch(recipe.cooking_container)
		if(PLATE)
			data["create_in"] = "Made with a debug-only serving plate."
		if(CUTTING_BOARD)
			data["create_in"] = "Made on a cutting board."
		if(PAN)
			data["create_in"] = "Made with a pan or skillet."
		if(POT)
			data["create_in"] = "Made in a cooking pot."
		if(BOWL)
			data["create_in"] = "Made in a prep bowl."
		if(DF_BASKET)
			data["create_in"] = "Made in a deep frying basket."
		if(DF_BASKET)
			data["create_in"] = "Made in an air frying basket."
		if(OVEN)
			data["create_in"] = "Made with an oven dish."
		if(GRILL)
			data["create_in"] = "Made on a grill."
		else
			data["create_in"] = "Made with a ~//SEGMENTATION FAULT//~ 00110001"

	return data

//===========================================================
/datum/asset/simple/cooking_icons
	keep_local_name = FALSE

/datum/asset/simple/cooking_icons/register()
	for(var/datum/cooking_with_jane/recipe/our_recipe in GLOB.cwj_recipe_list)
		var/icon/I = null
		var/filename = null
		if(our_recipe.product_type)
			filename = sanitizeFileName("[our_recipe.product_type].png")
			I = getFlatTypeIcon(our_recipe.product_type)
		else if(our_recipe.reagent_id)
			var/obj/item/reagent_containers/food/snacks/dollop/test_dollop = new(null, our_recipe.reagent_id, 1)

			filename = sanitizeFileName("[test_dollop.type][test_dollop.color].png")
			I = getFlatIcon(test_dollop)
			//I.Blend(test_dollop.color) --might not be needed
		if(I)
			assets[filename] = I
			our_recipe.icon_image_file = filename
			#ifdef CWJ_DEBUG
			log_debug("Created cooking icon under file name [filename]")
			#endif
	..()


