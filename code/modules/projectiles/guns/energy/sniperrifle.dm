/obj/item/weapon/gun/energy/sniperrifle
	name = "NT MER \"Valkyrie\""
	desc = "Valkyrie is an older design of Nanotrasen, Lightfall was based on it. A designated marksman rifle capable of shooting powerful ionized beams, this is a weapon to kill from a distance."
	icon_state = "sniper"
	item_state = "laser"
	fire_sound = 'sound/weapons/marauder.ogg'
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	charge_cost = 300
	fire_delay = 35
	force = 10
	w_class = ITEM_SIZE_LARGE
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 8, MATERIAL_SILVER = 9, MATERIAL_URANIUM = 6)
	cell_type = /obj/item/weapon/cell/medium

/obj/item/weapon/gun/energy/sniperrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)
