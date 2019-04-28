/obj/item/weapon/gun/projectile/revolver/deckard
	name = "FS REV .44 \"Deckard\""
	desc = "A rare, custom-built revolver. Use when there is no time for Voight-Kampff test. Uses .44 rounds."
	icon_state = "deckard"
	caliber = ".44"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/cl44/rubber
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	damage_multiplier = 1.1 //slightly more damaging because only 5 shots
	price_tag = 1900 //one of most robust revolvers here
	recoil = 0.7 //slightly less because custom-built and pricy