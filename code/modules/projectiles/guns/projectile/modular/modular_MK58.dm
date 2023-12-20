/obj/item/gun/projectile/automatic/modular/mk58 // Parent type
	name = "\"Mk58\""
	desc = "The NT Mk58 is a cheap, ubiquitous sidearm, that was produced by a NanoTrasen subsidiary. Uses standard .35 and high capacity magazines."
	icon = 'icons/obj/guns/projectile/modular/mk58.dmi'
	icon_state = "frame" // frame_gray, frame_black, frame_tan
	volumeClass = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1) // Parts can give better tech
	slot_flags = SLOT_BACK
	load_method = MAGAZINE // So far not modular
	magazine_type = /obj/item/ammo_magazine/pistol // Default magazine, only relevant for spawned pistols, not crafted or printed ones
	matter = list(MATERIAL_PLASTEEL = 5)
	price_tag = 600
	damage_multiplier = 1.3
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	can_dual = TRUE
	init_recoil = HANDGUN_RECOIL(1)

	spawn_tags = SPAWN_TAG_GUN_PART


	bad_type = /obj/item/gun/projectile/automatic/modular/mk58
	gun_tags = list(GUN_SILENCABLE)
	spriteTags = PARTMOD_SLIDE | PARTMOD_FRAME_SPRITE

	serial_type = "NT"

	required_parts = list(/obj/item/part/gun/modular/barrel/pistol = 0, /obj/item/part/gun/modular/mechanism/pistol = 0, /obj/item/part/gun/modular/grip = 0)

/obj/item/gun/projectile/automatic/modular/mk58/get_initial_name()
	if(grip_type)
		switch(grip_type)
			if("wood")
				return "NT HG [caliber] \"Mk58 C\"" //civillian
			if("black")
				return "NT HG [caliber] \"Mk58 S\"" //security
			if("rubber")
				return "NT HG [caliber] \"Mk58 T\"" //tacticool
			if("excelsior")
				return "NT HG [caliber] \"Mk58 M\"" //military
			if("serbian")
				return "SA HG [caliber] \"Mk58\"" //serbian arms
			if("makeshift")
				return "HM HG [caliber] \"Mk58\""
	else
		return "NT [caliber] \"Mk58\""

/obj/item/gun/projectile/automatic/modular/mk58/gray // Frame
	icon_state = "frame_gray"
	spawn_blacklisted = FALSE // Spawns in gun part loot

/obj/item/gun/projectile/automatic/modular/mk58/black // Frame
	icon_state = "frame_black"
	spawn_blacklisted = FALSE // Spawns in gun part loot

/obj/item/gun/projectile/automatic/modular/mk58/tan // Frame
	icon_state = "frame_tan"
	spawn_blacklisted = FALSE // Spawns in gun part loot

/obj/item/gun/projectile/automatic/modular/mk58/alternate // Frame
	icon_state = "frame_altgray"
	spawn_blacklisted = FALSE // Spawns in gun part loot

/obj/item/gun/projectile/automatic/modular/mk58/gray/stock
	gun_parts = list(/obj/item/part/gun/modular/mechanism/pistol = 0, /obj/item/part/gun/modular/barrel/pistol = 0, /obj/item/part/gun/modular/grip/black = 0)
	spawn_tags = SPAWN_TAG_GUN_PROJECTILE
	magazine_type = /obj/item/ammo_magazine/pistol

/obj/item/gun/projectile/automatic/modular/mk58/gray/wood
	gun_parts = list(/obj/item/part/gun/modular/mechanism/pistol = 0, /obj/item/part/gun/modular/barrel/pistol = 0, /obj/item/part/gun/modular/grip/wood = 0)
	spawn_tags = SPAWN_TAG_GUN_PROJECTILE
	magazine_type = /obj/item/ammo_magazine/pistol

/obj/item/gun/projectile/automatic/modular/mk58/black/army
	gun_parts = list(/obj/item/part/gun/modular/mechanism/pistol = 0, /obj/item/part/gun/modular/barrel/pistol = 0, /obj/item/part/gun/modular/grip/excel = 1)
	spawn_tags = SPAWN_TAG_GUN_PROJECTILE
	magazine_type = /obj/item/ammo_magazine/pistol

/obj/item/gun/projectile/automatic/modular/mk58/tan/army
	gun_parts = list(/obj/item/part/gun/modular/mechanism/pistol = 0, /obj/item/part/gun/modular/barrel/pistol = 0, /obj/item/part/gun/modular/grip/excel = 1)
	spawn_tags = SPAWN_TAG_GUN_PROJECTILE
	magazine_type = /obj/item/ammo_magazine/pistol
