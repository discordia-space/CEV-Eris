/obj/item/weapon/gun/projectile/IH_sidearm
	name = "FS HG \"Paco\""
	desc = "A modern and reliable sidearm for the soldier in the field"
	icon_state = "IH_sidearm"
	item_state = "IH_sidearm"
	w_class = ITEM_SIZE_SMALL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/c9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mm
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 3)
	price_tag = 750
	silencer_type = /obj/item/weapon/silencer
	damage_multiplier = 1.1 //Slightly better than other pistols

/obj/item/weapon/gun/projectile/IH_sidearm/update_icon()
	var/iconstring = initial(icon_state)
	var/itemstring = initial(item_state)

	if (ammo_magazine)
		iconstring += "_mag"

		if(!ammo_magazine.stored_ammo.len)
			iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"

	icon_state = iconstring
	item_state = itemstring