/obj/item/weapon/gun/projectile/IH_sidearm
	name = "FS HG \"Paco\""
	desc = "A modern and reliable sidearm for the soldier in the field. Commonly issued as a sidearm to Ironhammer Operatives. Uses standard .35 Auto mags."
	icon = 'icons/obj/guns/projectile/IH_sidearm.dmi'
	icon_state = "IH_sidearm"
	item_state = "IH_sidearm"
	w_class = ITEM_SIZE_NORMAL
	caliber = "pistol"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = "/obj/item/ammo_casing/pistol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 14, MATERIAL_PLASTIC = 4)
	price_tag = 1500
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	silencer_type = /obj/item/weapon/silencer
	damage_multiplier = 1.1
	recoil = 0.5 //regular pistol recoil

/obj/item/weapon/gun/projectile/IH_sidearm/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/weapon/gun/projectile/IH_sidearm/Initialize()
	. = ..()
	update_icon()