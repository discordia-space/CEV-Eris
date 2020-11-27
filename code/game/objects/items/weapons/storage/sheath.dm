/obj/item/weapon/storage/sheath
	name = "sheath"
	desc = "Made to store sword."
	icon = 'icons/obj/sheath.dmi'
	icon_state = "sheath_0"
	item_state = "sheath_0"
	slot_flags = SLOT_BELT
	price_tag = 50
	matter = list(MATERIAL_BIOMATTER = 5)
	spawn_frequency = 0
	storage_slots = 1
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_BULKY

	can_hold = list(
		/obj/item/weapon/tool/sword/nt,
		/obj/item/weapon/tool/sword/nt_sword
		)
	cant_hold = list(
		/obj/item/weapon/tool/knife/dagger/nt
		)
/obj/item/weapon/storage/sheath/attack_hand(mob/living/carbon/human/user)
	if(contents.len && (src in user))
		var/obj/item/I = contents[contents.len]
		if(istype(I))
			hide_from(usr)
			var/turf/T = get_turf(user)
			remove_from_storage(I, T)
			usr.put_in_hands(I)
			add_fingerprint(user)
	else
		..()

/obj/item/weapon/storage/sheath/update_icon()
	var/icon_to_set
	for(var/obj/item/weapon/tool/sword/SW in contents)
		icon_to_set = SW.icon_state
	icon_state = "sheath_[contents.len ? icon_to_set :"0"]"
	item_state = "sheath_[contents.len ? icon_to_set :"0"]"
	..()
