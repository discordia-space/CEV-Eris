//NO new variables here, might as well not even have this category, many guns outside /automatic use automatic firemodes
/obj/item/gun/projectile/automatic/modular/ak
	name = "Excelsior .30 \"Kalashnikov\""
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle chambered for .30 Rifle. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price. This gun is not in active military service anymore, but has become ubiquitous among criminals and insurgents. \
		 This is a high-quality copy, which has an automatic fire mode."
	icon = 'icons/obj/guns/projectile/ak/excel.dmi'
	icon_state = "AK"
	item_state = "AK"
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
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	init_recoil = RIFLE_RECOIL(0.8)
	damage_multiplier = 1
	penetration_multiplier = 0
	spawn_blacklisted = TRUE
	gun_parts = list(/obj/item/part/gun/frame/ak47 = 1, /obj/item/part/gun/grip/excel = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/lrifle = 1)

	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_300,
		BURST_5_ROUND
		)
	serial_type = "Excelsior"

	var/folded = FALSE

/obj/item/part/gun/frame/modular/ak
	name = "AK frame"
	desc = "An AK rifle frame. The eternal firearm."
	icon_state = "frame_ak"
	result = /obj/item/gun/projectile/automatic/modular/ak
	gripvars = list(/obj/item/part/gun/grip/excel, /obj/item/part/gun/grip/serb, /obj/item/part/gun/grip/wood, /obj/item/part/gun/grip/rubber)
	resultvars = list(/obj/item/gun/projectile/automatic/ak47, /obj/item/gun/projectile/automatic/ak47/sa, /obj/item/gun/projectile/automatic/ak47/fs, /obj/item/gun/projectile/automatic/ak47/fs/ih)
	mechanismvar = /obj/item/part/gun/mechanism/autorifle
	barrelvars = list(/obj/item/part/gun/barrel/lrifle)

/obj/item/gun/projectile/automatic/ak47/proc/can_interact(mob/user)
	if((!ishuman(user) && (loc != user)) || user.stat || user.restrained())
		return 1
	if(istype(loc, /obj/item/storage))
		return 2
	return 0

/obj/item/gun/projectile/automatic/ak47/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if(gilded)
		iconstring += "_gold"
		itemstring += "_gold"

	if (ammo_magazine)
		itemstring += "_full"
		if (ammo_magazine.mag_well == MAG_WELL_RIFLE_L)
			iconstring += "_l"
		if (ammo_magazine.mag_well == MAG_WELL_RIFLE_D)
			iconstring += "_drum"
		else
			iconstring += "[ammo_magazine? "_mag[ammo_magazine.max_ammo]": ""]"

	if(wielded)
		itemstring += "_doble"

	if(folded)
		iconstring += "_f"
		itemstring += "_f"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/automatic/ak47/Initialize()
	. = ..()
	update_icon()
