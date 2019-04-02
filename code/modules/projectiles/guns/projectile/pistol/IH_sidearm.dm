/obj/item/weapon/gun/projectile/IH_sidearm
	name = "FS HG \"Paco\""
	desc = "A modern and reliable sidearm for the soldier in the field. Uses 10mm rounds."
	icon_state = "IH_sidearm"
	item_state = "IH_sidearm"
	w_class = ITEM_SIZE_NORMAL
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = "/obj/item/ammo_casing/c9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a10mm
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 14, MATERIAL_PLASTIC = 4)
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	silencer_type = /obj/item/weapon/silencer
	//damage_multiplier = 1.1

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