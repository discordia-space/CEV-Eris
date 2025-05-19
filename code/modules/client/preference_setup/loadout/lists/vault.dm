/datum/gear/vault_item
	display_name = "Item"
	sort_category = "Vault Items"
	var/datum/weakref/player_vault
	var/expired = FALSE // whenever you want to hide item from seeing anyone
	var/ckey
	var/display_anyone = FALSE
	var/can_be_saved = TRUE
	var/transaction_id

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

/datum/gear/vault_item/on_spawn_on_real_mob()
	var/datum/player_vault/PV = player_vault?.resolve()
	if(!isnull(PV))
		PV.remove_item(src)
	expired = TRUE

/datum/gear/vault_item/is_allowed_to_display(mob/user)
	if(expired)
		return FALSE
	if(display_anyone)
		return TRUE
	return user.ckey == ckey

/datum/gear/vault_item/proc/get_save_info()
	return list("[type]","[path]",ckey)

/datum/gear/vault_item/perk
	display_name = "Perk"
	description = "Gives some perk on spawn."
	slot = slot_w_uniform // hack to make proc spawn_on_mob work

/datum/gear/vault_item/perk/spawn_item(location, metadata)
	return

/datum/gear/vault_item/perk/spawn_on_mob(mob/living/carbon/human/H, metadata)
	if(!H || !path)
		return
	H.stats.addPerk(path)

/datum/gear/vault_item/perk/spawn_in_storage_or_drop(var/mob/living/carbon/human/H, var/metadata)
	return
