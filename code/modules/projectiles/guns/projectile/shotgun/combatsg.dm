/obj/item/weapon/gun/projectile/shotgun/pump/combat
	name = "NT SG \"Regulator 1000\""
	desc = "Designed for close quarters combat, the Regulator is widely regarded as a weapon of choice for repelling boarders. Some may say that it's too old, but it actually proved itself useful. Kicks much harder due to full-rifled barrel, but recoil is also higher. Can hold up to 7 shells in tube magazine."
	icon_state = "cshotgun"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //less ammo
	recoil = 1.2 //more recoil
	damage_multiplier = 1.1 //kicks harder
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 12)
	price_tag = 3000 //since Regulator and Gladstone are competitors, they will get same price, but player must choose between higher capacity+lower recoil and lower capacity+higher damage