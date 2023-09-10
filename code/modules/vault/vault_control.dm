// developer only

/datum/player_vault/proc/get_random_perk_for_vault(ckey)
	if(!ckey)
		if(!player_ckey)
			return
		ckey = player_ckey
	var/datum/gear/vault_item/perk/perk = new(get_oddity_perk(), ckey)
	var/datum/player_vault/PV = SSpersistence.get_vault_account(ckey)
	PV.add_item(perk)

/datum/player_vault/proc/get_random_gun_for_vault(ckey)
	if(!ckey)
		if(!player_ckey)
			return
		ckey = player_ckey
	var/datum/gear/vault_item/VI = new(pick(subtypesof(/obj/item/gun/projectile)), ckey)
	var/datum/player_vault/PV = SSpersistence.get_vault_account(ckey)
	PV.add_item(VI, add_to_vault = TRUE)

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
	PV.add_item(VI, add_to_vault = TRUE)
