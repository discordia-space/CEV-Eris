/obj/item/gun/projectile/shotgun/pump/ks
	name = "KS-23"
	desc = "Karabin Spetsialniy, designed by Excelsior for cheap crowd control for their agents, made with reused anti-aircraft barrels."
	icon = 'icons/obj/guns/projectile/ks23.dmi'
	icon_state = "ks23"
	item_state = "ks23"
	max_shells = 4
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_ROBUST
	slot_flags = SLOT_BACK
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 10, MATERIAL_STEEL = 15)
	proj_step_multiplier = 1.2
	ammo_type = /obj/item/ammo_casing/shotgun/pellet/scrap
	price_tag = 3000
	damage_multiplier = 1.2
	penetration_multiplier = 1.5
	init_recoil = CARBINE_RECOIL(3)
	can_dual = FALSE
	saw_off = FALSE
	spawn_blacklisted = TRUE
	serial_type = "Excelsior"
