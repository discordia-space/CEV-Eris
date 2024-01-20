/obj/item/gun/projectile/revolver/consul
	name = "FS REV .40 Magnum \"Consul\""
	desc = "When you badly need this case to be closed. Uses .40 Magnum rounds."
	icon = 'icons/obj/guns/projectile/inspector.dmi'
	icon_state = "inspector"
	item_state = "revolver"
	drawChargeMeter = FALSE
	caliber = CAL_MAGNUM
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/magnum/rubber
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 8)
	price_tag = 1700
	damage_multiplier = 1.35
	init_recoil = HANDGUN_RECOIL(1)
	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/consul = 1, /obj/item/part/gun/modular/grip/rubber = 1, /obj/item/part/gun/modular/mechanism/revolver = 1, /obj/item/part/gun/modular/barrel/magnum = 1)
	serial_type = "FS"

/obj/item/part/gun/frame/consul
	name = "Consul frame"
	desc = "A Consul revolver frame. The standard detective's choice."
	icon_state = "frame_inspector"
	resultvars = list(/obj/item/gun/projectile/revolver/consul)
	gripvars = list(/obj/item/part/gun/modular/grip/rubber)
	mechanismvar = /obj/item/part/gun/modular/mechanism/revolver
	barrelvars = list(/obj/item/part/gun/modular/barrel/magnum)
