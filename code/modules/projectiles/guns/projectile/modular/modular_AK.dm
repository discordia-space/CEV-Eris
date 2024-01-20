/obj/item/gun/projectile/automatic/modular/ak // Frame
	name = "\"Kalash\""
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price."
	icon = 'icons/obj/guns/projectile/modular/ak.dmi'
	volumeClass = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 1) // Parts can give better tech
	slot_flags = SLOT_BACK
	load_method = MAGAZINE // So far not modular
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

/obj/item/gun/projectile/automatic/modular/ak/ironhammer_securities // Total points: 5, contains all the bits that make an IH ak an IH ak
	name = "FS AR .30 \"Venger\""
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/heavy = 0, /obj/item/part/gun/modular/barrel/lrifle = 0, /obj/item/part/gun/modular/grip/rubber = 1, /obj/item/part/gun/modular/stock = 0)
	spawn_blacklisted = TRUE
	magazine_type = /obj/item/ammo_magazine/lrifle

/obj/item/gun/projectile/automatic/modular/ak/frozen_star // Total points: 3, contains all the bits that make an FS ak an FS ak
	name = "FS AR .30 \"Vipr\""
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/basic = 0, /obj/item/part/gun/modular/barrel/lrifle = -1, /obj/item/part/gun/modular/grip/wood = 0, /obj/item/part/gun/modular/stock = 0)
	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	magazine_type = /obj/item/ammo_magazine/lrifle

/obj/item/gun/projectile/automatic/modular/ak/serbian_arms // Total points: 8, contains all the bits that make a serb ak a serb ak
	name = "SA AR .30 \"Krinkov\""
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/light = 1, /obj/item/part/gun/modular/barrel/lrifle/forged = 2, /obj/item/part/gun/modular/grip/serb = 1, /obj/item/part/gun/modular/stock = 0)
	spawn_blacklisted = TRUE
	magazine_type = /obj/item/ammo_magazine/lrifle/drum // Let em go wild

/obj/item/gun/projectile/automatic/modular/ak/serbian_arms/printed // Total points: 6, contains all the bits that make a serb ak a serb ak
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/light = 1, /obj/item/part/gun/modular/barrel/lrifle = 0, /obj/item/part/gun/modular/grip/serb = 1, /obj/item/part/gun/modular/stock = 0)

/obj/item/gun/projectile/automatic/modular/ak/serbian_arms/serbship // Total points: 9
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/light = 1, /obj/item/part/gun/modular/barrel/lrifle/forged = 2, /obj/item/part/gun/modular/grip/serb = 2, /obj/item/part/gun/modular/stock = 0)

/obj/item/gun/projectile/automatic/modular/ak/excelsior // Total points: 9, contains all the bits that make an excel ak an excel ak
	name = "Excelsior Car .30 \"Kalashnikov\""
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/determined/excelsior = 2, /obj/item/part/gun/modular/barrel/lrifle = 1, /obj/item/part/gun/modular/grip/excel = 2)
	spawn_blacklisted = TRUE
	magazine_type = /obj/item/ammo_magazine/lrifle

/obj/item/gun/projectile/automatic/modular/ak/makeshift // Total points: 1
	name = "MS AR .30 \"Sermak\""
	origin_tech = list(TECH_COMBAT = 1)
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
			This is a copy of an ancient semi-automatic rifle. If it won't fire, percussive maintenance should get it working again. \
			It is known for its easy maintenance, and low price. \
			This crude copy shows just how forgiving the design can be."
	init_recoil = RIFLE_RECOIL(1.125) // Placeholder debuff for makeshift production

/obj/item/gun/projectile/automatic/modular/ak/makeshift/get_initial_name()
		return "MS [(PARTMOD_FOLDING_STOCK & spriteTags) ? "AR" : "Car"] [caliber] \"Sermak\"" // Unlike normal AKs, the makeshift variant's frame is easily distinguishable at closer inspection. The name reflects this.

/obj/item/gun/projectile/automatic/modular/ak/makeshift/preset // Total points: 1
	gun_parts = list(/obj/item/part/gun/modular/mechanism/autorifle/simple = -1, /obj/item/part/gun/modular/barrel/lrifle/cheap = -1, /obj/item/part/gun/modular/grip/makeshift = -1, /obj/item/part/gun/modular/stock = 0)
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	magazine_type = /obj/item/ammo_magazine/lrifle
