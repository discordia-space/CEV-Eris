/obj/item/gun/projectile/revolver/hornet
	name = "OR REV .20 \"LBR-8 Hornet\""
	desc = "An attempt by Oberth to replicate lost syndicate tech. In order to achieve satisfactory ballistic \
			performance, it sports an usually long barrel and overpressurized chamber. Uses .20 rifle rounds."
	icon = 'icons/obj/guns/projectile/hornet.dmi'
	icon_state = "hornet"
	item_state = "hornet"
	drawChargeMeter = FALSE
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2)
	proj_step_multiplier = 0.8
	ammo_type = /obj/item/ammo_casing/srifle
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	caliber = CAL_SRIFLE
	max_shells = 8 // makes more sense than 7 shot .40 revolvers
	proj_step_multiplier = 0.8
	price_tag = 2400 // middle ground between miller and deckard
	damage_multiplier = 2
	penetration_multiplier = 0.5
	zoom_factors = list(0.2) // same scope as z8
	init_recoil = HANDGUN_RECOIL(1.6)
	gun_parts = list(/obj/item/part/gun/frame/hornet = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/revolver = 1, /obj/item/part/gun/barrel/srifle = 1)
	serial_type = "OR"

/obj/item/part/gun/frame/hornet
	name = "Hornet frame"
	desc = "A Hornet revolver frame. Long, heavy, and hotloaded."
	icon_state = "frame_hornet"
	resultvars = list(/obj/item/gun/projectile/revolver/hornet)
	gripvars = list(/obj/item/part/gun/grip/rubber)
	mechanismvar = /obj/item/part/gun/mechanism/revolver
	barrelvars = list(/obj/item/part/gun/barrel/srifle)
