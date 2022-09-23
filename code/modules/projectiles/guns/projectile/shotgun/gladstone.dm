/obj/item/gun/projectile/shotgun/pump/gladstone
	name = "FS SG \"Gladstone\""
	desc = "It is a next-generation Frozen Star shotgun intended as a cost-effective competitor to the aging NT \"Regulator 1000\". It has a semi-rifled lightweight full-length barrel which gives it exceptional projectile velocity and armor piercing capabilites with slugs, with a high-capacity magazine tube below it. Can hold up to 9+1 shells in a tube magazine."
	icon = 'icons/obj/guns/projectile/gladstone.dmi'
	icon_state = "gladstone"
	item_state = "gladstone"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	max_shells = 9 //more shells
	proj_step_multiplier = 0.8 // faster than non-shotgun bullets, slower than non-shotgun bullets with an accelerator
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 6)
	init_recoil = RIFLE_RECOIL(2.3)
	damage_multiplier = 0.8
	penetration_multiplier = 0.5
	saw_off = FALSE

	price_tag = 1800
	spawn_tags = SPANW_TAG_FS_SHOTGUN
	gun_parts = list(/obj/item/part/gun/frame/gladstone = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/shotgun = 1, /obj/item/part/gun/barrel/shotgun = 1)
	serial_type = "FS"

/obj/item/part/gun/frame/gladstone
	name = "Gladstone frame"
	desc = "A Gladstone shotgun frame. Where capacity and force combine."
	icon_state = "frame_gladstone"
	resultvars = list(/obj/item/gun/projectile/shotgun/pump/gladstone)
	gripvars = list(/obj/item/part/gun/grip/rubber)
	mechanismvar = /obj/item/part/gun/mechanism/shotgun
	barrelvars = list(/obj/item/part/gun/barrel/shotgun)
