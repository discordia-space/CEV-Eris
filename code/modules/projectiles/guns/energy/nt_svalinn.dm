/obj/item/weapon/gun/energy/nt_svalinn
	name = "NT LP \"Svalinn\""
	desc = "\"NeoTheology\" brand laser pistol. Small and easily concealable, it's still a reasonable punch for a laser weapon."
	icon = 'icons/obj/guns/energy/nt_svalinn.dmi'
	icon_state = "nt_svalinn"
	item_state = "nt_svalinn"
	item_charge_meter = FALSE
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 1)
	w_class = ITEM_SIZE_SMALL
	projectile_type = /obj/item/projectile/beam
	charge_cost = 50
	can_dual = 1
	zoom_factor = 0
	damage_multiplier = 1
	matter = list(MATERIAL_PLASTEEL = 8, MATERIAL_WOOD = 4, MATERIAL_SILVER = 2)
	price_tag = 1000
	init_firemodes = list(
		WEAPON_NORMAL,
 		WEAPON_CHARGE
	)
	twohanded = FALSE
	suitable_cell = /obj/item/weapon/cell/small
	cell_type = /obj/item/weapon/cell/small
