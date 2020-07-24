/obj/item/weapon/gun/projectile/automatic/ak47
	name = "Excelsior .30 AKMS"
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle chambered for .30 Rifle. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents. \
		 This is a high-quality copy, which has an automatic fire mode."
	icon = 'icons/obj/guns/projectile/ak.dmi'
	icon_state = "AK"
	item_state = "AK"
	var/item_suffix = ""
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_LRIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_COVERT = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/lrifle
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10)
	price_tag = 3500
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	recoil_buildup = 10
	one_hand_penalty = 15 //automatic rifle level

	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		BURST_5_ROUND
		)

/obj/item/weapon/gun/projectile/automatic/ak47/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (item_suffix)
		itemstring += "[item_suffix]"

	if (ammo_magazine)
		iconstring += "[ammo_magazine? "_mag[ammo_magazine.max_ammo]": ""]"
		itemstring += "_full"

	if(wielded)
		itemstring += "_doble"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/weapon/gun/projectile/automatic/ak47/Initialize()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/ak47/fs
	name = "FS AR .30 \"Kalashnikov\""
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle chambered for .30 Rifle. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents. \
		 This copy, in fact, is a reverse-engineered poor-quality copy of a more perfect copy of an ancient rifle, therefore it can fire only in bursts instead of auto-fire."
	icon_state = "AK_wood"
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 10)
	price_tag = 3000
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	init_firemodes = list(
	SEMI_AUTO_NODELAY,
	BURST_5_ROUND
	)

	item_suffix = "_wood"
	wielded_item_state = "_doble_wood"