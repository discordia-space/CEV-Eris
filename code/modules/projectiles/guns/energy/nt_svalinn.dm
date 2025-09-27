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

/obj/item/gun/energy/nt_svalinn/reloadable
	name = "NT LP \"Svalinn\" - R"
	desc = "\"NeoTheology\" brand laser pistol. Small and easily concealable, it's still a reasonable punch for a laser weapon. \
			This one is an older variant that can be reloaded, decorated with gold and a luxurious wooden grip."
	icon = 'icons/obj/guns/energy/nt_svalinn_reloadable.dmi'
	matter = list(MATERIAL_PLASTEEL = 8, MATERIAL_WOOD = 4, MATERIAL_SILVER = 2)
	disposable = FALSE
	price_tag = 2000 //twice the price of the old Svalinn, it's a unique gun now	
	suitable_cell = /obj/item/cell/small
	cell_type = /obj/item/cell/small