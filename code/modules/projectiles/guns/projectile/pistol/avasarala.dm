/obj/item/gun/projectile/avasarala
	name = "NT HG .40 Magnum \"Avasarala\""
	desc = "An obvious replica of an old Earth \"Desert Eagle\". Robust and straight, this is a gun for a leader, not just an officer."

	icon = 'icons/obj/guns/projectile/avasarala.dmi'
	icon_state = "avasarala"
	item_state = "avasarala"

	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_MAGNUM
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL

	magazine_type = /obj/item/ammo_magazine/magnum

	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 8)
	can_dual = TRUE
	damage_multiplier = 1.3
	penetration_multiplier = 0
	init_recoil = HANDGUN_RECOIL(0.8)

	fire_sound = 'sound/weapons/guns/fire/hpistol_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/hpistol_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/hpistol_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/hpistol_cock.ogg'

	price_tag = 1600
	gun_tags = list(GUN_GILDABLE)
	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/avasarala = 1, /obj/item/part/gun/grip/black = 1, /obj/item/part/gun/mechanism/pistol = 1, /obj/item/part/gun/barrel/magnum = 1)
	serial_type = "NT"

/obj/item/gun/projectile/avasarala/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if(gilded)
		iconstring += "_gold"
		itemstring += "_gold"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/avasarala/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/avasarala
	name = "Avasarala frame"
	desc = "An Avasarala pistol frame. Something to command respect."
	icon_state = "frame_deagle"
	resultvars = list(/obj/item/gun/projectile/avasarala)
	gripvars = list(/obj/item/part/gun/grip/black)
	mechanismvar = /obj/item/part/gun/mechanism/pistol
	barrelvars = list(/obj/item/part/gun/barrel/magnum)
