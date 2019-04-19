/obj/item/weapon/gun/projectile/IH_sidearm
	name = "FS HG \"Paco\""
	desc = "A modern and reliable sidearm for the soldier in the field. Commonly issued as a sidearm to Ironhammer Operatives. Uses 10mm rounds."
	icon_state = "IH_sidearm"
	item_state = "IH_sidearm"
	w_class = ITEM_SIZE_NORMAL
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = "/obj/item/ammo_casing/a10mm"
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	magazine_type = /obj/item/ammo_magazine/a10mm
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 14, MATERIAL_PLASTIC = 4)
	price_tag = 1500
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	silencer_type = /obj/item/weapon/silencer
	recoil = 0.5 //regular pistol recoil

/obj/item/weapon/gun/projectile/IH_sidearm/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = initial(item_state)

	if (ammo_magazine)
		iconstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"

	icon_state = iconstring
	item_state = itemstring

/obj/item/weapon/gun/projectile/IH_sidearm/Initialize()
	. = ..()
	update_icon()