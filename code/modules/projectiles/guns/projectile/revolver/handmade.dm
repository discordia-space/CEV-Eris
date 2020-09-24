/obj/item/weapon/gun/projectile/revolver/handmaderevolver
	name = "Handmade revolver"
	desc = "Handmade revolver, made from gun parts. and some duct tap, will it even hold up?."
	icon = 'icons/obj/guns/projectile/deckard.dmi'
	icon_state = "deckard"
	caliber = CAL_MAGNUM
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/magnum/rubber
	matter = list(MATERIAL_PLASTIC = 10, MATERIAL_STEEL = 15)
	price_tag = 250 //one of the cheapest revolvers here
	damage_multiplier = 1 //less than deckard
	penetration_multiplier = 1.65
	recoil_buildup = 50 //more even than the AMR
