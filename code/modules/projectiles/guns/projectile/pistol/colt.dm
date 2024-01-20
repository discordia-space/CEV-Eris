/obj/item/gun/projectile/colt
	name = "FS HG .35 Auto \"Colt M1911\""
	desc = "A cheap knock-off of a Colt M1911. Uses standard .35 and high capacity magazines."
	icon = 'icons/obj/guns/projectile/colt.dmi'
	icon_state = "colt"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	price_tag = 900
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	can_dual = TRUE
	caliber = CAL_PISTOL
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL|MAG_WELL_H_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	damage_multiplier = 1.5
	init_recoil = HANDGUN_RECOIL(1.2)
	gun_tags = list(GUN_GILDABLE)
	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/colt = 1, /obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/pistol = 1, /obj/item/part/gun/modular/barrel/pistol = 1)
	serial_type = "FS"
/obj/item/gun/projectile/colt/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring

	if(gilded)
		iconstring += "_gold"
		itemstring += "_gold"
		wielded_item_state = "_doble" + "_gold"
	else
		wielded_item_state = "_doble"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/colt/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/colt
	name = "Colt 1911 frame"
	desc = "A Colt pistol frame. Winner of dozens of world wars, and loser of many more guerilla wars."
	icon_state = "frame_1911"
	resultvars = list(/obj/item/gun/projectile/colt)
	gripvars = list(/obj/item/part/gun/modular/grip/wood)
	mechanismvar = /obj/item/part/gun/modular/mechanism/pistol
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol)
