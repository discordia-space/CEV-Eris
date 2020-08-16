/mob/living
	var/datum/nano_module/craft/CM

//this one is called when you need just a regular CM, without strick tab opened
/mob/living/verb/craft_menu()
	set name = "Craft Menu"
	set category = "IC"
	src.open_craft_menu()

//this is called when you use any proc and not verb, like atack_self and want to give tab name to be opened
/mob/living/proc/open_craft_menu(category = null)
	if(!CM)
		CM = new(src)
	CM.set_category(category, src)
	CM.ui_interact(src)

/datum/nano_module/craft
	name = "Craft menu"
	available_to_ai = FALSE

/datum/nano_module/craft/proc/get_category(mob/mob)
	var/ckey = mob.ckey
	if(!(ckey in SScraft.current_category))
		SScraft.current_category[ckey] = SScraft.cat_names[1]
	return SScraft.current_category[ckey]

/datum/nano_module/craft/proc/set_category(category, mob/mob)
	if(!category || !(category in SScraft.cat_names))
		return FALSE
	SScraft.current_category[mob.ckey] = category
	set_item(null, usr)
	return TRUE

/datum/nano_module/craft/proc/get_item(mob/mob)
	return (mob.ckey in SScraft.current_item) ? SScraft.current_item[mob.ckey] : null

/datum/nano_module/craft/proc/set_item(item_ref, mob/mob)
	SScraft.current_item[mob.ckey] = locate(item_ref)

/datum/nano_module/craft/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	if(!usr)
		return
	if(usr.incapacitated())
		return

	var/list/data = list()
	var/curr_category = get_category(usr)

	data["is_admin"] = check_rights(show_msg = FALSE)
	data["categories"] = SScraft.cat_names
	data["cur_category"] = curr_category
	var/datum/craft_recipe/CR = get_item(usr)
	data["cur_item"] = null

	if(CR)
		data["cur_item"] = list(
			"name" = CR.name,
			"icon" = getAtomCacheFilename(CR.result),
			"ref"  = "\ref[CR]",
			"desc" = CR.get_description(),
			"batch" = CR.flags & CRAFT_BATCH
		)
	var/list/items = list()
	for(var/datum/craft_recipe/recipe in SScraft.categories[curr_category])
		if((recipe.avaliableToEveryone || (recipe.type in user.mind.knownCraftRecipes)) && (recipe.variation_type == CRAFT_REFERENCE))
			items += list(list(
				"name" = capitalize(recipe.name_craft_menu ? recipe.name_craft_menu : recipe.name), // Display subtype name if the item is the reference of a subtype of items
				"ref" = "\ref[recipe]"
			))
	data["items"] = items


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "craft.tmpl", "[src]", 800, 450, state = state)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/craft/Topic(href, href_list)
	if(..())
		return TRUE

	if(usr.incapacitated())
		return

	if(href_list["build"])
		var/datum/craft_recipe/CR = locate(href_list["build"])
		var/amount = href_list["amount"]
		if(amount && (CR.flags & CRAFT_BATCH))
			if(amount == "input")
				amount = input("How many \"[CR.name]\" you want to craft?", "Craft batch") as null|num
			else
				amount = text2num(amount)
			amount = CLAMP(amount, 0, 50)
			if(!amount)
				return
			CR.build_batch(usr, amount)
		else
			CR.try_build(usr)
	else if(href_list["view_vars"] && check_rights())
		usr.client.debug_variables(locate(href_list["view_vars"]))
	else if(href_list["category"])
		set_category(href_list["category"], usr)
		SSnano.update_uis(src)
	else if(href_list["item"])
		var/list/subtypes_item = subtypesof(locate(href_list["item"]))
		if (subtypes_item.len > 1)  // Check if the crafted item has variations
			var/list/namelist = list()  // To store names of variations
			var/obj/item/CR  // Temporary item
			for (var/I in subtypes_item)  // Go through all variations of the reference item
				CR = new I (null)
				namelist += "[CR.name]"
			var/variation_choices = input(usr, "Please chose variation") as null|anything in namelist  // Ask the user which variation he wants to craft
			if(CanInteract(usr, GLOB.default_state))
				if (!variation_choices)
					return
				var/usr_choice = variation_choices
				for (var/I in subtypes_item)  // Retrieve the desired item by checking the name of all variations
					CR = new I (null)
					if (CR.name == usr_choice)
						set_item("\ref[CR]", usr)  // Update UI with desired variation
		else
			set_item(href_list["item"], usr)
		SSnano.update_uis(src)
