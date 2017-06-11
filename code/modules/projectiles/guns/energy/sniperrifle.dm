/obj/item/weapon/gun/energy/sniperrifle
	name = "NT MER \"Valkyrie\""
	desc = "Valkyrie is an older design of Nanotrasen, Lightfall was based on it. A designated marksman rifle capable of shooting powerful ionized beams, this is a weapon to kill from a distance."
	icon_state = "sniper"
	item_state = "laser"
	fire_sound = 'sound/weapons/marauder.ogg'
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	projectile_type = /obj/item/projectile/beam/sniper
	slot_flags = SLOT_BACK
	charge_cost = 400
	max_shots = 4
	fire_delay = 35
	force = 10
	w_class = 4
	accuracy = -3 //shooting at the hip
	scoped_accuracy = 0

/obj/item/weapon/gun/energy/sniperrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)
