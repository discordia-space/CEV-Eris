/obj/item/gun/projectile/automatic/modular/ak
	name = "\"Kalashnikov\""
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price."
	icon = 'icons/obj/guns/projectile/ak.dmi'
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1) // Parts can give better tech
	slot_flags = SLOT_BACK
	load_method = MAGAZINE // So far not modular
	magazine_type = /obj/item/ammo_magazine/lrifle // Default magazine, only relevant for spawned AKs, not crafted or printed ones
	matter = list(MATERIAL_PLASTEEL = 5)
	price_tag = 1000 // Same reason as matter, albeit this is where the license points matter
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/ltrifle_cock.ogg'
	init_recoil = RIFLE_RECOIL(1) // Default is 0.8 to 0.7 on most AKs, we will reduce this value with relevant gun parts
	spawn_blacklisted = FALSE

	gun_tags = list(GUN_SILENCABLE)
	serial_type = "FS"

/obj/item/gun/projectile/automatic/modular/ak/fs // Contains all the bits that make an FS ak an FS ak
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/burst, /obj/item/part/gun/modular/barrel/lrifle, /obj/item/part/gun/modular/grip/rubber, /obj/item/part/gun/modular/stock)
