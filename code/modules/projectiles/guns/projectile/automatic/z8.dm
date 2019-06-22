/obj/item/weapon/gun/projectile/automatic/z8
	name = "FS CAR 5.56x45mm \"Z8 Bulldog\""
	desc = "The Z8 Bulldog is an older bullpup carbine model, made by \"Frozen Star\". It includes an underbarrel grenade launcher which is compatible with most modern grenade types. Uses 5.56mm rounds."
	icon_state = "carbine"
	item_state = "z8carbine"
	w_class = ITEM_SIZE_LARGE
	force = WEAPON_FORCE_PAINFUL
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_STEEL = 10)
	price_tag = 3200 //old but gold, decent AP caliber, underbarrel GL, mild recoil and 20-round mags. Better than FS AK.
	ammo_type = "/obj/item/ammo_casing/a556"
	fire_sound = 'sound/weapons/guns/fire/batrifle_fire.ogg'
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_CIVI_RIFLE
	magazine_type = /obj/item/ammo_magazine/a556
	unload_sound 	= 'sound/weapons/guns/interact/batrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/batrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/batrifle_cock.ogg'
	recoil = 0.8 //it's carbine plus not 7.62
	zoom_factor = 0.2

	firemodes = list(
		SEMI_AUTO_NODELAY,
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, move_delay=4,     icon="burst"),
		list(mode_name="fire grenades",  burst=null, fire_delay=null, move_delay=null,  icon="grenade", use_launcher=1)
		)

	var/obj/item/weapon/gun/launcher/grenade/underslung/launcher

/obj/item/weapon/gun/projectile/automatic/z8/Initialize()
	. = ..()
	launcher = new(src)

/obj/item/weapon/gun/projectile/automatic/z8/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/weapon/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/attack_hand(mob/user)
	var/datum/firemode/cur_mode = firemodes[sel_mode]

	if(user.get_inactive_hand() == src && cur_mode.settings["use_launcher"])
		launcher.unload(user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	var/datum/firemode/cur_mode = firemodes[sel_mode]

	if(cur_mode.settings["use_launcher"])
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "carbine-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "carbine"

/obj/item/weapon/gun/projectile/automatic/z8/examine(mob/user)
	..()
	if(launcher.chambered)
		to_chat(user, "\The [launcher] has \a [launcher.chambered] loaded.")
	else
		to_chat(user, "\The [launcher] is empty.")
