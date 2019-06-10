/obj/item/weapon/gun/energy/pulse
	name = "NT PR \"Dominion\""
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Due to its complexity and cost, it is rarely seen in use, except by specialists."
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BELT|SLOT_BACK
	force = WEAPON_FORCE_PAINFUL
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 8, MATERIAL_SILVER = 7, MATERIAL_URANIUM = 8)
	price_tag = 4500
	fire_sound = 'sound/weapons/Laser.ogg'
	projectile_type = /obj/item/projectile/beam
	cell_type = /obj/item/weapon/cell/medium
	sel_mode = 2
	charge_cost = 75

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, fire_sound='sound/weapons/Taser.ogg', fire_delay=null, charge_cost=null, icon="stun"),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, fire_sound='sound/weapons/Laser.ogg', fire_delay=null, charge_cost=null, icon="kill"),
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_sound='sound/weapons/pulse.ogg', fire_delay=25, charge_cost=50, icon="destroy"),
	)


/obj/item/weapon/gun/energy/pulse/mounted
	self_recharge = TRUE
	use_external_power = TRUE


/obj/item/weapon/gun/energy/pulse/destroyer
	name = "NT PR \"Purger\""
	desc = "A more recent \"NeoTheology\" brand pulse rifle, developed in direct response to compete against the highly successful \"Cassad\" design."
	fire_sound = 'sound/weapons/pulse.ogg'
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 8, MATERIAL_SILVER = 10, MATERIAL_URANIUM = 5)
	sel_mode = 1
	projectile_type = /obj/item/projectile/beam/pulse
	fire_delay = 20

	firemodes = list(
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_sound='sound/weapons/pulse.ogg', fire_delay=null, charge_cost=null, icon="destroy"),
		list(mode_name="RAPID", projectile_type=/obj/item/projectile/beam/pulse, fire_sound='sound/weapons/pulse.ogg', fire_delay=10, charge_cost=175, icon="destroy"),
	)


/obj/item/weapon/gun/energy/pulse/cassad
	name = "FS PR \"Cassad\""
	desc = "\"Frozen Star\" brand energy assault rifle, capable of prolonged combat. When surrender is not an option."
	icon_state = "cassad"
	item_state = "cassad"
	matter = list(MATERIAL_PLASTEEL = 18, MATERIAL_PLASTIC = 8, MATERIAL_SILVER = 6, MATERIAL_URANIUM = 6)
	fire_sound = 'sound/weapons/pulse.ogg'
	projectile_type = /obj/item/projectile/beam/pulse
	sel_mode = 1
	charge_cost = 80
	fire_delay = 15
	price_tag = 3000
	zoom_factor = null

	firemodes = list(
		list(mode_name="DESTROY", projectile_type=/obj/item/projectile/beam/pulse, fire_sound='sound/weapons/pulse.ogg', fire_delay=null, charge_cost=null, icon="destroy"),
	)
