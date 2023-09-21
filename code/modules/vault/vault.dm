/datum/player_vault
	var/iriska_balance = 0
	var/player_ckey
	var/donator = FALSE
	var/patreon_tier = VAULT_PATRON_0
	// picked up when generating loadout
	// list of item types and thier data (job, fate, etc)
	// It's active list of items (posted in loadout)
	var/list/iriska_items = list()
	// duplicates items of above, on delete from above take one from it
	var/list/iriska_duplicates = list()
	var/static/list/patreon_modifier = list(
		VAULT_PATRON_0 = 1,
		VAULT_PATRON_1 = 1.25,
		VAULT_PATRON_2 = 1.5,
		VAULT_PATRON_3 = 1.75
	)

/datum/player_vault/New(ckey)
	. = ..()
	player_ckey = ckey

/datum/player_vault/proc/load_from_list(list/data, p_ckey)
	if(isnull(data) || isnull(p_ckey))
		return

	player_ckey = p_ckey
	patreon_tier = data[VAULT_PATRON] ? data[VAULT_PATRON] : VAULT_PATRON_0
	iriska_balance = data[VAULT_BALANCE] ? data[VAULT_BALANCE] : 0
	iriska_items = data[VAULT_ITEMS] ? data[VAULT_ITEMS] : list()
	iriska_duplicates = data[VAULT_ITEMS_DUBS] ? data[VAULT_ITEMS_DUBS] : list()
	
	for(var/list/item_data in iriska_items)
		create_item(item_data)

/datum/player_vault/proc/has_item(datum/gear/vault_item/item)
	return !isnull(return_original_item_data(item))

/datum/player_vault/proc/return_original_item_data(datum/gear/vault_item/item)
	var/list/data = item.get_save_info()
	for(var/list/item_data in iriska_items)
		if(!length(item_data))
			continue
		var/contme = FALSE
		for(var/item_value in item_data)
			if(!(item_value in data))
				contme = TRUE
				break
		if(contme)
			continue
		return item_data
	
	return null

/datum/player_vault/proc/get_patron_modifier()
	return patreon_modifier[patreon_tier]

/datum/player_vault/proc/recursive_add_dubs(datum/gear/vault_item/item, list/data)
	if(!item || !length(data))
		return
	var/list/original = return_original_item_data(item)
	while(iriska_duplicates[original])
		original = iriska_duplicates[original]
	iriska_duplicates[original] = data

/datum/player_vault/proc/add_item(datum/gear/vault_item/item, add_to_regisrty = TRUE, add_to_vault = TRUE, transaction_id = null)
	ASSERT(istype(item))

	item.ckey = player_ckey
	item.player_vault = WEAKREF(src)

	if(add_to_vault && item.can_be_saved)
		var/list/info = list()
		info.Add(item.get_save_info())
		if(has_item(item))
			recursive_add_dubs(item, info)
		else
			iriska_items.Add(list(info))
		// add item to DB
		if(transaction_id && config.donation_track)
			return SSdonations.give_item(player_ckey, json_encode(info), transaction_id)

	if(add_to_regisrty)
		var/use_name = item.display_name
		var/use_category = item.sort_category

		if(!loadout_categories[use_category])
			loadout_categories[use_category] = new /datum/loadout_category(use_category)
		var/datum/loadout_category/LC = loadout_categories[use_category]
		gear_datums[use_name] = item
		LC.gear[use_name] = gear_datums[use_name]
	return TRUE

/datum/player_vault/proc/create_item(list/item_data, add_to_vault = FALSE)
	if(!length(item_data))
		return
	var/path = text2path(item_data[1])
	var/datum/gear/vault_item/item = new path(arglist(item_data.Copy(2)))
	add_item(item, TRUE, add_to_vault)

/datum/player_vault/proc/remove_item(datum/gear/vault_item/item)
	if(!istype(item))
		return
	var/list/data = item.get_save_info()
	for(var/list/item_data in iriska_items)
		if(!length(item_data))
			continue
		var/contme = FALSE
		for(var/item_value in item_data)
			if(!(item_value in data))
				contme = TRUE
				break
		if(contme)
			continue
		iriska_items.Remove(list(item_data))
		if(iriska_duplicates[item_data])
			iriska_items.Add(list(iriska_duplicates[item_data]))
			iriska_duplicates.Remove(list(item_data))
		else
			var/datum/preferences/pref = SScharacter_setup.preferences_datums[player_ckey]
			if(!pref || !(item.display_name in pref.gear_list[pref.gear_slot]))
				return
			pref.gear_list[pref.gear_slot] -= item.display_name
			item.ckey = null
			item.expired = TRUE
			qdel(item)

		return

/datum/player_vault/proc/save_to_list()
	var/list/data = list()
	data[VAULT_BALANCE] = iriska_balance
	data[VAULT_ITEMS] = iriska_items
	data[VAULT_PATRON] = patreon_tier
	data[VAULT_ITEMS_DUBS] = iriska_duplicates
	return data
