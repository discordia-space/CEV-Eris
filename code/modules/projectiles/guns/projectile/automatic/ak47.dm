/obj/item/weapon/gun/projectile/automatic/ak47
	name = "Excelsior 7.62x39 AKMS"
	desc = "Weapon of oppressed, oppressors and just crazy terrorists.\
		 If it doesn't work, you can always hit him with it! It is the really old designed assault rifle, chambered in 7,62x39.\
		 It is known for it easy maintaining and low price. This gun is not used by military anymore, but it found a wide spread within criminals and insurgents."
	icon_state = "black-AK"
	item_state = "black-AK"
	w_class = ITEM_SIZE_LARGE
	force = 17
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/ak47
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/ltrifle_cock.ogg'

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    dispersion=list(0.0, 0.6, 0.6)),
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
	desc = "Weapon of oppressed, oppressors and just crazy terrorists.\
		 If it doesn't work, you can always hit him with it! It is the really old designed assault rifle, chambered in 7,62x39.\
		 It is known for it easy maintaining and low price. This gun is not used by military anymore, but it found a wide spread within criminals and insurgents."
	icon_state = "AK"
	item_state = "AK"
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)
	force = 20
