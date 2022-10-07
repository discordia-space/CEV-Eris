/obj/item/gun/projectile/lamia
	name = "FS HG .40 Magnum \"Lamia\""
	desc = "FS HG .40 Magnum \"Lamia\", a heavy pistol of Ironhammer enforcers. Uses 40 Magnum rounds."
	icon = 'icons/obj/guns/projectile/lamia.dmi'
	icon_state = "lamia"
	item_state = "lamia"
	fire_sound = 'sound/weapons/guns/fire/hpistol_fire.ogg'
	ammo_mag = "mag_magnum"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4)
	can_dual = TRUE
	caliber = CAL_MAGNUM
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	magazine_type = /obj/item/ammo_magazine/magnum
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 8)
	price_tag = 2400
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound = 'sound/weapons/guns/interact/hpistol_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/hpistol_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/hpistol_cock.ogg'
	damage_multiplier = 1.3
	penetration_multiplier = 0
	init_recoil = HANDGUN_RECOIL(0.4)

	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/lamia = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/pistol = 1, /obj/item/part/gun/barrel/magnum = 1)
	serial_type = "FS"

/obj/item/gun/projectile/lamia/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "lamia-[round(ammo_magazine.stored_ammo.len,2)]"
	else
		icon_state = "lamia"
	return

/obj/item/part/gun/frame/lamia
	name = "Lamia frame"
	desc = "A Lamia pistol frame. Summary executions are never the same without it."
	icon_state = "frame_lamia"
	resultvars = list(/obj/item/gun/projectile/lamia)
	gripvars = list(/obj/item/part/gun/grip/rubber)
	mechanismvar = /obj/item/part/gun/mechanism/pistol
	barrelvars = list(/obj/item/part/gun/barrel/magnum)
