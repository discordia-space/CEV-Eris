/obj/item/gun/projectile/automatic/z8
	name = "OR CAR .20 \"Z8 Bulldog\""
	desc = "The Z8 Bulldog is an older bullpup carbine69odel,69ade by \"Oberth Republic\". It includes an underbarrel grenade launcher which is compatible with69ost69odern grenade types. Uses .20 Rifle rounds."
	icon = 'icons/obj/guns/projectile/carabine.dmi'
	icon_state = "z8"
	item_state = "z8"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_SRIFLE
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	matter = list(MATERIAL_PLASTEEL = 20,69ATERIAL_STEEL = 10)
	price_tag = 3200 //old but gold, decent AP caliber, underbarrel GL,69ild recoil and 20-round69ags. Better than FS AK.
	ammo_type = /obj/item/ammo_casing/srifle
	fire_sound = 'sound/weapons/guns/fire/batrifle_fire.ogg'
	slot_flags = SLOT_BACK
	load_method =69AGAZINE
	mag_well =69AG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/srifle
	unload_sound = 'sound/weapons/guns/interact/batrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/batrifle_cock.ogg'
	recoil_buildup = 1
	penetration_multiplier = 1.1
	damage_multiplier = 1.1
	zoom_factor = 0.2
	one_hand_penalty = 10 //bullpup rifle level

	init_firemodes = list(
		SEMI_AUTO_NODELAY,
		BURST_3_ROUND,
		list(mode_name="fire grenades",69ode_desc="Unlocks the underbarrel grenade launcher", burst=null, fire_delay=null,69ove_delay=null,  icon="grenade", use_launcher=1)
		)

	var/obj/item/gun/projectile/shotgun/pump/grenade/underslung/launcher

	spawn_tags = SPAWN_TAG_FS_PROJECTILE

/obj/item/gun/projectile/automatic/z8/Initialize()
	. = ..()
	launcher =69ew(src)

/obj/item/gun/projectile/automatic/z8/attackby(obj/item/I,69ob/user)
	if((istype(I, /obj/item/ammo_casing/grenade)))
		launcher.load_underslung(I, user)
	else
		..()

/obj/item/gun/projectile/automatic/z8/attack_hand(mob/user)
	var/datum/firemode/cur_mode = firemodes69sel_mode69

	if(user.get_inactive_hand() == src && cur_mode.settings69"use_launcher"69)
		launcher.unload_underslung(user)
	else
		..()

/obj/item/gun/projectile/automatic/z8/Fire(atom/target,69ob/living/user, params, pointblank=0, reflex=0)
	var/datum/firemode/cur_mode = firemodes69sel_mode69

	if(cur_mode.settings69"use_launcher"69)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/gun/projectile/automatic/z8/update_icon()
	..()

	var/iconstring = initial(icon_state)

	if (ammo_magazine)
		iconstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring

/obj/item/gun/projectile/automatic/z8/Initialize()
	. = ..()
	update_icon()

/obj/item/gun/projectile/automatic/z8/examine(mob/user)
	..()
	if(launcher.chambered)
		to_chat(user, "\The 69launcher69 has \a 69launcher.chambered69 loaded.")
	else
		to_chat(user, "\The 69launcher69 is empty.")
