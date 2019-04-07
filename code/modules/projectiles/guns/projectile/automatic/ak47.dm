/obj/item/weapon/gun/projectile/automatic/ak47
	name = "Excelsior 7.62x39 AKMS"
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is an ancient semi-automatic rifle, chambered in 7.62x39. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents."
	icon_state = "black-AK"
	item_state = "black-AK"
	w_class = ITEM_SIZE_LARGE
	force = WEAPON_FORCE_PAINFULL
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/ak47
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 3500
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/ltrifle_cock.ogg'

	firemodes = list(
		SEMI_AUTO_NODELAY,
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    dispersion=list(0.0, 0.6, 0.6), icon="burst"),
		)

/obj/item/weapon/gun/projectile/automatic/ak47/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]-full"
		item_state = "[initial(item_state)]-full"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	return

/obj/item/weapon/gun/projectile/automatic/ak47/fs
	name = "FS AR 7.62x39 \"Kalashnikov\""
	icon_state = "AK"
	item_state = "AK"
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)
	force = WEAPON_FORCE_DANGEROUS
