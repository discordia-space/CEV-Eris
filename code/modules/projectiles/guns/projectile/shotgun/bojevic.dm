/obj/item/weapon/gun/projectile/shotgun/bojevic
	name = "SA SG \"Bojevic\""
	desc = "Semi-auto, half polymer, all serbian. \
			It's magazine-fed shotgun designed for close quarters combat, nicknamed 'Striker' by boarding parties. \
			Robust and reliable design allows you to swap magazines on go and dump as many shells at your foes as you want... \
			if you could manage recoil, of course. Compatible only with special M12 8-round drum magazines."
	icon = 'icons/obj/guns/projectile/bojevic.dmi'
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
	damage_multiplier = 1
	penetration_multiplier = 1.4 // this is not babies first gun. It's a Serb-level weapon.
	recoil_buildup = 15 // at least somewhat controllable
	one_hand_penalty = 20 //automatic shotgun level

				   //while also preserving ability to shoot as fast as you can click and maintain recoil good enough
	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY
		)

/obj/item/weapon/gun/projectile/shotgun/bojevic/update_icon()
	overlays.Cut()
	icon_state = "[initial(icon_state)]"
	if(ammo_magazine)
		overlays += "m12[ammo_magazine.ammo_color]"
	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		overlays += "slide"
	if(wielded)//I hate this snowflake bullshit but I don't feel like messing with it.
		if(ammo_magazine)
			item_state = wielded_item_state + "_mag"
		else
			item_state = wielded_item_state
	else
		item_state = initial(item_state)

/obj/item/weapon/gun/projectile/shotgun/bojevic/Initialize()
	. = ..()
	update_icon()
