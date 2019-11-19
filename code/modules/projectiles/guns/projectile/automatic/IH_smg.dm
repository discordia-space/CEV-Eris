/obj/item/weapon/gun/projectile/automatic/IH_smg
	name = "FS SMG .35 Auto \"Straylight\""
	desc = "A compact and lightweight submachinegun that sprays small rounds rapidly. Sacrifices a fire selector to cut mass, so it requires a careful hand. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/IH_smg.dmi'
	icon_state = "IH_smg"
	item_state = "IH_smg"
	w_class = ITEM_SIZE_NORMAL
	caliber = "pistol"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/pistol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 16, MATERIAL_PLASTIC = 4)
	price_tag = 2500 //good smg with normal recoil and silencer possibility
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	damage_multiplier = 0.7 //will be op if it have more damage
	recoil = 0.8
	recoil_buildup = 0.1 //smg level
	silencer_type = /obj/item/weapon/silencer

	firemodes = list(
		FULL_AUTO_600)

/obj/item/weapon/gun/projectile/automatic/IH_smg/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/weapon/gun/projectile/automatic/IH_smg/Initialize()
	. = ..()
	update_icon()