/obj/item/gun/projectile/automatic/modular/mk58
	name = "\"Mk-58\""
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, that was produced by a NanoTrasen subsidiary. Uses standard .35 and high capacity magazines."
	icon = 'icons/obj/guns/projectile/modular/mk58.dmi'
	icon_state = "frame" // frame_gray, frame_black, frame_tan
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1) // Parts can give better tech
	slot_flags = SLOT_BACK
	load_method = MAGAZINE // So far not modular
	magazine_type = /obj/item/ammo_magazine/lrifle // Default magazine, only relevant for spawned AKs, not crafted or printed ones
	matter = list(MATERIAL_PLASTEEL = 5)
	price_tag = 1000 // Same reason as matter, albeit this is where the license points matter
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	can_dual = TRUE
	magazine_type = /obj/item/ammo_magazine/pistol
	init_recoil = HANDGUN_RECOIL(1)
	spawn_blacklisted = FALSE
	var/slide_type

	gun_tags = list(GUN_SILENCABLE)
	serial_type = "NT"

	required_parts = list(/obj/item/part/gun/modular/mechanism/pistol = 0, /obj/item/part/gun/modular/barrel/pistol = 0, /obj/item/part/gun/modular/grip = 0)

/obj/item/gun/projectile/automatic/modular/mk58/Initialize()
	if(!slide_type)
		slide_type = pick("gray", "tan", "black")
	icon_state = "frame_[slide_type]"
	item_state = "_[slide_type]"
	..()

/obj/item/gun/projectile/automatic/modular/mk58/get_initial_name()
	var/slide_name = (slide_type == "black") ? "BM " : "NT "
	if(grip_type)
		switch(grip_type)
			if("wood")
				return "[slide_name][caliber] Mk-58 C"
			if("black")
				return "[slide_name][caliber] Mk-58 B" // Name of East-German AKs
			if("rubber")
				return "[slide_name][caliber] Mk-58 a"
			if("excelsior")
				return "[slide_name][caliber] Mk-58 e"
			if("serbian")
				return "[slide_name][caliber] Mk-58 T"
			if("makeshift")
				return "[slide_name][caliber] Mk-58 m"
	..()

/obj/item/gun/projectile/automatic/modular/mk58/stock
	slide_type = "gray"
	gun_parts = list(/obj/item/part/gun/modular/mechanism/pistol, /obj/item/part/gun/modular/barrel/pistol, /obj/item/part/gun/modular/grip/black)

/obj/item/gun/projectile/automatic/modular/mk58/wood
	slide_type = "gray"
	gun_parts = list(/obj/item/part/gun/modular/mechanism/pistol, /obj/item/part/gun/modular/barrel/pistol, /obj/item/part/gun/modular/grip/wood)

/obj/item/gun/projectile/automatic/modular/mk58/army
	slide_type = "black"
	gun_parts = list(/obj/item/part/gun/modular/mechanism/pistol, /obj/item/part/gun/modular/barrel/pistol, /obj/item/part/gun/modular/grip/excelsior) // Funny
