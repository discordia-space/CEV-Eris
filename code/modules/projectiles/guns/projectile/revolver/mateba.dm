/obj/item/gun/projectile/revolver/mateba
	name = "FS REV .40 Magnum \"Mateba\""
	desc = "Very old, reliable hand-cannon with a robust design. This is a gun for a real officer, not just a self-proclaimed \"leader\". Revolver of choice when you want to put someone down. Permanently. Uses .40 Magnum ammo."
	icon = 'icons/obj/guns/projectile/mateba.dmi'
	icon_state = "mateba"
	drawChargeMeter = FALSE
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	price_tag = 3000 //more op and rare than miller, hits as hard as a Miller and doesn't struggle with armor, good luck finding it
	damage_multiplier = 1.6
	penetration_multiplier = 0.4
	init_recoil = HANDGUN_RECOIL(2)

	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/mateba = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/revolver = 1, /obj/item/part/gun/barrel/magnum = 1)
	serial_type = "FS"

/obj/item/part/gun/frame/mateba
	name = "Mateba frame"
	desc = "A Mateba revolver frame. The officer's choice."
	icon_state = "frame_mateba"
	resultvars = list(/obj/item/gun/projectile/revolver/mateba)
	gripvars = list(/obj/item/part/gun/grip/rubber)
	mechanismvar = /obj/item/part/gun/mechanism/revolver
	barrelvars = list(/obj/item/part/gun/barrel/magnum)
