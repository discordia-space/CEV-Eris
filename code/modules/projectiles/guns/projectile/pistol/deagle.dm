/obj/item/weapon/gun/projectile/deagle
	name = "FS HG .40 Magnum \"Avasarala\""
	desc = "An obvious replica of an old Earth \"Desert Eagle\". Robust and straight, this is a gun for a leader, not just an officer."
	icon = 'icons/obj/guns/projectile/deagle.dmi'
	icon_state = "deagle"
	item_state = "revolver"
	force = WEAPON_FORCE_PAINFUL
	caliber = "magnum"
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 8)
	price_tag = 1600
	damage_multiplier = 0.83
	penetration_multiplier = 1.2
	recoil_buildup = 27
	fire_sound = 'sound/weapons/guns/fire/hpistol_fire.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/hpistol_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/hpistol_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/hpistol_cock.ogg'
