/obj/item/weapon/gun/energy/ionrifle
	name = "NT IR \"Halicon\""
	desc = "The NT IR Halicon is a man portable anti-armor weapon designed to disable mechanical threats, produced by NeoTheology. Not the best of its type, but gets job done."
	icon_state = "ionrifle"
	item_state = "ionrifle"
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)
	w_class = ITEM_SIZE_LARGE
	force = WEAPON_FORCE_PAINFULL
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	charge_cost = 200
	matter = list(MATERIAL_PLASTEEL = 24, MATERIAL_WOOD = 8, MATERIAL_SILVER = 10)
	projectile_type = /obj/item/projectile/ion

/obj/item/weapon/gun/energy/ionrifle/emp_act(severity)
	..(max(severity, 2)) //so it doesn't EMP itself, I guess

/obj/item/weapon/gun/energy/ionrifle/update_icon()
	..()
	if(!cell || cell.charge < charge_cost)
		item_state = "ionrifle-empty"
	else
		item_state = initial(item_state)
