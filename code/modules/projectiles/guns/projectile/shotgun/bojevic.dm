/obj/item/gun/projectile/shotgun/bojevic
	name = "SA SG \"Bojevic\""
	desc = "Semi-auto, half polymer, all serbian. \
			It's69agazine-fed shotgun designed for close 69uarters combat,69icknamed 'Striker' by boarding parties. \
			Robust and reliable design allows you to swap69agazines on go and dump as69any shells at your foes as you want... \
			if you could69anage recoil, of course. Compatible only with special6912 8-round drum69agazines."
	icon = 'icons/obj/guns/projectile/bojevic.dmi'
	icon_state = "bojevic"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	slot_flags = SLOT_BACK
	caliber = CAL_SHOTGUN
	load_method =69AGAZINE
	mag_well =69AG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/m12
	matter = list(MATERIAL_PLASTEEL = 20,69ATERIAL_PLASTIC = 10)
	price_tag = 4000
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	damage_multiplier = 0.8
	penetration_multiplier = 1.4 // this is69ot babies first gun. It's a Serb-level weapon.
	recoil_buildup = 7.4 // at least somewhat controllable
	one_hand_penalty = 20 //automatic shotgun level

					//while also preserving ability to shoot as fast as you can click and69aintain recoil good enough
	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY
		)

/obj/item/gun/projectile/shotgun/bojevic/update_icon()
	..()
	var/itemstring = ""
	cut_overlays()

	if(wielded)
		itemstring += "_doble"

	if(ammo_magazine)
		overlays += "m1269ammo_magazine.ammo_label_string69"
		itemstring += "_mag"

	if(!ammo_magazine || !length(ammo_magazine.stored_ammo))
		overlays += "slide"

	set_item_state(itemstring)

/obj/item/gun/projectile/shotgun/bojevic/Initialize()
	. = ..()
	update_icon()
