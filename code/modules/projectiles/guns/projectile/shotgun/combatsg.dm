/obj/item/weapon/gun/projectile/shotgun/pump/combat
	name = "NT SG \"Regulator 1000\""
	desc = "Designed for close quarters combat, the Regulator is widely regarded as a weapon of choice for repelling boarders. \
			Some may say that it's too old, but it actually proved itself useful. Can hold up to 7 shells in tube magazine."
	icon_state = "cshotgun"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //less ammo and regular recoil, decided not to give 1.2 because Gladstone would be anyhow better in this case
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 12)
	price_tag = 2600