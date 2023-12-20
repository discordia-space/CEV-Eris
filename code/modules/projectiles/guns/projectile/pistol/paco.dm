/obj/item/gun/projectile/paco
	name = "FS HG .35 Auto \"Paco\""
	desc = "A modern and reliable sidearm for the soldier in the field. Commonly issued as a sidearm to Ironhammer Operatives. Uses standard .35 and high capacity magazines."
	icon = 'icons/obj/guns/projectile/paco.dmi'
	icon_state = "paco"
	item_state = "paco"
	volumeClass = ITEM_SIZE_NORMAL
	can_dual = TRUE
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/pistol
	caliber = CAL_PISTOL
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL|MAG_WELL_H_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 14, MATERIAL_PLASTIC = 4)
	price_tag = 1500
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	damage_multiplier = 1.3
	init_recoil = HANDGUN_RECOIL(0.7)
	gun_tags = list(GUN_SILENCABLE)

	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/paco = 1, /obj/item/part/gun/modular/grip/rubber = 1, /obj/item/part/gun/modular/mechanism/pistol = 1, /obj/item/part/gun/modular/barrel/pistol = 1)
	serial_type = "FS"

/obj/item/gun/projectile/paco/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"
		wielded_item_state = "_doble" + "_mag"
	else
		wielded_item_state = "_doble"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"
		wielded_item_state += "_s"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/paco/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/paco
	name = "Paco frame"
	desc = "A Paco pistol frame. A reliable companion in the field."
	icon_state = "frame_paco"
	resultvars = list(/obj/item/gun/projectile/paco)
	gripvars = list(/obj/item/part/gun/modular/grip/rubber)
	mechanismvar = /obj/item/part/gun/modular/mechanism/pistol
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol)
