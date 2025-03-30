/obj/item/gun/projectile/automatic/modular/bolt // frame
	name = "Excelsior BR .30 \"Kardashev-Mosin\""
	desc = "Weapon for hunting, or endless trench warfare. \
			If you’re on a budget, it’s a darn good rifle for just about everything."
	icon = 'icons/obj/guns/projectile/modular/bolt.dmi'
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_ROBUST
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	matter = list(MATERIAL_PLASTEEL = 5, MATERIAL_PLASTIC = 4)
	price_tag = 900
	spawn_blacklisted = TRUE
	twohanded = TRUE
	spriteTagBans = PARTMOD_FOLDING_STOCK
	init_recoil = SLATE_RECOIL(1.5)
	required_parts = list(/obj/item/part/gun/modular/barrel = 0, /obj/item/part/gun/modular/grip = 0, /obj/item/part/gun/modular/stock = 0,\
	 /obj/item/part/gun/modular/mechanism/boltgun = 0, /obj/item/part/gun/modular/sights = -1, /obj/item/part/gun/modular/bayonet = -1)
	init_firemodes = list() // boltguns don't have firemodes!

/obj/item/gun/projectile/automatic/modular/bolt/get_initial_name()
	if(grip_type)
		switch(grip_type)
			if("wood")
				if(caliber == CAL_SRIFLE)
					return "FS SR .20 \"Arasaka\"" // or small
				else
					return "SA SR [caliber] \"Novakovic\"" // we love/fear them all
			if("black")
				return "NT SR [caliber] \"Eradicator\""
			if("rubber")
				return "FS SR [caliber] \"Kadmin\""
			if("excelsior")
				return "Excelsior SR [caliber] \"Kardashev-Mosin\""
			if("serbian")
				return "SA AMR [caliber] \"Hristov\"" // big
			if("makeshift")
				return  "HM SR [caliber] \"Riose\""
	else
		return "SR [caliber] \"Boltie\""

/obj/item/gun/projectile/automatic/modular/bolt/excel
	gun_parts = list(/obj/item/part/gun/modular/grip/excel = 0, /obj/item/part/gun/modular/mechanism/boltgun = 0, /obj/item/part/gun/modular/barrel/lrifle/steel = 0, \
	/obj/item/part/gun/modular/stock/longrifle = 0, /obj/item/part/gun/modular/bayonet = 0)

/obj/item/gun/projectile/automatic/modular/bolt/serbian
	desc = "Weapon for hunting, or endless trench warfare. \
		If you’re on a budget, it’s a darn good rifle for just about everything. \
		This copy, in fact, is a reverse-engineered poor-quality copy of a more perfect copy of an ancient rifle"
	init_recoil = SLATE_RECOIL(1.7)
	spawn_blacklisted = FALSE

/obj/item/gun/projectile/automatic/modular/bolt/serbian/finished
	gun_parts = list(/obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/boltgun = 0,\
	 /obj/item/part/gun/modular/barrel/lrifle/steel = 0, /obj/item/part/gun/modular/stock/longrifle = 0, /obj/item/part/gun/modular/bayonet/steel = 0)

/obj/item/gun/projectile/automatic/modular/bolt/fs
	gun_parts = list(/obj/item/part/gun/modular/grip/rubber = 0, /obj/item/part/gun/modular/mechanism/boltgun = 0, /obj/item/part/gun/modular/barrel/srifle/long = 0,\
	 /obj/item/part/gun/modular/stock/longrifle = 0, /obj/item/part/gun/modular/sights/scopebig = 0)

/obj/item/gun/projectile/automatic/modular/bolt/fs/civilian
	gun_parts = list(/obj/item/part/gun/modular/grip/wood = -1, /obj/item/part/gun/modular/mechanism/boltgun = 0, /obj/item/part/gun/modular/barrel/srifle/long = 0,\
	 /obj/item/part/gun/modular/stock/longrifle = 0, /obj/item/part/gun/modular/sights/scopesmall = 0) // nerfed the stock to simulate civilian shittyness that apparently increases recoil by 1/9th
	spawn_blacklisted = FALSE

/obj/item/gun/projectile/automatic/modular/bolt/handmade
	desc = "A handmade bolt action rifle, made from junk and some spare parts."
	spawn_blacklisted = FALSE
	matter = list(MATERIAL_STEEL = 4)
	init_recoil = SLATE_RECOIL(2) // lower quality frame
	price_tag = 800

/obj/item/gun/projectile/automatic/modular/bolt/handmade/finished
	gun_parts = list(/obj/item/part/gun/modular/grip/makeshift = 0, /obj/item/part/gun/modular/mechanism/boltgun/junk = 0, /obj/item/part/gun/modular/barrel/lrifle/steel = 0,\
	 /obj/item/part/gun/modular/stock/longrifle = 0, /obj/item/part/gun/modular/bayonet = 0)

/obj/item/gun/projectile/automatic/modular/bolt/sniper
	desc = "A portable anti-armour rifle, it was originally designed for use against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease, but suffers from overpenetration at close range. Fires armor piercing .60 shells."

/obj/item/gun/projectile/automatic/modular/bolt/sniper/finished
	gun_parts = list(/obj/item/part/gun/modular/grip/serb = 0, /obj/item/part/gun/modular/mechanism/boltgun/heavy = 0, /obj/item/part/gun/modular/barrel/antim/long = 0,\
	 /obj/item/part/gun/modular/stock/heavy = 0, /obj/item/part/gun/modular/sights/customizable/scopeheavy = 0)
