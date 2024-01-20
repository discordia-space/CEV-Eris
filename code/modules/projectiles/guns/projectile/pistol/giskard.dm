/obj/item/gun/projectile/giskard
	name = "FS HG .35 Auto \"Giskard\""
	desc = "A popular \"Frozen Star\" brand pocket pistol chambered for the ubiquitous .35 auto round. Uses standard capacity magazines."
	icon = 'icons/obj/guns/projectile/giskard.dmi'
	icon_state = "giskard"
	item_state = "pistol"
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	gun_tags = list(GUN_SILENCABLE)
	volumeClass = ITEM_SIZE_SMALL
	can_dual = TRUE
	fire_delay = 0.6
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)
	caliber = CAL_PISTOL
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_WOOD = 4)
	price_tag = 400
	damage_multiplier = 1.2
	init_recoil = HANDGUN_RECOIL(1)
	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/giskard = 1, /obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/pistol = 1, /obj/item/part/gun/modular/barrel/pistol = 1)
	serial_type = "FS"

/obj/item/gun/projectile/giskard/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""
	wielded_item_state = "_doble"

	if (ammo_magazine)
		iconstring += "_mag"
		wielded_item_state += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"
		wielded_item_state += "_s"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/giskard/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/giskard
	name = "Giskard frame"
	desc = "A Giskard pistol frame. A ubiquitous pocket deterrent."
	icon_state = "frame_giskard"
	resultvars = list(/obj/item/gun/projectile/giskard)
	gripvars = list(/obj/item/part/gun/modular/grip/wood)
	mechanismvar = /obj/item/part/gun/modular/mechanism/pistol
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol)
