/obj/item/gun/projectile/revolver/mateba
	name = "FS REV .40 Magnum \"Mateba\""
	desc = "Very old, reliable hand-cannon with a robust design. This is a gun for a real officer, not just a self-proclaimed \"leader\". Revolver of choice when you want to put someone down. Permanently. Uses .40 Magnum ammo."
	icon = 'icons/obj/guns/projectile/mateba.dmi'
	icon_state = "mateba"
	drawChargeMeter = FALSE
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	price_tag = 3000 //more op and rare than miller, hits as hard as a Miller and doesn't struggle with armor, good luck finding it
	damage_multiplier = 1.75
	penetration_multiplier = 1.5
	recoil_buildup = 6
	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	spawn_blacklisted = TRUE
