GLOBAL_LIST_INIT(vault_reward_list, list(
	// probably will be populated manualy/semi-manualy
))

// developer only

/datum/player_vault/proc/get_random_perk_for_vault(ckey)
	if(!ckey)
		if(!player_ckey)
			return
		ckey = player_ckey
	var/datum/gear/vault_item/perk/perk = new(get_oddity_perk(), ckey)
	perk.ckey = ckey
	var/datum/player_vault/PV = SSpersistence.get_vault_account(ckey)
	var/transaction_id = null
	if(config.donation_track && establish_don_db_connection())
		var/comment = "Vault store creation: [perk.display_name]"
		transaction_id = SSdonations.create_transaction(directory[ckey], 0, VAULT_TRANSACTION_TYPE_PURCHASE, comment)
	PV.add_item(perk, transaction_id=transaction_id)

/datum/player_vault/proc/get_random_gun_for_vault(ckey)
	if(!ckey)
		if(!player_ckey)
			return
		ckey = player_ckey
	var/datum/gear/vault_item/VI = new(pick(subtypesof(/obj/item/gun/projectile)), ckey)
	var/datum/player_vault/PV = SSpersistence.get_vault_account(ckey)
	VI.ckey = ckey
	var/transaction_id = null
	if(config.donation_track && establish_don_db_connection())
		var/comment = "Vault store creation: [VI.display_name]"
		transaction_id = SSdonations.create_transaction(directory[ckey], 0, VAULT_TRANSACTION_TYPE_PURCHASE, comment)
	PV.add_item(VI, transaction_id=transaction_id)

/datum/player_vault/proc/get_specific_item_for_vault(ckey, text)
	if(!ckey)
		if(!player_ckey)
			return
		ckey = player_ckey
	if(!text)
		return
	var/path = text2path(text)
	if(!path)
		return
	var/datum/player_vault/PV = SSpersistence.get_vault_account(ckey)
	var/datum/gear/vault_item/VI = new(path, ckey)
	VI.ckey = ckey
	var/transaction_id = null
	if(config.donation_track && establish_don_db_connection())
		var/comment = "Vault store creation: [VI.display_name]"
		transaction_id = SSdonations.create_transaction(directory[ckey], 0, VAULT_TRANSACTION_TYPE_PURCHASE, comment)
	PV.add_item(VI, transaction_id=transaction_id)

/datum/player_vault/proc/save_items()
	// basically just stores items in BD, if it on, other vise it stored by Persistence system.
	if(!config.donation_track)
		return
	// first of all, add items from buy list to "have" list
	for(var/type in selected_rewards)
		var/list/data = selected_rewards[type][1]
		selected_rewards.Remove(type)
		var/path = data[VAULT_REWARD_TYPE]
		if(!ispath(path))
			continue
		var/datum/gear/vault_item/VI = new(path, player_ckey)
		var/comment = "Vault store purchase: [data[VAULT_REWARD_NAME]]"
		var/trans = SSdonations.create_transaction(directory[player_ckey], -data[VAULT_REWARD_COST], VAULT_TRANSACTION_TYPE_PURCHASE, comment)
		SSdonations.give_item(player_ckey, json_encode(VI.get_save_info()), transaction_id=trans)

// add round end points TODO: get points by actions in-game
/datum/player_vault/proc/add_round_end_points()
	var/mob/my_mob
	for(var/mob/M in GLOB.mob_list)
		if(M.ckey == player_ckey)
			my_mob = M
			break
	if(!my_mob)
		return
	var/points = round(suppress_function(my_mob.get_total_score()), 1)
	if(points <= 0)
		return
	iriska_balance += points
	if(!config.donation_track)
		return
	SSdonations.create_transaction(directory[player_ckey], points, VAULT_TRANSACTION_TYPE_ROUND_END, "Round end points gain")

/datum/player_vault/proc/suppress_function(score)
	// function that sets value score inside boundaries.
	// I find out function x^0.(26) makes some good boundaries.
	return ROOT(26, score)

/hook/roundend/proc/claim_players_rewards()
	if(!length(clients))
		return
	for(var/client/C in clients)
		var/datum/player_vault/PV = SSpersistence.get_vault_account(C.ckey)
		if(!PV)
			continue
		PV.add_round_end_points()
		PV.get_reward_interface()

// round end interface

/datum/player_vault/ui_state(mob/user)
	return GLOB.always_state

