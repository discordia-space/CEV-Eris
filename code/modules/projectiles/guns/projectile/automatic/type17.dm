/obj/item/gun/projectile/automatic/type_17
	name = "OS AR .30 \"Type 17\"" //generic AR. i give up on trying to make this unique
	desc = "An older model One Star assault rifle. A reliable, if unintuitive, design. Uses .30 Rifle magazines."
	icon = 'icons/obj/guns/projectile/os/type_17.dmi'
	icon_state = "type_17"
	item_state = "type_17"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_LRIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/lrifle
	matter = list(MATERIAL_PLASTEEL = 18, MATERIAL_PLATINUM = 8, MATERIAL_PLASTIC = 10)
	price_tag = 3200
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	zoom_factors = list(0.6)
	init_recoil = RIFLE_RECOIL(0.8)
	damage_multiplier = 1.2
	penetration_multiplier = 0.4
	spawn_tags = SPAWN_TAG_GUN_OS
	init_firemodes = list(
		SEMI_AUTO_300,
		BURST_3_ROUND,
		FULL_AUTO_400
		)
	spawn_blacklisted = TRUE //until loot rework

	gun_tags = list(GUN_SILENCABLE)
	serial_type = "OS"

/obj/item/gun/projectile/automatic/type_17/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/automatic/type_17/Initialize()
	. = ..()
	update_icon()
