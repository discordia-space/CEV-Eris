/obj/item/gun/projectile/automatic/wintermute
	name = "FS AR .20 \"Wintermute\""
	desc = "A high end military grade assault rifle, designed as a modern ballistic infantry weapon. Primarily used by and produced for IH troops. Uses IH .20 Rifle magazines."
	icon = 'icons/obj/guns/projectile/wintermute.dmi'
	icon_state = "wintermute"
	item_state = "wintermute"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_SRIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/srifle
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 3500
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	zoom_factor = 0.4
	recoil_buildup = 1.5
	one_hand_penalty = 15 //automatic rifle level
	damage_multiplier = 1.15
	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		SEMI_AUTO_NODELAY,
		BURST_3_ROUND,
		FULL_AUTO_400
		)

	spawn_tags = SPAWN_TAG_FS_PROJECTILE

	gun_tags = list(GUN_SILENCABLE)
	gun_parts = list(/obj/item/part/gun/frame/wintermute = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/srifle = 1)

/obj/item/gun/projectile/automatic/wintermute/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/automatic/wintermute/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/wintermute
	name = "Wintermute frame"
	desc = "A Wintermute assault rifle frame. The finest of the Ironhammer lineup."
	icon_state = "frame_wintermute"
	result = /obj/item/gun/projectile/automatic/wintermute
	grip = /obj/item/part/gun/grip/rubber
	mechanism = /obj/item/part/gun/mechanism/autorifle
	barrel = /obj/item/part/gun/barrel/srifle