/datum/player_vault/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VaultReward")
		ui.set_autoupdate(TRUE)
		ui.open()

/datum/player_vault/ui_data(mob/user)
	var/list/data = list()
	data["iriska_balance"] = iriska_balance
	data["ckey"] = player_ckey
	data["items"] = list()
	if(!length(rewards))
		for(var/type in GLOB.vault_reward_list)
			data["items"] += list(GLOB.vault_reward_list[type])
		rewards = data["items"]
	else
		data["items"] = rewards
	data["equipped_items"] = list()
	for(var/type in selected_rewards)
		data["equipped_items"] += selected_rewards[type]
	return data

/datum/player_vault/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	if(!params["type"])
		return TRUE

	var/is_selecting = action == "select_type" ? 1 : -1
	var/cost = GLOB.vault_reward_list[params["type"]][VAULT_REWARD_COST]
	if(iriska_balance - cost*is_selecting < 0)
		return TRUE

	switch(action)
		if("select_type")
			selected_rewards[params["type"]] = list(GLOB.vault_reward_list[params["type"]])
			iriska_balance -= cost
		if("deselect_type")
			selected_rewards.Remove(params["type"])
			iriska_balance += cost
	return TRUE

/datum/player_vault/proc/get_reward_interface()
	var/mob/my_mob
	for(var/mob/M in GLOB.mob_list)
		if(M.ckey == player_ckey)
			my_mob = M
			break
	if(!my_mob)
		return
	ui_interact(my_mob)

// reward gen TODO: move to separate file

/proc/extract_item_data_for_vault(item_type, icon, iriski_cost)
	var/list/data
	var/obj/item/I = item_type
	var/item_icon
	if(icon)
		item_icon = icon2base64html(icon)
	else
		item_icon = icon2base64html(item_type)
	if(!iriski_cost)
		return
	data = list(
			VAULT_REWARD_COST = iriski_cost,
			VAULT_REWARD_IMAGE = item_icon,
			VAULT_REWARD_NAME = initial(I.name),
			VAULT_REWARD_DESC = initial(I.desc),
			VAULT_REWARD_TYPE = item_type
		)
	return data

/hook/startup/proc/populate_vault_reward_list()
	if(!fexists("config/vault_prices.json"))
		return
	var/list/config_json = json_decode(file2text("config/vault_prices.json"))
	for(var/list/data in config_json["vault"])
		var/type = text2path(data?["item_type"])
		var/iriski_cost = data?["cost"]
		var/subtypes_gen = data?["generate_subtypes"]
		var/list/exclude_list = data?["exclude_subtypes"]
		var/share_icon = data?["subtypes_share_parent_icon"]
		var/share_cost = data?["subtypes_share_cost"]
		var/icon = data?["icon"]
		var/icon_state = data?["icon_state"]
		var/exclude_base = data?["exclude_base"]
		if(isnull(type))
			log_debug("Vault: can't load some item for vault rewarding system. Item path: ([data?["item_type"]])")
			continue
		var/icon_override = FALSE
		if(fexists(icon) && icon_state)
			icon = file(icon) // God will guide us through the hell of runtime. Amen.
			if(icon_state in icon_states(icon))
				icon_override = TRUE
		var/obj/item/I = type
		if(initial(I.iriska_cost) == 0 && !iriski_cost)
			continue
		iriski_cost = iriski_cost ? iriski_cost : I.iriska_cost
		var/item_icon
		if(icon_override)
			item_icon = icon2base64html(icon(icon, icon_state))
		if(!exclude_base)
			GLOB.vault_reward_list["[type]"] = extract_item_data_for_vault(type, item_icon, iriski_cost)
		if(!subtypes_gen)
			continue
		if(!exclude_list)
			exclude_list = list()
		for(var/path in subtypesof(type))
			var/contme = FALSE
			for(var/exclude_path in exclude_list)
				exclude_path = text2path(exclude_path)
				if(ispath(path, exclude_path))
					contme = TRUE
					break
			if(contme)
				continue
			var/obj/item/sub_I = path
			var/sub_cost = share_cost ? iriski_cost : initial(sub_I.iriska_cost)
			if(sub_cost == 0)
				continue
			var/sub_image_icon
			if(share_icon)
				sub_image_icon = item_icon
			GLOB.vault_reward_list["[path]"] = extract_item_data_for_vault(path, sub_image_icon, sub_cost)
