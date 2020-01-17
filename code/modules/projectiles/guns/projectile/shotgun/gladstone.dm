/obj/item/weapon/gun/projectile/shotgun/pump/gladstone
	name = "FS SG \"Gladstone\""
	desc = "It is a next-generation Frozen Star shotgun intended as a cost-effective competitor to the aging NT \"Regulator 1000\". It has a semi-rifled lightweight full-length barrel which gives it exceptional accuracy with all types of ammunition, with a high-capacity magazine tube below it. Can hold up to 9 shells in tube magazine."
	icon = 'icons/obj/guns/projectile/gladstone.dmi'
	icon_state = "gladstone"
	item_state = "gladstone"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	max_shells = 9 //more shells, but
	damage_multiplier = 0.9 //slightly less damage
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 6)
	price_tag = 3000
	recoil_buildup = 14
	one_hand_penalty = 10
