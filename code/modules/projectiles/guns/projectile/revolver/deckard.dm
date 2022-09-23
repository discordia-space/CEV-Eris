/obj/item/gun/projectile/revolver/deckard
	name = "FS REV .40 Magnum \"Deckard\""
	desc = "A rare, custom-built revolver. Use when there is no time for Voight-Kampff test. Uses .40 Magnum rounds."
	icon = 'icons/obj/guns/projectile/deckard.dmi'
	icon_state = "deckard"
	caliber = CAL_MAGNUM
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/magnum/rubber
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	price_tag = 3100 //one of most robust revolvers here
	fire_sound = 'sound/weapons/guns/fire/deckard_fire.ogg'
	damage_multiplier = 1.35
	penetration_multiplier = 0.5
	proj_step_multiplier = 0.8
	init_recoil = HANDGUN_RECOIL(1)
	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/deckard = 1, /obj/item/part/gun/grip/wood = 1, /obj/item/part/gun/mechanism/revolver = 1, /obj/item/part/gun/barrel/magnum = 1)
	serial_type = "FS"

/obj/item/part/gun/frame/deckard
	name = "Deckard frame"
	desc = "A Deckard revolver frame. The secret policeman's choice."
	icon_state = "frame_thatgun"
	resultvars = list(/obj/item/gun/projectile/revolver/deckard)
	gripvars = list(/obj/item/part/gun/grip/wood)
	mechanismvar = /obj/item/part/gun/mechanism/revolver
	barrelvars = list(/obj/item/part/gun/barrel/magnum)
