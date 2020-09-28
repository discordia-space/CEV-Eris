/obj/item/weapon/gun/projectile/revolver/sky_driver
	name = "S REV .35 Auto \"Sky Driver\""
	desc = "Old, Syndicate revolver made on lost tech before the Corporate war. Uses .35 special rounds."
	icon = 'icons/obj/guns/projectile/sky_driver.dmi'
	icon_state = "sky_driver"
	item_state = "sky_driver"
	drawChargeMeter = FALSE
	max_shells = 5
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 10, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/pistol
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	price_tag = 20000
	damage_multiplier = 1.1 //because pistol round
	penetration_multiplier = 20
	pierce_multiplier =  5
	recoil_buildup = 50
	spawn_frequency = 0
	spawn_blacklisted = TRUE
