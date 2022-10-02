/obj/item/gun/projectile/revolver/handmade
	name = "handmade revolver"
	desc = "Handmade revolver, made from gun parts. and some duct tap, will it even hold up?"
	icon = 'icons/obj/guns/projectile/handmade_revolver.dmi'
	icon_state = "handmade_revolver"
	caliber = CAL_MAGNUM
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	max_shells = 5
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 5, MATERIAL_WOOD = 10)
	price_tag = 250 //one of the cheapest revolvers here
	damage_multiplier = 1.25
	penetration_multiplier = 0.1
	init_recoil = HANDGUN_RECOIL(1.2)
	gun_parts = list(/obj/item/part/gun = 1 ,/obj/item/stack/material/steel = 15)
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	serial_type = ""
	gun_parts = list(/obj/item/part/gun/frame/revolver_handmade = 1, /obj/item/part/gun/grip/wood = 1, /obj/item/part/gun/mechanism/revolver/steel = 1, /obj/item/part/gun/barrel/magnum/steel = 1)

/obj/item/part/gun/frame/revolver_handmade
	name = "Handmade revolver frame"
	desc = "A handmade revolver. The second most ancient gun design, made with scrap and spit."
	icon_state = "frame_revolver_hm"
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 5, MATERIAL_WOOD = 4)
	resultvars = list(/obj/item/gun/projectile/revolver/handmade)
	gripvars = list(/obj/item/part/gun/grip/wood)
	mechanismvar = /obj/item/part/gun/mechanism/revolver/steel
	barrelvars = list(/obj/item/part/gun/barrel/magnum/steel, /obj/item/part/gun/barrel/pistol/steel)
