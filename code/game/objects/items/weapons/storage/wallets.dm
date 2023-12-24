/obj/item/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	storage_slots = 7
	icon_state = "wallet"
	volumeClass = ITEM_SIZE_SMALL
	can_hold = list(
		/obj/item/spacecash,
		/obj/item/card,
		/obj/item/toy/card,
		/obj/item/clothing/mask/smokable/cigarette/,
		/obj/item/device/lighting/toggleable/flashlight/pen,
		/obj/item/seeds,
		/obj/item/reagent_containers/pill,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/flame/lighter,
		/obj/item/flame/match,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/dropper,
		/obj/item/tool/screwdriver,
		/obj/item/computer_hardware/hard_drive/portable,
		/obj/item/reagent_containers/syringe,
		/obj/item/stamp,
		/obj/item/oddity/common/coin,
		/obj/item/oddity/common/old_money,
		/obj/item/oddity/common/old_id,
		/obj/item/oddity/common/disk)
	slot_flags = SLOT_ID

	matter = list(MATERIAL_BIOMATTER = 4)
	var/obj/item/card/id/front_id


/obj/item/storage/wallet/remove_from_storage(obj/item/W, atom/new_location)
	. = ..(W, new_location)
	if(W == front_id)
		front_id = null
		name = initial(name)
		update_icon()

/obj/item/storage/wallet/handle_item_insertion(obj/item/W, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/card/id))
			front_id = W
			name = "[name] ([front_id])"
			update_icon()

/obj/item/storage/wallet/update_icon()

	if(front_id)
		switch(front_id.icon_state)
			if("id")
				icon_state = "walletid"
				return
			if(MATERIAL_SILVER)
				icon_state = "walletid_silver"
				return
			if(MATERIAL_GOLD)
				icon_state = "walletid_gold"
				return
			if("centcom")
				icon_state = "walletid_centcom"
				return
	icon_state = "wallet"


/obj/item/storage/wallet/GetIdCard()
	return front_id

/obj/item/storage/wallet/GetAccess()
	var/obj/item/I = GetIdCard()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/storage/wallet/random/populate_contents()
	var/to_add = pick(/obj/item/spacecash/bundle/c10,/obj/item/spacecash/bundle/c100,/obj/item/spacecash/bundle/c1000,/obj/item/spacecash/bundle/c20,/obj/item/spacecash/bundle/c200,/obj/item/spacecash/bundle/c50,/obj/item/spacecash/bundle/c500)
	new to_add(src)
	if(prob(50))
		to_add = pick(/obj/item/spacecash/bundle/c10,/obj/item/spacecash/bundle/c100,/obj/item/spacecash/bundle/c1000,/obj/item/spacecash/bundle/c20,/obj/item/spacecash/bundle/c200,/obj/item/spacecash/bundle/c50,/obj/item/spacecash/bundle/c500)
		new to_add(src)
	to_add = pick(/obj/item/coin/silver, /obj/item/coin/silver, /obj/item/coin/gold, /obj/item/coin/iron, /obj/item/coin/iron, /obj/item/coin/iron)
	new to_add(src)
	if(prob(20))
		new /obj/item/card/id/randomassistant(src)
