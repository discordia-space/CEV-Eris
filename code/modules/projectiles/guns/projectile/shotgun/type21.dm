/obj/item/gun/projectile/shotgun/type21
	name = "OS Type 21 SG \"Yaoguai\""
	desc = "S"
	icon =
	icon_state = "bojevic"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	slot_flags = SLOT_BACK
	caliber = CAL_SHOTGUN
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/m12
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 4000
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
	gun_parts = list(/obj/item/part/gun/frame/bojevic = 1, /obj/item/part/gun/grip/serb = 1, /obj/item/part/gun/mechanism/shotgun = 1, /obj/item/part/gun/barrel/shotgun = 1)
	serial_type = "SA"

/obj/item/gun/projectile/shotgun/bojevic/update_icon()
	..()
	var/itemstring = ""
	cut_overlays()

	if(wielded)
		itemstring += "_doble"

	if(ammo_magazine)
		overlays += "m12[ammo_magazine.ammo_label_string]"
		itemstring += "_mag"

	if(!ammo_magazine || !length(ammo_magazine.stored_ammo))
		overlays += "slide"

	set_item_state(itemstring)

/obj/item/gun/projectile/shotgun/bojevic/Initialize()
	. = ..()
	update_icon()
