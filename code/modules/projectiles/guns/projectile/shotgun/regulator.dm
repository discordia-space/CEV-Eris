/obj/item/gun/projectile/shotgun/pump/regulator
	name = "NT SG \"Regulator 1000\""
	desc = "Designed for close quarters combat, the Regulator is widely regarded as a weapon of choice for repelling boarders. \
			Some may say that it's too old, but it actually proved itself useful. Can hold up to 7+1 shells in tube magazine."
	icon = 'icons/obj/guns/projectile/regulator.dmi'
	icon_state = "regulator"
	item_state = "regulator"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	max_shells = 7 //less ammo and regular recoil, decided not to give 1.2 because Gladstone would be anyhow better in this case
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 2)
	price_tag = 2000
	damage_multiplier = 1.3
	init_recoil = RIFLE_RECOIL(2.4)
	saw_off = FALSE
	gun_parts = list(/obj/item/part/gun/frame/regulator = 1, /obj/item/part/gun/modular/grip/black = 1, /obj/item/part/gun/modular/mechanism/shotgun = 1, /obj/item/part/gun/modular/barrel/shotgun = 1)
	serial_type = "NT"

/obj/item/part/gun/frame/regulator
	name = "Regulator frame"
	desc = "A Regulator shotgun frame. The gold standard for boarder repelling."
	icon_state = "frame_regulator"
	result = /obj/item/gun/projectile/shotgun/pump/regulator
	gripvars = list(/obj/item/part/gun/modular/grip/black, /obj/item/part/gun/modular/grip/rubber)
	resultvars = list(/obj/item/gun/projectile/shotgun/pump/regulator, /obj/item/gun/projectile/shotgun/pump/regulator/army)
	mechanismvar = /obj/item/part/gun/modular/mechanism/shotgun
	barrelvars = list(/obj/item/part/gun/modular/barrel/shotgun)

/obj/item/gun/projectile/shotgun/pump/regulator/army
	name = "NT SG \"Regulator M1000\""
	desc = "Designed for close quarters combat, the Regulator is widely regarded as a weapon of choice for repelling boarders. \
		Some may say that it's too old, but it actually proved itself useful. This is a military model with lightweight-yet-durable plastic and rubber parts. Can hold up to 7+1 shells in tube magazine."
	icon_state = "regulator_army"
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 12)
	price_tag = 2200
	init_recoil = RIFLE_RECOIL(2.3)
	gun_parts = list(/obj/item/part/gun/frame/regulator = 1, /obj/item/part/gun/modular/grip/rubber = 1, /obj/item/part/gun/modular/mechanism/shotgun = 1, /obj/item/part/gun/modular/barrel/shotgun = 1)
