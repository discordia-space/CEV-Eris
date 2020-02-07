/obj/item/weapon/gun/projectile/revolver/havelock
	name = "FS REV .35 Auto \"Havelock\""
	desc = "A cheap Frozen Star knock-off of a Smith & Wesson Model 10. Uses .35 special rounds."
	icon = 'icons/obj/guns/projectile/havelock.dmi'
	icon_state = "havelock"
	drawChargeMeter = FALSE
	w_class = ITEM_SIZE_SMALL
	max_shells = 6
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	ammo_type = /obj/item/ammo_casing/pistol
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6)
	price_tag = 800 //cheap civ peashooter revolver, something similar to olivav
	damage_multiplier = 1.15 //because pistol round
	penetration_multiplier = 1.2
	recoil_buildup = 18
