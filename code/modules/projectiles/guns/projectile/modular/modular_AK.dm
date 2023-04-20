/obj/item/gun/projectile/automatic/modular/ak // Frame
	name = "\"Kalash\""
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price."
	icon = 'icons/obj/guns/projectile/modular/ak.dmi'
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 1) // Parts can give better tech
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

	spawn_blacklisted = FALSE // Spawns in gun part loot
	spawn_tags = SPAWN_TAG_GUN_PART

	gun_tags = list(GUN_SILENCABLE)

	serial_type = "FS"

	required_parts = list(/obj/item/part/gun/modular/mechanism/autorifle = 0, /obj/item/part/gun/modular/barrel = 0, /obj/item/part/gun/modular/grip = 0, /obj/item/part/gun/modular/stock = -1)

/obj/item/gun/projectile/automatic/modular/ak/get_initial_name()
	var/stock_type = (PARTMOD_FOLDING_STOCK & spriteTags) ? "AR" : "Car"
	if(grip_type)
		switch(grip_type)
			if("wood")
				return "FS [stock_type] [caliber] \"Vipr\""
			if("black")
				return "BM [stock_type] [caliber] \"MPi-K\"" // Name of East-German AKs
			if("rubber")
				return "FS [stock_type] [caliber] \"Venger\""
			if("excelsior")
				return "Excelsior [stock_type] [caliber] \"Kalashnikov\""
			if("serbian")
				return "SA [stock_type] [caliber] \"Krinkov\""
			if("makeshift")
				return "MS [stock_type] [caliber] \"[capitalize(english_list(shuffle(list("ka", "lash", "ni", "kov")), and_text = "", comma_text = "", final_comma_text = ""))]\""
	else
		return "Car [caliber] \"Kalash\"" // No nikov

/obj/item/gun/projectile/automatic/modular/ak/ironhammer_securities // Total points: 4, contains all the bits that make an IH ak an IH ak
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/heavy, /obj/item/part/gun/modular/barrel/lrifle, /obj/item/part/gun/modular/grip/rubber, /obj/item/part/gun/modular/stock)
	spawn_blacklisted = TRUE

/obj/item/gun/projectile/automatic/modular/ak/frozen_star // Total points: 3, contains all the bits that make an FS ak an FS ak
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/basic, /obj/item/part/gun/modular/barrel/lrifle/cheap, /obj/item/part/gun/modular/grip/rubber, /obj/item/part/gun/modular/stock)
	spawn_tags = SPAWN_TAG_FS_PROJECTILE

/obj/item/gun/projectile/automatic/modular/ak/serbian_arms // Total points: 6, contains all the bits that make a serb ak a serb ak
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/light, /obj/item/part/gun/modular/barrel/lrifle/forged, /obj/item/part/gun/modular/grip/serb, /obj/item/part/gun/modular/stock)
	spawn_blacklisted = TRUE

/obj/item/gun/projectile/automatic/modular/ak/excelsior // Total points: 6, contains all the bits that make an excel ak an excel ak
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/determined/excelsior, /obj/item/part/gun/modular/barrel/lrifle/forged, /obj/item/part/gun/modular/grip/excel)
	spawn_blacklisted = TRUE

/obj/item/gun/projectile/automatic/modular/ak/makeshift
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/simple, /obj/item/part/gun/modular/barrel/lrifle/cheap, /obj/item/part/gun/modular/grip/makeshift, /obj/item/part/gun/modular/stock)
	spawn_tags = SPAWN_TAG_GUN_HANDMADE

	origin_tech = list(TECH_COMBAT = 1)
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
			This is a copy of an ancient semi-automatic rifle. If it won't fire, percussive maintenance should get it working again. \
			It is known for its easy maintenance, and low price. \
			This crude copy shows just how forgiving the design can be."
	init_recoil = RIFLE_RECOIL(1.25) // Placeholder debuff for makeshift production

/obj/item/gun/projectile/automatic/modular/ak/makeshift/get_initial_name()
		return "MS [caliber] \"Sermak\"" // Unlike normal AKs, the makeshift variant's frame is easily distinguishable at closer inspection. The name reflects this.
