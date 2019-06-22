/obj/item/weapon/gun/projectile/automatic/ak47
	name = "Excelsior 7.62x39 AKMS"
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle chambered for 7.62x39. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents. \
		 This is a high-quality copy, which has an automatic fire mode."
	icon_state = "black-AK"
	item_state = "black-AK"
	w_class = ITEM_SIZE_LARGE
	force = WEAPON_FORCE_PAINFUL
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_AK|MAG_WELL_CIVI_RIFLE
	magazine_type = /obj/item/ammo_magazine/c762_long
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 3500
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/ltrifle_cock.ogg'

	firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=6,     icon="burst"),
		)

/obj/item/weapon/gun/projectile/automatic/ak47/update_icon()
	..()
	item_state = (ammo_magazine)? "[icon_state]-full" : icon_state
	icon_state = "[initial(icon_state)][ammo_magazine? "-[ammo_magazine.max_ammo]": ""]"

/obj/item/weapon/gun/projectile/automatic/ak47/fs
	name = "FS AR 7.62x39 \"Kalashnikov\""
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle chambered for 7.62x39. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents. \
		 This copy, in fact, is a reverse-engineered poor-quality copy of a more perfect copy of an ancient rifle, therefore it can fire only in bursts instead of auto-fire."
	icon_state = "AK"
	item_state = "AK"
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)
	price_tag = 3000

	firemodes = list(
	SEMI_AUTO_NODELAY,
	list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=6,     icon="burst"),
	)
