/obj/item/gun/projectile/type_47
	name = "OS Type 47 CAR .25 CS \"Zuosui\"" //Ghost
	desc = "A boxy carbine of One Star origin designed for special forces. There is a giant suppressor attached to it."
	icon = 'icons/obj/guns/projectile/os/type_47.dmi'
	icon_state = "type_47"
	item_state = "type_47"
	w_class = ITEM_SIZE_NORMAL
	ammo_mag = "ih_sol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_IH
	caliber = CAL_CLRIFLE
	magazine_type = /obj/item/ammo_magazine/ihclrifle
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 3)
	slot_flags = SLOT_BELT|SLOT_BACK
	matter = list(MATERIAL_PLASTEEL = 16, MATERIAL_PLATINUM = 4, MATERIAL_PLASTIC = 12)
	price_tag = 2800
	init_recoil = CARBINE_RECOIL(0.6)
	fire_sound = 'sound/weapons/Gunshot_silenced.wav'
	unload_sound = 'sound/weapons/guns/interact/batrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/batrifle_cock.ogg'
	penetration_multiplier = 0.2
	damage_multiplier = 1.2
	gun_tags = list(GUN_SILENCABLE)
	gun_parts = list(/obj/item/part/gun = 2 ,/obj/item/stack/material/plasteel = 6)
	init_firemodes = list(
		SEMI_AUTO_300,
		BURST_3_ROUND,
		FULL_AUTO_400
		)

	spawn_blacklisted = TRUE
	serial_type = "OS"

/obj/item/gun/projectile/type_47/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/type_47/Initialize()
	. = ..()
	update_icon()
