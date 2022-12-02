/obj/item/gun/projectile/automatic/z8
	name = "OR CAR .20 \"Z8 Bulldog\""
	desc = "The Z8 Bulldog is an older bullpup carbine model, made by \"Oberth Republic\". It includes an underbarrel grenade launcher which is compatible with most modern grenade types. Uses .20 Rifle rounds."
	icon = 'icons/obj/guns/projectile/carabine.dmi'
	icon_state = "z8"
	item_state = "z8"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_SRIFLE
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_STEEL = 10)
	price_tag = 3200 //old but gold, decent AP caliber, underbarrel GL, mild recoil and 20-round mags. Better than FS AK.
	ammo_type = /obj/item/ammo_casing/srifle
	fire_sound = 'sound/weapons/guns/fire/batrifle_fire.ogg'
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE|MAG_WELL_RIFLE_L
	magazine_type = /obj/item/ammo_magazine/srifle
	unload_sound = 'sound/weapons/guns/interact/batrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/batrifle_cock.ogg'
	init_recoil = CARBINE_RECOIL(0.5)
	damage_multiplier = 1.15
	penetration_multiplier = 0.1
	zoom_factors = list(0.2)
	gun_tags = list(GUN_FA_MODDABLE)

	init_firemodes = list(
		SEMI_AUTO_300,
		BURST_3_ROUND,
		list(mode_name="fire grenades", mode_desc="Unlocks the underbarrel grenade launcher", burst=null, fire_delay=null, move_delay=null,  icon="grenade", use_launcher=1)
		)

	var/obj/item/gun/projectile/shotgun/pump/grenade/underslung/launcher

	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/z8 = 1, /obj/item/part/gun/grip/black = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/srifle = 1)
	serial_type = "OR"

/obj/item/gun/projectile/automatic/z8/Initialize()
	. = ..()
	launcher = new(src)

/obj/item/gun/projectile/automatic/z8/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/ammo_casing/grenade)))
		launcher.load_underslung(I, user)
	else
		..()

/obj/item/gun/projectile/automatic/z8/attack_hand(mob/user)
	var/datum/firemode/cur_mode = firemodes[sel_mode]

	if(user.get_inactive_hand() == src && cur_mode.settings["use_launcher"])
		launcher.unload_underslung(user)
	else
		..()

/obj/item/gun/projectile/automatic/z8/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	var/datum/firemode/cur_mode = firemodes[sel_mode]

	if(cur_mode.settings["use_launcher"])
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/gun/projectile/automatic/z8/update_icon()
	..()

	var/iconstring = initial(icon_state)
	iconstring = initial(icon_state) + (ammo_magazine ? "_mag" + (ammo_magazine.mag_well == MAG_WELL_RIFLE_L ? "_l" : (ammo_magazine.mag_well == MAG_WELL_RIFLE_D ? "_d" : "")) : "")

	icon_state = iconstring

/obj/item/gun/projectile/automatic/z8/Initialize()
	. = ..()
	update_icon()

/obj/item/gun/projectile/automatic/z8/examine(mob/user)
	..()
	if(launcher.chambered)
		to_chat(user, "\The [launcher] has \a [launcher.chambered] loaded.")
	else
		to_chat(user, "\The [launcher] is empty.")

/obj/item/part/gun/frame/z8
	name = "Z8 Bulldog frame"
	desc = "A Z8 Bulldog carbine frame. Old but gold."
	icon_state = "frame_pug"
	resultvars = list(/obj/item/gun/projectile/automatic/z8)
	gripvars = list(/obj/item/part/gun/grip/black)
	mechanismvar = /obj/item/part/gun/mechanism/autorifle
	barrelvars = list(/obj/item/part/gun/barrel/srifle)
