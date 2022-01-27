/mob/living
	var/datum/nano_module/craft/CM

//this one is called when you need just a regular CM, without strick tab opened
/mob/living/verb/craft_menu()
	set name = "Craft69enu"
	set category = "IC"
	src.open_craft_menu()

//this is called when you use any proc and not69erb, like atack_self and want to give tab name to be opened
/mob/living/proc/open_craft_menu(category = null)
	if(!CM)
		CM = new(src)
	CM.set_category(category, src)
	CM.ui_interact(src)

/datum/nano_module/craft
	name = "Craft69enu"
	available_to_ai = FALSE

/datum/nano_module/craft/proc/get_category(mob/mob)
	var/ckey =69ob.ckey
	if(!(ckey in SScraft.current_category))
		SScraft.current_category69ckey69 = SScraft.cat_names69169
	return SScraft.current_category69ckey69

/datum/nano_module/craft/proc/set_category(category,69ob/mob)
	if(!category || !(category in SScraft.cat_names))
		return FALSE
	SScraft.current_category69mob.ckey69 = category
	set_item(null, usr)
	return TRUE

/datum/nano_module/craft/proc/get_item(mob/mob)
	return (mob.ckey in SScraft.current_item) ? SScraft.current_item69mob.ckey69 : null

/datum/nano_module/craft/proc/set_item(item_ref,69ob/mob)
	SScraft.current_item69mob.ckey69 = locate(item_ref)

/datum/nano_module/craft/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	if(!usr)
		return
	if(usr.incapacitated())
		return

	var/list/data = list()
	var/curr_category = get_category(usr)

	data69"is_admin"69 = check_rights(show_msg = FALSE)
	data69"categories"69 = SScraft.cat_names
	data69"cur_category"69 = curr_category
	var/datum/craft_recipe/CR = get_item(usr)
	data69"cur_item"69 = null

	if(CR)
		data69"cur_item"69 = list(
			"name" = CR.name,
			"icon" = getAtomCacheFilename(CR.result),
			"ref"  = "\ref69CR69",
			"desc" = CR.get_description(),
			"batch" = CR.flags & CRAFT_BATCH
		)
	var/list/items = list()
	for(var/datum/craft_recipe/recipe in SScraft.categories69curr_category69)
		if((recipe.avaliableToEveryone || (recipe.type in user.mind.knownCraftRecipes)))
			items += list(list(
				"name" = capitalize(recipe.name),
				"ref" = "\ref69recipe69"
			))
	data69"items"69 = items


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "craft.tmpl", "69src69", 800, 450, state = state)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/craft/Topic(href, href_list)
	if(..())
		return TRUE

	if(usr.incapacitated())
		return

	if(href_list69"build"69)
		var/datum/craft_recipe/CR = locate(href_list69"build"69)
		var/amount = href_list69"amount"69
		if(amount && (CR.flags & CRAFT_BATCH))
			if(amount == "input")
				amount = input("How69any \"69CR.name69\" you want to craft?", "Craft batch") as null|num
			else
				amount = text2num(amount)
			amount = CLAMP(amount, 0, 50)
			if(!amount)
				return
			CR.build_batch(usr, amount)
		else
			CR.try_build(usr)
	else if(href_list69"view_vars"69 && check_rights())
		usr.client.debug_variables(locate(href_list69"view_vars"69))
	else if(href_list69"category"69)
		set_category(href_list69"category"69, usr)
		SSnano.update_uis(src)
	else if(href_list69"item"69)
		set_item(href_list69"item"69, usr)
		SSnano.update_uis(src)
