/obj/item/storage/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon_state = "briefcase"
	item_state = "briefcase"
	flags = CONDUCT
	melleDamages = list(
		ARMOR_BLUNT = list(
			DELEM(BRUTE,5)
		)
	)
	/// Big whacker
	wieldedMultiplier = 4
	WieldedattackDelay = 16
	throwforce = WEAPON_FORCE_NORMAL
	throw_speed = 1
	throw_range = 4
	volumeClass = ITEM_SIZE_BULKY
	max_volumeClass = ITEM_SIZE_NORMAL
	max_storage_space = 16
	matter = list(MATERIAL_BIOMATTER = 8, MATERIAL_PLASTIC = 4)
	price_tag = 90
