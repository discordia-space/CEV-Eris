/datum/gear/vault_item
	display_name = "Item"
	sort_category = "Vault Items"
	var/datum/weakref/player_vault
	var/expired = FALSE // whenever you want to hide item from seeing anyone
	var/ckey
	var/display_anyone = FALSE
	var/can_be_saved = TRUE
	var/transaction_id
	price = 5

/datum/gear/vault_item/New(item_type, item_ckey)
	. = ..()
	if(item_ckey)
		ckey = item_ckey
	if(!item_type || (!ispath(item_type) && !text2path(item_type)))
		return
	path = ispath(item_type) ? item_type : text2path(item_type)
	var/atom/item = path
	display_name = initial(item.name)
	description = initial(item.desc)

/datum/gear/vault_item/spawn_item(location, metadata)
	// remove from player storage
	var/datum/player_vault/PV = player_vault?.resolve()
	if(!isnull(PV))
		PV.remove_item(src)
	expired = TRUE
	return ..()

/datum/gear/vault_item/is_allowed_to_display(mob/user)
	if(expired)
		return FALSE
	if(display_anyone)
		return TRUE
	return user.ckey == ckey

/datum/gear/vault_item/proc/on_buy_action(datum/player_vault/player_vault)
	return

/datum/gear/vault_item/proc/get_save_info()
	return list("[type]","[path]",ckey)

/datum/gear/vault_item/perk
	display_name = "Perk"
	description = "Gives some perk on spawn."
	price = 10
	slot = slot_w_uniform // hack to make proc spawn_on_mob work

/datum/gear/vault_item/perk/spawn_item(location, metadata)
	return

/datum/gear/vault_item/perk/spawn_on_mob(mob/living/carbon/human/H, metadata)
	if(!H || !path)
		return
	H.stats.addPerk(path)

/datum/gear/vault_item/perk/spawn_in_storage_or_drop(var/mob/living/carbon/human/H, var/metadata)
	return

/datum/gear/vault_item/perk/random
	display_name = "Random Perk"
	description = "Gives random perk on spawn."
	display_anyone = TRUE
	can_be_saved = FALSE
	price = 10

/datum/gear/vault_item/perk/random/on_buy_action(datum/player_vault/player_vault)
	player_vault.get_random_perk_for_vault()
	expired = TRUE
	return
