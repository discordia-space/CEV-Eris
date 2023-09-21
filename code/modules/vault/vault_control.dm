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
