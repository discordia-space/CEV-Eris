/obj/item/gun/projectile/shotgun/bojevic
	name = "SA SG \"Bojevic\""
	desc = "Semi-auto, half polymer, all serbian. \
			It's magazine-fed shotgun designed for close quarters combat, nicknamed 'Striker' by boarding parties. \
			Robust and reliable design allows you to swap magazines on go and dump as many shells at your foes as you want... \
			if you could manage recoil, of course. Compatible only with special M12 8-round drum magazines."
	icon = 'icons/obj/guns/projectile/bojevic.dmi'
	icon_state = "bojevic"
	volumeClass = ITEM_SIZE_BULKY
	slot_flags = SLOT_BACK
	caliber = CAL_SHOTGUN
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE|MAG_WELL_RIFLE_D
	magazine_type = /obj/item/ammo_magazine/m12
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 4000
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	damage_multiplier = 1
	init_recoil = CARBINE_RECOIL(1.1)

					//while also preserving ability to shoot as fast as you can click and maintain recoil good enough
	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_300
		)
	// Watch out when modularizing, autorifle/light cannot support shotgun barrels natively.
	gun_parts = list(/obj/item/part/gun/frame/bojevic = 1, /obj/item/part/gun/modular/grip/serb = 1, /obj/item/part/gun/modular/mechanism/autorifle/light = 1, /obj/item/part/gun/modular/barrel/shotgun = 1)
	serial_type = "SA"

/obj/item/gun/projectile/shotgun/bojevic/update_icon()
	..()
	var/itemstring = ""
	cut_overlays()

	if(wielded)
		itemstring += "_doble"

	if(ammo_magazine)
		overlays += "m12_[ammo_magazine.mag_well][ammo_magazine.ammo_label_string]"
		itemstring += "_mag"

	if(!ammo_magazine || !length(ammo_magazine.stored_ammo))
		overlays += "slide"

	set_item_state(itemstring)

/obj/item/gun/projectile/shotgun/bojevic/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/bojevic
	name = "Bojevic frame"
	desc = "A Bojevic shotgun frame. Specially designed to sweep streets and spaceship halls."
	icon_state = "frame_bojevic"
	resultvars = list(/obj/item/gun/projectile/shotgun/bojevic)
	gripvars = list(/obj/item/part/gun/modular/grip/serb)
	mechanismvar = /obj/item/part/gun/modular/mechanism/autorifle/light // listen, its semi and full auto, not pump. makes sense
	barrelvars = list(/obj/item/part/gun/modular/barrel/shotgun)
