/obj/item/gun/projectile/shotgun/type21
	name = "OS Type 21 SG \"Yaoguai\"" //Demon
	desc = "you may find your self. SHOTGUN" //placeholder description
	icon = 'icons/obj/guns/projectile/os/type_21.dmi'
	icon_state = "type_21"
	item_state = "type_21"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	slot_flags = SLOT_BACK
	caliber = CAL_SHOTGUN
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/m12
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 2000
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	damage_multiplier = 1.0
	penetration_multiplier = 0.5 // this is not babies first gun. It's a Serb-level weapon.
	init_recoil = CARBINE_RECOIL(1.0)

					//while also preserving ability to shoot as fast as you can click and maintain recoil good enough
	init_firemodes = list(
		SEMI_AUTO_300
		)

/obj/item/gun/projectile/shotgun/type_21/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/shotgun/type_21/Initialize()
	. = ..()
	update_icon()
