//Primary AR of IH. Has supreme AP to deal with those pesky Serbs (guildsmans actually) in armored hardsuits.
/obj/item/weapon/gun/projectile/automatic/IH_heavyrifle
	name = "FS AR \"Wintermute\""
	desc = "A high end military grade assault rifle, designed as a modern ballistic infantry weapon. Primarily used by and produced for IH troops. Uses 5.56mm rounds."
	icon_state = "IH_heavyrifle"
	item_state = "IH_heavyrifle"
	w_class = ITEM_SIZE_LARGE
	force = WEAPON_FORCE_PAINFULL
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_IH
	magazine_type = /obj/item/ammo_magazine/ih556
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 3500
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	zoom_factor = 2.0

	firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    dispersion=list(0.0, 0.6, 0.6), icon="burst"),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=6,    dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2), icon="burst"),
		)

/obj/item/weapon/gun/projectile/automatic/IH_heavyrifle/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]-full"
		item_state = "[initial(item_state)]-full"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	return