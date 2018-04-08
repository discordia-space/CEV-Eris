/obj/item/weapon/gun/energy/cassad
	name = "FS PR \"Cassad\""
	desc = "Frozen Star brand energy assault rifle, capable of prolonged combat. When surrender is not an option."
	icon_state = "cassad"
	item_state = "pulse"
	slot_flags = SLOT_BELT|SLOT_BACK
	force = WEAPON_FORCE_PAINFULL
	matter = list(MATERIAL_PLASTEEL = 18, MATERIAL_PLASTIC = 8, MATERIAL_SILVER = 6, MATERIAL_URANIUM = 6)
	fire_sound='sound/weapons/pulse.ogg'
	projectile_type = /obj/item/projectile/beam/pulse
	charge_cost = 75
	fire_delay = 15
