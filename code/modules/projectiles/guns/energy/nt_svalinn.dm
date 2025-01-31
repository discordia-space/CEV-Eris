/obj/item/gun/energy/nt_svalinn
	name = "NT LP \"Svalinn\""
	desc = "\"NeoTheology\" brand disposable laser pistol. Small and easily concealable, it's still a reasonable punch for a laser weapon."
	icon = 'icons/obj/guns/energy/nt_svalinn.dmi'
	icon_state = "nt_svalinn"
	item_state = "nt_svalinn"
	item_charge_meter = FALSE
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 1)
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_HOLSTER|SLOT_BELT
	projectile_type = /obj/item/projectile/beam
	charge_cost = 50
	can_dual = TRUE
	zoom_factors = list()
	damage_multiplier = 1
	matter = list(MATERIAL_STEEL = 8, MATERIAL_BIOMATTER = 8) //Cost of the cell is added automatically
	disposable = TRUE
	price_tag = 200
	init_firemodes = list(
		WEAPON_NORMAL,
 		WEAPON_CHARGE
	)
	twohanded = FALSE
	suitable_cell = /obj/item/cell/small/neotheology
	cell_type = /obj/item/cell/small/neotheology
	init_recoil = HANDGUN_RECOIL(1)
	serial_type = "NT"

