/obj/item/weapon/gun/energy/makeshiftlaser
	name = "makeshift laser carbine"
	desc = "A makeshift laser carbine, rather wastefull on its chage, but nonetheless reliable"
	icon = 'icons/obj/guns/energy/laser.dmi'
	icon_state = "laser"
	item_state = "laser"
	item_charge_meter = TRUE
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_NORMAL
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 1)
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 15)
	zoom_factor = 0
	damage_multiplier = 0.8 //worst lightfall
	charge_cost = 100 //ditto
	price_tag = 500
	projectile_type = /obj/item/projectile/beam/midlaser
	init_firemodes = list(
		WEAPON_NORMAL,
		WEAPON_CHARGE
	)
	twohanded = TRUE
	spawn_blacklisted = TRUE
