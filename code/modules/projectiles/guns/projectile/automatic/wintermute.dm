/obj/item/gun/projectile/automatic/wintermute
	name = "FS AR .20 \"Wintermute\""
	desc = "A high end military grade assault rifle, designed as a modern ballistic infantry weapon. Primarily used by and produced for IH troops. Uses IH .20 Rifle magazines. \
			The design was made to be able to fit long magazine alongside the standard ones."
	icon = 'icons/obj/guns/projectile/wintermute.dmi'
	icon_state = "wintermute"
	item_state = "wintermute"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_SRIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE|MAG_WELL_RIFLE_L
	magazine_type = /obj/item/ammo_magazine/srifle
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 3500
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	zoom_factors = list(0.4)
	init_recoil = RIFLE_RECOIL(0.6)
	damage_multiplier = 1.15
	penetration_multiplier = 0
	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		SEMI_AUTO_300,
		BURST_3_ROUND,
		FULL_AUTO_400
		)

	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/wintermute = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/srifle = 1)
	serial_type = "FS"

/obj/item/gun/projectile/automatic/wintermute/update_icon()
	..()

	var/iconstring = initial(icon_state)
	iconstring = initial(icon_state) + (ammo_magazine ? "_mag" + (ammo_magazine.mag_well == MAG_WELL_RIFLE_L ? "_l" : (ammo_magazine.mag_well == MAG_WELL_RIFLE_D ? "_d" : "")) : "")

	icon_state = iconstring

/obj/item/gun/projectile/automatic/wintermute/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/wintermute
	name = "Wintermute frame"
	desc = "A Wintermute assault rifle frame. The finest of the Ironhammer lineup."
	icon_state = "frame_wintermute"
	resultvars = list(/obj/item/gun/projectile/automatic/wintermute)
	gripvars = list(/obj/item/part/gun/grip/rubber)
	mechanismvar = /obj/item/part/gun/mechanism/autorifle
	barrelvars = list(/obj/item/part/gun/barrel/srifle)
