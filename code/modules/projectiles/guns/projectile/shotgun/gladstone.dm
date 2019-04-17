/obj/item/weapon/gun/projectile/shotgun/pump/gladstone
	name = "FS SG \"Gladstone\""
	desc = "It is a next-generation Frozen Star shotgun intended as a cost-effective competitor to the aging NT \"Regulator 1000\". It has a semi-rifled lightweight full-length plasteel alloy barrel which gives it exceptional accuracy with all types of ammunition, but tube magazine was made slightly shorter to reduce weight."
	icon_state = "gladstone"
	item_state = "gladstone"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //less shells but less recoil also
	recoil = 0.8
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 6)
	price_tag = 3000 //since Regulator and Gladstone are competitors, they will get same price, but player must choose between capacity and reduced recoil